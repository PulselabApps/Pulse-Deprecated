//
//  ViewController.swift
//  PulsetvOS
//
//  Created by Max Marze on 11/7/15.
//  Copyright © 2015 pulse. All rights reserved.
//

import UIKit
import Charts

class ViewController: UIViewController {

    @IBOutlet var questionView: UIView!
    @IBOutlet var statsView: UIView!
    
    var statsViewOriginalFrame = CGRectZero
    var swipeLeftCount = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let swipeLeftGesture = UISwipeGestureRecognizer(target: self, action: Selector("statsLeftSwipe:"))
        swipeLeftGesture.direction = .Left
        self.view.addGestureRecognizer(swipeLeftGesture)
        
        let swipeRightGesture = UISwipeGestureRecognizer(target: self, action: Selector("statsRightSwipe:"))
        swipeRightGesture.direction = .Right
        self.view.addGestureRecognizer(swipeRightGesture)
        
        statsView.hidden = true
        
        let chartFrame = CGRect(x: 0.0, y: 0.0, width: statsView.frame.width / 2, height: statsView.frame.height / 2)
        
        let pieChart = PieChartView()

        var chartDataSetEntries = [ChartDataEntry]()
        chartDataSetEntries.append(ChartDataEntry(value: 20, xIndex: 0))
        chartDataSetEntries.append(ChartDataEntry(value: 40, xIndex: 1))
        chartDataSetEntries.append(ChartDataEntry(value: 10, xIndex: 2))
        chartDataSetEntries.append(ChartDataEntry(value: 30, xIndex: 3))
        let chartDataSet = PieChartDataSet(yVals: chartDataSetEntries)
        
        var chartDataColors = [[UIColor]]()
        chartDataColors.append(ChartColorTemplates.vordiplom())
        chartDataColors.append(ChartColorTemplates.joyful())
        chartDataColors.append(ChartColorTemplates.liberty())
        chartDataColors.append(ChartColorTemplates.colorful())
        
        chartDataSet.colors = ChartColorTemplates.vordiplom()
        
        let chartData = PieChartData(xVals: ["One", "Two", "Three", "Four"], dataSet: chartDataSet)
        
        pieChart.data = chartData
        statsView.addSubview(pieChart)
        
        pieChart.frame = chartFrame
        // Do any additional setup after loading the view, typically from a nib.
        
        statsViewOriginalFrame = statsView.frame
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func statsLeftSwipe(recognizer : UISwipeGestureRecognizer) {
        if(statsView.hidden && swipeLeftCount == 0) {
            print("SwipeLeft")
            
            let originalViewRect = statsViewOriginalFrame
            
            statsView.frame.origin = CGPoint(x: self.view.frame.width, y: 0.0)
            
            let questionTransitionRect = CGRect(x: 0.0, y: 0.0, width: self.view.frame.width - originalViewRect.width, height: questionView.frame.height)
            
            UIView.animateWithDuration(1.1, animations: { () -> Void in
                self.statsView.hidden = false
                self.statsView.frame = originalViewRect
                self.questionView.frame = questionTransitionRect
                }, completion: { (completed) -> Void in
                    self.swipeLeftCount++
            })
            
        } else if(!statsView.hidden && swipeLeftCount == 1) {
            let transitionRect = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
            
            UIView.animateWithDuration(1.1, animations: { () -> Void in
                self.statsView.frame = transitionRect
                }, completion: { (completed) -> Void in
                    self.questionView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.questionView.frame.height)
                    self.swipeLeftCount++
            })
        }
    }
    
    func statsRightSwipe(recognizer : UISwipeGestureRecognizer) {
        if(!statsView.hidden) {
            print("SwipeRight")
            
            var transitionRect = statsView.frame
            if(self.swipeLeftCount > 1) {
                transitionRect = statsViewOriginalFrame
            } else {
                transitionRect.origin = CGPoint(x: self.view.frame.width, y: 0.0)
            }
            
            let originalRect = statsViewOriginalFrame
            let questionTransitionRect = CGRect(x: 0.0, y: 0.0, width: self.view.frame.width - originalRect.width, height: questionView.frame.height)
            
            UIView.animateWithDuration(1.1, animations: { () -> Void in
                self.statsView.frame = transitionRect
                if(self.swipeLeftCount == 2) {
                    self.questionView.frame = questionTransitionRect
                } else {
                    self.questionView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.questionView.frame.height)
                }
                }) { (completed) -> Void in
                    if(self.swipeLeftCount == 1) {
                        self.statsView.hidden = true
                    }
                    self.swipeLeftCount--
                    self.statsView.frame = originalRect
            }
        }
        
    }

}

