//
//  OrgRole.swift
//  Reimburse Final Project
//
//  Created by Gaury Nagaraju on 12/6/16.
//
//

import UIKit
import Alamofire

class OrgRole{
    
    // MARK: - Properties
    var org: String
    var role: String
    var user: User
    
    init(org: String, role: String, user: User){
        self.org = org
        self.role = role
        self.user = user
    }
    
}
