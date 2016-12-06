//
//  RequestsTableViewController.swift
//  Reimburse Final Project
//
//  Created by Gaury Nagaraju on 11/13/16.
//  Copyright © 2016 Sina Siddiqi. All rights reserved.
//

import UIKit

class RequestTableViewController: UITableViewController {
    
    // MARK: Properties
    let cellIdentifier = "RequestTableViewCell"
    let sampleReq = SampleRequests()
    
    @IBOutlet weak var topNavBar: UINavigationItem!
    
    @IBAction func newReimbursementRequest(_ sender: Any) {
        self.performSegue(withIdentifier: "newReimbursementRequest", sender: self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Load Requests Data from API
        sampleReq.loadRequestsForUser{ (isLoading, error) in
            if isLoading == false{
                self.tableView.reloadData()
            }
            else{
                print("Error: ", error)
                // Display Alert
                let msg = "Error Loading App. \nPlease Reload App"
                let alert = UIAlertController(title: "Error", message: msg, preferredStyle: UIAlertControllerStyle.alert)
                // Segue to Screen: list of reimbursement requests
                let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alert.addAction(defaultAction)
                self.present(alert, animated: true, completion: nil)
            }
        }
        
        // Status Bar Appearance
        UIApplication.shared.statusBarStyle = .default
        
        // Nav Bar Appearance
        let attrs = [NSForegroundColorAttributeName:UIColor.white, NSFontAttributeName: UIFont.systemFont(ofSize: 14.0)]
        self.navigationController?.navigationBar.titleTextAttributes = attrs
        
//        // Configure Table Title
//        let tableTitle = UIView()
//        let label = UILabel(frame: CGRect(x: self.tableView.frame.origin.x, y: self.tableView.frame.origin.y+20.0, width: self.tableView.frame.width, height: 10.0))
//        label.text = "Welcome Jane!"
//        tableTitle.addSubview(label)
//        self.tableView.tableHeaderView = tableTitle
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        // Status Bar Appearance
        UIApplication.shared.statusBarStyle = .lightContent
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return sampleReq.sampleReqs.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return sampleReq.sampleReqs[section].count
    }
    
    // Configure Section Header for Table View
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sampleReq.typesOfReqs[section]
    }
    
    // Configure Table Cell
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let req = sampleReq.sampleReqs[indexPath.section][indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! RequestTableViewCell

        // Configure the cell...
        cell.requester_name.text = req.requester.first_name + " " + req.requester.last_name
        let df = DateFormatter()
        cell.requester_date.text = df.string(from: req.request_date)

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showSubmittedRequest", sender: self)
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Populate Form with Values if Rquest already submiited
        if let cell = sender as? UITableViewCell{
            if segue.identifier == "showSubmittedRequest" {
                let navController = segue.destination as! UINavigationController
                let formView:RequestFormViewController = navController.topViewController as! RequestFormViewController
                let index = tableView.indexPath(for: cell)
                let request = sampleReq.sampleReqs[index!.section][index!.row]
                formView.en = request.event_name
                let df = DateFormatter()
                formView.ed = df.string(from: request.event_date)
                formView.el = request.event_location
                formView.noa = String(request.num_of_attendees)
                formView.o = request.organization
                formView.tot = String(request.total)
                formView.pd = request.description
                formView.disableFieldEditing = true
                formView.submitButtonIsHidden = true
                formView.saveBarButtonIsEnabled = false
                formView.cancelBarButtonIsHidden = true
                
            }// end of segue if loop
        }// end of cell if loop
            
    }

}