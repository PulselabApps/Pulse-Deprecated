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

struct AnswerTypes {
    static let MultipleChoice = "MultipleChoice"
    static let FillInTheBlank = "FillInTheBlank"
    static let Matching = "Matching"
}

class ViewController: UIViewController {
    
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
    
    var questions = NSArray()
    var currentQuestion : Int?
    
    
    var studentsAnswer : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let pieChart = PieChartView()
        submitButton.enabled = false
        rank.text = "0"
        points.text = "0"
        // drawPieChart(correct, incorrect: incorrect, pieChart: pieChart)
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

                self.questions = classSession.valueForKey("questions") as! NSArray
                self.currentQuestion = classSession.valueForKey("currentQuestion") as? Int
                
                self.initQuestionAnswers()
                
            }
        }
        
    }
    
    
    
    func initQuestionAnswers(){
        switch questions[currentQuestion!]["questionType"] as! String{
        case "MultipleChoice":
            showMultipleChoiceOptions()
            break
        case "FillInTheBlank":
            break
            
        default: break
        }
    }
    
    func showMultipleChoiceOptions(){

        let buttons = [topLeftMultipleChoiceButton, bottomLeftMultipleChoiceButton,topRightMultipleChoiceButton,bottomRightMultipleChoiceButton]
        
        //Randomize correct answer
        var answers = questions[currentQuestion!]["answers"]!! as! [String]
        let newIndex = Int(arc4random_uniform(UInt32(4)))
        let tmp = answers[0]
        answers[0] = answers[newIndex]
        answers[newIndex] = tmp
        
        for var i = 0; i < 4; i++
        {
            let answer = answers[i]
            buttons[i].setTitle(answer, forState: .Normal)
        }
    }
    

    
    
    @IBAction func submitButtonPressed(sender: UIButton) {
        let image = UIImage(named: "Checked Filled-100.png")
        sender.setImage(image, forState: .Normal)
    }
    
    // MARK: NEED A FUNCTION THAT IS ALWAYS CHECKING TO SEE IF THE QUESTION HAS CHANGED
    func checkForQuestionChange(){
        if true/*replace true with whether or not the question has changed*/{
            //if studentsAnswer
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
        
        let correctColor = UIColor(red: 91.0 / 255, green: 201.0 / 255, blue: 139.0 / 255, alpha: 1.0)
        let incorrectColor = UIColor(red: 201.0 / 255, green: 91.0 / 255, blue: 104.0 / 255, alpha: 1.0)
        
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
    
    func calculatePoints(){
        
    }
    
    func calculateRank() {
        
    }
    
    func fillInTheBlankView(){
        
    }
    
    func multipleChoiceView(){
        
    }
    
}

