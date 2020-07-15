//
//  TaskCell.swift
//  CP_Project
//
//  Created by Adam Anderson on 4/15/20.
//  Copyright © 2020 Manish Rajendran. All rights reserved.
//

import UIKit
import Parse

protocol TaskCellDelegate {
    func didTapCompleteTask(tag: Int, groupId: String)
}


class TaskCell: UITableViewCell {
    
    @IBOutlet weak var taskLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var groupLabel: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var taskdetailsButton: UIButton!
    @IBOutlet weak var taskcompleteButton: UIButton!
    
    var delegate: TaskCellDelegate?
    var groupId = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
        self.accessoryType = selected ? .checkmark : .none
    }

    @IBAction func buttonClicked(_ sender: Any) {
        delegate?.didTapCompleteTask(tag: self.tag, groupId: groupId)
    }
}
