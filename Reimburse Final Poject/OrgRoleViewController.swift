//
//  OrgRoleViewController.swift
//  Reimburse Final Project
//
//  Created by Gaury Nagaraju on 12/5/16.
//
//

import UIKit
import Alamofire
import SwiftyJSON

class OrgRoleViewController: UIViewController, UITableViewDataSource {
    
    // MARK: Properties
    @IBOutlet weak var userListTable: UITableView!
    @IBOutlet weak var tartanFooter: UIImageView!
    
    let dataManager = DataManager()
    let cellIdentifier = "OrgRoleTableViewCell"
    var orgRoles = [OrgRole]()
    
    // Nav Bar Button Actions
    @IBAction func logout(_ sender: Any) {
        // API Call to Logout
        logoutCurrentUser{ (isLoading, error) in
            if isLoading == false{
                // Delete Info From Plist If Saved
                // self.dataManager.destroyUser()
                self.dataManager.clearUserInfo()
                // Segue to Login View Controller
                self.performSegue(withIdentifier: "logoutSegue", sender: self)
            }
            else{
                print("Error: ", error)
                // Display Alert
                let msg = "Couldn't Log Out. \nPlease Try Again."
                let alert = UIAlertController(title: "Error", message: msg, preferredStyle: UIAlertControllerStyle.alert)
                let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alert.addAction(defaultAction)
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    func logoutCurrentUser(completionHandler: @escaping (Bool?, NSError?) -> ()){
        var isLoading = true 
        // API Call to logout
        Alamofire.request("https://reimbursementapi.herokuapp.com/logout/", method: .get).validate().responseJSON { response in
            switch response.result {
            case .success:
                print("Logout Successful")
                // Loading is complete
                isLoading = false
                completionHandler(isLoading, nil)
            case .failure(let error):
                print("Error: ", error)
                isLoading = true
                completionHandler(isLoading, error as NSError?)
            }
        }
    }
    @IBAction func newUserOrg(_ sender: Any) {
        self.performSegue(withIdentifier: "orgRoleSegue", sender: self)
    }
    @IBAction func done(_ sender: Any) {
        // Allow Transition to View Requests List only after selecting atleast one org.
        if orgRoles.count < 1{
            // Display Alert
            let msg = "Please Select atleast one organization."
            let alert = UIAlertController(title: "Error", message: msg, preferredStyle: UIAlertControllerStyle.alert)
            let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(defaultAction)
            self.present(alert, animated: true, completion: nil)
        }
        else{
            self.performSegue(withIdentifier: "cancelSettingsList", sender: self)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // Status Bar Appearance
        UIApplication.shared.statusBarStyle = .lightContent
        
        // Display Info Alert
        let msg = "Add Org and Click Done to Start a Request"
        let alert = UIAlertController(title: "Welcome", message: msg, preferredStyle: UIAlertControllerStyle.alert)
        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(defaultAction)
        self.present(alert, animated: true, completion: nil)
        
        // Setup Table
        userListTable.dataSource = self
        loadOrgRoles{ (isLoading, error) in
            if isLoading == false{
                self.userListTable.reloadData()
            }
            else{
                print("Error: ", error!)
                // Display Alert
                let msg = "Error Loading App. \nPlease Reload App"
                let alert = UIAlertController(title: "Error", message: msg, preferredStyle: UIAlertControllerStyle.alert)
                let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alert.addAction(defaultAction)
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    func loadOrgRoles(completionHandler: @escaping (Bool?, NSError?) -> ()){
        var isLoading = true
        // API Call to get org roles
        let ad = UIApplication.shared.delegate as! AppDelegate
        let u = ad.dataManager.user
        let reqURL = "https://reimbursementapi.herokuapp.com/orgs_for_user/" + String(u.id)
        Alamofire.request(reqURL, method: .get).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                print("Successful Getting orgs for each user")
                let json = JSON(value)
                // Loop through requests
                for (key,subJson):(String, JSON) in json {
                    // Create Request Object
                    let userOrg = OrgRole(org: subJson["organization"].stringValue, role: subJson["role"].stringValue)
                    // Append to Requests Array
                    self.orgRoles += [userOrg]
                }
                // Loading is complete
                isLoading = false
                completionHandler(isLoading, nil)
            case .failure(let error):
                print("Orgs for user error: ", error)
                isLoading = true
                completionHandler(isLoading, error as NSError?)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table View Delegate Methods
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if orgRoles.count < 1{
            return 1
        }
        else{
            return orgRoles.count
        }
    }
    
    // Configure Table Cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! OrgRoleTableViewCell
        // No Existing Org Roles
        if orgRoles.count < 1{
            cell.textLabel?.text = "No Organizations listed. Please Add One."
            cell.textLabel?.adjustsFontSizeToFitWidth = true
            cell.detailTextLabel?.text = ""
            cell.isUserInteractionEnabled = false
        }
        else{
            // Configure the cell with Org Role
            let orgRole = orgRoles[indexPath.row]
            cell.org.text = orgRole.org
            cell.role.text = orgRole.role
        }
        return cell
    }
    
    private func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
