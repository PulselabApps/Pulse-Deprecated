//
//  DeviceViewController.swift
//  PulseiOS
//
//  Created by Varun D Patel on 11/14/15.
//  Copyright © 2015 pulse. All rights reserved.
//

import UIKit
import Charts
import Parse
import Foundation

class DeviceViewController: UIViewController {
    
    var questions = [AnyObject]()
    var currentQuestion : Int?
    var correctAnswer : String?
    var studentsAnswer : String?
    var questionType : String?
    
    @IBOutlet weak var topLeftMultipleChoice: UIView!
    @IBOutlet weak var topRightMultipleChoice: UIView!
    @IBOutlet weak var bottomLeftMultipleChoice: UIView!
    @IBOutlet weak var bottomRightMultipleChoice: UIView!
    
    @IBOutlet weak var topLeftMultipleChoiceButton: UIButton!
    @IBOutlet weak var bottomLeftMultipleChoiceButton: UIButton!
    @IBOutlet weak var topRightMultipleChoiceButton: UIButton!
    @IBOutlet weak var bottomRightMultipleChoiceButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        _ = NSTimer.scheduledTimerWithTimeInterval(2.0, target: self, selector: Selector("checkForQuestionChange"), userInfo: nil, repeats: true)
        
        initScene()
    }
    
    func initScene(){
        
        makeMultipleChoicesRound()
        
        let query = PFQuery(className:"ClassSession")
        
        query.whereKey("name", equalTo:"Math")
        query.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            
            if error == nil {
                
                let classSession = objects![0]
                
                self.questions = classSession.valueForKey("questions") as! [AnyObject]
                self.currentQuestion = classSession.valueForKey("currentQuestion") as? Int
                
                
                self.initQuestionAnswers()
                
            }
        }
    }
    
    func makeMultipleChoicesRound(){
        let multipleChoices = [topLeftMultipleChoice,topRightMultipleChoice,bottomLeftMultipleChoice,bottomRightMultipleChoice]
        
        for view in multipleChoices{
            view.layer.cornerRadius = 10.0
            view.layer.borderColor = UIColor.grayColor().CGColor
            view.layer.borderWidth = 0.5
            view.clipsToBounds = true
        }
    }
    
    func initQuestionAnswers(){
        
        hideAllAnswers()
        
        switch questions[currentQuestion!]["questionType"] as! String {
        case "MultipleChoice":
            showMultipleChoiceOptions()
            break
        case "FillInTheBlank":
            showFillInTheBlank()
            submitButton.enabled = true
            break
            
        default: break
            
        }
    }
    
    
    
    func hideAllAnswers(){
        answerTextBox.hidden = true
        topLeftMultipleChoice.hidden = true
        topRightMultipleChoice.hidden = true
        bottomLeftMultipleChoice.hidden = true
        bottomRightMultipleChoice.hidden = true
    }
    
    func showFillInTheBlank(){
        answerTextBox.hidden = false
        var answers = questions[currentQuestion!]["answers"]!! as! [String]
        correctAnswer = answers[0]
    }
    
    func showMultipleChoiceOptions(){
        topLeftMultipleChoice.hidden = false
        topRightMultipleChoice.hidden = false
        bottomLeftMultipleChoice.hidden = false
        bottomRightMultipleChoice.hidden = false
        
        let buttons = [topLeftMultipleChoiceButton, bottomLeftMultipleChoiceButton,topRightMultipleChoiceButton,bottomRightMultipleChoiceButton]
        
        var answers = questions[currentQuestion!]["answers"]!! as! [String]
        correctAnswer = answers[0]
        
        let newIndex = Int(arc4random_uniform(UInt32(4)))
        let tmp = answers[0]
        answers[0] = answers[newIndex]
        answers[newIndex] = tmp
        
        for var i = 0; i < 4; i++ {
            let answer = answers[i]
            buttons[i].setTitle(answer, forState: .Normal)
        }
    }

    
}
