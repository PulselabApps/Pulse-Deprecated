//
//  iPhoneLogInViewController.swift
//  PulseiOS
//
//  Created by Varun D Patel on 11/14/15.
//  Copyright © 2015 pulse. All rights reserved.
//

import UIKit

class iPhoneLogInViewController: DeviceLogInViewController {
    
    @IBOutlet weak var userNameCenterConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomConstraintLogInButton: NSLayoutConstraint!
    var keyboardIsVisible = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if !keyboardIsVisible{
            if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
                self.keyboardIsVisible = true
                if ((self.loginButton.center.y) >  (self.view.frame.height - keyboardSize.height)) {
                    let keyboardTop = (self.view.frame.height - keyboardSize.height)
                    let userNameBottom = usernameTextBox.center.y + usernameTextBox.frame.height / 2
                    UIView.animateWithDuration(0.25, delay: 0.25, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
                        if (userNameBottom > keyboardTop) {
                            self.userNameCenterConstraint.constant -= (userNameBottom - keyboardTop)
                        }
                        self.bottomConstraintLogInButton.constant += keyboardSize.height
                        let logInButtonBottom = (self.loginButton.center.y - self.loginButton.frame.height / 2) - keyboardSize.height
                        self.userNameCenterConstraint.constant -= (self.loginButton.frame.height + (keyboardTop - logInButtonBottom))
                        }, completion: nil)
                }
            }
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if keyboardIsVisible {
            if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
                if ((self.loginButton.center.y) <  (self.view.frame.height - keyboardSize.height)) {
                    let keyboardTop = (self.view.frame.height - keyboardSize.height)
                    UIView.animateWithDuration(0.25, delay: 0.50, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
                        self.bottomConstraintLogInButton.constant -= keyboardSize.height
                        let logInButtonBottom = (self.loginButton.center.y - self.bottomConstraintLogInButton.constant)
                        self.userNameCenterConstraint.constant += (self.loginButton.frame.height + (keyboardTop - logInButtonBottom))
                        }, completion: nil)
                }
            }
        }
        keyboardIsVisible = false
    }

}
