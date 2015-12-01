//
//  iPhoneScoresViewController.swift
//  PulseiOS
//
//  Created by Varun D Patel on 11/30/15.
//  Copyright © 2015 pulse. All rights reserved.
//

import UIKit
import Charts
import Parse

class iPhoneScoresViewController: UIViewController {

    @IBOutlet weak var progressPieChart: PieChartView!
    let user = User.sharedInstance.user
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /** PIE CHART SETUP : ************************************/
        progressPieChart.legend.enabled = false
        progressPieChart.usePercentValuesEnabled = true
        progressPieChart.holeColor = ColorConstants.BlueAppColor
        progressPieChart.sizeToFit()
        progressPieChart.centerTextRadiusPercent = 75.0
        progressPieChart.descriptionText = ""
        /*********************************************************/
        let correctAnswers = user!["questionsCorrect"] as! Double
        let incorrectAnswers = user!["questionsIncorrect"] as! Double
        DeviceViewHelper.drawPieChart(correctAnswers, incorrect: incorrectAnswers, isInitialLoad: true, progressPieChart: progressPieChart)
    }
    
    
}
