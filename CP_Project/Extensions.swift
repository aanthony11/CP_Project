//
//  Extensions.swift
//  CP_Project
//
//  Created by Manish Rajendran on 4/28/20.
//  Copyright © 2020 Manish Rajendran. All rights reserved.
//

import Foundation
import Parse

extension PFUser {
    
    func getGroups(completion: @escaping (([PFObject]?, Error?) -> ())) {
        let query = PFQuery(className:"UserToGroup")
        query.whereKey("user", equalTo: self)
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
    }
}

//// How to use in another class
//        PFUser.current()?.getGroups(completion: { (groups, error) in
//            print(groups)
//        })
