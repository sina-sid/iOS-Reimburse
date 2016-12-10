//
//  User.swift
//  Reimburse Final Project
//
//  Created by Gaury Nagaraju on 11/13/16.
//  Copyright © 2016 Sina Siddiqi. All rights reserved.
//

import UIKit

class User: NSObject, NSCoding{
    
    // MARK: Properties
    var id: Int
    var first_name: String
    var last_name: String
    var andrewID: String
    var email: String
    var smc: Int
    var password: String
    
    init(id: Int, first_name: String, last_name: String, andrewID: String, email: String, smc:Int, password:String){
        self.id = id
        self.first_name = first_name
        self.last_name = last_name
        self.andrewID = andrewID
        self.email = email
        self.smc = smc
        self.password = password
        super.init()
    }
    
    // MARK: - Encoding
    required init(coder aDecoder: NSCoder) {
        self.id = Int(aDecoder.decodeInt64(forKey: "id"))
        self.first_name = aDecoder.decodeObject(forKey: "FirstName") as! String
        self.last_name = aDecoder.decodeObject(forKey: "LastName") as! String
        self.andrewID = aDecoder.decodeObject(forKey: "AndrewID") as! String
        self.email = aDecoder.decodeObject(forKey: "Email") as! String
        self.smc = Int(aDecoder.decodeInt64(forKey: "SMC"))
        self.password = aDecoder.decodeObject(forKey: "Password") as! String
        super.init()
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(id, forKey: "ID")
        aCoder.encode(first_name, forKey: "FirstName")
        aCoder.encode(last_name, forKey: "LastName")
        aCoder.encode(andrewID, forKey: "AndrewID")
        aCoder.encode(email, forKey: "Email")
        aCoder.encode(smc, forKey: "SMC")
        aCoder.encode(password, forKey: "Password")
    }
    
}
