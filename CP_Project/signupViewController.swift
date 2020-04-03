//
//  signupViewController.swift
//  CP_Project
//
//  Created by Austin Anthony on 4/2/20.
//  Copyright © 2020 Manish Rajendran. All rights reserved.
//

import UIKit
import Parse

class signupViewController: UIViewController {

    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextFIeld: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var signUpButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        signUpButton.layer.cornerRadius = 20
        errorLabel.alpha = 0
    }
    

    @IBAction func onSignUp(_ sender: Any) {
        let username = usernameTextField.text!
        let password = passwordTextField.text!
        let confirmedPassword = confirmPasswordTextFIeld.text!
        
        if password != confirmedPassword {
            errorLabel.text = "Passwords do not match."
            errorLabel.alpha = 1
        } else {
            let user = PFUser()
            user.username = username
            user.password = password
            
            user.signUpInBackground { (success, error) in
            if success {
                self.performSegue(withIdentifier: "signUpSegue", sender: nil)
            } else {
                print("Error: \(error?.localizedDescription)")
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

}
}
