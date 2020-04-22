//
//  CreateGroupViewController.swift
//  CP_Project
//
//  Created by Manish Rajendran on 4/22/20.
//  Copyright © 2020 Manish Rajendran. All rights reserved.
//

import UIKit
import Parse

class CreateGroupViewController: UIViewController, UISearchBarDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        // Do any additional setup after loading the view.
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let username = searchBar.text!.lowercased()
        print(username)
        
//        var currentUser = PFUser.current()
//        print(currentUser?.username)
        
        let query = PFQuery(className:"User")
        query.whereKey("username", equalTo:username)
        query.findObjectsInBackground { (objects: [PFObject]?, error: Error?) in
            if let error = error {
                // Log details of the failure
                print(error.localizedDescription)
            } else if let objects = objects {
                print(objects)
                // The find succeeded.
                print("Successfully retrieved \(objects.count) users.")
                // Do something with the found objects
                for object in objects {
                    print(object.objectId as Any)
                }
            }
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

}
