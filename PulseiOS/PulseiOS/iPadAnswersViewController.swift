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
    
    @IBOutlet weak var progressPieChart: PieChartView!
    @IBOutlet weak var rank: UILabel!
    @IBOutlet weak var points: UILabel!
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
        
        rank.text = String(studentRank)
        points.text = String(studentPoints)
        
        drawPieChart(1.0, incorrect: 0.0, isInitialLoad: true)
    }
    
    @IBAction func answerTextBoxType(sender: UITextField) {
        submitButton.enabled = true
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
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        switch segue.identifier! {
        case "FullQuestionSegue":
            let fullQuestionVC = segue.destinationViewController as! FullQuestionViewController
            fullQuestionVC.fullQuestion = questions[currentQuestion!].text
//            fullQuestionVC.fullQuestion = questions[currentQuestion!]["questionText"]!! as? String
            
        default:
            break
        }
    }
    
    @IBAction func submitButtonSelected(sender: UIButton) {
        self.points.text = String(self.user!["score"] as! Int)
        self.rank.text = String(studentRank)
        let correctAnswers = user!["questionsCorrect"] as! Double
        let incorrectAnswers = user!["questionsIncorrect"] as! Double
        drawPieChart(correctAnswers, incorrect: incorrectAnswers, isInitialLoad: false)
    }
    
}

