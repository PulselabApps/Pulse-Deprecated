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
    
    static let userData = User.sharedInstance
    
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
        } else if (grade < 70.0) {
            letterGrade = "D"
        } else if (grade < 80.0) {
            letterGrade =  "C"
        } else if (grade < 90.0) {
            letterGrade =  "B"
        } else {
            letterGrade = "A"
        }
        return letterGrade
    }
    
    static func setRankLabel(rankLabel: UILabel, offset: String) {
        let qos = Int(QOS_CLASS_USER_INITIATED.rawValue)
        dispatch_async(dispatch_get_global_queue(qos, 0)) { () -> Void in
            var rank = 1
            var scores = [Int]()
            let query = PFQuery(className: "Class")
            query.whereKey("name", equalTo: "Math")
            query.findObjectsInBackgroundWithBlock {
                (objects: [PFObject]?, error: NSError?) -> Void in
                if error == nil {
                    let currentClass = objects![0]
                    let relationalQuery : PFQuery? = currentClass.relationForKey("students").query()
                    relationalQuery?.whereKeyExists(UserKey.Score)
                    relationalQuery?.findObjectsInBackgroundWithBlock({ (object: [PFObject]?, errors: NSError?) -> Void in
                        if errors == nil {
                            for obj in object!{
                                let student = obj
                                let score = student.valueForKey(UserKey.Score) as? Int
                                scores.append(score!)
                            }
                            scores.sortInPlace({ $0 > $1 })
                            for score in scores {
                                if score == User.sharedInstance.user![UserKey.Score] as? Int {
                                    break
                                }
                                rank++
                            }
                            if (userData.currentRank != rank) {
                                userData.currentRank = rank
                                userData.reloadiPhoneScoresTable = true
                            dispatch_async(dispatch_get_main_queue()) { () -> Void in
                                let rankLabelText = rankLabel.text!
                                if rankLabelText != (offset + String(rank)) {
                                    rankLabel.text = offset + String(rank)
                                }
                            }
                            }
                        }
                    })
                }
            }
        }
    }
    
    static func calculateScore(isCorrectAnswer: Bool, offsetValue: Int, currentQuestion: Question) {
        let correctOrIncorrect = isCorrectAnswer ? UserKey.QuestionsCorrect : UserKey.QuestionsIncorrect
        var score = userData.user![UserKey.Score] as? Int
        score! += offsetValue
        userData.user![UserKey.Score] = score
        
        var questionStats = userData.user![correctOrIncorrect] as? Int
        questionStats!+=1
        userData.user![correctOrIncorrect] = questionStats
        
        isCorrectAnswer ? currentQuestion.numCorrectAnswers++ : currentQuestion.numIncorrectAnswers++
        saveUser()
    }
    
    static func saveUser(){
        userData.user!.saveInBackgroundWithBlock {
            (success: Bool, error: NSError?) -> Void in
            
            if (success) {
                print("user saved")
            } else {
                print(error?.description)
            }
        }
    }
}
