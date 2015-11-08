//
//  ViewController.swift
//  PulseiOS
//
//  Created by Max Marze on 11/7/15.
//  Copyright © 2015 pulse. All rights reserved.
//

import UIKit
import Charts
import Parse
import Foundation

struct AnswerTypes {
    static let MultipleChoice = "MultipleChoice"
    static let FillInTheBlank = "FillInTheBlank"
    static let Matching = "Matching"
}

class ViewController: UIViewController {
    
    @IBOutlet weak var answerTextBox: UITextField!
    
    var previouslyClickedButton : UIButton?
    var correctButton : UIButton?
    
    @IBOutlet weak var topLeftMultipleChoice: UIView!
    @IBOutlet weak var topRightMultipleChoice: UIView!
    @IBOutlet weak var bottomLeftMultipleChoice: UIView!
    @IBOutlet weak var bottomRightMultipleChoice: UIView!
    
    @IBOutlet weak var topLeftMultipleChoiceButton: UIButton!
    @IBOutlet weak var bottomLeftMultipleChoiceButton: UIButton!
    @IBOutlet weak var topRightMultipleChoiceButton: UIButton!
    @IBOutlet weak var bottomRightMultipleChoiceButton: UIButton!
    
    
    @IBOutlet weak var progressPieChart: UIView!
    @IBOutlet weak var rank: UILabel!
    @IBOutlet weak var points: UILabel!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var answerView: UIView!
    
    let user = PFUser.currentUser()
    
    var questionsCorrect = 0
    var questionsAsked = 0
    
    var questions = [AnyObject]()
    var currentQuestion : Int?
    
    var correctAnswer : String?
    
    let correctColor = UIColor(red: 91.0 / 255, green: 201.0 / 255, blue: 139.0 / 255, alpha: 1.0)
    let incorrectColor = UIColor(red: 201.0 / 255, green: 91.0 / 255, blue: 104.0 / 255, alpha: 1.0)
    let regularColor = UIColor(red: 205.0 / 255, green: 205.0 / 255, blue: 205.0 / 255, alpha: 1.0)
    
    var studentsAnswer : String?
    
    var questionType : String?
    
    let pieChart = PieChartView()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        _ = NSTimer.scheduledTimerWithTimeInterval(2.0, target: self, selector: Selector("checkForQuestionChange"), userInfo: nil, repeats: true)
        
        submitButton.enabled = false
        rank.text = "0"
        points.text = "0"
        initialLoad(pieChart)
        initScene()
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
    
    func initScene(){
        rank.text = "1"
        points.text = "0"
        
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
    
    func initQuestionAnswers(){
        
        hideAllAnswers()
        
        switch questions[currentQuestion!]["questionType"] as! String {
        case "MultipleChoice":
            showMultipleChoiceOptions()
            break
        case "FillInTheBlank":
            showFillInTheBlank()
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
    
    /*func increaseNumCorrectAnswersForQuestion(){
        let query = PFQuery(className:"ClassSession")
        
        query.whereKey("name", equalTo:"Math")
        query.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            
            if error == nil {
                
                let classSession = objects![0]
                
                let myQuestions = classSession.valueForKey("questions") as! NSArray
                myQuestions[self.currentQuestion!]["numCorrectAnswers"] = 5
                
                
                
            }
        }
    }*/
    
    
    @IBAction func submitButtonPressed(sender: UIButton) {
        let image = UIImage(named: "Checked Filled-100.png")
        sender.setImage(image, forState: .Normal)
        sender.enabled = false
        
        if let multipleChoicAnswer = previouslyClickedButton {
            let answer = multipleChoicAnswer.titleLabel?.text
            
            
            if answer == correctAnswer{
                var score = user!["score"] as? Int
                score = score! + 500
                user!["score"] = score
                
                var questionsCorrect = user!["questionsCorrect"] as? Int
                questionsCorrect!+=1
                user!["questionsCorrect"] = questionsCorrect
                
                var numCorrectAnswers = questions[currentQuestion!]["numCorrectAnswers"] as? Int
                numCorrectAnswers!+=1
                var question = questions[currentQuestion!] as! [String:AnyObject]
                question["numCorrectAnswers"] = numCorrectAnswers
                questions[currentQuestion!] = question
                
                saveQuestions()
                saveUser()
                previouslyClickedButton!.backgroundColor = correctColor
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
                correctView.backgroundColor = correctColor
                correctView.setTitleColor(UIColor.whiteColor(), forState: .Normal)
                correctButton = correctView
                previouslyClickedButton!.backgroundColor = incorrectColor
                
                
                var score = user!["score"] as? Int
                score = score! - 500
                user!["score"] = score
                
                var questionsIncorrect = user!["questionsIncorrect"] as? Int
                questionsIncorrect!+=1
                user!["questionsIncorrect"] = questionsIncorrect
                
                
                
                var numIncorrectAnswers = questions[currentQuestion!]["numIncorrectAnswers"] as? Int
                numIncorrectAnswers!+=1
                var question = questions[currentQuestion!] as! [String:AnyObject]
                question["numIncorrectAnswers"] = numIncorrectAnswers
                questions[currentQuestion!] = question
                
                saveQuestions()
                
                
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
                    
                    
                    var numCorrectAnswers = questions[currentQuestion!]["numCorrectAnswers"] as? Int
                    numCorrectAnswers!+=1
                    var question = questions[currentQuestion!] as! [String:AnyObject]
                    question["numCorrectAnswers"] = numCorrectAnswers
                    questions[currentQuestion!] = question
                    
                    saveQuestions()
                    
                    
                    
                    
                    saveUser()
                    
                    answerTextBox.backgroundColor = correctColor
                } else {
                    answerTextBox.backgroundColor = incorrectColor
                    
                    var score = user!["score"] as? Int
                    score = score! - 500
                    user!["score"] = score
                    
                    var questionsIncorrect = user!["questionsIncorrect"] as? Int
                    questionsIncorrect!+=1
                    user!["questionsIncorrect"] = questionsIncorrect
                    
                    
                    var numIncorrectAnswers = questions[currentQuestion!]["numIncorrectAnswers"] as? Int
                    numIncorrectAnswers!+=1
                    var question = questions[currentQuestion!] as! [String:AnyObject]
                    question["numIncorrectAnswers"] = numIncorrectAnswers
                    questions[currentQuestion!] = question
                    
                    saveQuestions()
                    
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
        drawPieChart(correctAnswers, incorrect: incorrectAnswers, pieChart: pieChart)
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
    
    func saveQuestions(){
        
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
    }
    
    
    
    @IBAction func multipleChoiceAnswerClicked(sender: UIButton) {
        if let button = previouslyClickedButton {
            button.setTitleColor(UIColor.blackColor(), forState: .Normal)
        }
        sender.setTitleColor(correctColor, forState: .Normal)
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
            button.backgroundColor = self.regularColor
        }
        if let button = self.correctButton {
            button.backgroundColor = self.regularColor
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
    
    func initialLoad(pieChart: PieChartView) {
        var chartDataSetEntries = [ChartDataEntry]()
        chartDataSetEntries.append(ChartDataEntry(value: 1, xIndex: 0))
        let chartDataSet = PieChartDataSet(yVals: chartDataSetEntries, label: "")
        chartDataSet.colors = ChartColorTemplates.liberty()
        chartDataSet.colors = [UIColor(red: 91.0 / 255, green: 201.0 / 255, blue: 139.0 / 255, alpha: 1.0)]
        
        let chartData = PieChartData(xVals: ["✔"], dataSet: chartDataSet)
        pieChart.data = chartData
        pieChart.setDescriptionTextPosition(x: 0, y: 0)
        pieChart.sizeToFit()
        pieChart.usePercentValuesEnabled = true
        pieChart.centerTextRadiusPercent = 100.0
        
        pieChart.centerText = ""
        pieChart.holeColor = UIColor(red: 255.0 / 255, green: 194.0 / 255, blue: 113.0 / 255, alpha: 1.0)
        pieChart.frame = CGRect(x: -40.0, y: -40.0, width: progressPieChart.frame.width * 2.0, height: progressPieChart.frame.height * 2.0)
        progressPieChart.addSubview(pieChart)
    }
    
    func drawPieChart(correct: Double, incorrect: Double, pieChart: PieChartView) {
        progressPieChart.subviews.forEach({ $0.removeFromSuperview() })
        var chartDataSetEntries = [ChartDataEntry]()
        chartDataSetEntries.append(ChartDataEntry(value: correct, xIndex: 0))
        chartDataSetEntries.append(ChartDataEntry(value: incorrect, xIndex: 1))
        
        let chartDataSet = PieChartDataSet(yVals: chartDataSetEntries, label: "")
        
        chartDataSet.colors = ChartColorTemplates.liberty()
        
        
        
        chartDataSet.colors = [correctColor, incorrectColor]
        
        let chartData = PieChartData(xVals: ["✔", "✕"], dataSet: chartDataSet)
        pieChart.data = chartData
        pieChart.setDescriptionTextPosition(x: 0, y: 0)
        pieChart.sizeToFit()
        // pieChart.setDrawSliceText(false)
        pieChart.usePercentValuesEnabled = true
        pieChart.centerTextRadiusPercent = 100.0
        
        pieChart.centerText = getGrade(100 * (correct / (correct + incorrect)))
        pieChart.holeColor = UIColor(red: 255.0 / 255, green: 194.0 / 255, blue: 113.0 / 255, alpha: 1.0)
        pieChart.frame = CGRect(x: -40.0, y: -40.0, width: progressPieChart.frame.width * 2.0, height: progressPieChart.frame.height * 2.0)
        // pieChart.center = progressPieChart.center
        progressPieChart.addSubview(pieChart)
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

