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

class TasksViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, AddTaskProtocol {
    
    //var pushCount : int = 0
    var helper = ParseHelper()
    var groups : Array<PFObject> = []
    var groupIds : Array<String> = []
    var tasks : Array<PFObject>  = []
    var taskIds : Array<String>  = []
    var name                     = ""
    var userImg: UIImage?

    //var count = 0
    
    @IBOutlet weak var tableView: UITableView!
        
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.dataSource = self
        tableView.delegate = self
                
        
       // helper.getGroupsFromPFUser(user: PFUser.current()!) { (groups, error) in
       //     for group in groups! {
       //         if self.groupIds.contains(group.objectId!) {
       //             print("Group already in array")
       //         } else {
       //             self.groups.append(group)
       //             self.groupIds.append(group.objectId!)
       //         }
       //     }
       // }
        print("XY: ", groups)
        
        
        getTasksFromPFUser(user: PFUser.current()!)
        getGroupsFromPFUser(user: PFUser.current()!)
        
//        #warning("Timer runnning")
//        Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(self.onTimer), userInfo: nil, repeats: true)

    }
    
//        @objc func onTimer() {
//            getTasksFromPFUser(user: PFUser.current()!)
//            #warning("Timer runnning")
//
//        }
    
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
                // The find succeeded.
                
                print("Successfully retrieved \(objects.count) groups.")
                // Do something with the found objects
                for object in objects{
                    let group = object["group"] as! PFObject
                    if self.groupIds.contains(group.objectId!) {
                        print("Group already in array")
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
                    let imageData = object["profilePicture"] as? PFFileObject
                    imageData?.getDataInBackground(block: { (imgData:Data?, error:Error?) in
                        if let error = error {
                            print(error.localizedDescription)
                        } else if let imgData = imgData {
                            self.userImg = UIImage(data: imgData)
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
                    print("Task already in array")
                } else {
                    self.tasks.append(task)
                    self.taskIds.append(task.objectId!)
                }
            }
            self.tableView.reloadData()
        }
        performSegue(withIdentifier: "calendarSegue", sender: self)
    }
    
    @IBAction func newCalendar(_ sender: Any) {
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
    
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//
//        performSegue(withIdentifier: "plusSegue", sender: nil)
//    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell") as! TaskCell
        
        let groupFind = tasks[indexPath.row]["group"] as! PFObject
        let groupId = groupFind.objectId!
        
        let userOwner = tasks[indexPath.row]["creator"] as! PFObject
        let userID = userOwner.objectId!
        getUserInfo(userId: userID)
        
        cell.taskLabel.text = (tasks[indexPath.row]["title"] as! String)
        
        // change image to circle
        cell.userImageView.layer.cornerRadius = cell.userImageView.frame.size.width / 2
        cell.userImageView.layer.borderColor = UIColor.black.cgColor
        cell.userImageView.layer.borderWidth = 1.6
        cell.userImageView.clipsToBounds = true
        cell.userImageView.image = userImg
        
        
        for group in groups {
            if group.objectId == groupId {
                cell.groupLabel.text = group["name"] as! String
            } else {
                continue
            }
        }
        
        cell.userLabel.text = name
        
        //count += 1
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
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
            var cani:[PFObject] = []
            for task in tasks {
                cani.append(task)
            }
            let destination = segue.destination as! NewCalendarVC
            destination.usersTasks = cani
            destination.groups = self.groups
        }
    }
    

}
