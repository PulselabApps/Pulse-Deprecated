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
import DeepLinkKit

class DeviceViewController: UIViewController, DPLTargetViewController {
    
    let userData = User.sharedInstance
    var studentRank = 1
    var studentPoints = 0
    
    var questions = [Question]()
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
    
    @IBOutlet weak var rank: UILabel!
    @IBOutlet weak var points: UILabel!
    
    var previouslyClickedButton : UIButton?
    var correctButton : UIButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initScene()
        submitButton.enabled = false
        ViewState.currentView = self
    }
    
    func initScene(){
        
        makeMultipleChoicesRound()
        
        let query = ClassSession_Beta.query()!
        query.getObjectInBackgroundWithId("udilE5VomO") { (object, error) -> Void in
            if error == nil {
                if let classSession = object as? ClassSession_Beta {
                    let questionQuery = classSession.questions.query()
                    questionQuery.orderByAscending("createdAt")
                    questionQuery.findObjectsInBackgroundWithBlock({ (objects, error) -> Void in
                        if error == nil {
                            if let questions = objects as? [Question] {
                                self.questions = questions
                                self.currentQuestion = classSession.currentQuestion
                                self.initQuestionAnswers()
                            }
                        }
                    })
                }
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
        
        let currentQ = self.questions[self.currentQuestion!]
        let type = QuestionType(rawValue: currentQ.questionType)!
        
        switch type {
        case .MultipleChoice:
            showMultipleChoiceOptions()
            break
        case .FillInTheBlank:
            showFillInTheBlank()
            break
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
        var answers = questions[currentQuestion!].answers
        correctAnswer = answers[0]
    }
    
    func showMultipleChoiceOptions(){
        topLeftMultipleChoice.hidden = false
        topRightMultipleChoice.hidden = false
        bottomLeftMultipleChoice.hidden = false
        bottomRightMultipleChoice.hidden = false
        
        let buttons = [topLeftMultipleChoiceButton, bottomLeftMultipleChoiceButton,topRightMultipleChoiceButton,bottomRightMultipleChoiceButton]
        var answers = questions[currentQuestion!].answers
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
    
    @IBAction func submitButtonPressed(sender: UIButton) {
        let image = UIImage(named: "Checked Filled-100.png")
        sender.setImage(image, forState: .Normal)
        sender.enabled = false
        let currentQ = questions[currentQuestion!]
        let type = QuestionType(rawValue: currentQ.questionType)!
        let answer: String
        
        switch type {
        case .MultipleChoice:
            answer = (previouslyClickedButton!.titleLabel?.text)!
            break
        case .FillInTheBlank:
            answer = answerTextBox.text!
            break
        }
        
        let isCorrectAnswer = answer == correctAnswer
        switch type {
        case .MultipleChoice:
            configureMultipleChoiceAfterSubmit(currentQ, answer: answer, isCorrectAnswer: isCorrectAnswer)
            break
        case .FillInTheBlank:
            configureFillInTheBlankAfterSubmit(isCorrectAnswer)
            break
        }
        
        let offset = isCorrectAnswer ? Score.Increment : Score.Decrement
        DeviceViewHelper.calculateScore(answer == correctAnswer, offsetValue: offset, currentQuestion: currentQ)
        
        currentQ.saveInBackgroundWithBlock({ (success, error) -> Void in
            if error == nil && success {
                print("Saved Question")
            }
        })
    }
    
    func configureMultipleChoiceAfterSubmit(currentQuestion: Question, answer: String, isCorrectAnswer: Bool) {
        currentQuestion.answerBreakdown[answer]!++
        if isCorrectAnswer {
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
            
        }
        previouslyClickedButton!.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        topLeftMultipleChoiceButton.enabled = false
        bottomLeftMultipleChoiceButton.enabled = false
        topRightMultipleChoiceButton.enabled = false
        bottomRightMultipleChoiceButton.enabled = false
    }
    
    func configureFillInTheBlankAfterSubmit(isCorrectAnswer: Bool) {
        if isCorrectAnswer {
            answerTextBox.backgroundColor = ColorConstants.GreenCorrectColor
        } else {
            answerTextBox.backgroundColor = ColorConstants.RedIncorrectColor
        }
        answerTextBox.textColor = UIColor.whiteColor()
        answerTextBox.userInteractionEnabled = false
    }
    
    func checkForQuestionChange(){
        let query = ClassSession_Beta.query()!
        query.getObjectInBackgroundWithId("udilE5VomO") { (object, error) -> Void in
            if error == nil {
                if let classSession = object as? ClassSession_Beta {
                    if classSession.currentQuestion != self.currentQuestion! {
                        self.currentQuestion = classSession.currentQuestion
                        self.loadNewQuestion()
                        self.submitButton.enabled = false
                        DeviceViewHelper.setRankLabel(self.rank, offset: "")
                    }
                }
            }
        }
        print("hello")
    }
    
    // MARK -: DPLTargetViewController
    func configureWithDeepLink(deepLink: DPLDeepLink!) {
        print("Came from deep link")
        checkForQuestionChange()
    }
}
