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
        
        /*"
        test_student"
        "password"
        */
        /*PFUser.logInWithUsernameInBackground(username, password:password) {
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
            }*/
            
            
            var query = PFQuery(className:"ClassSession")
            query.whereKey("name", equalTo:"Math")
            query.findObjectsInBackgroundWithBlock {
                (objects: [PFObject]?, error: NSError?) -> Void in
                
                if error == nil {
                // The find succeeded.
                print("Successfully retrieved \(objects!.count) scores.")
                // Do something with the found objects
                if let objects = objects! as? [PFObject] {
                for object in objects {
                
                
                var question = PFObject(className:"Question")
                question["questionType"] = "MultipleChoice"
                question["questionText"] = "Ellen went to a garage sale to buy chairs. Each chair cost 15 dollars. How much money did Ellen spend for the 12 chairs she bought?"
                question["answers"] = ["180","170","190","165"]
                
                var relation = question.relationForKey("classSession")
                relation.addObject(object)
                
                question.saveInBackgroundWithBlock {
                (success: Bool, error: NSError?) -> Void in
                if (success) {
                print("CLASS!!!!")
                // The object has been saved.
            } else {
                
                // There was a problem, check error.description
                }
                }
                
                
                var question_1 = PFObject(className:"Question")
                question_1["questionType"] = "MultipleChoice"
                question_1["questionText"] = "What is 5 x 10"
                question_1["questionTime"] = 60
                question_1["answers"] = ["50","20","55","35"]
                
                var relation_1 = question_1.relationForKey("classSession")
                relation_1.addObject(object)
                
                question_1.saveInBackgroundWithBlock {
                (success: Bool, error: NSError?) -> Void in
                if (success) {
                print("CLASS!!!!")
                // The object has been saved.
            } else {
                
                // There was a problem, check error.description
                }
                }
                
                
                
                var question_2 = PFObject(className:"Question")
                question_2["questionType"] = "FillInTheBlank"
                question_2["questionText"] = "A ___ is a horse, yes of course"
                question_2["answers"] = ["horse"]
                
                var relation_2 = question_2.relationForKey("classSession")
                relation_2.addObject(object)
                
                question_2.saveInBackgroundWithBlock {
                (success: Bool, error: NSError?) -> Void in
                if (success) {
                print("CLASS!!!!")
                // The object has been saved.
            } else {
                
                // There was a problem, check error.description
                }
                }
                
                }
                }
                
                
                
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


