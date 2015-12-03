//
//  DeviceLogInViewController.swift
//  PulseiOS
//
//  Created by Varun D Patel on 11/14/15.
//  Copyright © 2015 pulse. All rights reserved.
//

import UIKit
import Charts
import Parse
import Foundation

class DeviceLogInViewController: UIViewController {
    @IBOutlet weak var usernameTextBox: UITextField!
    @IBOutlet weak var passwordTextBox: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        loginButton.layer.cornerRadius = 10.0
    }
    
    @IBAction func loginButtonPressed(sender: AnyObject) {
        sender.layer.cornerRadius = 10.0
        // let username = usernameTextBox.text ?? ""
        // let password = passwordTextBox.text ?? ""
        let username = "math_student_2"
        let password = "math_student_2"

        PFUser.logInWithUsernameInBackground(username, password: password) {
            (user: PFUser?, error: NSError?) -> Void in
            
            if user != nil {
                // Do stuff after successful login.
                print("success")
                if user!["role"] as! String == "Student"{
                    print("YOU'RE A STUDENT")
                        if let studentVC = self.storyboard!.instantiateViewControllerWithIdentifier("StudentViewController") as? PulseTabViewController {
                            self.presentViewController(studentVC, animated: true, completion: nil)
                        } else  if let studentVC = self.storyboard!.instantiateViewControllerWithIdentifier("StudentViewController") as? DeviceViewController {
                            self.presentViewController(studentVC, animated: true, completion: nil)
                    }
                } else {
                    print("YOU'ER A TEACHER")
                }
                
            } else {
                
                let alert = UIAlertController(title: "incorrect username/password", message: "", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "ok", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
            }
        }
    }
}
