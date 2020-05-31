//
//  GroupDetailViewCell.swift
//  CP_Project
//
//  Created by Austin Anthony on 4/22/20.
//  Copyright © 2020 Manish Rajendran. All rights reserved.
//

import UIKit

class GroupDetailViewCell: UITableViewCell {

    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var profilePicture: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.profilePicture.layer.cornerRadius = self.profilePicture.frame.size.width / 2
        self.profilePicture.layer.borderColor = UIColor.black.cgColor
        self.profilePicture.layer.borderWidth = 1.6
        self.profilePicture.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
