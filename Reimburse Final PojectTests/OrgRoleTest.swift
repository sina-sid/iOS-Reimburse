//
//  OrgRoleTest.swift
//  Reimburse Final Project
//

import XCTest
@testable import Reimburse_Final_Project

class OrgRoleTest: XCTestCase {
    
    func testGetMemberOrgs(){
        let og1 = OrgRole(org: "OM", role: "Signer")
        let og2 = OrgRole(org: "Senate", role: "Member")
        let og3 = OrgRole(org: "ACM", role: "Member")
        let orgRoles = [og1, og2, og3]
        let results = OrgRole.getMemberOrgs(orgRoles: orgRoles)
        XCTAssertEqual(results.count, 2)
        XCTAssertEqual(results[0], "Senate")
        XCTAssertEqual(results[1], "ACM")
    }
    
}
