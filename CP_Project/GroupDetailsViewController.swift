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
    
    var usersTempArray:[PFUser] = []
    var userIds:[String] = []
    var user_names:[String] = []
    var arr:[String] = []
    var num = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        groupDetailTableView.delegate = self
        groupDetailTableView.dataSource = self
        
        addmembersButton.layer.cornerRadius = 10
        removemembersButton.layer.cornerRadius = 10
        
        // create variable for current user
        let user_current = PFUser.current()
        
        do {
            
            let query = PFQuery(className: "Group") // query for group class

            query.whereKey("name", equalTo: "Group 2") // search by group name (change Group 2 to label text)
            
            // make array of user Id's
            let lst = try query.getFirstObject()
            let arry = lst["Users"] as? Array<String> // make array from dictionary value
            userIds = arry! // set userIds to array of userd Id's
        }
        catch {
            // if list cant be found
            print("error occured")
        }

        print(userIds)

        for id in userIds {
            do {
                // query for user
                let query2 = PFQuery(className: "_User")
                let user = try query2.getObjectWithId(id)
                
                // get first and last name, and add to user_names array
                let name = "\(user["firstName"] as! String) \(user["lastName"] as! String)"
                user_names.append(name)
                
            }
            catch {
                // couldn't find user
            }
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return user_names.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       // let names = ["John Doe", "Jane Doe", "Timmy Turner", "Spongebob", "Jason Bourne"]
       // let random_num = Int.random(in: 0...4)
        
        let cell = groupDetailTableView.dequeueReusableCell(withIdentifier: "GroupDetailViewCell") as! GroupDetailViewCell
        cell.usernameLabel.text = user_names[self.num]
        num += 1
        
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
