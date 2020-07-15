//
//  SubCalendarTVC.swift
//  CP_Project
//
//  Created by Austin Anthony on 7/3/20.
//  Copyright © 2020 Manish Rajendran. All rights reserved.
//

import UIKit

class SubCalendarTVC: UITableViewCell {

    @IBOutlet weak var completetaskButton: UIButton!
    @IBOutlet weak var taskLabel: UILabel!
    @IBOutlet weak var groupLabel: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var taskDetails: UIButton!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
