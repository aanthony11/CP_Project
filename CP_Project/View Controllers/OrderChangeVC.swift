//
//  OrderChangeVC.swift
//  CP_Project
//
//  Created by Austin Anthony on 7/12/20.
//  Copyright © 2020 Manish Rajendran. All rights reserved.
//

import UIKit
import Parse

class OrderChangeVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var createButton: UIButton!
    var task =  PFObject(className: "Task")
    var delegate: AddTaskProtocol!
    var groups = [PFObject]()
    var groupC: PFObject?
    var userData = [String:String]()
    var groupId = ""
    var names: Array<String> = []
    var name = ""
    var tempId = ""
    var users : Array<PFUser> = []

    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        // Do any additional setup after loading the view.
        print("task: ", task)
        
        createButton.layer.cornerRadius = 20
        
        for group in groups {
            if group.objectId! == groupId {
                groupC = group
                users = groupC!["users"] as! [PFUser]
                break
            }
        }
        
        for user in users {
            let id = user.objectId!
            if userData.keys.contains(id) {
                names.append(userData[id]!)
            } else {
                getUserInfo(userId: id)
            }
        }
        tableView.isEditing = true
        
    }
    
    func getUserInfo(userId: String) -> Void {
        let query = PFQuery(className:"_User")
        query.whereKey("objectId", equalTo: userId)
        query.selectKeys(["lastName","firstName"])
        do {
            let user = try query.getObjectWithId(userId)
            let tempName = "\((user["firstName"]! as! String).capitalized) \((user["lastName"]! as! String).capitalized)"
            let index = names.firstIndex(of: tempName)
            if index == nil {
                names.append(tempName)
            }
        }
        catch {
            print("error occured")
        }
        
    }
    
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrderTVC") as! OrderTVC
        
//        for user in users {
//            let id = user.objectId!
//            if userData.keys.contains(id) {
//                names.append(userData[id]!)
//            } else {
//                getUserInfo(userId: id)
//            }
//        }
        let user = users[indexPath.row]
        let id = user.objectId!
        if userData.keys.contains(id) == false{
            getUserInfo(userId: id)
        }
        cell.nameLabel.text = names[indexPath.row]
        
        return cell
    }
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return UITableViewCell.EditingStyle.none
    }
    
    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
        // get current cell
        let item = names[sourceIndexPath.row]
        names.remove(at: sourceIndexPath.row)
        names.insert(item, at: destinationIndexPath.row)
        // update users array
        let itemU = users[sourceIndexPath.row]
        users.remove(at: sourceIndexPath.row)
        users.insert(itemU, at: destinationIndexPath.row)
   
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        let destVC = segue.destination as! TasksViewController
        destVC.userData = userData
        task["order"]  = users
        task["duty"] = users[0]
        delegate.didAddTask(task: task);
    }
    

}
