//
//  Request.swift
//  Reimburse Final Project
//
//  Created by Gaury Nagaraju on 11/13/16.
//  Copyright © 2016 Sina Siddiqi. All rights reserved.
//

import UIKit

class Request{
    
    // MARK: Properties
    var total: Float
    var description: String
    var status: String
    var requester: User
    var request_date: Date?
    var approval_date: Date?
    // Change to org class type
    var organization: String
    
    init(total: Float, description: String, status:String, requester: User, request_date: Date?, approval_date: Date?, organization: String){
        self.total = total
        self.description = description
        self.status = status
        self.requester = requester
        self.request_date = request_date
        self.approval_date = approval_date
        self.organization = organization
    }
    
    
}
