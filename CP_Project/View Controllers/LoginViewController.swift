//
//  loginViewController.swift
//  CP_Project
//
//  Created by Austin Anthony on 4/2/20.
//  Copyright © 2020 Manish Rajendran. All rights reserved.
//

import UIKit
import Parse

extension UITextField {
    func setStyleLogin() {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: self.frame.height))
        self.leftView = paddingView
        self.leftViewMode = .always
        
        self.layer.cornerRadius = 5
        self.backgroundColor = UIColor(red: 232/255, green: 232/255, blue: 232/255, alpha: 1)
    }
}

extension UIButton {
    func setStyleLogin() {
        self.layer.cornerRadius = 10
    }
}

class LoginViewController: UIViewController {

    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    
    @IBAction func onTap(_ sender: Any) {
        view.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        errorLabel.alpha = 0

        // Do any additional setup after loading the view.
        usernameField.setStyleLogin()
        passwordField.setStyleLogin()
        loginButton.setStyleLogin()
    }
    
    //    https://stackoverflow.com/questions/25471114/how-to-validate-an-e-mail-address-in-swift
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    
    @IBAction func onLogin(_ sender: Any) {
        let username = usernameField.text!.lowercased()
        let password = passwordField.text!
        let notEmail = "Not a valid email address."
        let loginFail = "Invalid email or password."
        
        if isValidEmail(username) != true {
            errorLabel.text = notEmail
            errorLabel.alpha = 1
        } else {
            PFUser.logInWithUsername(inBackground: username, password: password) { (user, error) in
                if (user != nil) {
                    //print("Bool before: ")
                    //print(UserDefaults.standard.bool(forKey: "loginSegue"))
                    
                    UserDefaults.standard.set(true, forKey: "UserLoggedIn")
                    self.performSegue(withIdentifier: "loginSegue", sender: nil) // performs segue to login
                    
                    //print("Bool after: ")
                    //print(UserDefaults.standard.bool(forKey: "loginSegue"))
                    
                } else {
                    self.errorLabel.text = loginFail
                    self.errorLabel.alpha = 1
                    print("Error: \(error?.localizedDescription)")
                }
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
