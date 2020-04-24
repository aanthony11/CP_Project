//
//  CreateGroupViewController.swift
//  CP_Project
//
//  Created by Manish Rajendran on 4/22/20.
//  Copyright © 2020 Manish Rajendran. All rights reserved.
//

import UIKit
import Parse

class CreateGroupViewController: UIViewController, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var groupName: UITextField!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var usersTempArray:[PFUser] = []
    var emailsTempArray:[String] = []
    var group = PFObject(className:"Group")
    var groupCreationSuccess = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        // Do any additional setup after loading the view.
        
        searchBar.autocapitalizationType = .none
    }
    
    @IBAction func onCancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onCreate(_ sender: Any) {
//        for user in usersTempArray{
//            print(user)
//            let userId = user.objectId!
//            let query = PFQuery(className:"_User")
//            query.getObjectInBackground(withId: userId) { (gameScore: PFObject?, error: Error?) in
//                if let error = error {
//                    print(error.localizedDescription)
//                } else if let gameScore = gameScore {
////                    query["groups"] =
//                    gameScore.saveInBackground()
//                }
//            }
//        }
        
        // SAVE GROUP TO PARSE
        if usersTempArray.count > 1 && groupName.text != "" {
            self.group["name"] = groupName.text
            self.group["users"] = usersTempArray
            self.group["count"] = usersTempArray.count
            self.group.saveInBackground { (succeeded, error)  in
                if (succeeded) {
                    self.groupCreationSuccess = true
                } else {
                    print(error?.localizedDescription)
                }
            }
        } else {
            print("Need at least two users in group and/or group name")
        }
        
        
        print("Users temp array: ", usersTempArray)
        // QUERY EVERY USER'S GROUPS ARRAY IN GROUP THAT WAS JUST CREATED
        for user in usersTempArray {
            print("Loop user: ", user)
            // GET USER'S GROUP ARRAY
            let query = PFQuery(className:"_User")
            query.getObjectInBackground(withId: user.objectId!) { (userObj, error) in
                if error == nil {
                    var userGroups = userObj?.object(forKey: "groups") as? Array<String>
//                    print(userGroups)
                    if userGroups == nil{
                        userGroups = []
                    }
                    // GOT USER'S GROUP ARRAY AND NOW UPDATE THE USER'S GROUP ARRAY
                    userGroups?.append(self.group.objectId!)
//                    print(userGroups)

                    // NOW PUSH UPDATED GROUPS ARRAY TO PARSE
                    userObj!["groups"] = userGroups
                    userObj!.saveInBackground()

                } else {
                    print(error?.localizedDescription)
                }
            }
        } //END FOR USER LOOP
        
        
        
//        if self.groupCreationSuccess == true{
        self.dismiss(animated: true, completion: nil)
//        }

        


    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        print(usersTempArray)
//        print(emailsTempArray)
//        for object in usersTempArray {
//              print(object.username!)
//          }
        
        let username = searchBar.text!.lowercased()
        
        let query = PFQuery(className:"_User")
        query.whereKey("username", equalTo:username)
        query.findObjectsInBackground { (objects: [PFObject]?, error: Error?) in
            if let error = error {
                // Log details of the failure
                print(error.localizedDescription)
            } else if let objects = objects {
                // The find succeeded.
//                print("Successfully retrieved \(objects.count) users.")
                // Do something with the found objects
                for object in objects {
                    let tempUser = object as! PFUser
                    let tempEmail = tempUser.username!
                    if self.emailsTempArray.contains(tempEmail){
                        print("User already in array")
                    } else {
                        self.usersTempArray.append(tempUser)
                        self.emailsTempArray.append(tempUser.username!)
                        self.searchBar.text = ""
                    }
                }
            }
        self.tableView.reloadData()
        } //end query
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return emailsTempArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = emailsTempArray[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection
                                section: Int) -> String? {
       return "Users to be added to group: "
    }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        <#code#>
//    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
