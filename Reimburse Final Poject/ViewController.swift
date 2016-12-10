//
//  ViewController.swift
//  Reimburse Final Project
//

import UIKit
import Alamofire
import SwiftyJSON

class ViewController: UIViewController {
    
    var currentUser = User(id: 1, first_name: "", last_name: "", andrewID: "", email: "", smc: 0000, password: "")
    var dataManager = DataManager()
    
    @IBOutlet weak var tartanFooter: UIImageView!
    @IBOutlet weak var appBody: UIView!
    
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var andrewID: UITextField!
    
    // Nav BAr Actions
    @IBOutlet weak var loginButton: UIButton!
    @IBAction func login(_ sender: Any) {
        // Submit Form to login user
        let parameters: Parameters = [
            "andrewid": andrewID.text ?? "",
            "password": password.text ?? ""
        ]
        // API Call to authenticate user
        Alamofire.request("https://reimbursementapi.herokuapp.com/login", method: .get, parameters: parameters).validate().responseJSON { response in
            switch response.result {
            case .failure(let error):
                print("Error Login")
                // Display Error Alert
                let msg = "Invalid credentials"
                let alert = UIAlertController(title: "Error", message: msg, preferredStyle: UIAlertControllerStyle.alert)
                let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alert.addAction(defaultAction)
                self.present(alert, animated: true, completion: nil)
            case .success(let value):
                print("Successful Request")
                let json = JSON(value)
                print("Json: ", json)
                // Set Current User
                self.currentUser = User(id: Int(json["id"].stringValue)!, first_name: json["first_name"].stringValue, last_name: json["last_name"].stringValue, andrewID: json["andrewid"].stringValue, email: json["email"].stringValue, smc: Int(json["smc"].stringValue)!, password: self.password.text!)
                // Save User
                self.dataManager.user = self.currentUser
                self.dataManager.saveUser()
                // Show Requests List
                self.performSegue(withIdentifier: "successLogin", sender: self)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib
        // Status Bar Appearance
        UIApplication.shared.statusBarStyle = .default
        
        dataManager.loadUser()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews(){
        super.viewDidLayoutSubviews()
        // set rounded corners of footer
        setRoundedCornersOfBody()
    }
    
    // Resign TextField as First Responder
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
        super.touchesBegan(touches, with: event)
    }
    
    // Set Rounded Ends of Footer
    func setRoundedCornersOfBody(){
        let rectShape = CAShapeLayer()
        rectShape.bounds = self.appBody.bounds
        rectShape.path = UIBezierPath(roundedRect: self.appBody.bounds, byRoundingCorners: [.bottomLeft , .bottomRight], cornerRadii: CGSize(width: 20, height: 20)).cgPath
        rectShape.position = self.appBody.center
        self.appBody.layer.mask = rectShape
        
    }

}

