//
//  LoginViewController.swift
//  PulseiOS
//
//  Created by Michael Ross on 11/7/15.
//  Copyright © 2015 pulse. All rights reserved.
//

import UIKit
import Parse

class LoginViewController: UIViewController {
    @IBOutlet weak var usernameTextBox: UITextField!
    @IBOutlet weak var passwordTextBox: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func loginButtonPressed(sender: AnyObject) {
        let username = usernameTextBox.text ?? ""
        let password = passwordTextBox.text ?? ""
        //let username = "math_student_2"
        //let password = "math_student_2"
        
        /*"
        test_student"
        "password"
        */
        PFUser.logInWithUsernameInBackground(username, password:password) {
            (user: PFUser?, error: NSError?) -> Void in
            
            if user != nil {
                // Do stuff after successful login.
                print("success")
                if user!["role"] as! String == "Student"{
                    print("YOUR A STUDENT")
                    
                    if let studentVC = self.storyboard!.instantiateViewControllerWithIdentifier("StudentViewController") as? ViewController {
                        self.presentViewController(studentVC, animated: true, completion: nil)
                    }
                    
                    
                    
                } else {
                    print("YOUR A TEACHER")
                }
                
                
            } else {
                
                let alert = UIAlertController(title: "incorrect username/password", message: "", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "ok", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
            }
        }
    }
}

/*
// MARK: - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
// Get the new view controller using segue.destinationViewController.
// Pass the selected object to the new view controller.
}
*/