//
//  GroupDetailsViewController.swift
//  CP_Project
//
//  Created by Austin Anthony on 4/15/20.
//  Copyright © 2020 Manish Rajendran. All rights reserved.
//

import UIKit
import Parse




class GroupDetailsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    @IBOutlet weak var removemembersButton: UIButton!
    @IBOutlet weak var addmembersButton: UIButton!
    @IBOutlet weak var ownerLabel: UILabel!
    @IBOutlet weak var groupnameLabel: UILabel!
    @IBOutlet weak var groupDetailTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        groupDetailTableView.delegate = self
        groupDetailTableView.dataSource = self
        
        addmembersButton.layer.cornerRadius = 10
        removemembersButton.layer.cornerRadius = 10
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let names = ["John Doe", "Jane Doe", "Timmy Turner", "Spongebob", "Jason Bourne"]
        let random_num = Int.random(in: 0...4)
        
        let cell = groupDetailTableView.dequeueReusableCell(withIdentifier: "GroupDetailViewCell") as! GroupDetailViewCell
        
        cell.usernameLabel.text = names[random_num]
        
        return cell
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
