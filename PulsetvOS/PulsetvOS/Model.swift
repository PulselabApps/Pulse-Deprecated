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
    
    private var userIsLoggedIn : Bool = false {
        didSet {
            initializeAfterLogin()
        }
    }
    
    enum QuestionType : Int {
        case MultipleChoice
        case FillInTheBlank
    }
    
    struct UserRankEntry {
        let name : String
        let score : Int
    }
    
    struct QuestionEntry {
        let question : Question
        var completed = false
    }
    
    class QuestionOld {
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
    
    struct QuestionScores {
        var correct : Int
        var id : Int
        var incorrect : Int
    }
    
    private let className = "Math"
    private var questions = [QuestionEntry]()
    private var userRankings = [UserRankEntry]()
    private var questionScores = [QuestionScores]()
    private let bodyRequest = ""
    
    private var currentAnswerDistribution = [String : Int]()
    private var currentQuestionEntry : Int?
    private let headers = [
        "X-Parse-Application-Id": "AR6NF8FvJQFx0zurn9snBroZi2S68SCRBIRMudo7",
        "X-Parse-REST-API-Key": "ajmBURZkjuoxSKavw1xZnKpGFMypVP5j3JNVFks8",
        "Content-Type": "application/json"
    ]
    
    private var currentSession : ClassSession_Beta?

    var mainVC : ViewController?
    
    private init() {
        //        Alamofire.request(.POST, "https://api.parse.com/1/functions/questions", headers: headers)
//            .responseJSON { response in
//                print(response.result.value!)
//                if let resultJson = response.result.value?.valueForKey("result") {
//                    if let questionsRaw = resultJson.valueForKey("questions") {
//                        let questionsArray = questionsRaw[0] as! [AnyObject]
//                        for question in questionsArray {
//                            let text = question.valueForKey("questionText") as! String
//                            let timeLimitOpt = question.valueForKey("questionTime") as? Int
//                            let questionType = question.valueForKey("questionType") as! String
//                            let answers = question.valueForKey("answers") as! [String]
//                            
//                            let timeLimit = timeLimitOpt == nil ? -1 : timeLimitOpt!
//                            let type : QuestionType = questionType == "MultipleChoice" ? QuestionType.MultipleChoice : QuestionType.FillInTheBlank
//                            self.questions.append(QuestionEntry(question: Question(text: text, timeLimit: timeLimit, type: type, answers: answers), completed: false))
//
//                        }
//                        print("Finished Initalizing Questions")
//                        if let currentQuestion = resultJson.valueForKey("currentQuestion"){
//                            self.currentQuestionEntry = currentQuestion[0] as? Int
//                        } else {
//                            self.currentQuestionEntry = 0
//                        }
//                        self.initQuestionAnswers()
//                        if let mainVCU = self.mainVC {
//                            mainVCU.changeQuestion()
//                        }
//                    }
//                }
//        }
    }
    
    func initializeAfterLogin() {
        let sessionQuery = ClassSession_Beta.query()!
        sessionQuery.getObjectInBackgroundWithId("udilE5VomO", block: { (object, error) -> Void in
            if error == nil {
                if let session = object as? ClassSession_Beta {
                    self.currentQuestionEntry = session.currentQuestion
                    self.currentSession = session
                    let classQuery = session.classIn.query()
                    let questionQuery = session.questions.query()
                    classQuery.getFirstObjectInBackgroundWithBlock({ (currentClass, error) -> Void in
                        if error == nil {
                            if let cClass = currentClass as? PulseClass {
                                print(cClass.name)
                            }
                        }
                    })
                    questionQuery.findObjectsInBackgroundWithBlock({ (objects, error) -> Void in
                        if error == nil {
                            if let questions = objects as? [Question] {
                                for question in questions {
                                    print(question.text)
                                    self.questions.append(QuestionEntry(question: question, completed: false))
                                    for (key, value) in question.answerBreakdown {
                                        print("Key \(key) and Value \(value)")
                                    }
                                }
                                if let mainVCU = self.mainVC {
                                    mainVCU.changeQuestion()
                                }
                                
                            }
                        }
                    })
                }
            }
        })
    }
    
    func setLoggedIn(isLoggedIn : Bool) {
        userIsLoggedIn = isLoggedIn
    }
    
    func getFirstUnansweredQuestion() -> Question? {
        
        if let _ = currentQuestionEntry {
            
//            if currentQuestionEntry! >= 2 {
//                for (index, _) in questions.enumerate() {
//                    questions[index].completed = false
//                }
//                currentQuestionEntry = 0
//            }
            
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
    }
    
    func getCurrentQuestion() -> Question? {
        if let x = currentQuestionEntry {
            return questions[x].question
        }
        
        return nil
    }
    
    func completeCurrentQuestion() -> Bool {
        if let _ = currentQuestionEntry {
            questions[currentQuestionEntry!].completed = true
            return true
        } else {
            return false
        }
    }
    
    func incrementCurrentQuestion() {
        if let session = currentSession {
            session.currentQuestion++
            session.saveInBackgroundWithBlock({ (completed, error) -> Void in
                if error == nil {
                    print("Saved session")
                }
            })
        }
//        Alamofire.request(.POST, "https://api.parse.com/1/functions/changeCurrentQuestion", headers: headers)
//            .responseJSON { response in
//                print("change question")
//                self.initQuestionAnswers()
//        }
    }
    
    func endSubmission() {
        if let session = currentSession {
            session.answerDisplayed = true
            session.saveInBackgroundWithBlock({ (completed, error) -> Void in
                if error == nil && completed {
                    print("Saved session")
                }
            })
        }
    }
    
    func getTopStudentsFromCloud() {
        userRankings.removeAll()
        Alamofire.request(.POST, "https://api.parse.com/1/functions/topStudents", headers: headers)
            .responseJSON { response in
                //                print(response.result.value!)
                if let resultJson = response.result.value?.valueForKey("result") {
                    if let results = resultJson as? [AnyObject] {
                        print("SCORES")
                        for result in results {
                            print(result.valueForKey("score") as! Int)
                            let name = result.valueForKey("username") as! String
                            let score = result.valueForKey("score") as! Int
                            self.userRankings.append(UserRankEntry(name: name, score: score))
                        }
                        
                        if !self.userRankings.isEmpty {
                            if let mainVCU = self.mainVC {
                                mainVCU.showRank()
                            }
                        }
                    }
                }
                if let mainVCU = self.mainVC {
                    mainVCU.showChartForCurrentQuestion()
                    mainVCU.showBarGraph()
                }
        }
    }
    
    func getTopStudents() -> [UserRankEntry] {
        return userRankings
    }
    
    func getQuestionScores() -> QuestionScores? {
        if let _ = currentQuestionEntry {
            let currentQuestion = getCurrentQuestion()
            if let question = currentQuestion {
                let scores = QuestionScores(correct: question.numCorrectAnswers, id: currentQuestionEntry!, incorrect: question.numIncorrectAnswers)
                return scores
            }
        }
        return nil
    }
    
    func getAnswerChoiceResults() -> ([String : Int], QuestionType) {
        let currentQuestion = questions[currentQuestionEntry!].question
        let currentType = currentQuestion.questionType
        let answerDistribution = currentQuestion.answerBreakdown
        return (answerDistribution, QuestionType(rawValue: currentType)!)
//        return (currentAnswerDistribution, questions[currentQuestionEntry!].question.questionType)
    }
}