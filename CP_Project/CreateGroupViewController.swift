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
        if usersTempArray.count > 1 && groupName.text != "" {
            let group = PFObject(className:"Group")
            group["name"] = groupName.text
            group["users"] = usersTempArray
            group["count"] = usersTempArray.count
            group.saveInBackground { (succeeded, error)  in
                if (succeeded) {
                    self.dismiss(animated: true, completion: nil)
                } else {
                    print(error?.localizedDescription)
                }
            }
        } else {
            print("Need at least one and/or group name")
        }
        


    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print(usersTempArray)
        print(emailsTempArray)
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
                print("Successfully retrieved \(objects.count) users.")
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
