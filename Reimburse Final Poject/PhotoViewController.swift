//
//  PhotoViewController.swift
//  Reimburse Final Project
//
//  PURPOSE:
//  Take Images of Multiple Receipts and attach to request form
//  Save Image and Add to URL array to attach to form
//  In future, implement delete images after submission to save memory

import UIKit
import Foundation

class PhotoViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    var imagePicker: UIImagePickerController!
    // URL Paths -- Images in here is going to be zipped up
    var urlPaths = [URL]()
    // Current Directory
    var documentsDirectoryURL = try! FileManager().url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
    
    // MARK: - Properties
    @IBOutlet weak var receiptImage: UIImageView!
    @IBOutlet weak var examplePhotoLabel: UILabel!
    // Nav Bar Buttons
    @IBOutlet weak var nextBarButton: UIBarButtonItem!
    @IBAction func enterFormDetails(_ sender: Any) {
        // Need to select atleast one image
        if urlPaths.count<1{
            // Display Info Alert
            let msg = "Attach atleast one receipt image"
            let alert = UIAlertController(title: "Error", message: msg, preferredStyle: UIAlertControllerStyle.alert)
            let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(defaultAction)
            self.present(alert, animated: true, completion: nil)
        }
        else{
            // Perform Segue
            self.performSegue(withIdentifier: "enterRequestDetails", sender: self)
        }
    }
    // Take Photo Button
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
        saveImage()
    }
    
    // For Photo Library
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        // Set Image
        receiptImage.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        receiptImage.contentMode = .scaleAspectFit
        imagePicker.dismiss(animated: true, completion: {
            // Post Image Processing
            self.postImageProcessing()
        })

    }
    
    func saveImage(){
        let randomNum = arc4random()
        let name = "image" + String(randomNum) + ".png"
        print (name)
        // get image that was taken
        let image = receiptImage.image!
        // create fileURL to add to documents directory
        let fileURL = documentsDirectoryURL.appendingPathComponent(name)
        // turn image into a file and write it to the file URL, so that it saves to the document directory
        if !FileManager.default.fileExists(atPath: fileURL.path) {
            let data = UIImagePNGRepresentation(image)!
            do {
                try data.write(to: fileURL)
                print("Url: ", fileURL)
                self.urlPaths.append(fileURL)
            } catch {
                print("THE ERROR: ", error)
            }
        } else {
            print("Image Not Added")
        }
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "enterRequestDetails"{
            let navController = segue.destination as! UINavigationController
            let formView:RequestFormViewController = navController.topViewController as! RequestFormViewController
            // Pass path to images for request submission
            formView.urlPaths = urlPaths
            
        }
    }
 
}
