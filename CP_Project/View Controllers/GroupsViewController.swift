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
    
    
    
    var helper = ParseHelper()
    var groups:Array<PFObject> = []
    var groupIds:Array<String> = []
    var table_data = [Int:String]()
    var groupImg: UIImage?
    var name = ""
    
    
    let myRefreshControl = UIRefreshControl()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        GroupTableView.dataSource = self
        GroupTableView.delegate = self
        
        print(":)", groups)
        
        // make profile picture circular
        self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.width / 2
        self.profileImageView.layer.borderColor = UIColor.black.cgColor
        self.profileImageView.layer.borderWidth = 1.6
        self.profileImageView.clipsToBounds = true
        
        // create variable for current user
        let current_user = PFUser.current()
        let firstname = current_user!["firstName"] as! String
        let lastname = current_user!["lastName"] as! String
        let name = "\(firstname) \(lastname)"
        
        let data = current_user!["profilePicture"] as? PFFileObject
        
        // get users profile picture
        if data != nil {
            do {
                // get image data and change image view
                let imgData = try data?.getData()
                let img = UIImage(data: imgData as! Data)
                profileImageView.image = img
            }
            catch {
                // image cant be loaded
                print("Profile Picture can't be loaded")
            }
        }
        
        usernameLabel.text = name.capitalized
         
  //      helper.getGroupsFromPFUser(user: PFUser.current()!) { (groups, error) in
  //          for group in groups! {
  //              if self.groupIds.contains(group.objectId!) {
  //                  print("Group already in array")
  //              } else {
  //                  print("appending")
  //                  self.groups.append(group)
  //                  self.groupIds.append(group.objectId!)
  //              }
  //          }
  //      }
        
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
    
    func getGroupsFromPFUser(user: PFUser) -> Void {
        let query = PFQuery(className:"UserToGroup")
        query.whereKey("user", equalTo:user)
        query.includeKeys(["group"])
        query.selectKeys(["group"])
        query.findObjectsInBackground { (objects: [PFObject]?, error: Error?) in
            if let error = error {
                // Log details of the failure
                print(error.localizedDescription)
            } else if let objects = objects {
                // The find succeeded.
                print("Successfully retrieved \(objects.count) groups.")
                // Do something with the found objects
                for object in objects{
                    let group = object["group"] as! PFObject
                    if self.groupIds.contains(group.objectId as! String) {
                        print("Group already in array")
                    } else {
                        self.groups.append(group)
                        self.groupIds.append(group.objectId as! String)
                    }
                    
                }
            }
            self.GroupTableView.reloadData()
        }
    }
    
    func getUserInfo(userId: String) -> Void {
        let query = PFQuery(className:"_User")
        do {
            let user = try query.getObjectWithId(userId)
            let first_name = user["firstName"] as! String
            let last_name = user["lastName"] as! String
            name = "\(first_name) \(last_name)"
        }
        catch {
            print("error occured")
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "detailSegue" {
            // need to pass: group name, group owner, users list
            
            let cell = try sender as! UITableViewCell
            let indexpath = GroupTableView.indexPath(for: cell)!
            let title = (groups[indexpath.row]["name"] as! String)
            
            let user = (groups[indexpath.row]["owner"] as! PFUser)
            getUserInfo(userId: user.objectId!)
            
            let detailController = segue.destination as! GroupDetailsViewController
            detailController.group_title = title
            detailController.usersTempArray = (groups[indexpath.row]["users"] as! Array<PFUser>)
           
            detailController.group_owner = name
            detailController.group_ownerId = user.objectId as! String
            
            
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        getGroupsFromPFUser(user: PFUser.current()!)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groups.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("groups: ", groups)
        let group = groups[indexPath.row]
        let user = group["owner"] as! PFUser
        print("userGuy: ", user)
        
        
        // image of group, user may choose group image
        let imageData = (groups[indexPath.row]["groupPicture"] as! PFFileObject) // get image data of group

        let cell = tableView.dequeueReusableCell(withIdentifier: "GroupCell") as! GroupCell
        cell.groupLabel.text = (groups[indexPath.row]["name"] as! String)
        
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

        return cell
    }

    // pull to refresh data function
    @objc func loadGroups() {

        table_data.removeAll()
        
        self.GroupTableView.reloadData()
        myRefreshControl.endRefreshing()
    }
    

}

