//
//  Request.swift
//  Reimburse Final Project
//
//  Created by Gaury Nagaraju on 11/13/16.
//  Copyright © 2016 Sina Siddiqi. All rights reserved.
//

import UIKit
import Alamofire

class Request{
    
    // MARK: Properties
    // Request Details
    var total: Float
    var description: String
    var request_date: Date
    // Event Details
    var event_date: Date
    var event_name: String
    var event_location: String
    var num_of_attendees: Int
    // Change to org class type
    var organization: String
    
    init(total: Float, description: String, request_date: Date, organization: String, event_date: Date, event_name: String, event_location: String, num_of_attendees: Int){
        self.total = total
        self.description = description
        self.request_date = request_date
        self.organization = organization
        self.event_date = event_date
        self.event_name = event_name
        self.event_location = event_location
        self.num_of_attendees = num_of_attendees
    }
    
}
