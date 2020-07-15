//
//  ParseHelper.swift
//  CP_Project
//
//  Created by Manish Rajendran on 4/24/20.
//  Copyright © 2020 Manish Rajendran. All rights reserved.
//

import Foundation
import Parse


class ParseHelper {
    
    func getGroupsFromPFUser(user: PFUser,  completion: @escaping (([PFObject]?, Error?) -> ())) -> Void {
        let query = PFQuery(className:"UserToGroup")
        query.whereKey("user", equalTo:user)
        query.includeKey("group")
        
        query.findObjectsInBackground { (objects: [PFObject]?, error: Error?) in
            if let error = error {
                // Log details of the failure
                completion(nil, error)
            } else if let objects = objects {
                // The find succeeded.
                print("Successfully retrieved \(objects.count) objects.")
                // Do something with the found objects
                var groups = [PFObject]()
                for object in objects{
                    let group = object["group"] as! PFObject
                    groups.append(group)
                }
                completion(groups, nil)
            }
        }
    } // end function
    
    
    
    func getTasksFromPFUser(user: PFUser,  completion: @escaping (([PFObject]?, Error?) -> ())) -> Void {
        let query = PFQuery(className:"TaskToUser")
        query.whereKey("user", equalTo:user)
        query.includeKey("task")
        query.findObjectsInBackground { (objects: [PFObject]?, error: Error?) in
            if let error = error {
                // Log details of the failure
                completion(nil, error)
            } else if let objects = objects {
                // The find succeeded.
                print("Successfully retrieved \(objects.count) objects.")
                // Do something with the found objects
                var tasks = [PFObject]()
                for object in objects{
                    let task = object["task"] as! PFObject
                    tasks.append(task)
                }
                completion(tasks, nil)
            }
        }
    } // end function
//    func getName(userId: String) -> String {
//        let user = PFUser.fe
//        let query = PFQuery(className: "_User")
//        query.fetc
//
//
//    }
    
    
} // end Class

class taskData {
    var profilePictures: [UIImage?]
    var names: Set<String>          = []
    var dates: Set<String>          = []
    var tasks: Array<String>        = []
    var groupNames: [String]        = []
    var dateDict                    = [String:[PFObject]]()
 
    init(profilePictures: [UIImage], names: Set<String>, dates: Set<String>, tasks: [String], groupNames: [String], dateDict: [String:[PFObject]]) {
        self.profilePictures = profilePictures
        self.names = names
        self.dates = dates
        self.groupNames = groupNames
        self.tasks = tasks
        self.dateDict = dateDict
        
    }
}

class CustomUser {
    var name        = ""
    var profileImage:UIImage
    
    init(name: String, profileImage: UIImage) {
        self.name = name
        self.profileImage = profileImage
    }
}
