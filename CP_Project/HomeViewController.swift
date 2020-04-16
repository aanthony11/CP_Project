//
//  ViewController.swift
//  CP_Project
//
//  Created by Manish Rajendran on 3/25/20.
//  Copyright © 2020 Manish Rajendran. All rights reserved.
//

import UIKit
import Parse

class ViewController: UIViewController {
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signupButton: UIButton!
    
override func viewDidAppear(_ animated: Bool) {
       
    if UserDefaults.standard.bool(forKey: "UserLoggedIn") == true {
        performSegue(withIdentifier: "UserLoggedInFromHome", sender: nil)
        
    }
}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        loginButton.layer.cornerRadius = 10
        signupButton.layer.cornerRadius = 10
    }

    
    
}

