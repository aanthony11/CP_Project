//
//  GroupDetailsViewController.swift
//  CP_Project
//
//  Created by Austin Anthony on 4/15/20.
//  Copyright © 2020 Manish Rajendran. All rights reserved.
//

import UIKit
import Parse
import AlamofireImage




class GroupDetailsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    
    @IBOutlet weak var changeImageButton: UIButton!
    @IBOutlet weak var addmembersButton: UIButton!
    @IBOutlet weak var ownerLabel: UILabel!
    @IBOutlet weak var groupnameLabel: UILabel!
    @IBOutlet weak var groupDetailTableView: UITableView!
    
    var helper = ParseHelper()
    var usersTempArray:[PFUser] = []
    var userIds:[String] = []
    var userPics:[PFFileObject] = []
    var user_info:[PFObject] = []
    var user_names : Array<String> = []
    var arr:[String] = []
    var group_title = ""
    var group_owner = ""
    var group_ownerId = ""
    var count = 0
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        groupDetailTableView.delegate = self
        groupDetailTableView.dataSource = self
                
        changeImageButton.layer.cornerRadius = 10
        addmembersButton.layer.cornerRadius = 10
        
        // create variable for current user
        let user_current = PFUser.current()
        
        // hide Group Picture and Add Members button if user isn't group owner
        if user_current?.objectId != group_ownerId {
            changeImageButton.isHidden = true
            addmembersButton.isHidden = true
        }
        
        groupnameLabel.text? = group_title
        ownerLabel.text = group_owner.capitalized
        
        print("usersTempArray: ", usersTempArray)
        for user in usersTempArray {
            getPFUserInfo(user: user)
        }
       
    }
    
    @IBAction func onPressed(_ sender: Any) {
        
        // open users camera or photo library
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            print("Camera is available 📸")
            picker.sourceType = .camera
        } else {
            
            picker.sourceType = .photoLibrary
        }
        
        present(picker, animated: true, completion: nil)
        
    }
    
    func getPFUserInfo(user: PFUser) -> Void {
        // need users name and profile image data
        let query = PFQuery(className:"_User")
        query.whereKey("objectId", equalTo:user.objectId!)
        query.includeKeys(["firstName"])
        query.findObjectsInBackground { (objects: [PFObject]?, error: Error?) in
            if let error = error {
                // Log details of the failure
                print(error.localizedDescription)
            } else if let objects = objects {
                // The find succeeded.
                print("Successfully retrieved \(objects.count) objects.")
                // Do something with the found objects
                for object in objects{
                    if self.userIds.contains(object.objectId!) {
                        print("object already in list")
                    } else {
                        let last_name = object["lastName"] as! String
                        let first_name = object["firstName"] as! String
                        let name = "\(first_name) \(last_name)"
                        self.userPics.append(object["profilePicture"] as! PFFileObject)
                        self.user_names.append(name.capitalized)
                        self.userIds.append(object.objectId!)
                    }
                }
            }
        }
        self.groupDetailTableView.reloadData()
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let image = info[.editedImage] as! UIImage
        let size = CGSize(width: 300, height: 300)
        let scaled = image.af_imageScaled(to: size)
        let imageData = scaled.pngData()
        let file = PFFileObject(data: imageData!)
        
        // update groups["groupPicture"] data
        let groupQuery = PFQuery(className: "Group") // query for group datr
       // groupQuery.getObjectInBackground(withId: group_id) { (object:PFObject?, error:Error?) in
       //     if object != nil {
       //         print("success from imagePicker!")
       //         object!["groupPicture"] = file
       //         object!.saveInBackground()
       //
       //     } else {
       //         // some error occured
       //     }
       //
       // }
        
        dismiss(animated: true, completion: nil)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        for user in usersTempArray {
            let query = PFQuery(className: "_User")
            query.getObjectInBackground(withId: user.objectId!) { (objects:PFObject?, error:Error?) in
                if let error = error {
                    print(error.localizedDescription)
                } else if let objects = objects {
                    self.getPFUserInfo(user: objects as! PFUser)
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return user_names.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       // let names = ["John Doe", "Jane Doe", "Timmy Turner", "Spongebob", "Jason Bourne"]
       // let random_num = Int.random(in: 0...4)
        let cell = groupDetailTableView.dequeueReusableCell(withIdentifier: "GroupDetailViewCell") as! GroupDetailViewCell
        cell.usernameLabel.text = user_names[indexPath.row]
        
        // get and set profile picture
        let imgData = userPics[indexPath.row] 
        imgData.getDataInBackground { (imgData:Data?, error:Error?) in
            if let error = error {
                print(error.localizedDescription)
            } else if let imgData = imgData {
                let image = UIImage(data: imgData)
                cell.profilePicture.image = image
            }
        }
        
        return cell
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "userInfoSegue" {
            
            let cell = try sender as! UITableViewCell
            let indexpath = groupDetailTableView.indexPath(for: cell)!
            //let name = user_names[indexpath.row]
            
            let destination = segue.destination as! UserInfoViewController
            destination.name = user_names[indexpath.row]
            destination.imageData = [userPics[indexpath.row]]
            destination.groupOwnerId = group_ownerId
            //destination.name = name
            //destination.userId = userIds[indexpath.row]
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
