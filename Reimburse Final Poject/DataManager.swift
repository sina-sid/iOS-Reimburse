//
//  DataManager.swift
//  Reimburse Final Project
//
//  Created by Gaury Nagaraju on 12/6/16.
//
//

import Foundation

// MARK: - String Extension

extension String {
    // recreating a function that String class no longer supports in Swift 2.3
    // but still exists in the NSString class. (This trick is useful in other
    // contexts as well when moving between NS classes and Swift counterparts.)
    
    /**
     Returns a new string made by appending to the receiver a given string.  In this case, a new string made by appending 'aPath' to the receiver, preceded if necessary by a path separator.
     
     - parameter aPath: The path component to append to the receiver. (String)
     
     - returns: A new string made by appending 'aPath' to the receiver, preceded if necessary by a path separator. (String)
     
     */
    func stringByAppendingPathComponent(aPath: String) -> String {
        let nsSt = self as NSString
        return nsSt.appendingPathComponent(aPath)
    }
}


// MARK: - Data Manager Class
class DataManager {
    
    // MARK: - General
    var user = User(first_name: "", last_name: "", andrewID: "", email: "", smc: 0000)
    
    init() {
        loadUser()
        print("Documents folder is \(documentsDirectory())\n")
        print("Data file path is \(dataFilePath())")
    }
    
    
    // MARK: - Data Location Methods
    
    func documentsDirectory() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        return paths[0]
    }
    
    func dataFilePath() -> String {
        return documentsDirectory().stringByAppendingPathComponent(aPath: "UserInfo.plist")
    }
    
    
    // MARK: - Saving, Loading & Clearing Data
    
    /**
     Saves user data to a plist.
     */
    
    func saveUser() {
        let data = NSMutableData()
        let archiver = NSKeyedArchiver(forWritingWith: data)
        archiver.encode(user, forKey: "User")
        archiver.finishEncoding()
        data.write(toFile: dataFilePath(), atomically: true)
    }
    
    /**
     Loads the data from a plist as user.
     */
    
    func loadUser() {
        let path = dataFilePath()
        if FileManager.default.fileExists(atPath: path) {
            if let data = NSData(contentsOfFile: path) {
                let unarchiver = NSKeyedUnarchiver(forReadingWith: data as Data)
                self.user = unarchiver.decodeObject(forKey: "User") as! User
                unarchiver.finishDecoding()
            } else {
                print("\nFILE NOT FOUND AT: \(path)")
            }
        }
    }
    
    /**
     Clear user data from a plist.
     */
    func clearUserInfo(){
        user.first_name=""
        user.last_name=""
        user.andrewID = ""
        user.email=""
        user.smc = 0000
        saveUser()
    }
    func destroyUser() {
        let path = dataFilePath()
        if FileManager.default.fileExists(atPath: path) {
            if let data = NSMutableDictionary(contentsOfFile: path){
                // TO BE FIXED: DOESN"T WORK CURRENTLY
                data.removeObject(forKey: "User")
                // Save Changes to Plist
                data.write(toFile: path, atomically: true)
            }
            else{
                print("\nFILE NOT FOUND AT: \(path)")
            }
        }
    }
    
}
