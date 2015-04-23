//
//  ViewController.swift
//  YouSay
//
//  Created by George Urick on 4/22/15.
//  Copyright (c) 2015 George Urick. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var pageMenu : CAPSPageMenu?
    
    var controllerArray: [UIViewController]!
    var parameters: [String: AnyObject]!
    
    var twitterTable: TwitterFeedTableViewController!
    var facebookTable: FeedTableViewController!
    //var googlePlusTable: FeedTableViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // MARK: - Scroll menu setup
        
        // Initialize view controllers to display and place in array
        controllerArray = []
        
        twitterTable = self.storyboard?.instantiateViewControllerWithIdentifier("TwitterFeedTableViewController") as! TwitterFeedTableViewController
        twitterTable.loaded = false
        twitterTable.viewingSavedTweets = false
        twitterTable.title = "Twitter"
        controllerArray.append(twitterTable)
        
        facebookTable = self.storyboard?.instantiateViewControllerWithIdentifier("FeedTableViewController") as! FeedTableViewController
        facebookTable.title = "Facebook"
        controllerArray.append(facebookTable)
        
//        googlePlusTable = self.storyboard?.instantiateViewControllerWithIdentifier("FeedTableViewController") as! FeedTableViewController
//        googlePlusTable.title = "Google Plus"
//        controllerArray.append(googlePlusTable)
        
        // Customize menu (Optional)
        parameters = [
            "scrollMenuBackgroundColor": UIColor(red: 30/255, green: 29/255, blue: 32/255, alpha: 1),
            "viewBackgroundColor": UIColor(red: 30/255, green: 29/255, blue: 32/255, alpha: 1),
            "selectionIndicatorColor": UIColor.blueColor(),
            "addBottomMenuHairline": true,
            "menuItemFont": UIFont(name: "HelveticaNeue", size: 17.0)!,
            "menuHeight": 44.0,
            "selectionIndicatorHeight": 1.0,
            "menuItemWidthBasedOnTitleTextWidth": true,
            "selectedMenuItemLabelColor": UIColor.whiteColor(),
            "centerMenuItems": true,
            "hideTopMenuBar": false
        ]
        
        // Initialize scroll menu
        pageMenu = CAPSPageMenu(viewControllers: controllerArray, frame: CGRectMake(0.0, 0.0, self.view.frame.width, self.view.frame.height), options: parameters)
        
        self.view.addSubview(pageMenu!.view)
    }



}

