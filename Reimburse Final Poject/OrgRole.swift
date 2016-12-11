//
//  OrgRole.swift
//  Reimburse Final Project
//
//  PURPOSE: Model to store org + role for each user
//  Class Method that returns array of orgs in which user's role == MEMBER

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
