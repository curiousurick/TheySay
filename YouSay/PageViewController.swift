//
//  PageViewController.swift
//  TwitterTube
//
//  Created by George Urick on 4/22/15.
//  Copyright (c) 2015 George Urick. All rights reserved.
//

import UIKit

class PageViewController: UIViewController, CAPSPageMenuDelegate {
    
    var pageMenu : CAPSPageMenu?
    
    var controllerArray: [UIViewController]!
    var parameters: [String: AnyObject]!
    
    @IBOutlet weak var twitterTableActivity: UIActivityIndicatorView!
    var twitterTable: TwitterFeedTableViewController!
    var savedPostsTable: TwitterFeedTableViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.pageMenu?.delegate = self
        // MARK: - Scroll menu setup
        
        // Initialize view controllers to display and place in array
        controllerArray = []
        
        twitterTable = self.storyboard?.instantiateViewControllerWithIdentifier("TwitterFeedTableViewController") as! TwitterFeedTableViewController
        twitterTable.loaded = false
        twitterTable.viewingSavedTweets = false
        twitterTable.title = "Twitter"
        controllerArray.append(twitterTable)
        
        savedPostsTable = self.storyboard?.instantiateViewControllerWithIdentifier("TwitterFeedTableViewController") as! TwitterFeedTableViewController
        savedPostsTable.title = "Saved"
        savedPostsTable.viewingSavedTweets = true
        controllerArray.append(savedPostsTable)
        
        // Customize menu (Optional)
        parameters = [
            "scrollMenuBackgroundColor": UIColor(red: 30/255, green: 29/255, blue: 32/255, alpha: 1),
            "viewBackgroundColor": UIColor(red: 30/255, green: 29/255, blue: 32/255, alpha: 1),
            "selectionIndicatorColor": UIColor.orangeColor(),
            "addBottomMenuHairline": true,
            "menuItemFont": UIFont(name: "HelveticaNeue", size: 17.0)!,
            "menuItemWidth": 85,
            "selectionIndicatorHeight": 5.0,
            "menuItemWidthBasedOnTitleTextWidth": false,
            "selectedMenuItemLabelColor": UIColor.whiteColor(),
            "centerMenuItems": true,
            "hideTopMenuBar": false
        ]
        
        // Initialize scroll menu
        pageMenu = CAPSPageMenu(viewControllers: controllerArray, frame: CGRectMake(0.0, 0.0, self.view.frame.width, self.view.frame.height), options: parameters)
        
        self.view.addSubview(pageMenu!.view)
    }
    
    
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }



}

