//
//  DataManagerTest.swift
//  Reimburse Final Project
//
//  Created by Gaury Nagaraju on 12/13/16.
//
//

import XCTest
@testable import Reimburse_Final_Project

class DataManagerTest: XCTestCase {
    
    func testLoadUser(){
        let dataManager = DataManager()
        let user = User(id: 1, first_name: "Test First Name", last_name: "Test Last Name", andrewID: "testAndrew", email: "testemail@example.com", smc: 1234, password: "testPassword")
        dataManager.user = user
        dataManager.saveUser()
        // Check if UserInfo plist created
        let fileManager = FileManager()
        let fpath = dataManager.dataFilePath()
        XCTAssertTrue(fileManager.fileExists(atPath: fpath))
        // Check If User Correctly Stored & Loaded
        dataManager.loadUser()
        XCTAssertEqual(dataManager.user.andrewID, "testAndrew")
        XCTAssertEqual(dataManager.user.password, "testPassword")
    }
    
    func testClearUserInfo(){
        let dataManager = DataManager()
        dataManager.clearUserInfo()
        dataManager.loadUser()
        // Check if User Info cleared
        XCTAssertEqual(dataManager.user.andrewID, "")
        XCTAssertEqual(dataManager.user.password, "")
    }
    
}
