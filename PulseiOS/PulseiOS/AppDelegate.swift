//
//  AppDelegate.swift
//  PulseiOS
//
//  Created by Max Marze on 11/7/15.
//  Copyright © 2015 pulse. All rights reserved.
//

import UIKit
import Bolts
import Parse
import DeepLinkKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate /*, PushNotificationDelegate*/ {
    
    var window: UIWindow?
    var loadedEnoughToDeepLink : Bool = false
    var deepLink : RemoteNotificationDeepLink?
    
    lazy var router: DPLDeepLinkRouter = DPLDeepLinkRouter()
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        Parse.enableLocalDatastore()
        
        // Initialize Parse.
        Parse.setApplicationId("AR6NF8FvJQFx0zurn9snBroZi2S68SCRBIRMudo7",
            clientKey: "bM55tcvcIPaclkqWIwkhcLg2x15IWUHr6MapZudk")
        
//        PushNotificationManager.pushManager().delegate = self
//        PushNotificationManager.pushManager().handlePushReceived(launchOptions)
//        PushNotificationManager.pushManager().sendAppOpen()
//        PushNotificationManager.pushManager().registerForPushNotifications()
        
        // [Optional] Track statistics around application opens.
        PFAnalytics.trackAppOpenedWithLaunchOptions(launchOptions)
        
                // Register for Push Notitications
                if application.applicationState != UIApplicationState.Background {
                    // Track an app open here if we launch with a push, unless
                    // "content_available" was used to trigger a background push (introduced in iOS 7).
                    // In that case, we skip tracking here to avoid double counting the app-open.
        
                    let preBackgroundPush = !application.respondsToSelector("backgroundRefreshStatus")
                    let oldPushHandlerOnly = !self.respondsToSelector("application:didReceiveRemoteNotification:fetchCompletionHandler:")
                    var pushPayload = false
                    if let options = launchOptions {
                        pushPayload = options[UIApplicationLaunchOptionsRemoteNotificationKey] != nil
                    }
                    if (preBackgroundPush || oldPushHandlerOnly || pushPayload) {
                        PFAnalytics.trackAppOpenedWithLaunchOptions(launchOptions)
                    }
                }
                if application.respondsToSelector("registerUserNotificationSettings:") {
        //            let userNotificationTypes = UIUserNotificationType.Alert | UIUserNotificationType.Badge | UIUserNotificationType.Sound
                    let settings = UIUserNotificationSettings(forTypes: [.Alert, .Badge, .Sound], categories: nil)
                    application.registerUserNotificationSettings(settings)
                    application.registerForRemoteNotifications()
                } else {
        //            let types = UIRemoteNotificationType.Badge | UIRemoteNotificationType.Alert | UIRemoteNotificationType.Sound
        //            application.registerForRemoteNotificationTypes(types)
                    let settings = UIUserNotificationSettings(forTypes: [.Alert, .Badge, .Sound], categories: nil)
                    application.registerUserNotificationSettings(settings)
                    application.registerForRemoteNotifications()
                }
        
        // MARK :- DeepLinkKit Setup
        self.router.registerHandlerClass(PushRouteHandler.self, forRoute: "/say/:title/:message")
        self.router.registerHandlerClass(UpdateQuestionRouteHandler.self, forRoute: "/updatequestion")
        
        /* iPad OR iPhone App ?? **************/
        let storyboardname = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.Pad) ? StoryBoards.iPadStoryBoardName : ( (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.Phone) ? StoryBoards.iPhoneStoryBoardName : "" )
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        let sb = UIStoryboard(name: storyboardname, bundle: nil)
        self.window?.rootViewController = sb.instantiateInitialViewController()
        window!.makeKeyAndVisible()
        /**************************************/
        
        /* Auto Login *************************/
        if PFUser.currentUser() != nil {
            self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
            let storyboard = UIStoryboard(name: storyboardname, bundle: nil)
            let initialViewController = storyboard.instantiateViewControllerWithIdentifier("StudentViewController")
            self.window?.rootViewController = initialViewController
            self.window?.makeKeyAndVisible()
        }
        /**************************************/
        
        return true
    }
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        self.router.handleURL(url, withCompletion: nil)
        if url.host == nil
        {
            return true;
        }
        
        let urlString = url.absoluteString
        let queryArray = urlString.componentsSeparatedByString("/")
        let query = queryArray[2]
        
        // Check if article
        if query.rangeOfString("article") != nil
        {
            let data = urlString.componentsSeparatedByString("/")
            if data.count >= 3
            {
                let parameter = data[3]
                let userInfo = [RemoteNotificationDeepLinkAppSectionKey : parameter ]
                self.applicationHandleRemoteNotification(application, didReceiveRemoteNotification: userInfo)
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
    
    func applicationHandleRemoteNotification(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject])
    {
        if application.applicationState == UIApplicationState.Background || application.applicationState == UIApplicationState.Inactive
        {
            let canDoNow = loadedEnoughToDeepLink
            
            self.deepLink = RemoteNotificationDeepLink.create(userInfo)
            
            if canDoNow
            {
                self.triggerDeepLinkIfPresent()
            }
        }
    }
    
    func triggerDeepLinkIfPresent() -> Bool
    {
        self.loadedEnoughToDeepLink = true

        let ret = (self.deepLink?.trigger() != nil)
        self.deepLink = nil
        return ret
    }
    
//    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
//        PushNotificationManager.pushManager().handlePushRegistration(deviceToken)
//    }
//    
//    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
//        PushNotificationManager.pushManager().handlePushRegistrationFailure(error)
//    }
//    
//    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
//        PushNotificationManager.pushManager().handlePushReceived(userInfo)
//        self.deepLink = RemoteNotificationDeepLink.create(userInfo)
//        if let deepLink = self.deepLink {
//            if !deepLink.article.isEmpty {
//                self.triggerDeepLinkIfPresent()
//            }
//        }
//    }
//    
//    func onPushAccepted(pushManager: PushNotificationManager!, withNotification pushNotification: [NSObject : AnyObject]!, onStart: Bool) {
//        print("Push notification accepted: \(pushNotification)");
//    }
    
        func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
            let installation = PFInstallation.currentInstallation()
            installation.setDeviceTokenFromData(deviceToken)
            installation.channels = ["global"]
            installation.saveInBackground()
        }
    
        func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
            if error.code == 3010 {
                print("Push notifications are not supported in the iOS Simulator.")
            } else {
                print("application:didFailToRegisterForRemoteNotificationsWithError: %@", error)
            }
        }
    
        func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
            PFPush.handlePush(userInfo)
            self.deepLink = RemoteNotificationDeepLink.create(userInfo)
            if application.applicationState == UIApplicationState.Inactive {
                PFAnalytics.trackAppOpenedWithRemoteNotificationPayload(userInfo)
            }
            
            if let deepLink = self.deepLink {
                if !deepLink.article.isEmpty {
                    let url = NSURL(string: deepLink.article)
                    if let url = url {
                        UIApplication.sharedApplication().openURL(url)
                    }
//                    self.triggerDeepLinkIfPresent()
                }
            }
        }
    
}

