//
//  OrgRoleTableViewCell.swift
//  Reimburse Final Project
//
//  Created by Gaury Nagaraju on 12/5/16.
//
//

import UIKit

class OrgRoleTableViewCell: UITableViewCell {
    
    // MARK: Properties
    @IBOutlet weak var role: UILabel!
    @IBOutlet weak var org: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
