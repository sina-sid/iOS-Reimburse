//
//  RequestFormViewController.swift
//  Reimburse Final Project
//
//  Created by Gaury Nagaraju on 11/21/16.
//
//

import Foundation
import UIKit
import SwiftValidator
import Alamofire
import SwiftyJSON
import AWSS3

class RequestFormViewController: UIViewController, ValidationDelegate, UIPickerViewDelegate, UITextViewDelegate {
    
    // Amazon S3
    // Initialize the Amazon Cognito credentials provider
    let S3BucketName = "reimbursementapi"
    
    // Zipped File of Receipts Passed from PhotoController
    var zipReceiptImages: URL!
    var urlPaths = [URL]()
    
    // Values passed from Table View: indicate if text field has pre-set value and if editing is enabled or not
    var en: String=""
    var ed: String=""
    var el: String=""
    var noa: String=""
    var o: String=""
    var tot: String=""
    var pd: String="- Where were items purchased? \n- When were they purchased? \n- What was purchased?"
    var disableFieldEditing: Bool=false
    var submitButtonIsHidden: Bool=false
    var saveBarButtonIsEnabled: Bool=true
    var cancelBarButtonIsHidden: Bool=false
    
    // Load from API Call
    var orgs: Array<String>=[]
    
    // Swift In-Form Validator - External Framework
    let validator = Validator()
    
    // MARK: - Properties
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var scrollContentView: UIView!
    @IBOutlet weak var eventName: UITextField!{
        didSet{
            eventName.text = en
            if disableFieldEditing{
                eventName.isEnabled = false
            }
        }
    }
    @IBOutlet weak var eventDate: UITextField!{
        didSet{
            eventDate.text = ed
            if disableFieldEditing{
                eventDate.isEnabled = false
            }
        }
    }
    @IBOutlet weak var eventLoc: UITextField!{
        didSet{
            eventLoc.text = el
            if disableFieldEditing{
                eventLoc.isEnabled = false
            }
        }
    }
    @IBOutlet weak var eventNumOfAttendees: UITextField!{
        didSet{
            eventNumOfAttendees.text = noa
            if disableFieldEditing{
                eventNumOfAttendees.isEnabled = false
            }
        }
    }
    @IBOutlet weak var org: UITextField!{
        didSet{
            org.text = o
            if disableFieldEditing{
                org.isEnabled = false
            }
        }
    }
    @IBOutlet weak var total: UITextField!{
        didSet{
            total.text = tot
            if disableFieldEditing{
                total.isEnabled = false
            }
        }
    }
    @IBOutlet weak var purchaseDescription: UITextView!{
        didSet{
            purchaseDescription.text = pd
            if disableFieldEditing{
                purchaseDescription.isEditable = false
            }
        }
    }
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!{
        didSet{
            loadingIndicator.stopAnimating()
            loadingIndicator.isHidden = true
        }
    }
    
    @IBOutlet weak var submitRequest: UIButton!{
        didSet{
            submitRequest.isHidden = submitButtonIsHidden
        }
    }
    @IBAction func submit(_ sender: AnyObject) {
        validator.validate(self)
    }
    // Nav Bar Properties
    @IBOutlet weak var topNavBar: UINavigationItem!
    @IBOutlet weak var cancelBarButton: UIBarButtonItem!
    @IBOutlet weak var saveBarButton: UIBarButtonItem!
    @IBAction func cancel(_ sender: Any) {
        self.performSegue(withIdentifier: "cancelReimbursementRequest", sender: self)
    }
    
    // MARK: View Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        // Scroll View
        view.addSubview(scrollView)
        
        // Status Bar Appearance
        UIApplication.shared.statusBarStyle = .lightContent
        
        // Nav Bar Appearance
        cancelBarButton.setTitleTextAttributes([NSFontAttributeName: UIFont.systemFont(ofSize: 12.0)], for: UIControlState.normal)
        saveBarButton.setTitleTextAttributes([NSFontAttributeName: UIFont.systemFont(ofSize: 12.0)], for: UIControlState.normal)
        let attrs = [NSForegroundColorAttributeName:UIColor.white, NSFontAttributeName: UIFont.systemFont(ofSize: 14.0)]
        self.navigationController?.navigationBar.titleTextAttributes = attrs
        
        // Nav Bar Buttons
        saveBarButton.isEnabled = saveBarButtonIsEnabled
        if !saveBarButtonIsEnabled{
            saveBarButton.title=""
        }
        if cancelBarButtonIsHidden{
            cancelBarButton.title="Back"
        }
        
        // Border for Textfield box
        purchaseDescription.layer.borderWidth = 1.0
        purchaseDescription.layer.cornerRadius = 5
        purchaseDescription.layer.borderColor = UIColor.lightGray.cgColor
        
        // Default Value for Event Date = Today
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.short
        let nowString = dateFormatter.string(from: Date())
        eventDate.text = nowString
        // DatePicker for Event Date
        let datePickerView = UIDatePicker()
        datePickerView.datePickerMode = UIDatePickerMode.date
        eventDate.inputView = datePickerView
        datePickerView.addTarget(self, action: #selector(RequestFormViewController.datePickerValueChanged), for: UIControlEvents.valueChanged)
        
        // Dropdown For Orgs
        loadOrgRoles{ (isLoading, error) in
            if isLoading == false{
                let pickerView = UIPickerView()
                pickerView.delegate = self
                // pickerView.dataSource = self
                // pickerView.reloadAllComponents()
                self.org.inputView = pickerView
            }
            else{
                print("Error: ", error!)
                // Display Alert
                let msg = "No Orgs found. Please go to Settings to list Orgs you are part of."
                let alert = UIAlertController(title: "Error", message: msg, preferredStyle: UIAlertControllerStyle.alert)
                let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alert.addAction(defaultAction)
                self.present(alert, animated: true, completion: nil)
            }
        }
        
        // Validated Fields Display: Red or Green
        validator.styleTransformers(success:{ (validationRule) -> Void in
            // If Error Labels Added: clear error label
            // validationRule.errorLabel?.isHidden = true
            // validationRule.errorLabel?.text = ""
            if let textField = validationRule.field as? UITextField {
                textField.layer.borderColor = UIColor.green.cgColor
                textField.layer.borderWidth = 0.5
                
            }
        }, error:{ (validationError) -> Void in
            // validationError.errorLabel?.isHidden = false
            // validationError.errorLabel?.text = validationError.errorMessage
            if let textField = validationError.field as? UITextField {
                textField.layer.borderColor = UIColor.red.cgColor
                textField.layer.borderWidth = 1.0
            }
        })
        
        // Validations
        validator.registerField(eventName, rules: [RequiredRule()])
        validator.registerField(eventLoc, rules: [RequiredRule()])
        // validator.registerField(eventDate, rules: [RequiredRule(), EventDateRule()])
        validator.registerField(eventDate, rules: [RequiredRule()])
        validator.registerField(eventNumOfAttendees, rules: [RequiredRule(), NumericRule()])
        // validator.registerField(org, rules: [RequiredRule(), InclusiveRule(orgList: orgs)])
        validator.registerField(org, rules: [RequiredRule()])
        validator.registerField(total, rules: [RequiredRule(), FloatRule()])
        validator.registerField(purchaseDescription, rules: [RequiredRule()])
        
        // Amazon S3
        let credentialsProvider = AWSCognitoCredentialsProvider(regionType:.usWest2,
                                                                identityPoolId:"us-west-2:e848a71f-99d5-44f5-b618-b932f2ea0b22")
        let configuration = AWSServiceConfiguration(region: .usWest2, credentialsProvider: credentialsProvider)
        AWSServiceManager.default().defaultServiceConfiguration = configuration
        
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        scrollView.contentSize = CGSize(width: self.view.frame.width, height: self.view.frame.height+100)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadOrgRoles(completionHandler: @escaping (Bool?, NSError?) -> ()){
        var isLoading = true
        // API Call to get org roles
        Alamofire.request("https://reimbursementapi.herokuapp.com/user_orgs/", method: .get).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                print("Validation Successful")
                let json = JSON(value)
                // Loop through requests
                for (key,subJson):(String, JSON) in json {
                    // Create Request Object
                    let userOrg = OrgRole(org: subJson["organization"].stringValue, role: subJson["role"].stringValue)
                    // Append to Requests Array
                    self.orgs += [userOrg.org]
                }
                // TO BE FIXED
                self.orgs += ["Senate"]
                // Loading is complete
                isLoading = false
                completionHandler(isLoading, nil)
            case .failure(let error):
                print(error)
                isLoading = true
                completionHandler(isLoading, error as NSError?)
            }
        }
    }
    
    // Update Event Date in View when date picker value changes
    func datePickerValueChanged(sender:UIDatePicker){
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.short
        // let nowString = dateFormatter.string(from: Date())
        eventDate.text = dateFormatter.string(from: sender.date)
    }
    
    // MARK: - Validation Delegate Methods
    
    func sendImages(completionHandler: @escaping (String?, String?) -> ()){
        var isLoading = true
        var receiptsURL = ""
        // Submit Receipts
        for i in 0..<self.urlPaths.count{
            // 1. Get Image
            let img = UIImage(contentsOfFile: self.urlPaths[i].absoluteString)
            // 2. Prepare Uploader
            let ext = "png"
            let uploadRequest = AWSS3TransferManagerUploadRequest()
            uploadRequest?.body = urlPaths[i]
            // uploadRequest?.key = ProcessInfo.processInfo.globallyUniqueString + "." + ext
            print("URL: ", self.urlPaths[i])
            print("URL LC: ", self.urlPaths[i].lastPathComponent)
            uploadRequest?.key = self.urlPaths[i].lastPathComponent
            uploadRequest?.bucket = S3BucketName
            uploadRequest?.contentType = "image/" + ext
            // 3. Push Image to Server
            var s3URL = NSURL()
            let transferManager = AWSS3TransferManager.default()
            transferManager?.upload(uploadRequest).continue({(task)->AnyObject! in
                if let error = task.error{
                    print ("Upload Failed: ", error)
                }
                if let exception = task.exception{
                    print("Upload failed: ", exception)
                }
                if task.result != nil{
                    let urlStr = "http://s3.amazonaws.com/\(self.S3BucketName)/\(uploadRequest?.key!)"
                    let escUrlStr = urlStr.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
                    s3URL = NSURL(string: escUrlStr)!
                    print("Uploaded to:\n\(s3URL)")
                    // Append to String of URLs
                    receiptsURL += s3URL.absoluteString! + ","
                    // If pushed all images, then submit reimbursement form
                    if (i==self.urlPaths.count-1){
                        isLoading = false
                        completionHandler(receiptsURL, nil)
                    }
                }
                else{
                    let error = "Unexpected empty result"
                    print(error)
                    isLoading = true
                    completionHandler("", error)
                }
                return nil
            })// End of Push Images
        }// End of For Loop
    }
    
    func validationSuccessful() {
        var receiptsURL = ""
        // Submit Receipts
        for i in 0..<self.urlPaths.count{
            // 1. Get Image
            let img = UIImage(contentsOfFile: self.urlPaths[i].absoluteString)
            // 2. Prepare Uploader
            let ext = "png"
            let uploadRequest = AWSS3TransferManagerUploadRequest()
            uploadRequest?.body = urlPaths[i]
            // uploadRequest?.key = ProcessInfo.processInfo.globallyUniqueString + "." + ext
            print("URL: ", self.urlPaths[i])
            print("URL LC: ", self.urlPaths[i].lastPathComponent)
            uploadRequest?.key = self.urlPaths[i].lastPathComponent
            uploadRequest?.bucket = S3BucketName
            uploadRequest?.contentType = "image/" + ext
            // 3. Push Image to Server
            var s3URL = NSURL()
            let transferManager = AWSS3TransferManager.default()
            transferManager?.upload(uploadRequest).continue({(task)->AnyObject! in
                if let error = task.error{
                    print ("Upload Failed: ", error)
                }
                if let exception = task.exception{
                    print("Upload failed: ", exception)
                }
                if task.result != nil{
                    let urlStr = "http://s3.amazonaws.com/\(self.S3BucketName)/\(uploadRequest?.key!)"
                    let escUrlStr = urlStr.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
                    s3URL = NSURL(string: escUrlStr)!
                    print("Uploaded to:\n\(s3URL)")
                    // Append to String of URLs
                    receiptsURL += s3URL.absoluteString! + ","
                    // Submit Reimbursement Form after pushing all images
                    if i==self.urlPaths.count-1{
                        // Submit the Reimbursement form
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateStyle = DateFormatter.Style.short
                        let ed = dateFormatter.date(from: self.eventDate.text!)
                        let parameters: Parameters = [
                            "reimbursement":[
                                "event_date": ed!,
                                "event_name": self.eventName.text!,
                                "event_location": self.eventLoc.text!,
                                "num_of_attendees": Int(self.eventNumOfAttendees.text!)!,
                                "organization": self.org.text!,
                                "total": Float(self.total.text!)!,
                                "description": self.purchaseDescription.text!,
                                "receipt_images": receiptsURL
                            ]
                        ]
                        // API Call to submit reimbursement request
                        Alamofire.request("https://reimbursementapi.herokuapp.com/reimbursements/", method: .post, parameters: parameters).validate().responseJSON { response in
                            
                            var alert = UIAlertController()
                            var defaultAction = UIAlertAction()
                            
                            switch response.result {
                            case .success:
                                print("Request Successful Outer A")
                                // Display Confirmation
                                let msg = "Submitted Request. \nPending Signer Approval"
                                alert = UIAlertController(title: "Success", message: msg, preferredStyle: UIAlertControllerStyle.alert)
                                // Segue to Screen: list of reimbursement requests
                                defaultAction = UIAlertAction(title: "OK", style: .default, handler: { action in self.performSegue(withIdentifier: "successRequestSubmission", sender: self) })
                            case .failure(let error):
                                print(error)
                                // Display Error
                                let msg = "Error while submitting request. \nPlease try again."
                                alert = UIAlertController(title: "Error", message: msg, preferredStyle: UIAlertControllerStyle.alert)
                                defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                            }// End of Outer Switch
                            alert.addAction(defaultAction)
                            self.present(alert, animated: true, completion: nil)
                        }// End of Outer Alamo Request
                    }
                }
                else{
                    let error = "Unexpected empty result"
                    print(error)
                }
                return nil
            })// End of Push Images
        }// End of For Loop
        
    }
    
    func validationFailed(_ errors:[(Validatable ,ValidationError)]) {
        // turn the fields to red
        for (field, error) in errors {
            if let field = field as? UITextField {
                field.layer.borderColor = UIColor.red.cgColor
                field.layer.borderWidth = 1.0
            }
            // If Error Labels Added - uncomment
            // error.errorLabel?.text = error.errorMessage
            // error.errorLabel?.isHidden = false
        }
    }
    
    // MARK: - PickerView Delegate Methods
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return orgs.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return orgs[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        org.text = orgs[row]
    }
    
    // Resign TextField as First Responder
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
        super.touchesBegan(touches, with: event)
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

// MARK: - Custom Validation Rules
class EventDateRule: Rule {
    // NOTE: THIS RULE ISN'T CURRENTLY USED SINCE EVENT DATE CAN BE IN FUTURE. DATE FORMAT IS ENSURED USING DATE PICKER
    private var message:String
    
    init(message:String="Enter Valid Date On or Before Today"){
        self.message = message
    }
    
    func validate(_ value: String) -> Bool {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.short
        let ed = dateFormatter.date(from: value)
        let nowString = dateFormatter.string(from: Date())
        let now = dateFormatter.date(from: nowString)
        
        // ensure event date is on or before today
        return (ed?.compare(now!) == .orderedAscending || ed?.compare(now!) == .orderedSame)
    }
    
    func errorMessage() -> String {
        return message
    }
}

class NumericRule: Rule {
    
    private var regex: String
    private var message: String
    
    public init(regex: String = "^\\d+$", message: String = "Not a number"){
        self.regex = regex
        self.message = message
    }
    
    public func validate(_ value: String) -> Bool {
        // needs to be a number
        let test = NSPredicate(format: "SELF MATCHES %@", self.regex)
        return test.evaluate(with: value)
    }
    
    public func errorMessage() -> String {
        return message
    }
    
}

class InclusiveRule: Rule{
    
    private var message: String
    private var orgList: Array<String>
    
    public init(orgList: Array<String>, message: String = "Not a member in org listed."){
        self.orgList = orgList
        self.message = message
    }
    
    public func validate(_ value: String) -> Bool {
        // needs to be in list of orgs
        return orgList.contains(value)
    }
    
    public func errorMessage() -> String {
        return message
    }
}

extension UITextView: Validatable{
    public var validationText: String {
        return text ?? ""
    }
}
