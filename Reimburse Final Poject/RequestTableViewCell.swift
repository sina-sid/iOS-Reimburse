//
//  RequestTableViewCell.swift
//  Reimburse Final Poject
//
//  Created by Gaury Nagaraju on 11/13/16.
//  Copyright © 2016 Sina Siddiqi. All rights reserved.
//

import UIKit

class RequestTableViewCell: UITableViewCell {
    
    // MARK: Properties
    @IBOutlet weak var requester_date: UILabel!
    @IBOutlet weak var requester_name :UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
