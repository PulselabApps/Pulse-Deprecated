//
//  AppDelegate.swift
//  PulsetvOS
//
//  Created by Max Marze on 11/7/15.
//  Copyright © 2015 pulse. All rights reserved.
//

import UIKit
import Bolts
import Parse

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
//        Parse.enableLocalDatastore()
        // Initialize Parse.
        
        Parse.setApplicationId("AR6NF8FvJQFx0zurn9snBroZi2S68SCRBIRMudo7",
            clientKey: "bM55tcvcIPaclkqWIwkhcLg2x15IWUHr6MapZudk")
        
        // [Optional] Track statistics around application opens.
        PFAnalytics.trackAppOpenedWithLaunchOptions(launchOptions)
        PFUser.registerSubclass()
        Question.registerSubclass()
        PulseClass.registerSubclass()
        ClassSession_Beta.registerSubclass()

        PFUser.logInWithUsernameInBackground("aakash", password:"isAPussy") {
            (user: PFUser?, error: NSError?) -> Void in
            if user != nil {
//                let newQuestion = Question()
//                newQuestion.questionType = Model.QuestionType.MultipleChoice.rawValue
//                newQuestion.text = "John has 10 apples and Jill has 2 apples. If John gives Jill 5 apples, how many apples does John have?"
//                newQuestion.answers = ["5", "2", "10", "4"]
//                newQuestion.answerBreakdown = [ "5": 0, "2": 0, "10": 0, "4": 0]
//                newQuestion.numCorrectAnswers = 0
//                newQuestion.numIncorrectAnswers = 0
//                newQuestion.saveInBackgroundWithBlock({ (success, error) -> Void in
//                    if error == nil && success {
//                        let newQuestion2 = Question()
//                        newQuestion2.questionType = 1
//                        newQuestion2.text = "A horse is a ___, of course"
//                        newQuestion2.answers = ["horse"]
//                        newQuestion2.numIncorrectAnswers = 0
//                        newQuestion2.numCorrectAnswers = 0
//                        newQuestion2.saveInBackgroundWithBlock({ (success, error) -> Void in
//                            if error == nil && success {
//                                let sessionQuery = ClassSession_Beta.query()!
//                                sessionQuery.getObjectInBackgroundWithId("udilE5VomO", block: { (object, error) -> Void in
//                                    if error == nil {
//                                        if let session = object as? ClassSession_Beta {
//                                            session.questions.addObject(newQuestion)
//                                            session.questions.addObject(newQuestion2)
//                                            session.saveInBackgroundWithBlock({ (success, error) -> Void in
//                                                if error == nil && success {
//                                                    print("New questions")
//                                                }
//                                            })
//                                        }
//                                    }
//                                })
//                            }
//                        })
//                    }
//                })
                // Do stuff after successful login.
                
//                let newTeacher = PFUser()
//                newTeacher.username = "English Teacher"
//                newTeacher.password = "aakashIsAPussy"
//                newTeacher.email = "englishTeacher@english.blah"
//                newTeacher.signUpInBackgroundWithBlock({ (success, error) -> Void in
//                    if error == nil && success {
//                        let teacherRole = PFRole(name: "Teacher", acl: PFACL())
//                        teacherRole.users.addObject(newTeacher)
//                        teacherRole.saveInBackground()
//                        let studentRole = PFRole(name: "Student", acl: PFACL())
//                        let newUser1 = PFUser()
//                        newUser1.username = "e_student_1"
//                        newUser1.password = "english"
//                        newUser1.email = "newuser1@english.blah"
//                        newUser1.signUpInBackgroundWithBlock({ (success, error) -> Void in
//                            if error == nil && success {
//                                let newUser2 = PFUser()
//                                newUser2.username = "e_student_2"
//                                newUser2.password = "english"
//                                newUser2.email = "newuser2@english.blah"
//                                newUser2.signUpInBackgroundWithBlock({ (success, error) -> Void in
//                                    if error == nil && success {
//                                        let newUser3 = PFUser()
//                                        newUser3.username = "e_student_3"
//                                        newUser3.password = "english"
//                                        newUser3.email = "newuser3@english.blah"
//                                        newUser3.signUpInBackgroundWithBlock({ (success, error) -> Void in
//                                            if error == nil && success {
//                                                studentRole.users.addObject(newUser1)
//                                                studentRole.users.addObject(newUser2)
//                                                studentRole.users.addObject(newUser3)
//                                                studentRole.saveInBackground()
//                                                let EnglishClass = PulseClass()
//                                                EnglishClass.name = "English 1"
//                                                EnglishClass.teacher.addObject(newTeacher)
//                                                EnglishClass.students.addObject(newUser1)
//                                                EnglishClass.students.addObject(newUser2)
//                                                EnglishClass.students.addObject(newUser3)
//                                                EnglishClass.saveInBackgroundWithBlock({ (success, error) -> Void in
//                                                    if error == nil && success {
//                                                        print("New Class")                                                    }
//                                                })
//                                            }
//                                        })
//                                    }
//                                })
//                            }
//                        })
//                    }
//                })
                
                
                
                Model.sharedInstance.setLoggedIn(true)
            } else {
                // The login failed. Check error to see why.
                print("Login failed")
            }
        }
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

