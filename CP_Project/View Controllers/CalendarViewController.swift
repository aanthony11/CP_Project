//
//  CalendarViewController.swift
//  CP_Project
//
//  Created by Austin Anthony on 4/30/20.
//  Copyright © 2020 Manish Rajendran. All rights reserved.
//

import UIKit
import Parse
import FSCalendar

class CalendarViewController: UIViewController,FSCalendarDataSource,FSCalendarDelegate, FSCalendarDelegateAppearance {

    @IBOutlet weak var calendar: FSCalendar!
    
    //let datesWithEvent = ["2020/04/09", "2020/04/19", "2020/04/29"]
    //let datesWithMultipleEvents = ["2020/04/04", "2020/04/16", "2020/04/20"]
    let multipleEvents = ["2020-04-14","2020-04-30"]
    let borderDefaultColors = ["2020/04/21": UIColor.brown]
    let borderSelectionColors = ["2020/04/01": UIColor.red]
    let fillSelectionColors = ["2020/04/11": UIColor.green]
    
    var helper = ParseHelper()
    var currentUser = PFUser.current()
    var UsersTasks:[PFObject] = []
    var TaskDict = [String:[String]]()
    var tasks : Array<PFObject> = []
    var taskIds:[String] = []
    var groups:[String] = []
    var num = 0
    var datesWithEvent:[String] = []
    var datesWithMultipleEvents:[String] = []
    
    
    fileprivate lazy var dateFormatter1: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        

        // Initializing Calendar Settings
        calendar.delegate = self
        
        // Do any additional setup after loading the view.
        calendar.appearance.borderRadius = 0
        calendar.appearance.borderDefaultColor = UIColor.yellow
        
        // change background of view
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.view.bounds
        gradientLayer.colors = [UIColor.orange.cgColor,UIColor.orange.cgColor,UIColor.yellow.cgColor, UIColor.orange.cgColor,UIColor.orange.cgColor,UIColor.orange.cgColor]
        self.view.layer.insertSublayer(gradientLayer, at: 0)
        
        // change colors of calendar settings
        calendar.calendarHeaderView.backgroundColor = UIColor.orange
        calendar.appearance.eventSelectionColor = UIColor.brown
        calendar.appearance.selectionColor = UIColor.brown
        
        //getTasksFromPFUser(user: currentUser!)
        
        // make dictionary  [taskDate] --> Array[tasks]
        
        //var titleArray:[String] = []
        for task in UsersTasks {
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
            } else if val.count > 1 {
                datesWithMultipleEvents.append(key)

            }
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
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        let dateString = self.dateFormatter1.string(from: date)
        //calendar.appearance.backgroundColors = UIColor.init(displayP3Red: 255, green: 140, blue: 105, alpha: 0.8)
        
        print("\(dateString)")
    }
 
    
    func calendar(_ calendar: FSCalendar, willDisplay cell: FSCalendarCell, for date: Date, at monthPosition: FSCalendarMonthPosition) {
        
        let dateFormatter3 = DateFormatter()
        dateFormatter3.dateFormat = "yyyy-MM-dd"
        let dateString = dateFormatter3.string(from: date)
        

        
        //display events as dots
        cell.eventIndicator.isHidden = false
        cell.eventIndicator.color = UIColor.white
        
        // put event on each day that has task due
        if datesWithEvent.contains(dateString){
            // number needs to be amount of tasks due that day
            cell.eventIndicator.numberOfEvents = 1
        }
        if datesWithMultipleEvents.contains(dateString) {
            cell.eventIndicator.numberOfEvents = 3
        }
    }
    
    internal func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, fillDefaultColorFor date: Date) -> UIColor? {
        return nil
    }
    
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        self.calendar.frame.size.height = bounds.height
    }
    
  
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, fillSelectionColorFor date: Date) -> UIColor? {
        let key = self.dateFormatter1.string(from: date)
        if let color = self.fillSelectionColors[key] {
            return color
        }
        return appearance.selectionColor
    }
    
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, borderDefaultColorFor date: Date) -> UIColor? {
        let key = self.dateFormatter1.string(from: date)
        if let color = self.borderDefaultColors[key] {
            return color
        }
        return appearance.borderDefaultColor
    }
    
    
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, borderSelectionColorFor date: Date) -> UIColor? {

        let dateString = self.dateFormatter1.string(from: date)
        
        if let color = self.borderSelectionColors[dateString] {
            return color
        }
        return appearance.borderSelectionColor
    }
    
    
    
    

}
