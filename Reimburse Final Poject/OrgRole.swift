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
    
    init(org: String, role: String){
        self.org = org
        self.role = role
    }
    
    // Returns Array of Orgs in which user is member
    class func getMemberOrgs(orgRoles: Array<OrgRole>) -> Array<String>{
        var orgs: Array<String> = []
        for i in 0..<orgRoles.count{
            let o = orgRoles[i].org
            let r = orgRoles[i].role
            if r=="Member"{
                orgs.append(o)
            }// End of if
        }// End of for loop
        return orgs
    }
}
