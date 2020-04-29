//
//  AddMembersViewController.swift
//  CP_Project
//
//  Created by Austin Anthony on 4/26/20.
//  Copyright © 2020 Manish Rajendran. All rights reserved.
//

import UIKit
import Parse

class AddMembersViewController: UIViewController, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource {
    
    
    
    
    @IBOutlet weak var memberSearchBar: UISearchBar!
    @IBOutlet weak var membersTableView: UITableView!
    @IBOutlet weak var doneBarButton: UIBarButtonItem!
    @IBOutlet weak var errorLabel: UILabel!
    
    var currentUser = PFUser.current()
    var usersTempArray:[PFUser] = []
    var emailsTempArray:[String] = []
    var group = PFObject(className:"Group")
    
    override func viewDidLoad() {
        super.viewDidLoad()

        memberSearchBar.delegate = self
        membersTableView.delegate = self
        membersTableView.dataSource = self
        memberSearchBar.autocapitalizationType = .none
        self.errorLabel.alpha = CGFloat(0.0)
        
        // Do any additional setup after loading the view.
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        let username = memberSearchBar.text!.lowercased()
        
        let query = PFQuery(className: "_User")
        query.whereKey("username", equalTo: username)
        query.findObjectsInBackground { (objects:[PFObject]?, error: Error?) in
            if objects!.count == 0 || objects?.count == nil {
                self.errorLabel.text = "User not found or could not be added to group."
                
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
                print(error.localizedDescription)
            } else if let objects = objects {
                // find was successful
                
                //print("Successfully retrieved \(objects.count) users")
                // do something with found obojects
                for object in objects {
                    let tempUser = object as! PFUser
                    let tempEmail = tempUser.username!
                    if self.emailsTempArray.contains(tempEmail) {
                        self.errorLabel.text = ("User has already ready to be added")
                        
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
                        self.memberSearchBar.text = ""
                        
                    }
                }
            }
            self.membersTableView.reloadData()
        } // end query
        
    }
    
    @IBAction func onCancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onDone(_ sender: Any) {
        print("emailTempArray: ", emailsTempArray)
        
        for user in usersTempArray {
            ///ERROR
            /// Can't update user information due to authentication problem, still need to fix
            
            //print(user.objectId)
            //let user1 = PFUser.becomein
            let query = PFQuery(className: "_Users")
            
            //print(user["objectId"])
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return emailsTempArray.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "AddMembersCell") as! AddMembersCell
        
        cell.textLabel?.text = emailsTempArray[indexPath.row]
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
