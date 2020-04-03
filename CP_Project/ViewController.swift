//
//  ViewController.swift
//  CP_Project
//
//  Created by Manish Rajendran on 3/25/20.
//  Copyright © 2020 Manish Rajendran. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signupButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        loginButton.layer.cornerRadius = 20
        signupButton.layer.cornerRadius = 20
    }

    
    
}

