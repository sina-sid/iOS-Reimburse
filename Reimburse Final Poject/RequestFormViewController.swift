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
    
    // TO BE FIXED: Get List of Orgs from API.
    var orgs = ["OM", "Emerging Leaders", "Senate", "StuGov Cabinet"]
    
    let validator = Validator()
    
    // MARK: - Properties
    @IBOutlet weak var eventName: UITextField!
    @IBOutlet weak var eventDate: UITextField!
    @IBOutlet weak var eventLoc: UITextField!
    @IBOutlet weak var eventNumOfAttendees: UITextField!
    @IBOutlet weak var org: UITextField!
    @IBOutlet weak var total: UITextField!
    @IBOutlet weak var purchaseDescription: UITextView!
    
    @IBAction func submit(_ sender: AnyObject) {
        validator.validate(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
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
                "description": purchaseDescription.text!
            ]
        ]
        Alamofire.request("http://localhost:3000/reimbursements/", method: .post, parameters: parameters)
        
        // Display Confirmation
        let alert = UIAlertController(title: "Success", message: "Submitted Request. \nPending Signer Approval", preferredStyle: UIAlertControllerStyle.alert)
        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(defaultAction)
        self.present(alert, animated: true, completion: nil)
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
