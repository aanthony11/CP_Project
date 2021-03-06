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
    @IBOutlet weak var errorLabel: UILabel!
    
    var currentUser = PFUser.current()
    var usersTempArray:[PFUser] = [PFUser.current()!]
    var emailsTempArray:[String] = [PFUser.current()!.username!]
    var group = PFObject(className:"Group")
    var image : UIImage?
    var userIds:[String] = []
    var groupsLst:[String] = []
    var count = 0
    var itr = 0
    var get_id = ""
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        searchBar.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.autocapitalizationType = .none
        
        self.errorLabel.alpha = CGFloat(0.0)
    }
    
    @IBAction func onCancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onCreate(_ sender: Any) {

        // SAVE GROUP TO PARSE
        if usersTempArray.count > 1 && groupName.text != "" {
            self.group["name"] = groupName.text
            self.group["users"] = usersTempArray
            self.group["count"] = usersTempArray.count
            self.group["owner"] = PFUser.current()
            
            // set group profile picture
            let imageData = image?.pngData()
            if imageData != nil {
                let file = PFFileObject(data: imageData!)
                self.group["groupPicture"] = file
            } else {
                let img = UIImage(named: "crown.png")
                let imgData = img?.pngData()
                let file1 = PFFileObject(data: imgData!)
                self.group["groupPicture"] = file1
            }
            for user in self.usersTempArray {
                self.userIds.append(user.objectId!)
            }
            
            self.group.saveInBackground { (succeeded, error)  in
                if (succeeded) {
                    
                    // CREATE CONNECTION FOR EVERY USER ADDED TO NEWLY CREATED GROUP
                    print("usersTempArray count: ", self.usersTempArray.count)
                    for user in self.usersTempArray {
                        
                        
                        let userToGroup = PFObject(className: "UserToGroup")
                        userToGroup["user"] = user
                        userToGroup["group"] = self.group
                        userToGroup["allUsers"] = self.userIds
                        userToGroup.saveInBackground()
                        
                        // store group id in user's userGroup dictionary
                        let query = PFQuery(className: "userGroups")
                        let uuid = user["userGroupsId"]
                        query.whereKey("uuidString", equalTo: uuid)
                        query.getFirstObjectInBackground { (object:PFObject?, error:Error?) in

                            let arr = object!["allUserGroups"] as? Array<String>
                            var arry:[String] = []
                            arry.append(contentsOf: arr!)
                            arry.append(self.group.objectId!)
                            object!["allUserGroups"] = arry
                            object!.saveInBackground()
                            
                        }
                        
                    }
                    
                    self.performSegue(withIdentifier: "goToHome", sender: self)

    
                } else {
                    print(error?.localizedDescription)
                    self.errorLabel.text = error?.localizedDescription
                    self.errorLabel.alpha = 1.0
                }
            }
        } else if groupName.text == "" {
            self.errorLabel.text = ("Add a Group Name to create a group.")
            
            UIView.animate(withDuration: 1.5, delay: 0, animations: {
                self.errorLabel.alpha = 1.0
            }, completion: {
                (Completed : Bool) -> Void in
                UIView.animate(withDuration: 1.5, delay: 2.0, animations: {
                self.errorLabel.alpha = 0
                })
            })
        } else if usersTempArray.count < 2 {
            self.errorLabel.text = "Add at least two users to create a group."
    
            UIView.animate(withDuration: 1.5, delay: 0, animations: {
                self.errorLabel.alpha = 1.0
            }, completion: {
                (Completed : Bool) -> Void in
                UIView.animate(withDuration: 1.5, delay: 2.0, animations: {
                self.errorLabel.alpha = 0
                })
            })
        }

        

        
        
                                                                                        //        print("Users temp array: ", usersTempArray)
                                                                                        //        // QUERY EVERY USER'S GROUPS ARRAY IN GROUP THAT WAS JUST CREATED
                                                                                        //        for user in usersTempArray {
                                                                                        //            print("Loop user: ", user)
                                                                                        //            // GET USER'S GROUP ARRAY
                                                                                        //            let query = PFQuery(className:"_User")
                                                                                        //            query.getObjectInBackground(withId: user.objectId!) { (userObj, error) in
                                                                                        //                if error == nil {
                                                                                        //                    var userGroups = userObj?.object(forKey: "groups") as? Array<String>
                                                                                        ////                    print(userGroups)
                                                                                        //                    if userGroups == nil{
                                                                                        //                        userGroups = []
                                                                                        //                    }
                                                                                        //                    // GOT USER'S GROUP ARRAY AND NOW UPDATE THE USER'S GROUP ARRAY
                                                                                        //                    userGroups?.append(self.group.objectId!)
                                                                                        ////                    print(userGroups)
                                                                                        //
                                                                                        //                    // NOW PUSH UPDATED GROUPS ARRAY TO PARSE
                                                                                        //                    userObj!["groups"] = userGroups
                                                                                        //                    userObj!.saveInBackground()
                                                                                        //
                                                                                        //                } else {
                                                                                        //                    print(error?.localizedDescription)
                                                                                        //                }
                                                                                        //            }
                                                                                        //        } //END FOR USER LOOP
        
        
        

        


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
            if objects!.count == 0 || objects?.count == nil {
                self.errorLabel.text = ("User not found or could not be added to group.")

                UIView.animate(withDuration: 1.5, delay: 0, animations: {
                   self.errorLabel.alpha = 1.0
                }, completion: {
                   (Completed : Bool) -> Void in
                   UIView.animate(withDuration: 1.5, delay: 2.0, animations: {
                   self.errorLabel.alpha = 0
                   })
                })
            }
            
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
                        self.errorLabel.text = ("User already ready to be added.")

                        UIView.animate(withDuration: 1.5, delay: 0, animations: {
                           self.errorLabel.alpha = 1.0
                        }, completion: {
                           (Completed : Bool) -> Void in
                           UIView.animate(withDuration: 1.5, delay: 2.0, animations: {
                           self.errorLabel.alpha = 0
                           })
                        })
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
        
        if indexPath.row == 0 {
            var firstEmail = "You: "
            firstEmail.append(emailsTempArray[indexPath.row])
            cell.textLabel?.text = firstEmail
        } else {
            cell.textLabel?.text = emailsTempArray[indexPath.row]
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection
                                section: Int) -> String? {
       return "Users to be added to group: "
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "goToHome" {
            print("going back to groupsViewController")
            //let destination = segue.destination as! GroupsViewController
            //destination.count = 0 // reset counter
            //destination.GroupTableView.reloadData() // TODO
            
        }
        
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
