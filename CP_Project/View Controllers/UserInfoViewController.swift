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
    var imageData:[PFFileObject] = []
    var groupOwnerId = ""

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var removeButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        removeButton.layer.cornerRadius = 15
        

        // Change label to display user's name
        usernameLabel.text = name
        
        // hide remove member button if user isn't group owner
        if groupOwnerId != PFUser.current()?.objectId {
            removeButton.isHidden = true
        }
        
        // display user's profile picture
        let imgData = imageData[0]
        imgData.getDataInBackground { (imgData:Data?, error:Error?) in
            if let error = error {
                print(error.localizedDescription)
            } else if let imgData = imgData {
                let image = UIImage(data: imgData)
                self.imageView.image = image
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
