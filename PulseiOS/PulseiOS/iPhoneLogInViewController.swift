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
                    
                    UIView.animateWithDuration(0.25, delay: 0.25, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
                           // MARK: adjust bottomConstraintLogInButton here
                        }, completion: nil)
                }
            }
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if keyboardIsVisible {
            if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
                if ((self.loginButton.center.y) >  (self.view.frame.height - keyboardSize.height)) {
                    UIView.animateWithDuration(0.25, delay: 0.25, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
                          // MARK: adjust bottomConstraintLogInButton here
                        }, completion: nil)
                }
            }
        }
        keyboardIsVisible = false
    }

}
