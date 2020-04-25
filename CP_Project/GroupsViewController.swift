//
//  GroupsViewController.swift
//  CP_Project
//
//  Created by Austin Anthony on 4/15/20.
//  Copyright © 2020 Manish Rajendran. All rights reserved.
//

import UIKit
import Parse

class GroupsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    @IBOutlet weak var logoutButton: UIBarButtonItem!
    @IBOutlet weak var GroupTableView: UITableView!
    
    var groups_lst:[String] = []
    var group_names:[String] = []
    var usersTempList:[PFUser] = []
    var count = 0
    var group_dict = [String:String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        GroupTableView.dataSource = self
        GroupTableView.delegate = self
        
        // create variable for current user
         let current_user = PFUser.current()
         
         let query = PFQuery(className:"Group")
         query.getObjectInBackground(withId: "RAn718yP3z") { (group, error) in
             if error == nil {
                 // Success!
                 print("group retrival was sucessful")
             } else {
                 // Fail!
                 print("error occured: \(error?.localizedDescription)")
             }
         }
         do {
             
             let query1 = PFQuery(className: "_User")
             query1.whereKey("objectId", equalTo: current_user?.objectId)
             let user_array = try query1.getFirstObject()
             
             // make array of groupId's that user is in
             let user_groups = user_array["groups"] as! Array<String>
             groups_lst = user_groups
         
         }
         catch {
             // if user cant be found
             print("error occured1")
         }

         
         for id in groups_lst {
             do {
                 // query for group
                 let query2 = PFQuery(className: "Group")
                 let group = try query2.getObjectWithId(id)
                 
                 group_names.append(group["name"] as! String)
                 
             }
             catch{
                 // couldn't find group
                 print("couldn't find group")
             }
         }
         // create dictionary to hold group id's and group names [name] --> "groupid"
         var num = 0
         print("groups lst: ", groups_lst)
         for i in group_names {
             group_dict[i] = groups_lst[num]
             num += 1
         }
         
         print("group dictionary: ", group_dict)
        
    }
    
    
    @IBAction func onLogout(_ sender: Any) {
            
        PFUser.logOut()
        UserDefaults.standard.set(false, forKey: "UserLoggedIn")
                   
        let main = UIStoryboard(name: "Main", bundle: nil)
        let viewController = main.instantiateViewController(withIdentifier: "ViewController")
        let sceneDelegate = self.view.window?.windowScene?.delegate as! SceneDelegate

        sceneDelegate.window?.rootViewController = viewController
        
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return group_dict.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // image of group, user may choose group image
        let photos = ["crown.png","fish.png","smiley.png","hat.png","shinin.png","rocket.png"]
        let random_num = Int.random(in: 0...5)
        let group_titles = [String](group_dict.keys)
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "GroupCell") as! GroupCell
        cell.groupImageView.image = UIImage(named: photos[random_num])
        cell.groupLabel.text = group_titles[count]
        count += 1
        
        //let findGroup = groups[indexPath.row]
                
        
        return cell
    }

    

}

