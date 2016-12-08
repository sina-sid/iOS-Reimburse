//
//  AppDelegate.swift
//  Reimburse Final Project
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    let dataManager = DataManager()
    
    /**
     Uses the dataManager instance to save user info in the ViewController to a plist
     */
    
    func saveData() {
        let controller = window!.rootViewController as! ViewController
        dataManager.user = controller.currentUser
        dataManager.saveUser()
    }
    
    /**
     Uses the dataManager instance to load user info from a plist and add to the ViewController
     */
    func restoreData() {
        dataManager.loadUser()
        let controller = window!.rootViewController as! ViewController
        if !dataManager.user.andrewID.isEmpty {
            controller.currentUser = dataManager.user
        }
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        // Override point for customization after application launch.
        
        // Navigation Bar Appearance Settings
        let navBar = UINavigationBar.appearance()
        navBar.barTintColor = UIColor(colorLiteralRed: 128.0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 1.0)
        navBar.tintColor = UIColor.white
        let attrs = [NSForegroundColorAttributeName:UIColor.white]
        navBar.titleTextAttributes = attrs
        
        // Restore User Login Info
        restoreData()
        if !dataManager.user.andrewID.isEmpty{
            // display requests tableViewController directly
            let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
            let initialViewController = storyBoard.instantiateViewController(withIdentifier: "requestsTableNavigationID")
            self.window?.rootViewController = initialViewController
            self.window?.makeKeyAndVisible()
        }
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
        saveData()
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        saveData()
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
        restoreData()
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        saveData()
    }
    


}

