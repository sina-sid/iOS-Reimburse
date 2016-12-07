//
//  ViewController.swift
//  ReceiptScan
//
//  Created by Gaury Nagaraju on 10/29/16.
//  Copyright © 2016 Gaury Nagaraju. All rights reserved.
//

import UIKit
import Zip
import MessageUI


class ViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, MFMailComposeViewControllerDelegate {

    @IBOutlet weak var receiptImage: UIImageView!
    
    var imagePicker: UIImagePickerController!
    var data: NSData?
    
    // Take Image of Receipt
    @IBAction func takePhoto(_ sender: Any) {
        print("Hit")
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
    
    //zip up file
    @IBAction func zipImage (sender: UIButton) {
//        let zippath = "ZIPIMAGE"
//        if let image = receiptImage.image {
////            let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString
////            let destinationPath = documentsPath.appendingPathComponent("filename.jpg")
//            let dPath = "/Users/rumbywilson/Desktop/zipImage.jpg"
//            let url = NSURL(string: dPath)
//           let b =  UIImageJPEGRepresentation(image, 1.0)
//            try b?.write(to: url as! URL) {
//                
//            }
        
        //let img = #imageLiteral(resourceName: "stuff")
//        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("test.jpg")
//        
//        do {
//            try jpegData.write(to: fileURL, options: .atomic)
//        } catch {
//            print(error)
//        }
//            let ddURL = try! FileManager().url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
//            let fileURL = ddURL.appendingPathComponent("trial.jpg")
//            let data = UIImageJPEGRepresentation(img, 1.0)
//         //   try! data?.write(to: fileURL) {
//
//      //  }
       // "/Users/rumbywilson/Desktop/pepe"
        let image = receiptImage.image!
        guard let imageURL = NSURL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("TempImage.png") else {
            return
        }
        do {
            try UIImagePNGRepresentation(image)?.write(to: imageURL)
        } catch { }
        
        var urlPaths = [URL]()
       // let path = "file:///Users/rumbywilson/Desktop/pepe.png"
        //let url = URL(string: path)
        urlPaths.append(imageURL)
        do {
            let z = try Zip.quickZipFiles(urlPaths, fileName: "TEST1")
            print("PASSED")
            print(z)
        } catch {
            print("ERROR")
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

