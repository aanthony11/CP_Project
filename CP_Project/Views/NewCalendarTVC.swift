//
//  NewCalendarTVC.swift
//  CP_Project
//
//  Created by Austin Anthony on 6/27/20.
//  Copyright © 2020 Manish Rajendran. All rights reserved.
//

import UIKit

class NewCalendarTVC: UITableViewCell {

    @IBOutlet weak var completeTaskButton: UIButton!
    @IBOutlet weak var taskLabel: UILabel!
    @IBOutlet weak var groupLabel: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var infoButton: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        
    }

}
