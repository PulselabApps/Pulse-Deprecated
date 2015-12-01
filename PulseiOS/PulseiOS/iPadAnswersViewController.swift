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
    
    @IBOutlet weak var answerView: UIView!
    @IBOutlet weak var progressPieChart: PieChartView!
    
    var questionsCorrect = 0
    var questionsAsked = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /** PIE CHART SETUP : ************************************/
        progressPieChart.legend.enabled = false
        progressPieChart.usePercentValuesEnabled = true
        progressPieChart.holeColor = ColorConstants.OrangeAppColor
        progressPieChart.sizeToFit()
        progressPieChart.centerTextRadiusPercent = 75.0
        progressPieChart.descriptionText = ""
        /*********************************************************/
        
        rank.text = String(studentRank)
        points.text = String(studentPoints)
        
        let correctAnswers = userData.user!["questionsCorrect"] as! Double
        let incorrectAnswers = userData.user!["questionsIncorrect"] as! Double
        DeviceViewHelper.drawPieChart(correctAnswers, incorrect: incorrectAnswers, isInitialLoad: true, progressPieChart: progressPieChart)
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
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        switch segue.identifier! {
        case "FullQuestionSegue":
            let fullQuestionVC = segue.destinationViewController as! FullQuestionViewController
            fullQuestionVC.fullQuestion = questions[currentQuestion!].text            
        default:
            break
        }
    }
    
    @IBAction func submitButtonSelected(sender: UIButton) {
        self.points.text = String(userData.points)
        DeviceViewHelper.setRankLabel(self.rank)
        let correctAnswers = userData.user!["questionsCorrect"] as! Double
        let incorrectAnswers = userData.user!["questionsIncorrect"] as! Double
        DeviceViewHelper.drawPieChart(correctAnswers, incorrect: incorrectAnswers, isInitialLoad: false, progressPieChart: progressPieChart)
    }
    
}

