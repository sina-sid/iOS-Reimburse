//
//  ViewController.swift
//  ReceiptScan
//
//  Created by Gaury Nagaraju on 10/29/16.
//  Copyright © 2016 Gaury Nagaraju. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    @IBOutlet weak var receiptImage: UIImageView!
    
    var imagePicker: UIImagePickerController!
    
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

