//
//  ViewController.swift
//  Reimburse Final Project
//
//  Created by Sina Siddiqi on 11/9/16.
//  Copyright © 2016 Sina Siddiqi. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var tartanFooter: UIImageView!
    @IBOutlet weak var appBody: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib
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

