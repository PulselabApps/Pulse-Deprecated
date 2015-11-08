//
//  Model.swift
//  PulsetvOS
//
//  Created by Max Marze on 11/7/15.
//  Copyright © 2015 pulse. All rights reserved.
//

import Foundation
import Bolts
import Parse
import Alamofire

class Model {
    
    static let sharedInstance = Model()
    
    enum QuestionType {
        case MultipleChoice
        case FillInTheBlank
    }
    
    struct QuestionEntry {
        let question : Question
        var completed = false
    }
    
    class Question {
        let text : String
        let timeLimit : Int
        let questionType : QuestionType
        let answers : [String]
        
        init(text : String, timeLimit : Int, type : QuestionType, answers : [String]) {
            self.text = text
            self.timeLimit = timeLimit
            self.questionType = type
            self.answers = answers
        }
    }
    
    private let className = "Math"
    private var questions = [QuestionEntry]()
    private let bodyRequest = ""
    private var currentQuestionEntry : Int?
    
    var mainVC : ViewController?
    
    private init() {
        //        PFUser.login
        let headers = [
            "X-Parse-Application-Id": "AR6NF8FvJQFx0zurn9snBroZi2S68SCRBIRMudo7",
            "X-Parse-REST-API-Key": "ajmBURZkjuoxSKavw1xZnKpGFMypVP5j3JNVFks8",
            "Content-Type": "application/json"
        ]
        
        Alamofire.request(.POST, "https://api.parse.com/1/functions/questions", headers: headers)
            .responseJSON { response in
                print(response.result.value!)
                if let resultJson = response.result.value?.valueForKey("result") {
                    if let questionsRaw = resultJson.valueForKey("questions") {
                        let questionsArray = questionsRaw[0] as! [AnyObject]
                        for question in questionsArray {
                            print(question.valueForKey("questionText"))
                            let text = question.valueForKey("questionText") as! String
                            let timeLimitOpt = question.valueForKey("questionTime") as? Int
                            let questionType = question.valueForKey("questionType") as! String
                            let answers = question.valueForKey("answers") as! [String]
                            
                            let timeLimit = timeLimitOpt == nil ? -1 : timeLimitOpt!
                            let type : QuestionType = questionType == "MultipleChoice" ? QuestionType.MultipleChoice : QuestionType.FillInTheBlank
                            self.questions.append(QuestionEntry(question: Question(text: text, timeLimit: timeLimit, type: type, answers: answers), completed: false))

                        }
                        print("Finished Initalizing Questions")
                        self.currentQuestionEntry = 0
                        if let mainVCU = self.mainVC {
                            mainVCU.changeQuestion()
                        }
                    }
                }
//                debugPrint(response)
        }
//        curl -X POST \
//        -H "X-Parse-Application-Id: AR6NF8FvJQFx0zurn9snBroZi2S68SCRBIRMudo7" \
//        -H "X-Parse-REST-API-Key: ajmBURZkjuoxSKavw1xZnKpGFMypVP5j3JNVFks8" \
//        -H "Content-Type: application/json" \
//        -d '{}' \
//        https://api.parse.com/1/functions/questions
        
        // Get latest Session
    }
    
    func getFirstUnansweredQuestion() -> Question? {
        if let _ = currentQuestionEntry {
            if !(questions[currentQuestionEntry!].completed) {
                return questions[currentQuestionEntry!].question
            }
        }
        var firstNew = -1
        for (index, _) in questions.enumerate() {
            if !questions[index].completed {
                if firstNew == -1 {
                    firstNew = index
                    currentQuestionEntry = index
                    return questions[index].question
                }
            }
        }
        return nil
//        if result.count > 0 {
//            currentQuestionEntry = questions.indexOf()
//            return result[0].question
//        } else {
//            return nil
//        }
//        return (result.count > 0 ? result[0].question : nil)
    }
    
    func completeCurrentQuestion() -> Bool {
        if let _ = currentQuestionEntry {
            questions[currentQuestionEntry!].completed = true
            return true
        } else {
            return false
        }
    }
}