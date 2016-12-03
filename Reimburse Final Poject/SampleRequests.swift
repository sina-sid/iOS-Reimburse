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
        // TO BE FIXED: Test User
        let testUser = User(first_name: "TestF", last_name: "TestL", andrewID: "test", email: "test@andrew.cmu.edu", smc: 1234, org_roles: ["Scotch n Soda":"Member", "Mayur SASA":"Signer"])
        // API Call to get reimbursement requests
        Alamofire.request("https://reimbursementapi.herokuapp.com/reimbursements/", method: .get).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                print("Validation Successful")
                let json = JSON(value)
                let df = DateFormatter()
                df.dateStyle = DateFormatter.Style.short
                df.dateFormat = "yyyy/MM/dd"
                // Loop through requests
                for (key,subJson):(String, JSON) in json {
                    let reqDate = df.date(from: subJson["request_date"].stringValue)
                    let eventDate = df.date(from: subJson["event_date"].stringValue)
                    let tot = Float(subJson["total"].stringValue)
                    let noa = Int(subJson["num_of_attendees"].stringValue)
                    // Create Request Object
                    let req = Request(total: tot!, description: subJson["description"].stringValue, requester: testUser, request_date: reqDate!, organization: subJson["organization"].stringValue, event_date: eventDate!, event_name: subJson["event_name"].stringValue, event_location: subJson["event_location"].stringValue, num_of_attendees: noa!)
                    // Append to Requests Array
                    self.submittedRequests += [req]
                }
                self.sampleReqs += [self.submittedRequests, self.approvedRequests]
                // Loading is complete
                isLoading = false
                completionHandler(isLoading, nil)
            case .failure(let error):
                print(error)
                completionHandler(isLoading, error as NSError?)
            }
        }
    }
    
    // MARK: Load Sample Requests
    func loadSampleRequests(){
        
        // Submitted Requests
        let requester2 = User(first_name: "Jill", last_name: "Dane", andrewID: "jdane", email: "jdane@andrew.cmu.edu", smc: 3008, org_roles: ["Scotch n Soda":"Member", "Mayur SASA":"Signer"])
        let calendar = Calendar.current
        let twoDaysAgo = calendar.date(byAdding: .day, value: -2, to: Date())
        let request2 = Request(total: 18.30, description: "Francescas Senior Gifts",requester: requester2, request_date: twoDaysAgo!, organization: "Mayur SASA", event_date: twoDaysAgo!, event_name: "Diwali Eid", event_location: "Weigand Gym", num_of_attendees: 200)
        
        let requester3 = User(first_name: "Christina", last_name: "Bale", andrewID: "cbale", email: "cbale@andrew.cmu.edu", smc: 1982, org_roles: ["FORGE":"Member", "Explorers Club":"Member"])
        let request3 = Request(total: 20.0, description: "Francescas Senior Gifts", requester: requester3, request_date: NSDate() as Date, organization: "FORGE", event_date: NSDate() as Date, event_name: "Senior Farewell", event_location: "PH 125", num_of_attendees: 10)
        
        self.submittedRequests += [request2, request3]
        
        // Approved Requests
        let requester4 = User(first_name: "James", last_name: "Bond", andrewID: "jbond", email: "jbond@andrew.cmu.edu", smc: 2010, org_roles: ["PACE":"Member", "Dancers Symposium":"PContact"])
        let yesterday = calendar.date(byAdding: .day, value: -1, to: Date())
        let request4 = Request(total: 120.0, description: "Sweatshirt Order", requester: requester4, request_date: yesterday!, organization: "Dancers Symposium", event_date: yesterday!, event_name: "DS", event_location: "Rangos", num_of_attendees: 150)
        
        self.approvedRequests += [request4]
        
        // All Sample Requests
        sampleReqs += [submittedRequests, approvedRequests]
        
    }
    
}
