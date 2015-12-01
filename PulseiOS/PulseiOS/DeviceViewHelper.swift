//
//  DeviceViewHelper.swift
//  PulseiOS
//
//  Created by Varun D Patel on 11/30/15.
//  Copyright © 2015 pulse. All rights reserved.
//

import UIKit
import Foundation
import Charts
import Parse

class DeviceViewHelper {
        
    static func drawPieChart(var correct: Double, incorrect: Double, isInitialLoad: Bool, progressPieChart: PieChartView) {
        var chartDataSetEntries = [ChartDataEntry]()
        
        chartDataSetEntries.append(ChartDataEntry(value: correct, xIndex: 0))
        chartDataSetEntries.append(ChartDataEntry(value: incorrect, xIndex: 1))
        
        let chartDataSet = PieChartDataSet(yVals: chartDataSetEntries, label: "")
        chartDataSet.colors = [ColorConstants.GreenCorrectColor, ColorConstants.RedIncorrectColor]
        
        let chartData = PieChartData(xVals: ["✔", "✕"], dataSet: chartDataSet)
        progressPieChart.data = chartData
        
        if (isInitialLoad) {
            if (correct == 0 && incorrect == 0){
                correct = 1
            }
        }
        progressPieChart.centerText =  !isInitialLoad ? getGrade(100 * (correct / (correct + incorrect))) : "A"
    }
    
    static func getGrade(grade: Double) -> String {
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
    
    static func setRankLabel(rankLabel: UILabel, offset: String) {
        var rank = 1
        var scores = [Int]()
        let rankLabelText = rankLabel.text
        let query = PFQuery(className: "Class")
        query.whereKey("name", equalTo: "Math")
        query.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
                let currentClass = objects![0]
                let relationalQuery : PFQuery? = currentClass.relationForKey("students").query()
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
                            if score == User.sharedInstance.user!["score"] as? Int {
                                break
                            }
                            rank++
                        }
                        if rankLabelText != (offset + String(rank)) {
                            rankLabel.text = offset + String(rank)
                        }
                    }
                })
            }
        }
    }

}
