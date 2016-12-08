//
//  PhotoViewController.swift
//  Reimburse Final Project
//
//  Created by Gaury Nagaraju on 12/7/16.
//
//

import UIKit
import Foundation
import Zip

class PhotoViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    var imagePicker: UIImagePickerController!
    var zipFilePath: URL!
    // URL Paths -- Images in here is going to be zipped up
    var urlPaths = [URL]()
    // Current Directory
    var documentsDirectoryURL = try! FileManager().url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
    
    // MARK: - Properties
    @IBOutlet weak var receiptImage: UIImageView!
    @IBOutlet weak var examplePhotoLabel: UILabel!
    @IBOutlet weak var takePhotoButton: UIButton!
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // Status Bar Appearance
        UIApplication.shared.statusBarStyle = .lightContent
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Image Picker Delegate Methods
    // Implement imagePickerController Delegate Method
    
    func updateLabelAfterTakePhoto(){
        examplePhotoLabel.text = ""
        takePhotoButton.setTitle("Add Another Receipt", for: UIControlState.normal)
    }
    
    func postImageProcessing(){
        // Update Label
        updateLabelAfterTakePhoto()
        // Save Image
        saveReceiptPhoto()
        zipImage()
    }
    
    // For Camera
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        // Set Image
        receiptImage.image = image
        // Post Image Processing
        postImageProcessing()
        imagePicker.dismiss(animated: true, completion: nil)
    }
    // For Photo Library
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        // Set Image
        receiptImage.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        receiptImage.contentMode = .scaleAspectFit
        // Post Image Processing
        postImageProcessing()
        print("ReceiptImage: ", receiptImage.image!)
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Save Receipt Images
    func saveReceiptPhoto(){
        // generate name for image: timestamp + receipt
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy HH:mm"
        let todayString = dateFormatter.string(from: Date())
        let name = "Receipt_" + todayString
        // get image that was taken
        let image = receiptImage.image!
        // create fileURL to add to documents directory
        let fileURL = documentsDirectoryURL.appendingPathComponent(name)
        // turn image into a file and write it to the file URL, so that it saves to the document directory
        if !FileManager.default.fileExists(atPath: fileURL.path) {
            do {
                try UIImagePNGRepresentation(image)!.write(to: fileURL)
            } catch {
                print("THE ERROR in SaveReceiptPhoto: ", error)
            }
        } else {
            print("No Image Provided to Save")
        }
    }
    
    func zipImage(){
        let documentsUrl =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        // adding to urlpaths
        do {
            // Document directory content( can't use documentsDirectoryURL for this)
            let directoryContents = try FileManager.default.contentsOfDirectory(at: documentsUrl, includingPropertiesForKeys: nil, options: [])
            // Filter the directory to capture images (images are not saved with an extension)
            let imgFiles = directoryContents.filter{ $0.pathExtension == ""}
            // Add relevant image file urls to array
            imgFiles.map{urlPaths.append($0)}
        } catch let error as NSError {
            print("Error in zipImage URL: ", error.localizedDescription)
        }
        // Attempting to zip it
        do {
            // Generate Zip File Name
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd-MM-yyyy HH:mm"
            let todayString = dateFormatter.string(from: Date())
            let zipFileName = "ZippedReceipts_" + todayString
            // Zip Images
            zipFilePath = try Zip.quickZipFiles(urlPaths, fileName: zipFileName)
            print("Zip File PAth: ", zipFilePath)
        } catch {
            print("ERROR in zipImage Zip")
        }
    }
    

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
