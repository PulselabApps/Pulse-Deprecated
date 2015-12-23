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
    
    @IBOutlet var multipleChoices: [UIButton]!
    
    
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
        for button in multipleChoices{
            button.layer.cornerRadius = 10.0
            button.layer.borderColor = UIColor.grayColor().CGColor
            button.layer.borderWidth = 0.5
            button.clipsToBounds = true
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
        
        for button in multipleChoices{
            button.hidden = true
        }
    }
    
    func showFillInTheBlank(){
        answerTextBox.hidden = false
        var answers = questions[currentQuestion!].answers
        correctAnswer = answers[0]
    }
    
    func showMultipleChoiceOptions(){
        for button in multipleChoices{
            button.hidden = false
        }
        
        var answers = questions[currentQuestion!].answers
        correctAnswer = answers[0]
        
        // randomize correct answer location
        let newIndex = Int(arc4random_uniform(UInt32(4)))
        let tmp = answers[0]
        answers[0] = answers[newIndex]
        answers[newIndex] = tmp
        
        for var i = 0; i < 4; i++ {
            let answer = answers[i]
            multipleChoices[i].setTitle(answer, forState: .Normal)
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
        for button in multipleChoices{
            button.enabled = true
            button.setTitleColor(UIColor.blackColor(), forState: .Normal)
        }
    }
    
    func disableAllButtons(){
        for button in multipleChoices{
            button.enabled = false
        }
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
            
            for button in multipleChoices {
                if correctAnswer! == button.titleLabel!.text! {
                    correctView = button
                    break
                }
            }

            correctView.backgroundColor = ColorConstants.GreenCorrectColor
            correctView.setTitleColor(UIColor.whiteColor(), forState: .Normal)
            correctButton = correctView
            previouslyClickedButton!.backgroundColor = ColorConstants.RedIncorrectColor
            
        }
        previouslyClickedButton!.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        disableAllButtons()
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
