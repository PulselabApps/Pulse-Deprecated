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
//        PulseClass.registerSubclass()
//        ClassSession_Beta.registerSubclass()
//        PFUser.logInWithUsernameInBackground("aakash", password: "isAPussy") { (user, error) -> Void in
//            let classSession = PFObject(className: "ClassSession_Beta")
//            let classQuery = PFQuery(className: "Class")
//            classQuery.getObjectInBackgroundWithId("jn7RQ7N39o", block: { (currentClass, error) -> Void in
//                if error == nil {
//                    let questionQuery = PFQuery(className: "Question")
//                    questionQuery.getObjectInBackgroundWithId("lL0MbYlKlM", block: { (question, error) -> Void in
//                        if error == nil {
//                            let questionRelation = classSession.relationForKey("questions")
//                            let classRelation = classSession.relationForKey("classIn")
//                            questionRelation.addObject(question!)
//                            classRelation.addObject(currentClass!)
//                            classSession.setValue(false, forKey: "answerDisplayed")
//                            classSession.setValue(0, forKey: "currentQuestion")
//                            classSession.saveInBackgroundWithBlock({ (completed, error) -> Void in
//                                if completed && error == nil {
//                                    print("Saved Session")
//                                } else {
//                                    print("fuck")
//                                }
//                            })
//                        }
//                    })
//                }
//            })
//        }

        PFUser.logInWithUsernameInBackground("aakash", password:"isAPussy") {
            (user: PFUser?, error: NSError?) -> Void in
            if user != nil {
                // Do stuff after successful login.
                let sessionQuery = PFQuery(className: "ClassSession_Beta")
                sessionQuery.getObjectInBackgroundWithId("udilE5VomO", block: { (object, error) -> Void in
                    if error == nil {
                        let classIn = object!.relationForKey("classIn")
                        classIn.query().getFirstObjectInBackgroundWithBlock({ (tempClass, error) -> Void in
                            if error == nil {
                                let name = tempClass!.objectForKey("name") as! String
                                print(name)
                            }
                        })
                        let questionsRelation = object!.relationForKey("questions")
                        questionsRelation.query().findObjectsInBackgroundWithBlock({ (objects, error) -> Void in
                            if error == nil {
                                for object in objects! {
                                    if let question = object as? Question {
                                        let text = question.text
                                        print(text)
                                    }
                                }
                            }
                        })
//                        let classIn = object!.objectForKey("classIn") as! PFObject
//                        let className = classIn.objectForKey("name") as! String
//                        let questions = object!.objectForKey("questions") as! [PFObject]
//                        for question in questions {
//                            let text = question.objectForKey("text") as! String
//                            print(text)
//                        }
//                        if let session = object as? ClassSession_Beta {
//                            print(session.classIn.objectForKey("name") as! String)
//                            for question in session.questions {
//                                print(question.text)
//                            }
//                        }
                    }
                })
//                let questionQuery = Question.query()!
//                questionQuery.getObjectInBackgroundWithId("lL0MbYlKlM", block: { (object, error) -> Void in
//                    if error == nil {
//                        if let question = object as? Question {
//                            print(question.text)
//                        }
//                    }
//                })
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

