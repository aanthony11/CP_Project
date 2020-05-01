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
        query.includeKeys(["group", "users"])
//        query.selectKeys(["group"])
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
        query.includeKeys(["task", "user", "group"])
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
    
 
    func getDutyForTask(task: PFObject,  completion: @escaping (([PFObject]?, Error?) -> ())) -> Void {
     
        
        
        
    }
    
    
    
    
    
    
    
    
    
} // end Class
