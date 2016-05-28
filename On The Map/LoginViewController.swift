//
//  LoginViewController.swift
//  On The Map
//
//  Created by Eytan Biala on 4/27/16.
//  Copyright © 2016 Udacity. All rights reserved.
//

import Foundation
import UIKit

class LoginViewController : UIViewController, UITextFieldDelegate {

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var loginButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        emailField.delegate = self
        passwordField.delegate = self
    }

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if (textField == emailField) {
            passwordField.becomeFirstResponder()
        } else if (textField == passwordField) {
            passwordField.resignFirstResponder()
            doLogin(textField)
        }
        return true
    }

    @IBAction func doLogin(sender: AnyObject) {
        let email = emailField.text
        let pass = passwordField.text
        if (email?.characters.count == 0) {
            emailField.becomeFirstResponder()
            return
        }
        if (pass?.characters.count == 0) {
            passwordField.becomeFirstResponder()
            return
        }

        loginButton.enabled = false

        UdacityClient.login(email!, password: pass!) { (error, result) -> (Void) in
            self.loginButton.enabled = true
            if (error != nil) {
                print(error)
                let alert = UIAlertController(title: "Login Error", message: error?.localizedDescription, preferredStyle: .Alert)
                alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
            } else {
                print("Logged in")
                let nav = UINavigationController(rootViewController: TabViewController())
                self.presentViewController(nav, animated: true, completion: nil)
            }
        }
    }
}
