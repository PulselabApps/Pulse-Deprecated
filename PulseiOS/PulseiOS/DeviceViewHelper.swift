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

}
