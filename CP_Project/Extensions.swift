//
//  Extensions.swift
//  CP_Project
//
//  Created by Manish Rajendran on 4/28/20.
//  Copyright © 2020 Manish Rajendran. All rights reserved.
//

import Foundation
import Parse
import UIKit

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

extension UIView {
    
    func setGradientBackground(colorOne: UIColor, colorTwo: UIColor, colorThree: UIColor) {
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = [colorOne.cgColor,colorTwo.cgColor, colorThree.cgColor]
        gradientLayer.locations = [0.0,0.7,1.0]
        gradientLayer.startPoint = CGPoint(x:1.0, y: 1.0)
        gradientLayer.endPoint = CGPoint(x: 0.0, y: 0.0)
        
        layer.insertSublayer(gradientLayer, at: 0)
        
    }
    
}

extension String {
    subscript (bounds: CountableClosedRange<Int>) -> String {
        let start = index(startIndex, offsetBy: bounds.lowerBound)
        let end = index(startIndex, offsetBy: bounds.upperBound)
        return String(self[start...end])
    }

    subscript (bounds: CountableRange<Int>) -> String {
        let start = index(startIndex, offsetBy: bounds.lowerBound)
        let end = index(startIndex, offsetBy: bounds.upperBound)
        return String(self[start..<end])
    }
}


