//
//  AppDelegate.swift
//  YouSay
//
//  Created by George Urick on 4/21/15.
//  Copyright (c) 2015 George Urick. All rights reserved.
//

import UIKit
import Parse
import Fabric
import TwitterKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        Parse.enableLocalDatastore()
        //Initialize Twitter/Fabric
        Fabric.with([Twitter()])
        // Initialize Parse.
        Parse.setApplicationId("n8JolGHQ4VMQ1dinZaBpTXmdMwGCUjiEUUmjcsgb",
            clientKey: "bJNHgbVUqRDbSBqK6c4Pi4S3OvkM37J3TODIAWmS")
        PFTwitterUtils.initializeWithConsumerKey("XovhOg4IQpvQh8AcyglnKAwV4",
            consumerSecret:"0QXZfuGy2RSGIt2LDRHoHVyrnD62EZI4XopKbhNvXKg0TIx9LE")
        PFAnalytics.trackAppOpenedWithLaunchOptions(launchOptions)
        
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        var storyboard = UIStoryboard(name: "Main", bundle: nil)
        var viewController: UIViewController
        
        if let user = PFUser.currentUser() {
            viewController = storyboard.instantiateViewControllerWithIdentifier("TwitterFeedNav") as! UINavigationController
            
        }
        else {
            viewController = storyboard.instantiateViewControllerWithIdentifier("Splash") as! SplashViewController
        }
        
        self.window?.rootViewController = viewController
        self.window?.makeKeyAndVisible()
        
        
        
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.LightContent
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        
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

