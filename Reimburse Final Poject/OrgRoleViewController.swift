//
//  OrgRoleViewController.swift
//  Reimburse Final Project
//
//  Created by Gaury Nagaraju on 12/5/16.
//
//

import UIKit

class OrgRoleViewController: UIViewController, UITableViewDataSource {
    
    // MARK: Properties
    @IBOutlet weak var userListTable: UITableView!
    @IBOutlet weak var tartanFooter: UIImageView!
    let cellIdentifier = "OrgRoleTableViewCell"

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        // Setup Table
        userListTable.dataSource = self
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
        return 3
    }
    
    // Configure Table Cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! OrgRoleTableViewCell
        
        // Configure the cell...
        cell.org.text = "OM"
        cell.role.text = "Member"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
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
