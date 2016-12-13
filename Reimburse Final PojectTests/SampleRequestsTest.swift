//
//  SampleRequestsTest.swift
//  Reimburse Final Project
//

import XCTest
@testable import Reimburse_Final_Project

class SampleRequestsTest: XCTestCase {
    
    func testInitRequestsForUser(){
        let sampleRequest = SampleRequests()
        XCTAssertTrue(sampleRequest.submittedRequests.isEmpty)
        XCTAssertTrue(sampleRequest.approvedRequests.isEmpty)
        XCTAssertTrue(sampleRequest.sampleReqs.isEmpty)
    }
    
    func testLoadRequestsForUser(){
        let sampleRequest = SampleRequests()
        sampleRequest.loadRequestsForUser{ (isLoading, error) in
            if isLoading==false{
                // Date Formatter
                let dateFormatter = DateFormatter()
                dateFormatter.dateStyle = DateFormatter.Style.short
                // Check that no requests are approved
                XCTAssertTrue(sampleRequest.approvedRequests.isEmpty)
                // Check that 2 requests are submitted
                XCTAssertEqual(sampleRequest.submittedRequests.count, 2)
                // Check attributes of test event 1
                let testRequest1 = sampleRequest.submittedRequests[0]
                XCTAssertEqual(testRequest1.event_name, "Test Event")
                XCTAssertEqual(testRequest1.event_location, "Rangos")
                XCTAssertEqual(testRequest1.total, 20.0)
                XCTAssertEqual(testRequest1.organization, "OM")
                XCTAssertEqual(testRequest1.event_date, dateFormatter.date(from: "2016-12-08"))
                XCTAssertEqual(testRequest1.approval_date, dateFormatter.date(from: ""))
                // Check attributes of test event 2
                let testRequest2 = sampleRequest.submittedRequests[0]
                XCTAssertEqual(testRequest2.event_name, "Finals Weeks Giveaways")
                XCTAssertEqual(testRequest2.event_location, "Outside Dh")
                XCTAssertEqual(testRequest2.total, 30.0)
                XCTAssertEqual(testRequest2.organization, "Senate")
                XCTAssertEqual(testRequest2.event_date, dateFormatter.date(from: "2016-12-09"))
                XCTAssertEqual(testRequest2.approval_date, dateFormatter.date(from: ""))
            }
            else{
                // Check that no requests loaded
                XCTAssertTrue(sampleRequest.submittedRequests.isEmpty)
                XCTAssertTrue(sampleRequest.approvedRequests.isEmpty)
                XCTAssertTrue(sampleRequest.sampleReqs.isEmpty)
            }
        }
    }
    
    func testLoadSampleRequests(){
        let sampleRequest = SampleRequests()
        sampleRequest.loadSampleRequests()
        // Check counts of submitted and approved requests
        XCTAssertEqual(sampleRequest.submittedRequests.count, 2)
        XCTAssertEqual(sampleRequest.approvedRequests.count, 1)
        XCTAssertEqual(sampleRequest.sampleReqs.count, 2)
        // Check attributes of submitted requests
        // Check attribute of request 1
        let testRequest1 = sampleRequest.submittedRequests[0]
        XCTAssertEqual(testRequest1.event_name, "Diwali Eid")
        XCTAssertEqual(testRequest1.event_location, "Weigand Gym")
        XCTAssertEqual(testRequest1.total, 18.30)
        XCTAssertEqual(testRequest1.organization, "Mayur SASA")
        XCTAssertEqual(testRequest1.approval_date, nil)
        // Check attributes of request 2
        let testRequest2 = sampleRequest.submittedRequests[1]
        XCTAssertEqual(testRequest2.event_name, "Senior Farewell")
        XCTAssertEqual(testRequest2.event_location, "PH 125")
        XCTAssertEqual(testRequest2.total, 20.0)
        XCTAssertEqual(testRequest2.organization, "FORGE")
        XCTAssertEqual(testRequest2.approval_date, nil)
        // Check attributes of approved requests
        let testRequest3 = sampleRequest.approvedRequests[0]
        XCTAssertEqual(testRequest3.event_name, "DS")
        XCTAssertEqual(testRequest3.event_location, "Rangos")
        XCTAssertEqual(testRequest3.total, 120.0)
        XCTAssertEqual(testRequest3.organization, "Dancers Symposium")
        
    }
    
}
