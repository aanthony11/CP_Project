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
    
    var usersTempArray:[PFUser] = []
    var userIds:[String] = []
    var user_names:[String] = []
    var arr:[String] = []
    var group_title = ""
    var group_id = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        groupDetailTableView.delegate = self
        groupDetailTableView.dataSource = self
        
        self.groupDetailTableView.reloadData()
        
        changeImageButton.layer.cornerRadius = 10
        addmembersButton.layer.cornerRadius = 10
        
        // create variable for current user
        let user_current = PFUser.current()
        groupnameLabel.text? = group_title
        
        do {
            
            let query = PFQuery(className: "Group") // query for group class

            query.whereKey("objectId", equalTo: group_id) // search by group id
            query.includeKey("users")
            
            // make array of user Id's
            
            let lst = try query.getFirstObject()
            let arr = lst.object(forKey: "users")
            let arr_data:NSArray = (arr as? NSArray)!
            
            for i in 0...(arr_data.count-1) {
                let user = arr_data[i] as! PFUser
                userIds.append(user.objectId!)
            }
            
            
        }
        catch {
            // if list cant be found
            print("error occured")
        }

        print(userIds)

        for id in userIds {
            do {
                // query for user
                let query2 = PFQuery(className: "_User")
                let user = try query2.getObjectWithId(id)
                
                // get first and last name, and add to user_names array
                let name = "\(user["firstName"] as! String) \(user["lastName"] as! String)"
                user_names.append(name)
                
            }
            catch {
                // couldn't find user
            }
        }
    }
    
    @IBAction func onPressed(_ sender: Any) {
        
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
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let image = info[.editedImage] as! UIImage
        let size = CGSize(width: 300, height: 300)
        let scaled = image.af_imageScaled(to: size)
        
        dismiss(animated: true, completion: nil)
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return user_names.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       // let names = ["John Doe", "Jane Doe", "Timmy Turner", "Spongebob", "Jason Bourne"]
       // let random_num = Int.random(in: 0...4)
        
        let cell = groupDetailTableView.dequeueReusableCell(withIdentifier: "GroupDetailViewCell") as! GroupDetailViewCell
        cell.usernameLabel.text = user_names[indexPath.row]
        
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
