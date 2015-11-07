//
//  ViewController.swift
//  PulseiOS
//
//  Created by Max Marze on 11/7/15.
//  Copyright © 2015 pulse. All rights reserved.
//

import UIKit
import Charts

class ViewController: UIViewController {

    @IBOutlet weak var progressPieChart: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let pieChart = PieChartView()
        let correct = 40.0
        let incorrect = 20.0
        
        drawPieChart(correct, incorrect: incorrect, pieChart: pieChart)
        
    }
    
    
    func drawPieChart(correct: Double, incorrect: Double, pieChart: PieChartView) {
        var chartDataSetEntries = [ChartDataEntry]()
        chartDataSetEntries.append(ChartDataEntry(value: correct, xIndex: 0))
        chartDataSetEntries.append(ChartDataEntry(value: incorrect, xIndex: 1))
        
        let chartDataSet = PieChartDataSet(yVals: chartDataSetEntries, label: "")
        
        
        chartDataSet.colors = ChartColorTemplates.liberty()
        chartDataSet.colors = [UIColor(), UIColor.magentaColor()]
        // chartDataSet.colorAt(0) = UIColor.redColor()
        
        
        let chartData = PieChartData(xVals: ["✔", "✕"], dataSet: chartDataSet)
        pieChart.data = chartData
        pieChart.setDescriptionTextPosition(x: 0, y: 0)
        pieChart.sizeToFit()
        // pieChart.setDrawSliceText(false)
        pieChart.usePercentValuesEnabled = true
        
        pieChart.frame = CGRect(x: -40.0, y: -40.0, width: progressPieChart.frame.width * 2.0, height: progressPieChart.frame.height * 2.0)
        // pieChart.center = progressPieChart.center
        progressPieChart.addSubview(pieChart)
    }

}

