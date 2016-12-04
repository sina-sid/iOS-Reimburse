//
//  RequestFormViewController.swift
//  Reimburse Final Project
//
//  Created by Gaury Nagaraju on 11/21/16.
//
//

import UIKit
import SwiftValidator
import Alamofire

class RequestFormViewController: UIViewController, ValidationDelegate, UIPickerViewDelegate, UITextViewDelegate {
    
    // Values passed from Table View
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
    
    // TO BE FIXED: Get List of Orgs from API.
    var orgs = ["OM", "Emerging Leaders", "Senate", "StuGov Cabinet"]
    
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
        
        // Dropdown For Orgs
        let pickerView = UIPickerView()
        pickerView.delegate = self
        org.inputView = pickerView
        
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
        validator.registerField(eventDate, rules: [RequiredRule(), EventDateRule()])
        validator.registerField(eventNumOfAttendees, rules: [RequiredRule(), NumericRule()])
        validator.registerField(org, rules: [RequiredRule(), InclusiveRule(orgList: orgs)])
        validator.registerField(total, rules: [RequiredRule(), FloatRule()])
        validator.registerField(purchaseDescription, rules: [RequiredRule()])
        
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        scrollView.contentSize = CGSize(width: self.view.frame.width, height: self.view.frame.height+100)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Revert to Default status bar style for other view controllers
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.default
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Validation Delegate Methods
    
    func validationSuccessful() {
        
        // Submit the form
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.short
        let ed = dateFormatter.date(from: eventDate.text!)
        let parameters: Parameters = [
            "reimbursement":[
                "event_date": ed!,
                "event_name": eventName.text!,
                "event_location": eventLoc.text!,
                "num_of_attendees": Int(eventNumOfAttendees.text!)!,
                "organization": org.text!,
                "total": Float(total.text!)!,
                "description": purchaseDescription.text!,
                "request_date": Date(),
                "requester_id": 1 // TO BE FIXED: Use current_user ID
            ]
        ]
        // Display Activity Indicator
        loadingIndicator.startAnimating()
        loadingIndicator.isHidden = false
        
        // API Call to submit reimbursement request
        Alamofire.request("https://reimbursementapi.herokuapp.com/reimbursements/", method: .post, parameters: parameters).validate().responseJSON { response in
            
            var alert = UIAlertController()
            var defaultAction = UIAlertAction()
            
            // Do Not Display Activity Indicator
            self.loadingIndicator.stopAnimating()
            self.loadingIndicator.isHidden = true
            
            switch response.result {
            case .success:
                print("Validation Successful")
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
            }
            alert.addAction(defaultAction)
            self.present(alert, animated: true, completion: nil)
        }
        
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
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
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
