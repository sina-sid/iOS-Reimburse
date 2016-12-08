//
//  ViewController.swift
//  ReceiptScan
//
//  Created by Gaury Nagaraju on 10/29/16.
//  Copyright © 2016 Gaury Nagaraju. All rights reserved.
//

import UIKit
import Zip

// After we have a working app to show tmrw I will go through and add unit tests

class ViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    @IBOutlet weak var receiptImage: UIImageView!
    @IBOutlet weak var receiptName: UITextField!
    
    var imagePicker: UIImagePickerController!
    var data: NSData?
    // Document
    var documentsDirectoryURL = try! FileManager().url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
    
    // Take Image of Receipt
    @IBAction func takePhoto(_ sender: Any) {
        imagePicker =  UIImagePickerController()
        imagePicker.delegate = self
        // Check if camera source type is available and set source type for image
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            print("Camera available")
            imagePicker.sourceType = .camera
        }
        else{
            print("Camera not available")
            imagePicker.sourceType = .photoLibrary
        }
        
        present(imagePicker, animated: true, completion: nil)
        
    }
    //Save image to document directory
    @IBAction func saveImage (sender: UIButton) {
        // get a name for your image
        let randomNum = arc4random()
        let name = "image" + String(randomNum) + ".png"
        print (name)
        // get image that was taken
        let image = receiptImage.image!
        // create fileURL to add to documents directory
        let fileURL = documentsDirectoryURL.appendingPathComponent(name)
        // turn image into a file and write it to the file URL, so that it saves to the document directory
        if !FileManager.default.fileExists(atPath: fileURL.path) {
            do {
                try UIImagePNGRepresentation(image)!.write(to: fileURL)
                print("FILE URL")
                print(fileURL)
                print("Image Added Successfully")
            } catch {
                print("THE ERROR")
                print(error)
            }
        } else {
            print("Image Not Added")
        }
    }
    
    //zip up file
    @IBAction func zipImage (sender: UIButton) {
        // URL Paths -- everything in here is going to be zipped up
        var urlPaths = [URL]()
        let documentsUrl =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        // adding to urlpaths
        do {
            // Document directory content( can't use documentsDirectoryURL for this)
            let directoryContents = try FileManager.default.contentsOfDirectory(at: documentsUrl, includingPropertiesForKeys: nil, options: [])
            // Filter the directory to capture images (images are not saved with an extension)
            let imgFiles = directoryContents.filter{ $0.pathExtension == ""}
            print("img urls:",imgFiles)
            for file in imgFiles {
                urlPaths.append(file)
            }
            
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        // Attempting to zip it
        do {
            let z = try Zip.quickZipFiles(urlPaths, fileName: "TESTINGZIP")
            print(z.path)
            // Take this out after adding in tests
            print("PASSED")
        } catch {
            print("ERROR")
        }
        // When implmenting email feature make sure to grab the zipped file from the document directory
        // After the file is zipped and emailed off,clear the doucment directory to avoid having images repeated
    }
    //Clear Document Directory
    @IBAction func clearDD (sender: UIButton) {
//        let fileManager = FileManager.default
//        let nsDocumentDirectory = FileManager.SearchPathDirectory.documentDirectory
//        let nsUserDomainMask = FileManager.SearchPathDomainMask.userDomainMask
//        let paths = NSSearchPathForDirectoriesInDomains(nsDocumentDirectory, nsUserDomainMask, true)
//        guard let dirPath = paths.first else {
//            return
//        }
//        let filePath = "\(dirPath)/\(itemName).\(fileExtension)"
//        do {
//            try fileManager.removeItem(atPath: filePath)
//        } catch let error as NSError {
//            print(error.debugDescription)
//        }
        for path in documentsDirectoryURL{
            print(path)
        }
    }
    
    // Implement imagePickerController Delegate Method
     func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        receiptImage.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        receiptImage.contentMode = .scaleAspectFit
        print("ReceiptImage: ", receiptImage.image!)
        
        imagePicker.dismiss(animated: true, completion: {
            // Scale Image for Tesseract
            let scaledImage = self.scaleImage(image: self.receiptImage.image!, maxDimension: 640)
            // Tesseract Scan Image Uploaded
            self.performImageRecognition(image: scaledImage)
        })
        
    }
    
    // Tesseract Scanner
    func performImageRecognition(image: UIImage) {
        // 1: Initialize Tesseract
        let tesseract = G8Tesseract()
        // 2: Search for English training dataset
        tesseract.language = "eng"
        // 3: Set OCR Engine Mode - most accurate but slow
        tesseract.engineMode = .tesseractCubeCombined
        // 4: Let Tesseract know how page is segmented: by paragraphs
        tesseract.pageSegmentationMode = .auto
        // 5: Amount of time dedicated to image recognition
        tesseract.maximumRecognitionTime = 60.0
        // 6: Best Result when text contrasts highly with background. Thus, desaturate image + increase contrast + reduce exposure
        tesseract.image = image.g8_blackAndWhite()
        tesseract.recognize()
        // 7
        print("Tesseract Text: ",tesseract.recognizedText)
        
    }
    
    // Scale Image for Better Tesseract Recognition
    func scaleImage(image: UIImage, maxDimension: CGFloat) -> UIImage {
        
        var scaledSize = CGSize(width: maxDimension, height: maxDimension)
        var scaleFactor: CGFloat
        
        if image.size.width > image.size.height {
            scaleFactor = image.size.height / image.size.width
            scaledSize.width = maxDimension
            scaledSize.height = scaledSize.width * scaleFactor
        } else {
            scaleFactor = image.size.width / image.size.height
            scaledSize.height = maxDimension
            scaledSize.width = scaledSize.height * scaleFactor
        }
        
        UIGraphicsBeginImageContext(scaledSize)
        image.draw(in: CGRect(x: 0, y: 0, width: scaledSize.width, height: scaledSize.height))
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return scaledImage!
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

