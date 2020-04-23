//
//  GroupSelectViewController.swift
//  CP_Project
//
//  Created by Adam Anderson on 4/22/20.
//  Copyright © 2020 Manish Rajendran. All rights reserved.
//

import UIKit
import Parse

class GroupSelectViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var currentUser = PFUser.current()
    var groups = [PFObject]()
    
    @IBOutlet weak var pickerView: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        pickerView.delegate = self
        pickerView.dataSource = self
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let userId = currentUser?.objectId
        let query = PFQuery(className: "Group")
        query.whereKey("users", contains: userId)
        query.findObjectsInBackground { (results: [PFObject]?, error: Error?) in
            if let error = error {
                print(error.localizedDescription)
            } else {
                self.groups = results!
                self.pickerView.reloadAllComponents()
            }
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return groups.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let group = groups[row]
        let groupName = group["Group"] as? String
        
        return groupName!
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return groups.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let group = groups[row]
        let groupName = group["Group"] as? String
        
        let vc = storyboard?.instantiateViewController(withIdentifier: "TaskDetailsVC") as? TaskDetailsViewController
        vc?.groupName = groupName!
        vc?.tableView.reloadData()
    }

    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
