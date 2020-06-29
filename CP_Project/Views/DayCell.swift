//
//  DayCell.swift
//  CP_Project
//
//  Created by Austin Anthony on 6/20/20.
//  Copyright © 2020 Manish Rajendran. All rights reserved.
//

import UIKit

class DayCell: UITableViewCell {

    @IBOutlet weak var taskLabel: UILabel!
    @IBOutlet weak var userLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
