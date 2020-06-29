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
    
    let currentUser                           = PFUser.current()
    var usersTasks:[PFObject]                 = []
    var TaskDict = [String:[String]]()
    var tasks: Array<PFObject>                = []
    var groups:[PFObject]                       = []
    var datesWithEvent:[String]               = [] // will not be needed in future
    
    
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
        tableView.dataSource = self
        tableView.delegate = self
        
        // Do any additional setup after loading the view.
        //calendar.calendarHeaderView.backgroundColor = UIColor.lightGray
        
        
        for task in usersTasks {
            if task["dateDue"] == nil {
                continue
            }
            let dateDue = task["dateDue"] as! String
            let title = task["title"] as! String
            TaskDict[dateDue, default:[String]()].append(title)
        }
        
        // figure out which days have mutiple events
        for (key,val) in TaskDict {
            if val.count == 1 {
                datesWithEvent.append(key)
            }
        }
        print("NewVC: ", groups)
        
    }
    
    
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        print("hello world!")
        let dateString = self.dateFormatter1.string(from: date)
        print("dateString: ",dateString)
        if self.datesWithEvent.contains(dateString) {
            return 1
        } else {
            return 0
        }
    }
    
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
       // this function runs when a cell is tapped
        
        let dateString = self.dateFormatter1.string(from: date)
        
        print("\(dateString)")
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
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewCalendarTVC") as! NewCalendarTVC
        
        
        
        return cell
    }
}
