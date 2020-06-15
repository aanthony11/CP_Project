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

class CalendarViewController: UIViewController,FSCalendarDataSource,FSCalendarDelegate, FSCalendarDelegateAppearance{
    

    @IBOutlet weak var calendar: FSCalendar!
    
    //let datesWithEvent = ["2020/04/09", "2020/04/19", "2020/04/29"]
    //let datesWithMultipleEvents = ["2020/04/04", "2020/04/16", "2020/04/20"]
    let multipleEvents = ["2020-04-14","2020-04-30"]
    let borderDefaultColors = ["2020/04/21": UIColor.brown]
    let borderSelectionColors = ["2020/04/01": UIColor.red]
    let fillSelectionColors = ["2020/04/11": UIColor.green]
    let customAlert = MyAlert()

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
        // this function runs when a cell is tapped
        
        let dateString = self.dateFormatter1.string(from: date)
        
        //calendar.appearance.backgroundColors = UIColor.init(displayP3Red: 255, green: 140, blue: 105, alpha: 0.8)
        
        customAlert.showAlert(with: "Hello World", message: "yooooooo", on: self)
        var newTableView: UITableView!
        customAlert.setValue(newTableView, forKey: "accessoryView")
        
        func dismissAlert() {
            customAlert.dismissAlert()
        }
        
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

class MyAlert: UIView, UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CalendarTableCell") as! CalendarTableCell
        cell.taskLabel.text = "here is the task that needs to be done"
        
        
        return cell
    }
    
    
    struct Constants {
        static let backgroundAlphaTo: CGFloat = 0.6
    }
    
    private let backgrounudView: UIView = {
        let backgroundView = UIView()
        backgroundView.backgroundColor = .black
        backgroundView.alpha = 0
        return backgroundView
    }()
    
    private let alertView: UIView = {
        let alert = UIView()
        alert.backgroundColor = .white
        alert.layer.masksToBounds = true
        alert.layer.cornerRadius = 12
        return alert
    }()
    
    private var mytargetview: UIView?
    
    func showAlert(with title: String,
                   message: String,
                   on viewController: UIViewController) {
        guard let targetView = viewController.view else {
            return
        }
        
        mytargetview = targetView
        
        backgrounudView.frame = targetView.bounds
        
        targetView.addSubview(backgrounudView)
        
        targetView.addSubview(alertView)
        alertView.frame = CGRect(x: 40, y: -300, width: targetView.frame.size.width - 80, height: 300)
        
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: alertView.frame.size.width, height: 80))
        titleLabel.text = title
        titleLabel.textAlignment = .center
        alertView.addSubview(titleLabel)
        
       // let messageLabel = UILabel(frame: CGRect(x: 0, y: 80, width: alertView.frame.size.width, height: 170))
       //
       // messageLabel.numberOfLines = 0
       // messageLabel.text = message
       // messageLabel.textAlignment = .left
       // alertView.addSubview(messageLabel)
        
        let tableView = UITableView()
        alertView.addSubview(tableView)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CalendarTableCell.self, forCellReuseIdentifier: "CalendarTableCell")
        
        
        // set delegates
        
        // set height
        tableView.rowHeight = 50
        // register cells
        
        //set constraints
            
            
        
        
        let button = UIButton(frame: CGRect(x: 0, y: alertView.frame.size.height - 50, width: alertView.frame.size.width, height: 50))
        button.setTitleColor(.orange, for: .normal)
        button.setTitle("Dismiss", for: .normal)
        button.addTarget(self, action: #selector(dismissAlert), for: .touchUpInside)
        alertView.addSubview(button)
        

        UIView.animate(withDuration: 0.25, animations: {

            self.backgrounudView.alpha = Constants.backgroundAlphaTo
            

        }, completion: { done in
            if done {
                UIView.animate(withDuration: 0.25, animations: {
                    self.alertView.center = targetView.center
                    
                })
            }
        })
        
    }
    
    @objc func dismissAlert() {
        UIView.animate(withDuration: 0.25, animations: {

            guard let targetView = self.mytargetview else {
                return
            }
            
            
            self.alertView.frame = CGRect(x: 40, y: targetView.frame.size.height, width: targetView.frame.size.width - 80, height: 300)


        }, completion: { done in
            if done {
                UIView.animate(withDuration: 0.25, animations: {
                    self.backgrounudView.alpha = 0
                    
                }, completion: {done in
                    if done {
                        self.alertView.removeFromSuperview()
                        self.backgrounudView.removeFromSuperview()
                    }
                })
            }
        })
    }
    
    
}



