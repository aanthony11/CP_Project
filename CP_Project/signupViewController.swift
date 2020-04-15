//
//  signupViewController.swift
//  CP_Project
//
//  Created by Austin Anthony on 4/2/20.
//  Copyright © 2020 Manish Rajendran. All rights reserved.
//

import UIKit
import Parse

extension UITextField {
    func setStyleSignup() {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: self.frame.height))
        self.leftView = paddingView
        self.leftViewMode = .always
        
        self.layer.cornerRadius = 5
        self.backgroundColor = UIColor(red: 232/255, green: 232/255, blue: 232/255, alpha: 1)
    }
}

extension UIButton {
    func setStyleSignup() {
        self.layer.cornerRadius = 10
    }
}

class signupViewController: UIViewController {

    @IBOutlet weak var firstnameTextField: UITextField!
    @IBOutlet weak var lastnameTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextFIeld: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var signUpButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
//        signUpButton.layer.cornerRadius = 20
        errorLabel.alpha = 0
        
        firstnameTextField.setStyleSignup()
        lastnameTextField.setStyleSignup()
        usernameTextField.setStyleSignup()
        passwordTextField.setStyleSignup()
        confirmPasswordTextFIeld.setStyleSignup()
        
        signUpButton.setStyleSignup()
    }
    
//    https://stackoverflow.com/questions/25471114/how-to-validate-an-e-mail-address-in-swift
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    

    @IBAction func onSignUp(_ sender: Any) {
        let username = usernameTextField.text!.lowercased()
        let password = passwordTextField.text!
        let confirmedPassword = confirmPasswordTextFIeld.text!
        let passwordMismatch = "Passwords do not match."
        let notEmail = "Not a valid email address."

        
        if isValidEmail(username) != true {
            errorLabel.text = notEmail
            errorLabel.alpha = 1
        } else if password != confirmedPassword {
            errorLabel.text = passwordMismatch
            errorLabel.alpha = 1
        } else {
            let user = PFUser()
            user.username = username
            user.password = password
            user["firstName"] = firstnameTextField.text!.lowercased()
            user["lastName"] = lastnameTextField.text!.lowercased()
            user["tasks"] = []
            
            user.signUpInBackground { (success, error) in
            if success {
                self.performSegue(withIdentifier: "signUpSegue", sender: nil)
            } else {
                self.errorLabel.text = error?.localizedDescription
                self.errorLabel.alpha = 1
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
