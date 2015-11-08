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
    
//    @IBOutlet var answerText: UITextView!
    
    @IBOutlet var answerText: UILabel!
    var statsViewOriginalFrame = CGRectZero
    var swipeLeftCount = 0
    let model = Model.sharedInstance
    
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
        
        answerText.clipsToBounds = true
        answerText.layer.cornerRadius = 60.0
        
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
        model.incrementCurrentQuestionInCloud()
        changeQuestion()
    }
    
    func answerTapHandler(recognizer : UITapGestureRecognizer) {
        if let question = model.getFirstUnansweredQuestion() {
            model.endSubmissionInCloud()
            answerText.hidden = false
            answerText.text = question.answers[0]
//            answerText.font = answerText.font!.fontWithSize(questionText.font!.pointSize)
            answerText.sizeToFit()
//            resizeTextView(answerText, newRect: nil)
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
                        UIView.animateWithDuration(1.1, animations: { () -> Void in
                            self.resizeTextView(self.questionText, newRect: questionTextTransitionRect)
                            let newXForAnswer = (self.questionText.frame.width / 2.0) + 20.0
                            self.answerText.frame = CGRect(x: newXForAnswer, y: self.answerText.frame.origin.y, width: self.answerText.frame.width, height: self.answerText.frame.height)
                        });
                    }
                    self.swipeLeftCount--
                    self.statsView.frame = originalRect
            }
        }
        
    }

}

