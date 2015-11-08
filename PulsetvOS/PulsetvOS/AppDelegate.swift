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
        Parse.enableLocalDatastore()
        // Initialize Parse.
        Parse.setApplicationId("AR6NF8FvJQFx0zurn9snBroZi2S68SCRBIRMudo7",
            clientKey: "bM55tcvcIPaclkqWIwkhcLg2x15IWUHr6MapZudk")
        
        // [Optional] Track statistics around application opens.
        PFAnalytics.trackAppOpenedWithLaunchOptions(launchOptions)
        PFUser.registerSubclass()
        
//        PFUser.logInWithUsernameInBackground("aakash", password:"isAPussy") {
//            (user: PFUser?, error: NSError?) -> Void in
//            if user != nil {
//                // Do stuff after successful login.
//                let query = PFQuery(className:"ClassSession")
//                query.whereKey("name", equalTo:"Math")
//                query.findObjectsInBackgroundWithBlock {
//                    (objects: [PFObject]?, error: NSError?) -> Void in
//                    if error == nil {
//                        print("error nil")
//                        let questionQuery = PFQuery(className: "Question")
//                        questionQuery.whereKey("classSession", equalTo: objects![0])
//                        questionQuery.findObjectsInBackgroundWithBlock({ (questions, error) -> Void in
//                            if error == nil {
//                                Model.sharedInstance.initializeQuestions(questions!)
////                                if let question = self.model.getFirstUnansweredQuestion() {
////                                    self.questionText.text = question.text
////                                }
//                            }
//                        })
//                    }
//                }
//            } else {
//                // The login failed. Check error to see why.
//                print("Login failed")
//            }
//        }
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

