//
//  CalendarTableCell.swift
//  Alamofire
//
//  Created by Austin Anthony on 6/14/20.
//

import UIKit

class CalendarTableCell: UITableViewCell {

    var taskLabel = UILabel()
    var userLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(taskLabel)
        addSubview(userLabel)
        
        configureTaskLabel()
        configureUserLabel()
        setTaskContraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureTaskLabel() {
        taskLabel.numberOfLines = 0
        taskLabel.text = "this is the task"
    }
    
    func configureUserLabel() {
        userLabel.numberOfLines = 0
        userLabel.text = "Jane Doe"
    }
    
    func setTaskContraints() {
        taskLabel.translatesAutoresizingMaskIntoConstraints = false
        taskLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        taskLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12).isActive = true
        taskLabel.heightAnchor.constraint(equalToConstant: 80).isActive = true
        taskLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12).isActive = true
    }
    
   // func setUserConstraints() {
   //     userLabel.translatesAutoresizingMaskIntoConstraints = false
   //     userLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
   //     userLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12).isActive = true
   //     userLabel.heightAnchor.constraint(equalToConstant: 80).isActive = true
   //     userLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12).isActive = true
   // }
    
    
}
