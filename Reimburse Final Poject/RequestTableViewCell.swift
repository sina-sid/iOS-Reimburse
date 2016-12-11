//
//  RequestTableViewCell.swift
//  Reimburse Final Project
//
//  PURPOSE: View Model for Cell in RequestTable VC

import UIKit

class RequestTableViewCell: UITableViewCell {
    
    // MARK: Properties
    @IBOutlet weak var event_name: UILabel!
    @IBOutlet weak var total: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
