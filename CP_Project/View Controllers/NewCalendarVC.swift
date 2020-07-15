//
//  NewCalendarVC.swift
//  CP_Project
//
//  Created by Austin Anthony on 6/27/20.
//  Copyright © 2020 Manish Rajendran. All rights reserved.
//

import UIKit
import Parse
import FSCalendar

class NewCalendarVC: UIViewController, FSCalendarDataSource, FSCalendarDelegate, FSCalendarDelegateAppearance, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var calendar: FSCalendar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var exitBarButton: UIBarButtonItem!
    
    let currentUser                           = PFUser.current()
    var tableInfo                             = taskData(profilePictures: [], names: [], dates: [], tasks: [], groupNames: [], dateDict: [String : [PFObject]]())
    //var usersTasks:[PFObject]                 = []
    var name = "" // delete later
    var TaskDict                              = [String:[String]]()
    var groups:[PFObject]                     = []
    var datesWithEvent:[String]               = [] // will not be needed, go through tableinfo to find dates with multiple tasks
    var userImg                               = [String:UIImage]()
    var userDict                              = [String:String]()
    
    fileprivate lazy var dateFormatter1: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    // when cell is tapped, it is not highlighted
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        calendar.delegate = self
        calendar.dataSource = self
        tableView.dataSource = self
        tableView.delegate = self
        
        // Do any additional setup after loading the view.
        //calendar.calendarHeaderView.backgroundColor = UIColor.lightGray
        print("dictonary here: ")
        print(tableInfo.dateDict)
        print("get your dates here: ", tableInfo.dates)
        
       // for task in usersTasks {
       //     if task["dateDue"] == nil {
       //         continue
       //     }
       //     let dateDue = task["dateDue"] as! String
       //     let title = task["title"] as! String
       //     TaskDict[dateDue, default:[String]()].append(title)
       // }
        
        // figure out which days have mutiple events
        for key in tableInfo.dateDict.keys {
            datesWithEvent.append(key)
        }
        print("datesWithEvent: ", datesWithEvent)
        //print("NewVC: ", groups)
        //print("names@: ",tableInfo.namßes)
        //print("list groups: ", tableInfo.groupNames)
        //print("datess ",tableInfo.dates)
        //print("task names: ",tableInfo.tasks)
        //print("sorted Dates: ", tableInfo.dates.sorted())
    }
    
    @IBAction func dismiss(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
       // this function runs when a cell is tapped
        
        let dateString = self.dateFormatter1.string(from: date)
        
        print("\(dateString)")
    }
    
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        let dateString = self.dateFormatter1.string(from: date)
        if self.datesWithEvent.contains(dateString) {
            return 1
        } else {
            return 0
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
                            //self.userImg = UIImage(data: imgData)
                        }
                    })
                    //self.userImg = UIImage(data: imgData as! Data)
                }
            }
        }
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return tableInfo.dates.count
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let date = tableInfo.dates.sorted()[section]
        let fixedDate = "\(date[5..<7])/\(date[8...9])/\(date[2..<4])"
        return fixedDate
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let date = tableInfo.dates.sorted()[section]
        let numTasks = tableInfo.dateDict[date]?.count
        
        return numTasks!
    }
    
    // function below changes color of section header in tableview
    
    //func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    //    let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 30))
    //    headerView.setGradientBackground(colorOne: UIColor.orange, colorTwo: UIColor.white, colorThree: UIColor.red)
    //    return headerView
    //}
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewCalendarTVC") as! NewCalendarTVC
        let date = tableInfo.dates.sorted()[indexPath.section]
        let tasks = tableInfo.dateDict[date]
        let task = tasks![indexPath.row]
        let user = task["creator"] as! PFObject
        let group = task["group"] as! PFObject
        let groupId = group.objectId!

        // set user fields
        cell.taskLabel.text         = task["title"] as! String
        cell.userLabel.text         = userDict[user.objectId!]

        // set image fields
        cell.userImageView.layer.cornerRadius = cell.userImageView.frame.size.width / 2
        cell.userImageView.layer.borderColor = UIColor.black.cgColor
        cell.userImageView.layer.borderWidth = 1.6
        cell.userImageView.clipsToBounds = true
        cell.userImageView.image    = userImg[user.objectId!]
        
        // set group fields
        for group in groups {
            if group.objectId == groupId {
                cell.groupLabel.text = group["name"] as! String
            } else {
                continue
            }
        }
        
        return cell
    }
}

