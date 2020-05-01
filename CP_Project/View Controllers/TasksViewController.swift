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
            
    @IBOutlet weak var tableView: UITableView!

    var helper = ParseHelper()
    var groups : Array<PFObject> = []
    var groupIds : Array<String> = []
    var tasks : Array<PFObject> = []
    var taskIds : Array<String> = []
    var duties : Array<PFUser> = []
    let currentUser = PFUser.current()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        
        helper.getGroupsFromPFUser(user: PFUser.current()!) { (groups, error) in
            self.groups = groups ?? []
        }
        
        helper.getTasksFromPFUser(user: PFUser.current()!) { (tasks, error) in
            self.tasks = tasks ?? []
            self.tableView.reloadData()
                        
//            for task in self.tasks{
//                let duty = task["duty"] as! PFUser
//                duty.fetchInBackground { (user, error) in
//                    self.duties.append(user as! PFUser)
//                    self.tableView.reloadData()
//                    print(self.duties)
//
//                }
//            }
            
            
        }
        
        
        

    }
    
    @IBAction func onRefresh(_ sender: Any) {
        helper.getGroupsFromPFUser(user: PFUser.current()!) { (groups, error) in
            self.groups = groups ?? []
        }
        
        helper.getTasksFromPFUser(user: PFUser.current()!) { (tasks, error) in
            self.tasks = tasks ?? []
            self.tableView.reloadData()
        }
    }
    
    @IBAction func onJoker(_ sender: Any) {
        performSegue(withIdentifier: "calendarSegue", sender: self)
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell") as! TaskCell
        cell.taskLabel.text = (tasks[indexPath.row]["title"] as! String)
        cell.dutyLabel.text = (currentUser!["firstName"] as! String).capitalized
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        print(tasks[indexPath.row])
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
    }
    

}
