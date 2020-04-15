//
//  GroupViewController.swift
//  CP_Project
//
//  Created by Adam Anderson on 4/15/20.
//  Copyright © 2020 Manish Rajendran. All rights reserved.
//

import UIKit
import Parse

class GroupViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func onLogout(_ sender: Any) {
        
        PFUser.logOut()
               
       let main = UIStoryboard(name: "Main", bundle: nil)
       let viewController = main.instantiateViewController(withIdentifier: "ViewController")
       let sceneDelegate = self.view.window?.windowScene?.delegate as! SceneDelegate
       
       sceneDelegate.window?.rootViewController = viewController
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
