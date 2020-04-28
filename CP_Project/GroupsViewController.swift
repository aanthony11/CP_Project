//
//  GroupsViewController.swift
//  CP_Project
//
//  Created by Austin Anthony on 4/15/20.
//  Copyright © 2020 Manish Rajendran. All rights reserved.
//

import UIKit
import Parse

class GroupsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    @IBOutlet weak var createGroupButton: UIBarButtonItem!
    @IBOutlet weak var logoutButton: UIBarButtonItem!
    @IBOutlet weak var GroupTableView: UITableView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    
    
    
    
    var groups_lst:[String] = []
    var group_names:[String] = []
    var usersTempList:[PFUser] = []
    var count = 0
    var group_dict = [String:String]() // dictionary of group[name] --> groupId
    var table_data = [Int:String]()
    var group_id = ""
    var userGroupsId = ""
    var groupsIds:[String] = []
    var groupImg: UIImage?
    var IDtoImage = [Int:UIImage]()
    var imageDataList:[PFFileObject] = []
    
    let myRefreshControl = UIRefreshControl()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        GroupTableView.dataSource = self
        GroupTableView.delegate = self

        
        
        
        // create variable for current user
        let current_user = PFUser.current()
        let firstname = current_user!["firstName"] as! String
        let lastname = current_user!["lastName"] as! String
        let name = "\(firstname) \(lastname)"
        
        let data = current_user!["profilePicture"] as? PFFileObject
        
        if data != nil {
            do {
                
                // get image data and change image view
                let imgData = try data?.getData()
                let img = UIImage(data: imgData as! Data)
                profileImageView.image = img
           
            }
            catch {
                // image cant be loaded
            }
        }
        usernameLabel.text = name.capitalized
         
        
        do {
            
            let query3 = PFQuery(className: "_User")
            query3.whereKey("objectId", equalTo: current_user?.objectId)
            let usr_arr = try query3.getFirstObject()
            
            userGroupsId = usr_arr["userGroupsId"] as! String
            
        }
        catch {
            //
        }
        
        do {
            
           let query4 = PFQuery(className: "userGroups")
            query4.whereKey("uuidString", equalTo: userGroupsId)
            let group_arr = try query4.getFirstObject()
            groupsIds = group_arr["allUserGroups"] as! Array<String>
            
        }
        catch {
            // if error occurs
        }
        
         do {
             
             let query1 = PFQuery(className: "_User")
             query1.whereKey("objectId", equalTo: current_user?.objectId)
             let user_array = try query1.getFirstObject()
            let user_uuid = user_array["userGroupsId"]
            
            
            let query6 = PFQuery(className: "userGroups")
            query6.whereKey("uuidString", equalTo: user_uuid)
            let userGroupsArray = try query6.getFirstObject()
            //print("userGroupsArray: ", userGroupsArray)
            //print("allUsersGroups list: ",userGroupsArray["allUserGroups"])
             
             // make array of groupId's that user is in
             let user_groups = userGroupsArray["allUserGroups"] as! Array<String>
             groups_lst = user_groups // list of group id's
         
         }
         catch {
             // if user cant be found
             print("error occured1")
         }

         
         for id in groupsIds {
            var num = 0
             do {
                 // query for group
                 let query2 = PFQuery(className: "Group")
                 let group = try query2.getObjectWithId(id)
                 
                 group_names.append(group["name"] as! String)
                imageDataList.append(group["groupPicture"] as! PFFileObject)
                
                let imageData = group["groupPicture"] as? PFFileObject
                if imageData != nil {
                    do {
                        // get image data and change image view
                        let imgData = try imageData?.getData()
                        let img = UIImage(data: imgData as! Data)
                        groupImg = img
                        IDtoImage[num] = groupImg
                    
                     }
                     catch {
                         // image cant be loaded
                     }
        
                }
                 
             }
             catch{
                 // couldn't find group
                 print("couldn't find group")
             }
            num += 1
         }
        
         // create dictionary to hold group id's and group names [name] --> "groupid"
         var num = 0
         print("groups lst: ", groupsIds)
         for i in group_names {
             group_dict[i] = groupsIds[num]
             num += 1
         }
        
        // needed for pull to refresh
        myRefreshControl.addTarget(self, action: #selector(loadGroups), for: .valueChanged)
        GroupTableView.refreshControl = myRefreshControl
         
        
    }
    
    @objc func reloadData() {
        
        // pull up to refresh table
        self.GroupTableView.reloadData()
        self.myRefreshControl.endRefreshing()
        
    }
    
    @IBAction func createSegue(_ sender: Any) {
        performSegue(withIdentifier: "createGroupSegue", sender: self)
        
    }
    
    @IBAction func onLogout(_ sender: Any) {
            
        PFUser.logOut()
        UserDefaults.standard.set(false, forKey: "UserLoggedIn")
                   
        let main = UIStoryboard(name: "Main", bundle: nil)
        let viewController = main.instantiateViewController(withIdentifier: "ViewController")
        let sceneDelegate = self.view.window?.windowScene?.delegate as! SceneDelegate

        sceneDelegate.window?.rootViewController = viewController
        
    }
    
    @IBAction func unwindToViewControllerA(segue: UIStoryboardSegue) {}
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "detailSegue" {
            let titles_lst = [String](group_dict.keys)
            let cell = try sender as! UITableViewCell
            let indexpath = GroupTableView.indexPath(for: cell)!
            let title = titles_lst[indexpath.row]
            group_id = group_dict[title]!
            
            let detailController = segue.destination as! GroupDetailsViewController
            detailController.group_title = title
            detailController.group_id = group_id
        }
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
        let group_ids = [String](group_dict.values)
        let imageData = imageDataList[indexPath.row] // get image data of group
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "GroupCell") as! GroupCell
        
        // turn image data into UIImage and change imageView
        imageData.getDataInBackground { (imgData:Data?, error:Error?) in
            if let error = error {
                print(error.localizedDescription)
            } else if let imgData = imgData {
                print("succesfully got image data :)")
                let image = UIImage(data: imgData)
                cell.groupImageView.image = image
            }
        }
        
        table_data[indexPath.row] = group_titles[indexPath.row]
        cell.groupLabel.text = group_titles[indexPath.row]
        
        return cell
    }

    // pull to refresh data function
    @objc func loadGroups() {
        
        groups_lst.removeAll()
        group_names.removeAll()
        usersTempList.removeAll()
        count = 0
        group_dict.removeAll()
        table_data.removeAll()
        group_id = ""
        userGroupsId = ""
        groupsIds.removeAll()
        IDtoImage.removeAll()
        imageDataList.removeAll()
        
        let current_user = PFUser.current()
        do {
            
            let query3 = PFQuery(className: "_User")
            query3.whereKey("objectId", equalTo: current_user?.objectId)
            let usr_arr = try query3.getFirstObject()
            
            userGroupsId = usr_arr["userGroupsId"] as! String
            
        }
        catch {
            //
        }
        
        do {
            
           let query4 = PFQuery(className: "userGroups")
            query4.whereKey("uuidString", equalTo: userGroupsId)
            let group_arr = try query4.getFirstObject()
            groupsIds = group_arr["allUserGroups"] as! Array<String>
            
        }
        catch {
            // if error occurs
        }
        
         do {
             
             let query1 = PFQuery(className: "_User")
             query1.whereKey("objectId", equalTo: current_user?.objectId)
             let user_array = try query1.getFirstObject()
            let user_uuid = user_array["userGroupsId"]
            
            
            let query6 = PFQuery(className: "userGroups")
            query6.whereKey("uuidString", equalTo: user_uuid)
            let userGroupsArray = try query6.getFirstObject()
            //print("userGroupsArray: ", userGroupsArray)
            //print("allUsersGroups list: ",userGroupsArray["allUserGroups"])
             
             // make array of groupId's that user is in
             let user_groups = userGroupsArray["allUserGroups"] as! Array<String>
             groups_lst = user_groups // list of group id's
         
         }
         catch {
             // if user cant be found
             print("error occured1")
         }

         
         for id in groupsIds {
            var num = 0
             do {
                 // query for group
                 let query2 = PFQuery(className: "Group")
                 let group = try query2.getObjectWithId(id)
                 
                 group_names.append(group["name"] as! String)
                imageDataList.append(group["groupPicture"] as! PFFileObject)
                
                let imageData = group["groupPicture"] as? PFFileObject
                if imageData != nil {
                    do {
                        // get image data and change image view
                        let imgData = try imageData?.getData()
                        let img = UIImage(data: imgData as! Data)
                        groupImg = img
                        IDtoImage[num] = groupImg
                    
                     }
                     catch {
                         // image cant be loaded
                     }
        
                }
                 
             }
             catch{
                 // couldn't find group
                 print("couldn't find group")
             }
            num += 1
         }
        
         // create dictionary to hold group id's and group names [name] --> "groupid"
         var dict_index = 0
         print("groups lst: ", groupsIds)
         for i in group_names {
             group_dict[i] = groupsIds[dict_index]
             dict_index += 1
         }
        
        self.GroupTableView.reloadData()
        myRefreshControl.endRefreshing()
    }
    

}

