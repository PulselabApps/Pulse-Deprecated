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
    
    let user = User.sharedInstance.user
    var studentRank = 1
    var studentPoints = 0
    
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
    
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var answerTextBox: UITextField!
    
    var previouslyClickedButton : UIButton?
    var correctButton : UIButton?

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
    
    @IBAction func multipleChoiceAnswerClicked(sender: UIButton) {
        if let button = previouslyClickedButton {
            button.setTitleColor(UIColor.blackColor(), forState: .Normal)
        }
        sender.setTitleColor(ColorConstants.GreenCorrectColor, forState: .Normal)
        previouslyClickedButton = sender
        submitButton.enabled = true
    }
    
    func getGrade(grade: Double) -> String {
        var letterGrade = ""
        if grade < 60.0 {
            letterGrade = "F"
        }
        if (grade >= 60.0 && grade < 70.0) {
            letterGrade = "D"
        }
        if (grade >= 70.0 && grade < 80.0) {
            letterGrade =  "C"
        }
        if (grade >= 80.0 && grade < 90.0) {
            letterGrade =  "B"
        }
        if grade >= 90.0 {
            letterGrade = "A"
        }
        return letterGrade
    }
    
    func loadNewQuestion(){
        self.submitButton.enabled = true
        let image = UIImage(named: "Checked-100.png")
        submitButton.setImage(image, forState: .Normal)
        
        if let button = self.previouslyClickedButton {
            self.previouslyClickedButton!.selected = false
            button.backgroundColor = ColorConstants.GrayNormalButtonColor
        }
        if let button = self.correctButton {
            button.backgroundColor = ColorConstants.GrayNormalButtonColor
        }
        
        self.previouslyClickedButton = nil
        
        enableAllButtons()
        initQuestionAnswers()
    }
    
    func enableAllButtons(){
        topLeftMultipleChoiceButton.enabled = true
        topLeftMultipleChoiceButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
        
        bottomLeftMultipleChoiceButton.enabled = true
        bottomLeftMultipleChoiceButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
        
        topRightMultipleChoiceButton.enabled = true
        topRightMultipleChoiceButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
        
        bottomRightMultipleChoiceButton.enabled = true
        bottomRightMultipleChoiceButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
    }
    
    func getRank() {
        var rank = 1
        var scores = [Int]()
        let query = PFQuery(className: "Class")
        query.whereKey("name", equalTo: "Math")
        query.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
                let currentClass = objects![0]
                let relationalQuery = currentClass.relationForKey("students").query()
                relationalQuery?.whereKeyExists("score")
                relationalQuery?.findObjectsInBackgroundWithBlock({ (object: [PFObject]?, errors: NSError?) -> Void in
                    if errors == nil {
                        for obj in object!{
                            let student = obj
                            let score = student.valueForKey("score") as? Int
                            scores.append(score!)
                        }
                        scores.sortInPlace({ $0 > $1 })
                        for score in scores {
                            if score == self.user!["score"] as? Int {
                                break
                            }
                            rank++
                        }
                        self.studentRank = rank
                    }
                })
            }
            
        }
    }
    
    @IBAction func submitButtonPressed(sender: UIButton) {
        let image = UIImage(named: "Checked Filled-100.png")
        sender.setImage(image, forState: .Normal)
        sender.enabled = false
        
        if let multipleChoicAnswer = previouslyClickedButton {
            let answer = multipleChoicAnswer.titleLabel?.text
            
            let answerDick = ["answerChoice":answer!]
            PFCloud.callFunctionInBackground("sendAnswer", withParameters: answerDick)
            
            if answer == correctAnswer{
                var score = user!["score"] as? Int
                score = score! + 500
                user!["score"] = score
                
                var questionsCorrect = user!["questionsCorrect"] as? Int
                questionsCorrect!+=1
                user!["questionsCorrect"] = questionsCorrect
                
                /*var numCorrectAnswers = questions[currentQuestion!]["numCorrectAnswers"] as? Int
                numCorrectAnswers!+=1
                var question = questions[currentQuestion!] as! [String:AnyObject]
                question["numCorrectAnswers"] = numCorrectAnswers
                questions[currentQuestion!] = question
                
                saveQuestions()*/
                
                let blahDict = ["answerChoice":true]
                PFCloud.callFunctionInBackground("incrementCorrectOrIncorrect", withParameters: blahDict)
                
                saveUser()
                previouslyClickedButton!.backgroundColor = ColorConstants.GreenCorrectColor
            } else {
                var correctView = UIButton()
                switch correctAnswer!{
                case topLeftMultipleChoiceButton.titleLabel!.text!:
                    correctView = topLeftMultipleChoiceButton
                    
                    break
                case bottomLeftMultipleChoiceButton.titleLabel!.text!:
                    correctView = bottomLeftMultipleChoiceButton
                    break
                case topRightMultipleChoiceButton.titleLabel!.text!:
                    correctView = topRightMultipleChoiceButton
                    break
                case bottomRightMultipleChoiceButton.titleLabel!.text!:
                    correctView = bottomRightMultipleChoiceButton
                    break
                default:
                    break
                    
                }
                
                correctView.backgroundColor = ColorConstants.GreenCorrectColor
                correctView.setTitleColor(UIColor.whiteColor(), forState: .Normal)
                correctButton = correctView
                previouslyClickedButton!.backgroundColor = ColorConstants.RedIncorrectColor
                
                var score = user!["score"] as? Int
                score = score! - 500
                user!["score"] = score
                
                var questionsIncorrect = user!["questionsIncorrect"] as? Int
                questionsIncorrect!+=1
                user!["questionsIncorrect"] = questionsIncorrect
                
                /*var numIncorrectAnswers = questions[currentQuestion!]["numIncorrectAnswers"] as? Int
                numIncorrectAnswers!+=1
                var question = questions[currentQuestion!] as! [String:AnyObject]
                question["numIncorrectAnswers"] = numIncorrectAnswers
                questions[currentQuestion!] = question
                
                saveQuestions()*/
                
                let blahDict = ["answerChoice":false]
                PFCloud.callFunctionInBackground("incrementCorrectOrIncorrect", withParameters: blahDict)
                
                saveUser()
                
            }
            
            previouslyClickedButton!.setTitleColor(UIColor.whiteColor(), forState: .Normal)
            topLeftMultipleChoiceButton.enabled = false
            bottomLeftMultipleChoiceButton.enabled = false
            topRightMultipleChoiceButton.enabled = false
            bottomRightMultipleChoiceButton.enabled = false
        } else { // FILL IN THE BLANK
            if let answer = answerTextBox.text {
                if answer == correctAnswer{
                    // INCREMENT SCORE
                    var score = user!["score"] as? Int
                    score = score! + 500
                    user!["score"] = score
                    
                    var questionsCorrect = user!["questionsCorrect"] as? Int
                    questionsCorrect!+=1
                    user!["questionsCorrect"] = questionsCorrect
                    
                    /*var numCorrectAnswers = questions[currentQuestion!]["numCorrectAnswers"] as? Int
                    numCorrectAnswers!+=1
                    var question = questions[currentQuestion!] as! [String:AnyObject]
                    question["numCorrectAnswers"] = numCorrectAnswers
                    questions[currentQuestion!] = question
                    
                    saveQuestions()*/
                    
                    let blahDict = ["answerChoice":true]
                    PFCloud.callFunctionInBackground("incrementCorrectOrIncorrect", withParameters: blahDict)
                    
                    saveUser()
                    
                    answerTextBox.backgroundColor = ColorConstants.GreenCorrectColor
                } else {
                    answerTextBox.backgroundColor = ColorConstants.RedIncorrectColor
                    
                    var score = user!["score"] as? Int
                    score = score! - 500
                    user!["score"] = score
                    
                    var questionsIncorrect = user!["questionsIncorrect"] as? Int
                    questionsIncorrect!+=1
                    user!["questionsIncorrect"] = questionsIncorrect
                    
                    
                    /*var numIncorrectAnswers = questions[currentQuestion!]["numIncorrectAnswers"] as? Int
                    numIncorrectAnswers!+=1
                    var question = questions[currentQuestion!] as! [String:AnyObject]
                    question["numIncorrectAnswers"] = numIncorrectAnswers
                    questions[currentQuestion!] = question
                    
                    saveQuestions()*/
                    
                    let blahDict = ["answerChoice":false]
                    PFCloud.callFunctionInBackground("incrementCorrectOrIncorrect", withParameters: blahDict)
                    
                    saveUser()
                }
                answerTextBox.textColor = UIColor.whiteColor()
                answerTextBox.userInteractionEnabled = false
                
            } else { // It was left blank
                
            }
            
        }
    }
    
    func saveUser(){
        user!.saveInBackgroundWithBlock {
            (success: Bool, error: NSError?) -> Void in
            
            if (success) {
                print("user saved")
            } else {
                print(error?.description)
            }
            
        }
    }
    
    func checkForQuestionChange(){
        let query = PFQuery(className:"ClassSession")
        
        query.whereKey("name", equalTo: "Math")
        query.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            
            if error == nil {
                let classSession = objects![0]
                
                if classSession.valueForKey("currentQuestion") as? Int != self.currentQuestion{
                    
                    self.currentQuestion = classSession.valueForKey("currentQuestion") as? Int
                    
                    self.loadNewQuestion()
                    self.submitButton.enabled = false
                    self.getRank()
                }
                
            }
        }
        print("hello")
    }
}
