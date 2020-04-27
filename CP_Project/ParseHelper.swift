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
    
    func getGroupsFromPFUser(user: PFUser) -> Void {
        let query = PFQuery(className:"UserToGroup")
        query.whereKey("user", equalTo:user)
        query.includeKey("group")
        query.findObjectsInBackground { (objects: [PFObject]?, error: Error?) in
            if let error = error {
                // Log details of the failure
                print(error.localizedDescription)
            } else if let objects = objects {
                // The find succeeded.
                print("Successfully retrieved \(objects.count) objects.")
                // Do something with the found objects
                for object in objects{
                    let group = object["group"] as! PFObject
                }
            }
        }
    } // end function
    
        
    
    
    
    
    
    
    
    
    
    
} // end Class
