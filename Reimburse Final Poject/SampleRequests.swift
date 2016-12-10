//
//  SampleRequests.swift
//  Reimburse Final Project
//
//  Created by Gaury Nagaraju on 11/13/16.
//  Copyright © 2016 Sina Siddiqi. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class SampleRequests{
    
    // MARK: Properties
    var submittedRequests = [Request]()
    var approvedRequests = [Request]()
    var sampleReqs = [[Request]]()
    
    let typesOfReqs = ["Submitted Requests", "Approved Requests"]
    
//    init(){
//        // loadSampleRequests()
//        // loadRequestsForUser()
//    }
    
    // MARK: Load Requests for User
    func loadRequestsForUser(completionHandler: @escaping (Bool?, NSError?) -> ()){
        var isLoading = true
        let ad = UIApplication.shared.delegate as! AppDelegate
        let u = ad.dataManager.user
        let reqURL = "https://reimbursementapi.herokuapp.com/requests_for_user/" + String(u.id)
        // API Call to get reimbursement requests
        Alamofire.request(reqURL, method: .get).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                print("Validation Successful")
                let json = JSON(value)
                let df = DateFormatter()
                df.dateStyle = DateFormatter.Style.short
                df.dateFormat = "yyyy/MM/dd"
                // Loop through requests
                for (key,subJson):(String, JSON) in json {
                    var approvalDate: Date? = nil
                    if subJson["approval_date"] is NSNull{
                        approvalDate = nil
                    }
                    else{
                        approvalDate = df.date(from: subJson["approval_date"].stringValue)
                    }
                    let reqDate = df.date(from: subJson["request_date"].stringValue)
                    let eventDate = df.date(from: subJson["event_date"].stringValue)
                    let tot = Float(subJson["total"].stringValue)
                    let noa = Int(subJson["num_of_attendees"].stringValue)
                    // Create Request Object
                    let req = Request(total: tot!, description: subJson["description"].stringValue, approval_date: approvalDate, request_date: reqDate!, organization: subJson["organization"].stringValue, event_date: eventDate!, event_name: subJson["event_name"].stringValue, event_location: subJson["event_location"].stringValue, num_of_attendees: noa!)
                    // Append to Requests Array
                    if approvalDate == nil {
                        self.submittedRequests += [req]
                    }
                    else{
                        self.approvedRequests += [req]
                    }
                    
                }
                self.sampleReqs += [self.submittedRequests, self.approvedRequests]
                // Loading is complete
                isLoading = false
                completionHandler(isLoading, nil)
            case .failure(let error):
                print(error)
                isLoading = true
                completionHandler(isLoading, error as NSError?)
            }
        }
    }
    
    // MARK: Load Sample Requests: FOR TESTING PURPOSES
    func loadSampleRequests(){
        
        // Submitted Requests
        let calendar = Calendar.current
        let twoDaysAgo = calendar.date(byAdding: .day, value: -2, to: Date())
        let request2 = Request(total: 18.30, description: "Francescas Senior Gifts",approval_date: nil, request_date: twoDaysAgo!, organization: "Mayur SASA", event_date: twoDaysAgo!, event_name: "Diwali Eid", event_location: "Weigand Gym", num_of_attendees: 200)
        
        let request3 = Request(total: 20.0, description: "Francescas Senior Gifts", approval_date: nil, request_date: NSDate() as Date, organization: "FORGE", event_date: NSDate() as Date, event_name: "Senior Farewell", event_location: "PH 125", num_of_attendees: 10)
        
        self.submittedRequests += [request2, request3]
        
        // Approved Requests
        let yesterday = calendar.date(byAdding: .day, value: -1, to: Date())
        let request4 = Request(total: 120.0, description: "Sweatshirt Order", approval_date: NSDate() as Date, request_date: yesterday!, organization: "Dancers Symposium", event_date: yesterday!, event_name: "DS", event_location: "Rangos", num_of_attendees: 150)
        
        self.approvedRequests += [request4]
        
        // All Sample Requests
        sampleReqs += [submittedRequests, approvedRequests]
        
    }
    
}
