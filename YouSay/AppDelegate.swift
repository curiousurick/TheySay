//
//  AppDelegate.swift
//  YouSay
//
//  Created by George Urick on 4/21/15.
//  Copyright (c) 2015 GameThrift. All rights reserved.
//

import UIKit
import Parse
import Bolts
import Fabric
import TwitterKit

var tweetsDidLoadAsynchronously = "tweetsDidLoadAsynchronously"

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        Parse.enableLocalDatastore()
        Fabric.with([Twitter()])
        // Initialize Parse.
        Parse.setApplicationId("n8JolGHQ4VMQ1dinZaBpTXmdMwGCUjiEUUmjcsgb",
            clientKey: "bJNHgbVUqRDbSBqK6c4Pi4S3OvkM37J3TODIAWmS")
        PFTwitterUtils.initializeWithConsumerKey("dZCDuwg56yYLfc9CgwsiB3jX6",
            consumerSecret:"ZGxOe2JbYbmCjhC3RHBm37HqqppRkVN10lIFcuVy8PyyOqmUv9")
        
        //Weird issue that the Parse library has now that Swift 1.2 has been released.
        //waiting on update
        var launchO = launchOptions
        if launchO == nil {
            launchO = ["":""]
        }
        PFFacebookUtils.initializeFacebookWithApplicationLaunchOptions(launchO!)
        
//        PFTwitterUtils.initializeWithConsumerKey("YOUR CONSUMER KEY",
//            consumerSecret:"YOUR CONSUMER SECRET")
        
        PFAnalytics.trackAppOpenedWithLaunchOptions(launchOptions)
        return true
    }
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject?) -> Bool {
        return FBSDKApplicationDelegate.sharedInstance().application(application,openURL: url, sourceApplication: sourceApplication, annotation: annotation)
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
        FBSDKAppEvents.activateApp()
        
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

