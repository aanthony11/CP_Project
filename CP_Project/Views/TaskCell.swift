//
//  TaskCell.swift
//  CP_Project
//
//  Created by Adam Anderson on 4/15/20.
//  Copyright © 2020 Manish Rajendran. All rights reserved.
//

import UIKit

class TaskCell: UITableViewCell {
    
    @IBOutlet weak var taskLabel: UILabel!
    @IBOutlet weak var infoImageView: UIImageView!
    @IBOutlet weak var dutyLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
        self.accessoryType = selected ? .checkmark : .none
    }

}
