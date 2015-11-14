//
//  iPadAnswersViewController
//  PulseiOS
//
//  Created by Varun Patel on 11/14/15.
//  Copyright © 2015 pulse. All rights reserved.
//

import UIKit
import Charts
import Parse
import Foundation

class iPadAnswersViewController : DeviceViewController {
    
    @IBOutlet weak var answerTextBox: UITextField!
    
    var previouslyClickedButton : UIButton?
    var correctButton : UIButton?
    
    @IBOutlet weak var progressPieChart: PieChartView!
    @IBOutlet weak var rank: UILabel!
    @IBOutlet weak var points: UILabel!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var answerView: UIView!
    
    var questionsCorrect = 0
    var questionsAsked = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /** PIE CHART SETUP : **/
        progressPieChart.legend.enabled = false
        progressPieChart.usePercentValuesEnabled = true
        progressPieChart.holeColor = ColorConstants.OrangeAppColor
        progressPieChart.sizeToFit()
        progressPieChart.centerTextRadiusPercent = 75.0
        progressPieChart.descriptionText = ""
        /*********************************************************/
        
        submitButton.enabled = false
        rank.text = "1"
        points.text = "0"
        
        drawPieChart(1.0, incorrect: 0.0, isInitialLoad: true)
    }
    
    @IBAction func answerTextBoxType(sender: UITextField) {
        submitButton.enabled = true
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
        self.points.text = String(self.user!["score"] as! Int)
        let correctAnswers = user!["questionsCorrect"] as! Double
        let incorrectAnswers = user!["questionsIncorrect"] as! Double
        drawPieChart(correctAnswers, incorrect: incorrectAnswers, isInitialLoad: false)
    }
    
    func saveUser(){
        user!.saveInBackgroundWithBlock {
            (success: Bool, error: NSError?) -> Void in
            if (success) {
                print("user saved")
                // The object has been saved.
            } else {
                
                // There was a problem, check error.description
            }
        }
    }
    
    /*func saveQuestions(){
    
    let query = PFQuery(className:"ClassSession")
    
    query.whereKey("name", equalTo:"Math")
    query.findObjectsInBackgroundWithBlock {
    (objects: [PFObject]?, error: NSError?) -> Void in
    
    if error == nil {
    
    let classSession = objects![0]
    
    classSession.setValue(self.questions, forKey: "questions")
    
    
    classSession.saveInBackground()
    }
    }
    }*/
    
    
    
    @IBAction func multipleChoiceAnswerClicked(sender: UIButton) {
        if let button = previouslyClickedButton {
            button.setTitleColor(UIColor.blackColor(), forState: .Normal)
        }
        sender.setTitleColor(ColorConstants.GreenCorrectColor, forState: .Normal)
        previouslyClickedButton = sender
        submitButton.enabled = true
    }
    
    // MARK: NEED A FUNCTION THAT IS ALWAYS CHECKING TO SEE IF THE QUESTION HAS CHANGED
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
                            // print (score)
                            scores.append(score!)
                        }
                        scores.sortInPlace({ $0 > $1 })
                        for score in scores {
                            // print (score)
                            if score == self.user!["score"] as? Int {
                                break
                            }
                            rank++
                        }
                        self.rank.text = String(rank)
                    }
                })
            }
            
        }
    }
    
    func drawPieChart(correct: Double, incorrect: Double, isInitialLoad: Bool) {
        var chartDataSetEntries = [ChartDataEntry]()
        
        chartDataSetEntries.append(ChartDataEntry(value: correct, xIndex: 0))
        chartDataSetEntries.append(ChartDataEntry(value: incorrect, xIndex: 1))
        
        let chartDataSet = PieChartDataSet(yVals: chartDataSetEntries, label: "")
        chartDataSet.colors = [ColorConstants.GreenCorrectColor, ColorConstants.RedIncorrectColor]
        
        let chartData = PieChartData(xVals: ["✔", "✕"], dataSet: chartDataSet)
        progressPieChart.data = chartData
        
        progressPieChart.centerText =  !isInitialLoad ? getGrade(100 * (correct / (correct + incorrect))) : "A"
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
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        switch segue.identifier! {
        case "FullQuestionSegue":
            let fullQuestionVC = segue.destinationViewController as! FullQuestionViewController
            fullQuestionVC.fullQuestion = questions[currentQuestion!]["questionText"]!! as? String
            
        default:
            break
        }
    }
}

