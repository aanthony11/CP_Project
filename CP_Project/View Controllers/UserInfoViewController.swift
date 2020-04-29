//
//  UserInfoViewController.swift
//  CP_Project
//
//  Created by Austin Anthony on 4/25/20.
//  Copyright © 2020 Manish Rajendran. All rights reserved.
//

import UIKit
import Parse
import AlamofireImage

class UserInfoViewController: UIViewController {
    
    // data is passed from previous view controller
    var name = ""
    var userId = ""

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Change label to display user's name
        usernameLabel.text = name
        
        // display user's profile picture
        do {
            
            let userQuery = PFQuery(className: "_User")
            let user = try userQuery.getObjectWithId(userId)
            let profileImageData = user["profilePicture"] as! PFFileObject
            profileImageData.getDataInBackground { (imageData:Data?, error:Error?) in
                if let error = error {
                    print(error.localizedDescription)
                } else if let imageData = imageData {
                    print("succesfully got image data :)")
                    let image = UIImage(data: imageData)
                    self.imageView.image = image
                }
            }
            
            
        }
        catch {
            // if error occured
            print("error occured retrieving user data")
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
