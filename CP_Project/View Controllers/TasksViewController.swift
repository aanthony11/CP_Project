//
//  TasksViewController.swift
//  CP_Project
//
//  Created by Adam Anderson on 4/15/20.
//  Copyright © 2020 Manish Rajendran. All rights reserved.
//

import UIKit
import Parse

protocol AddTaskProtocol {
    func didAddTask(task: PFObject)
}



class TasksViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, AddTaskProtocol, TaskCellDelegate {
    //var pushCount : int = 0
    var helper = ParseHelper()
    var tableInfo                = taskData(profilePictures: [], names: [], dates: [], tasks: [], groupNames: [], dateDict: [String:[PFObject]]())
    var groups : Array<PFObject> = []
    var groupIds : Array<String> = []
    var tasks : Array<PFObject>  = []
    var taskIds : Array<String>  = []
    var name                     = ""
    var userImg                  = [String:UIImage]()
    var tempDict                 = [String:[PFObject]]()
    var userData                 = [String:String]() // userID -> user name
    var tempId                   = ""

    //var count = 0
    
    @IBOutlet weak var tableView: UITableView!
        
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.dataSource = self
        tableView.delegate = self
        
                
        print("XY: ", groups)
        
        getTasksFromPFUser(user: PFUser.current()!)
        getGroupsFromPFUser(user: PFUser.current()!)

    }
    
    func getGroupsFromPFUser(user: PFUser) -> Void {
        let query = PFQuery(className:"UserToGroup")
        query.whereKey("user", equalTo:user)
        query.includeKeys(["group"])
        query.selectKeys(["group"])
        query.findObjectsInBackground { (objects: [PFObject]?, error: Error?) in
            if let error = error {
                // Log details of the failure
                print(error.localizedDescription)
            } else if let objects = objects {
                // Do something with the found objects
                for object in objects{
                    let group = object["group"] as! PFObject
                    if self.groupIds.contains(group.objectId!) {
                    } else {
                        self.groups.append(group)
                        self.groupIds.append(group.objectId!)
                    }
                }
            }
        }
    }
    
    func getUserInfo(userId: String) -> Void {
        let query = PFQuery(className:"_User")
        query.whereKey("objectId", equalTo: userId)
        query.selectKeys(["lastName","firstName","profilePicture"])
        query.findObjectsInBackground { (objects:[PFObject]?, error: Error?) in
            if let error = error {
                print(error.localizedDescription)
            } else if let objects = objects {
                for object in objects {
                    self.name = "\((object["firstName"]! as! String).capitalized) \((object["lastName"]! as! String).capitalized)"
                    self.tableInfo.names.insert("\((object["firstName"]! as! String).capitalized) \((object["lastName"]! as! String).capitalized)")
                    self.userData[userId] = "\((object["firstName"]! as! String).capitalized) \((object["lastName"]! as! String).capitalized)"
                    self.tempId = userId
                    let imageData = object["profilePicture"] as? PFFileObject
                    imageData?.getDataInBackground(block: { (imgData:Data?, error:Error?) in
                        if let error = error {
                            print(error.localizedDescription)
                        } else if let imgData = imgData {
                            self.userImg[userId] = UIImage(data: imgData)
                        }
                    })
                    //self.userImg = UIImage(data: imgData as! Data)
                }
            }
        }
        
    }
    
    
    func getTasksFromPFUser(user: PFUser) -> Void {
        let query = PFQuery(className:"TaskToUser")
        query.whereKey("user", equalTo:user)
        query.includeKeys(["task"])
//        query.selectKeys(["group"])
        query.findObjectsInBackground { (objects: [PFObject]?, error: Error?) in
            if let error = error {
                // Log details of the failure
                print(error.localizedDescription)
            } else if let objects = objects {
                // The find succeeded.
                print("Successfully retrieved \(objects.count) tasks.")
                // Do something with the found objects
                for object in objects{
                    let task = object["task"] as! PFObject
                    if self.taskIds.contains(task.objectId!) {
                        print("Task already in array")
                    } else {
                        self.tasks.append(task)
                        self.taskIds.append(task.objectId!)
                    }
                }
            }
            self.tableView.reloadData()
        }
    }
    
    @IBAction func onRefresh(_ sender: Any) {
        helper.getTasksFromPFUser(user: PFUser.current()!) { (tasks, error) in
            for task in tasks! {
                if self.taskIds.contains(task.objectId!) {
                    print("Task already in array")
                } else {
                    self.tasks.append(task)
                    self.taskIds.append(task.objectId!)
                }
            }
            self.tableView.reloadData()
        }
        
        helper.getGroupsFromPFUser(user: PFUser.current()!) { (groups, error) in
            for group in groups! {
                if self.groupIds.contains(group.objectId!) {
                    print("Group already in array")
                } else {
                    self.groups.append(group)
                    self.groupIds.append(group.objectId!)
                }
            }
        }
    }
    
    @IBAction func onJoker(_ sender: Any) {
        
        helper.getTasksFromPFUser(user: PFUser.current()!) { (tasks, error) in
            for task in tasks! {
                if self.taskIds.contains(task.objectId!) {
                } else {
                    self.tasks.append(task)
                    self.taskIds.append(task.objectId!)
                }
            }
            self.tableView.reloadData()
        }
        performSegue(withIdentifier: "calendarSegue", sender: self)
    }
    
    @IBAction func unwindToHome (_ sender: UIStoryboardSegue) {}
    
    @IBAction func newCalendar(_ sender: Any) {
        helper.getTasksFromPFUser(user: PFUser.current()!) { (tasks, error) in
            for task in tasks! {
                if self.taskIds.contains(task.objectId!) {
                } else {
                    self.tasks.append(task)
                    self.taskIds.append(task.objectId!)
                }
            }
            self.tableView.reloadData()
        }
        performSegue(withIdentifier: "NewCalendarSegue", sender: self)
    }
    
    func didAddTask(task: PFObject) {
        task.saveInBackground { (x, y) in
            self.taskIds.append(task.objectId!)
        }
        
        let group = task["group"] as! PFObject
        let users = group["users"] as! Array<PFObject>
        for user in users{
            let taskToUser = PFObject(className: "TaskToUser")
            taskToUser["user"] = user
            taskToUser["task"] = task
            taskToUser.saveInBackground()
        }
        
        self.tasks.append(task)
        
        tableView.reloadData()
    }
    
    @IBAction func onLogout(_ sender: Any) {
        PFUser.logOut()
        UserDefaults.standard.set(false, forKey: "UserLoggedIn")

        let main = UIStoryboard(name: "Main", bundle: nil)
        let viewController = main.instantiateViewController(withIdentifier: "ViewController")
        let sceneDelegate = self.view.window?.windowScene?.delegate as! SceneDelegate

        sceneDelegate.window?.rootViewController = viewController
        
    }
    
     override func viewWillAppear(_ animated: Bool) {
        getTasksFromPFUser(user: PFUser.current()!)
        getGroupsFromPFUser(user: PFUser.current()!)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell") as! TaskCell
        cell.delegate = self
        let groupFind = tasks[indexPath.row]["group"] as! PFObject
        let groupId = groupFind.objectId!
        
        let userOwner = tasks[indexPath.row]["duty"] as! PFObject
        let userID = userOwner.objectId!
        if (userData.keys.contains(userID) == false) {
            getUserInfo(userId: userID)
            cell.userLabel.text = userData[userID]
        } else {
            cell.userLabel.text = userData[userID]
            
        }
        // set task label
        cell.taskLabel.text = (tasks[indexPath.row]["title"] as! String)
        if self.tableInfo.tasks.contains((tasks[indexPath.row]["title"] as! String)) {
        } else {
            self.tableInfo.tasks.append((tasks[indexPath.row]["title"] as! String))
        }

        // change image to circle
        cell.userImageView.layer.cornerRadius = cell.userImageView.frame.size.width / 2
        cell.userImageView.layer.borderColor = UIColor.black.cgColor
        cell.userImageView.layer.borderWidth = 1.6
        cell.userImageView.clipsToBounds = true
        cell.userImageView.image = userImg[userID]

        // update date labels
        let dateDue = tasks[indexPath.row]["dateDue"] as! String // in yyyy-MM-dd format
        if tempDict.keys.contains(dateDue) && tempDict[dateDue]!.contains(tasks[indexPath.row]) {
            //print(tasks[indexPath.row]["title"])
        } else if (tempDict.keys.contains(dateDue) == false) {
            tempDict[dateDue] = [tasks[indexPath.row]]
        } else if (tempDict.keys.contains(dateDue)) && (tempDict[dateDue]?.contains(tasks[indexPath.row]) == false) {
            tempDict[dateDue]?.append(tasks[indexPath.row])
        }
        
        if dateDue != "" {
            cell.dateLabel.text = "Due \(dateDue[5..<7])/\(dateDue[8...9])/\(dateDue[2..<4])"
            self.tableInfo.dates.insert(dateDue)
            
        }
        
        // update group name labels
        for group in groups {
            if group.objectId == groupId {
                cell.groupLabel.text = (group["name"] as! String)
                cell.groupId = group.objectId!
                if self.tableInfo.groupNames.contains((group["name"] as! String)) {
                } else {
                    self.tableInfo.groupNames.append((group["name"] as! String))
                }
            } else {
                continue
            }
        }
        
        // set up button
        cell.tag = indexPath.row

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .destructive, title: "Delete") { (action, view, nil) in
            print("delete")
        }
        
        let config = UISwipeActionsConfiguration(actions: [delete])
        config.performsFirstActionWithFullSwipe = false
        
        return config
    }
    
    func updateDuty(_ index: Int, count: Int) -> Int{
        var index = index
        index += 1 // for ints starting at 0
        if index < count {
            return index
        } else {
            index = 0
            return index
        }
    }
    
    func didTapCompleteTask(tag: Int, groupId: String) {
        /// updating task object: need to switch "duty"  data, , update "duty" index,
        var group: PFObject?
        
        for i in groups {
            if i.objectId! == groupId {
                group = i
                break
            }
        }
        
        let groupCount = group!["count"] as! Int
        let task = (tasks[tag] as! PFObject)
        let users = task["order"] as! [PFUser]
        print("users: ", users)
        // get new duty index
        let dutyIndex = task["dutyIndex"] as! Int
        let newDutyIndex = updateDuty(dutyIndex, count: groupCount)
        let newDuty = users[newDutyIndex]
        print(newDuty)
        
        // get next user and switch "creator" data
    }
    
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "plusSegue" {
            let newNvc = segue.destination as! UINavigationController
            let newVc = newNvc.children.first as! AddTaskViewController
            newVc.delegate = self
            newVc.groupsFromTaskVC = self.groups
            newVc.userData = self.userData
        }
        if segue.identifier == "calendarSegue" {
            var cani:[PFObject] = []
            for task in tasks {
                cani.append(task)
            }
            let destination = segue.destination as! CalendarViewController
            destination.UsersTasks = cani
        }
        if segue.identifier == "NewCalendarSegue" {
            //var cani:[PFObject] = []
            //for task in tasks {
            //    cani.append(task)
            //}
            tableInfo.dateDict = tempDict
            
            let destination = segue.destination as! NewCalendarVC
            destination.groups = self.groups
            destination.tableInfo = tableInfo
            destination.userDict = userData
            destination.userImg = userImg
        }
    }
}


