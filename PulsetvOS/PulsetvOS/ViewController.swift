//
//  ViewController.swift
//  PulsetvOS
//
//  Created by Max Marze on 11/7/15.
//  Copyright © 2015 pulse. All rights reserved.
//

import UIKit
import Charts
import Bolts
import Parse

class ViewController: UIViewController {

    @IBOutlet var questionView: UIView!
    @IBOutlet var statsView: UIView!
    
//    @IBOutlet var questionText: UITextView!
    @IBOutlet var questionText: UITextView!
    
    @IBOutlet var rankOneName: UILabel!
    @IBOutlet var rankOneScore: UILabel!
    @IBOutlet var rankTwoName: UILabel!
    @IBOutlet var rankTwoScore: UILabel!
    @IBOutlet var rankThreeName: UILabel!
    @IBOutlet var ranktThreeScore: UILabel!

    @IBOutlet var greenRankView: UIView!
    
    @IBOutlet var answerText: UILabel!
    var statsViewOriginalFrame = CGRectZero
    var swipeLeftCount = 0
    let model = Model.sharedInstance
    let correctColor = UIColor(red: 91.0 / 255, green: 201.0 / 255, blue: 139.0 / 255, alpha: 1.0)
    let incorrectColor = UIColor(red: 201.0 / 255, green: 91.0 / 255, blue: 104.0 / 255, alpha: 1.0)
    let regularColor = UIColor(red: 205.0 / 255, green: 205.0 / 255, blue: 205.0 / 255, alpha: 1.0)
    
    var pieChart = PieChartView()
    let barChart = BarChartView()
    
    override func viewDidLoad() {
        
        model.mainVC = self
        super.viewDidLoad()
//        model.prepareQuestions()
        let swipeLeftGesture = UISwipeGestureRecognizer(target: self, action: Selector("statsLeftSwipe:"))
        swipeLeftGesture.direction = .Left
        self.view.addGestureRecognizer(swipeLeftGesture)
        
        let swipeRightGesture = UISwipeGestureRecognizer(target: self, action: Selector("statsRightSwipe:"))
        swipeRightGesture.direction = .Right
        self.view.addGestureRecognizer(swipeRightGesture)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: Selector("tapHandler:"))
//        tapGesture.allowedPressTypes = [NSNumber(integer: UIPressType.PlayPause.rawValue)]
        self.view.addGestureRecognizer(tapGesture)
        
        let answerTapGesture = UITapGestureRecognizer(target: self, action: Selector("answerTapHandler:"))
        answerTapGesture.allowedPressTypes = [NSNumber(integer: UIPressType.PlayPause.rawValue)]
        self.view.addGestureRecognizer(answerTapGesture)
        
        statsView.hidden = true
        
        // Do any additional setup after loading the view, typically from a nib.
        
        statsViewOriginalFrame = statsView.frame
        
        answerText.clipsToBounds = true
        answerText.layer.cornerRadius = 60.0
        answerText.backgroundColor = correctColor
        greenRankView.backgroundColor = correctColor
    }

    func changeQuestion() {
        if let question = model.getFirstUnansweredQuestion() {
            questionText.text = question.text
            resizeTextView(questionText, newRect: nil)
        }
        
        answerText.hidden = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func resizeTextView(textView : UITextView, newRect : CGRect?) {
        if let newFrame = newRect {
            textView.frame = newFrame
        }
//        textView.frame = CGRect(x: self.questionText.frame.origin.x, y: self.questionText.frame.origin.y, width: self.view.frame.width - statsViewOriginalFrame.width, height: questionText.frame.height)
        if (textView.text.isEmpty || CGSizeEqualToSize(textView.bounds.size, CGSizeZero)) {
            return;
        }
        
        let textViewSize = textView.frame.size;
        let fixedWidth = textViewSize.width;
        let expectSize = textView.sizeThatFits(CGSizeMake(fixedWidth, CGFloat(MAXFLOAT)));
        
        var expectFont = textView.font;
        if (expectSize.height > textViewSize.height) {
            while (textView.sizeThatFits(CGSizeMake(fixedWidth, CGFloat(MAXFLOAT))).height > textViewSize.height) {
                expectFont = textView.font!.fontWithSize(textView.font!.pointSize - 1)
                textView.font = expectFont
            }
        }
        else {
            while (textView.sizeThatFits(CGSizeMake(fixedWidth, CGFloat(MAXFLOAT))).height < textViewSize.height) {
                expectFont = textView.font;
                textView.font = textView.font!.fontWithSize(textView.font!.pointSize + 1)
            }
            textView.font = expectFont;
        }

    }
    
    func tapHandler(recognizer : UITapGestureRecognizer) {
        model.completeCurrentQuestion()
        model.incrementCurrentQuestion()
        changeQuestion()
    }
    
    func answerTapHandler(recognizer : UITapGestureRecognizer) {
        if let question = model.getCurrentQuestion() {
            model.endSubmission()
            answerText.hidden = false
            answerText.text = question.answers[0]
//            answerText.font = answerText.font!.fontWithSize(questionText.font!.pointSize)
            answerText.sizeToFit()
            model.getTopStudentsFromCloud()
//            resizeTextView(answerText, newRect: nil)
        }
    }
    
    func showRank() {
        let rankings = model.getTopStudents()
        rankOneName.text = rankings[0].name
        rankOneScore.text = String(rankings[0].score)
        rankOneScore.sizeToFit()
        rankOneName.sizeToFit()
        
        rankTwoName.text = rankings[1].name
        rankTwoScore.text = String(rankings[1].score)
        rankTwoScore.sizeToFit()
        rankTwoName.sizeToFit()
        
        rankThreeName.text = rankings[2].name
        ranktThreeScore.text = String(rankings[2].score)
        ranktThreeScore.sizeToFit()
        rankThreeName.sizeToFit()
    }
    
    func showChartForCurrentQuestion() {
        
        let scoresOpt = model.getQuestionScores()
        let scores = scoresOpt!
        
        let chartFrame = CGRect(x: 175.0, y: 0.0, width: statsView.frame.width / 2, height: statsView.frame.height / 2)
//        pieChart.removeFromSuperview()
//        pieChart.delete(pieChart)
        pieChart = PieChartView()
        
        var chartDataSetEntries = [ChartDataEntry]()
        chartDataSetEntries.append(ChartDataEntry(value: Double(scores.correct), xIndex: 0))
        chartDataSetEntries.append(ChartDataEntry(value: Double(scores.incorrect), xIndex: 1))
        let chartDataSet = PieChartDataSet(yVals: chartDataSetEntries, label: "")
        
        chartDataSet.colors = ChartColorTemplates.liberty()
        
        chartDataSet.colors = [correctColor, incorrectColor]
        
        let chartData = PieChartData(xVals: ["✔", "✕"], dataSet: chartDataSet)
        pieChart.holeColor = UIColor(red:0.80, green:0.80, blue:0.80, alpha:1.0)
        pieChart.descriptionText = ""
        pieChart.legend.enabled = false
        pieChart.data = chartData
        pieChart.usePercentValuesEnabled = true

        statsView.addSubview(pieChart)
        
        pieChart.frame = chartFrame
    }
    
    func showBarGraph() {
        let results = model.getAnswerChoiceResults()
        if results.1 == .MultipleChoice {
            barChart.hidden = false
            let answers = results.0
            let chartFrame = CGRect(x: 175.0 * 4.0, y: 100.0, width: statsView.frame.height / 2, height: statsView.frame.width / 2)
            
            var barDataSetEntries = [ChartDataEntry]()
            var xVals = [String]()
            var i = 0
            for (key, content) in answers {
                let tempEntry = BarChartDataEntry(value: Double(content), xIndex: i)
                xVals.append(key)
                barDataSetEntries.append(tempEntry)
                i++
            }
            let dataSet = BarChartDataSet(yVals: barDataSetEntries)
            //        let dataSet = BarChartDataSet(yVals: barDataSetEntries, label: "")
            dataSet.colors = ChartColorTemplates.liberty()
            
            let chartData = BarChartData(xVals: xVals, dataSets: [dataSet])
            barChart.descriptionText = ""
            barChart.legend.enabled = false
            barChart.data = chartData
            statsView.addSubview(barChart)
            
            barChart.frame = chartFrame
        } else {
            barChart.hidden = true
        }
        
    }
    
    func statsLeftSwipe(recognizer : UISwipeGestureRecognizer) {
        if(statsView.hidden && swipeLeftCount == 0) {
            print("SwipeLeft")
            
            let originalViewRect = statsViewOriginalFrame
            
            statsView.frame.origin = CGPoint(x: self.view.frame.width, y: 0.0)
            
            let questionTransitionRect = CGRect(x: 0.0, y: 0.0, width: self.view.frame.width - originalViewRect.width, height: questionView.frame.height)
            
            let questionTextTransitionRect = CGRect(x: self.questionText.frame.origin.x, y: self.questionText.frame.origin.y, width: self.view.frame.width - originalViewRect.width - 50, height: questionText.frame.height)
            
//            let newXForAnswer = self.view.frame.width - (self.view.frame.width - originalViewRect.width - 50)
            
//            let answerLabelTransitionRect = CGRect(x: newXForAnswer, y: answerText.frame.origin.y, width: self.answerText.frame.width, height: self.answerText.frame.height)
            
            print("Transition width: \(questionTextTransitionRect.width), original: \(questionText.frame.width)")
            UIView.animateWithDuration(1.1, animations: { () -> Void in
                self.statsView.hidden = false
                self.statsView.frame = originalViewRect
                self.questionView.frame = questionTransitionRect
//                self.questionText.bounds = questionTextTransitionRect
//                self.questionText.frame = questionTextTransitionRect
                
//                self.questionText.
                
                }, completion: { (completed) -> Void in
                    UIView.animateWithDuration(1.1, animations: { () -> Void in
                        self.resizeTextView(self.questionText, newRect: questionTextTransitionRect)
                        let newXForAnswer = (self.questionText.frame.width / 2.0) + 20.0
                        self.answerText.frame = CGRect(x: newXForAnswer, y: self.answerText.frame.origin.y, width: self.answerText.frame.width, height: self.answerText.frame.height)
                    });
                    print("original: \(self.questionText.frame.width)")
                    self.swipeLeftCount++
            })
            
        } else if(!statsView.hidden && swipeLeftCount == 1) {
            let transitionRect = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
            
            UIView.animateWithDuration(1.1, animations: { () -> Void in
                self.statsView.frame = transitionRect
                }, completion: { (completed) -> Void in
                    self.view.bringSubviewToFront(self.statsView)
                    self.statsView.frame = transitionRect
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
            let questionTextTransitionRect = CGRect(x: self.questionText.frame.origin.x, y: self.questionText.frame.origin.y, width: self.view.frame.width - originalRect.width - 50, height: questionText.frame.height)
            
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
                    } else {
                        self.resizeTextView(self.questionText, newRect: questionTextTransitionRect)
                        let newXForAnswer = (self.questionText.frame.width / 2.0) + 20.0
                        self.answerText.frame = CGRect(x: newXForAnswer, y: self.answerText.frame.origin.y, width: self.answerText.frame.width, height: self.answerText.frame.height)
//                        UIView.animateWithDuration(1.1, animations: { () -> Void in
//                            self.resizeTextView(self.questionText, newRect: questionTextTransitionRect)
//                            let newXForAnswer = (self.questionText.frame.width / 2.0) + 20.0
//                            self.answerText.frame = CGRect(x: newXForAnswer, y: self.answerText.frame.origin.y, width: self.answerText.frame.width, height: self.answerText.frame.height)
//                        });
                    }
                    self.swipeLeftCount--
                    self.statsView.frame = originalRect
            }
        }
        
    }

}

