//
//  TaskDetailsViewController.swift
//  CP_Project
//
//  Created by Adam Anderson on 4/21/20.
//  Copyright © 2020 Manish Rajendran. All rights reserved.
//

import UIKit
import Parse

class AddTaskViewController: UITableViewController {
    
    
    @IBOutlet weak var taskTextField: UITextField!
    @IBOutlet weak var groupNameLabel: UILabel!
    
    var currentUser = PFUser.current()
    var groupName = "Team Red"
    
    var delegate: AddTaskProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        taskTextField.becomeFirstResponder()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    @IBAction func didTapCancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func didTapDone(_ sender: Any) {      
        let task = PFObject(className: "Task")
        task["title"] = taskTextField.text
        task["creator"] = PFUser.current()
        
        let taskToUser = PFObject(className: "TaskToUser")
        taskToUser["user"] = PFUser.current()
        taskToUser["task"] = task
        //taskToUser.saveInBackground()
        
        // show a loading animation to the user while it saves...
        
        delegate.didAddTask(task: task, taskToUser: taskToUser);
        self.dismiss(animated: true, completion: nil)
       
        
//        let taskTitle = taskTextField.text
//        var groupId = [String]()
        
        // Get group and save task to group
//        let query = PFQuery(className: "Group")
//        query.whereKey("name", equalTo: groupName)
//        query.findObjectsInBackground { (objects: [AnyObject]!, error: Error?) in
//            if let error = error {
//                print(error.localizedDescription)
//            } else {
//                for object in objects {
//                    groupId.append(object.objectId!)
//                }
//            }
//            let newQuery = PFQuery(className: "Group")
//            newQuery.getObjectInBackground(withId: groupId[0]) { (group: PFObject?, error: Error?) in
//                if let error = error {
//                    print(error.localizedDescription)
//                } else {
//                    group?.add(task, forKey: "tasks")
//                    group?.saveInBackground(block: { (success, error) in
//                        if success {
//                            print("task saved")
//                        } else {
//                            print("error saving task")
//                        }
//                    })
//                }
//            }
//        }
    } //end didTapDone
    

    
    // MARK: - Table view data source
    
//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//
//    }
//
//    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        if indexPath.row == 2 {
//            groupNameLabel.text = groupName
//        }
//    }

    

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
