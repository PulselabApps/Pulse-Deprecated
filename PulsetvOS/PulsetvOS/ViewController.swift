//
//  ViewController.swift
//  PulsetvOS
//
//  Created by Max Marze on 11/7/15.
//  Copyright © 2015 pulse. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var statsView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let swipeLeftGesture = UISwipeGestureRecognizer(target: self, action: Selector("statsLeftSwipe:"))
        swipeLeftGesture.direction = .Left
        self.view.addGestureRecognizer(swipeLeftGesture)
        
        let swipeRightGesture = UISwipeGestureRecognizer(target: self, action: Selector("statsRightSwipe:"))
        swipeRightGesture.direction = .Right
        self.view.addGestureRecognizer(swipeRightGesture)
        
        statsView.hidden = true
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func statsLeftSwipe(recognizer : UISwipeGestureRecognizer) {
        print("SwipeLeft")
        
        let originalViewRect = statsView.frame
        
        statsView.frame.origin = CGPoint(x: self.view.frame.width, y: 0.0)
        
        UIView.animateWithDuration(1.1, animations: { () -> Void in
            self.statsView.hidden = false
            self.statsView.frame = originalViewRect
        }, completion: nil)
    }
    
    func statsRightSwipe(recognizer : UISwipeGestureRecognizer) {
        if(!statsView.hidden) {
            print("SwipeRight")
            
            var transitionRect = statsView.frame
            transitionRect.origin = CGPoint(x: self.view.frame.width, y: 0.0)
            let originalRect = statsView.frame
            
            UIView.animateWithDuration(1.1, animations: { () -> Void in
                self.statsView.frame = transitionRect
                }) { (completed) -> Void in
                    self.statsView.hidden = true
                    self.statsView.frame = originalRect
            }
        }
        
    }

}

