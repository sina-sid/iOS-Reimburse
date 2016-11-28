//
//  SampleRequests.swift
//  Reimburse Final Project
//
//  Created by Gaury Nagaraju on 11/13/16.
//  Copyright © 2016 Sina Siddiqi. All rights reserved.
//

import UIKit

class SampleRequests{
    
    // MARK: Properties
    var pendingRequests = [Request]()
    var submittedRequests = [Request]()
    var approvedRequests = [Request]()
    var sampleReqs = [[Request]]()
    
    let typesOfReqs = ["Pending Requests", "Submitted Requests", "Approved Requests"]
    
    init(){
        loadSampleRequests()
    }
    
    // MARK: Load Sample Requests
    func loadSampleRequests(){
        
        // Pending Requests
        let requester1 = User(first_name: "Jane", last_name: "Doe", andrewID: "jdoe", email: "jdoe@andrew.cmu.edu", smc: 3109, org_roles: ["Scotch n Soda":"Signer", "Mayur SASA":"Member"])
        let request1 = Request(total: 20.0, description: "GEagle Cutlery Purchase", status: "Pending", requester: requester1, request_date: nil, approval_date: nil, organization: "Mayur SASA")
        
        self.pendingRequests += [request1]
        
        // Submitted Requests
        let requester2 = User(first_name: "Jill", last_name: "Dane", andrewID: "jdane", email: "jdane@andrew.cmu.edu", smc: 3008, org_roles: ["Scotch n Soda":"Member", "Mayur SASA":"Signer"])
        let calendar = Calendar.current
        let twoDaysAgo = calendar.date(byAdding: .day, value: -2, to: Date())
        let request2 = Request(total: 18.30, description: "Francescas Senior Gifts", status: "Submitted", requester: requester2, request_date: twoDaysAgo, approval_date: nil, organization: "Mayur SASA")
        
        let requester3 = User(first_name: "Christina", last_name: "Bale", andrewID: "cbale", email: "cbale@andrew.cmu.edu", smc: 1982, org_roles: ["FORGE":"Member", "Explorers Club":"Member"])
        let request3 = Request(total: 20.0, description: "Francescas Senior Gifts", status: "Submitted", requester: requester3, request_date: NSDate() as Date, approval_date: nil, organization: "FORGE")
        
        self.submittedRequests += [request2, request3]
        
        // Approved Requests
        let requester4 = User(first_name: "James", last_name: "Bond", andrewID: "jbond", email: "jbond@andrew.cmu.edu", smc: 2010, org_roles: ["PACE":"Member", "Dancers Symposium":"PContact"])
        let yesterday = calendar.date(byAdding: .day, value: -1, to: Date())
        let request4 = Request(total: 120.0, description: "Sweatshirt Order", status: "Approved", requester: requester4, request_date: yesterday, approval_date: NSDate() as Date, organization: "Dancers Symposium")
        
        self.approvedRequests += [request4]
        
        // All Sample Requests
        sampleReqs += [pendingRequests, submittedRequests, approvedRequests]
        
    }
    
}
