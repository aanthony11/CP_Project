//
//  TaskDetailsViewController.swift
//  CP_Project
//
//  Created by Adam Anderson on 4/21/20.
//  Copyright © 2020 Manish Rajendran. All rights reserved.
//

import UIKit
import Parse

class AddTaskViewController: UITableViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var taskTextField: UITextField!
    @IBOutlet weak var groupNameLabel: UILabel!
    @IBOutlet weak var groupPicker: UIPickerView!
    @IBOutlet weak var dateField: UITextField!
    
    private var datePicker: UIDatePicker?
    
    var groupsFromTaskVC = [PFObject]()
    var group = PFObject(className: "Group")
    var groupId = ""
    var userData = [String:String]()
    var selectedGroupIndex : Int = 0
    var currentUser = PFUser.current()
    var delegate: AddTaskProtocol!
    var newTask = PFObject(className: "Task")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("dicitonary: ", userData)
        taskTextField.becomeFirstResponder()
        
        groupPicker.delegate = self
        groupPicker.dataSource = self
        
        self.groupPicker.reloadAllComponents()

        // Setting up date picker
        datePicker = UIDatePicker()
        datePicker?.datePickerMode = .date
        dateField.inputView = datePicker
        datePicker?.addTarget(self, action: #selector(AddTaskViewController.dateChanged(datePicker:)), for: .valueChanged)
        
        // dismiss datepicker when user taps off of it
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(AddTaskViewController.viewTapped(gestureRecognizer:)))
        view.addGestureRecognizer(tapGesture)
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        print(self.groupsFromTaskVC)
        
    }
    
    @objc func dateChanged(datePicker: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateField.text = dateFormatter.string(from: datePicker.date)
    }
    
    @objc func viewTapped(gestureRecognizer: UITapGestureRecognizer) {
        view.endEditing(true)
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
        task["group"] = groupsFromTaskVC[self.selectedGroupIndex]
        task["dutyIndex"] = 0
        task["dateDue"] = dateField.text
        
        self.newTask = task
        self.groupId = groupsFromTaskVC[self.selectedGroupIndex].objectId!

        //taskToUser.saveInBackground()
        // and show a loading animation to the user while it saves or use delegate...
                
        //delegate.didAddTask(task: task);
        //self.dismiss(animated: true, completion: nil)
        
       
        
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
    
    
    // MARK: - Picker view data source
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let group = self.groupsFromTaskVC[row]
        let title = group["name"]
        return (title as! String)
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return groupsFromTaskVC.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.selectedGroupIndex = row
                
//        let vc = storyboard?.instantiateViewController(withIdentifier: "TaskDetailsVC") as? AddTaskViewController
//        vc?.tableView.reloadData()
    }
    

    
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

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "OrderSegue" {
            let task = PFObject(className: "Task")
            task["title"] = taskTextField.text
            task["creator"] = PFUser.current()
            task["group"] = groupsFromTaskVC[self.selectedGroupIndex]
            task["dutyIndex"] = 0
            task["dateDue"] = dateField.text
            self.newTask = task
            self.groupId = groupsFromTaskVC[self.selectedGroupIndex].objectId!
            
            let destination = segue.destination as! OrderChangeVC
            destination.task = self.newTask
            let newUsers = self.userData
            print("groupId", groupId)
            destination.userData = self.userData
            destination.groups = self.groupsFromTaskVC
            destination.groupId = groupId
            destination.delegate = delegate
        }
    }
    
    

}
