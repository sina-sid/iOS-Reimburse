//
//  User.swift
//  Reimburse Final Project
//
//  Created by Gaury Nagaraju on 11/13/16.
//  Copyright © 2016 Sina Siddiqi. All rights reserved.
//

import UIKit

class User{
    
    // MARK: Properties
    var first_name: String
    var last_name: String
    var andrewID: String
    var email: String
    var smc: Int
    var org_roles = [String:String]()
    
    init(first_name: String, last_name: String, andrewID: String, email: String, smc:Int, org_roles:[String:String]){
        self.first_name = first_name
        self.last_name = last_name
        self.andrewID = andrewID
        self.email = email
        self.smc = smc
        self.org_roles = org_roles
    }
    
}
