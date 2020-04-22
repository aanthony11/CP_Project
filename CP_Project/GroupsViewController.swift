//
//  GroupsViewController.swift
//  CP_Project
//
//  Created by Austin Anthony on 4/15/20.
//  Copyright © 2020 Manish Rajendran. All rights reserved.
//

import UIKit
import Parse

class GroupsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    @IBOutlet weak var logoutButton: UIBarButtonItem!
    @IBOutlet weak var GroupTableView: UITableView!
    
    var groups = [[group].self]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        GroupTableView.dataSource = self
        GroupTableView.delegate = self
        
        //create a new button
        //let button = UIButton(type: .custom)
        //set image for button
        //button.setImage(UIImage(named: "crown.png"), for: .normal)
        //add function for button
        //button.addTarget(self, action: #selector(fbButtonPressed), for: .touchUpInside)
        //set frame
        //button.frame = CGRect(x: 0, y: 0, width: 53, height: 51)

        //let barButton = UIBarButtonItem(customView: button)
        //assign button to navigationbar
        //self.navigationItem.rightBarButtonItem = barButton
        
        // create new object
        let group = PFObject(className: "Group")
        
        
        // initialize group
        var init_group: [String] = ["n6wB4V1ojB"] // add user to list
        init_group.append("BETn0mfdWB")
        
        // set properties
        group["name"] = "Group 1"
        group["users"] = init_group
        group["users count"] = init_group.count
        
        let query = PFQuery(className:"Group")
        query.getObjectInBackground(withId: "RAn718yP3z") { (group, error) in
            if error == nil {
                // Success!
                print("group retrival was sucessful")
            } else {
                // Fail!
                print("error occured: \(error?.localizedDescription)")
            }
        }
        
        
    }
    
    
    @IBAction func onLogout(_ sender: Any) {
            
        PFUser.logOut()
        UserDefaults.standard.set(false, forKey: "UserLoggedIn")
                   
        let main = UIStoryboard(name: "Main", bundle: nil)
        let viewController = main.instantiateViewController(withIdentifier: "ViewController")
        let sceneDelegate = self.view.window?.windowScene?.delegate as! SceneDelegate

        sceneDelegate.window?.rootViewController = viewController
        
    }
    
    

//This method will call when you press button.
    @objc func fbButtonPressed() {

        print("Share to fb")
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // image of group, user may choose group image
        let photos = ["crown.png","fish.png","smiley.png","hat.png","shinin.png","rocket.png"]
        let random_num = Int.random(in: 0...5)
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "GroupCell") as! GroupCell
        cell.groupImageView.image = UIImage(named: photos[random_num])
        
        cell.textLabel?.text = "Group"
        //let findGroup = groups[indexPath.row]
                
        
        return cell
    }

    

}

