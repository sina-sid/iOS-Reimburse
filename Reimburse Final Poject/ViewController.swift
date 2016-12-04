//
//  ViewController.swift
//  Reimburse Final Project
//
//  Created by Sina Siddiqi on 11/9/16.
//  Copyright © 2016 Sina Siddiqi. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController {
    
    @IBOutlet weak var tartanFooter: UIImageView!
    @IBOutlet weak var appBody: UIView!
    
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var andrewID: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!
    @IBAction func login(_ sender: Any) {
        // Submit Form to login user
        let parameters: Parameters = [
            "andrewid": andrewID.text ?? "",
            "password": password.text ?? ""
        ]
        // API Call to authenticate user
        Alamofire.request("http://localhost:3000/login", method: .get, parameters: parameters).validate().responseJSON { response in
            switch response.result {
            case .failure(let error):
                print("Error")
                // Display Error Alert
                let msg = "Invalid credentials"
                let alert = UIAlertController(title: "Error", message: msg, preferredStyle: UIAlertControllerStyle.alert)
                let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alert.addAction(defaultAction)
                self.present(alert, animated: true, completion: nil)
            case .success:
                print("Validation Successful")
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
    
    func setRoundedCornersOfBody(){
        let rectShape = CAShapeLayer()
        rectShape.bounds = self.appBody.bounds
        rectShape.path = UIBezierPath(roundedRect: self.appBody.bounds, byRoundingCorners: [.bottomLeft , .bottomRight], cornerRadii: CGSize(width: 20, height: 20)).cgPath
        rectShape.position = self.appBody.center
        self.appBody.layer.mask = rectShape
        
    }

}

