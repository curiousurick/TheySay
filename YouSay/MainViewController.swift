//
//  MainViewController.swift
//  YouSay
//
//  Created by George Urick on 4/22/15.
//  Copyright (c) 2015 George Urick. All rights reserved.
//

import UIKit
import Parse

class MainViewController: UIViewController, YTPlayerViewDelegate, UIAlertViewDelegate, UITextFieldDelegate {
    
    var name: String?
    var email: String?
    @IBOutlet var playerView: YTPlayerView!
    @IBOutlet var searchTextField: SpringTextField!
    @IBOutlet var searchButton: UIBarButtonItem!
    var twitterFeed: TwitterFeedTableViewController?
    var tweetIds: [String]?
    var networkEngine: NetworkingEngine = NetworkingEngine()
    var pageController: ViewController?
    
    var shouldShowSearchField = true
    
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerNotifications()
        self.playerView.delegate = self
        
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(animated: Bool) {
        var playerVars = ["playsinline" : 1]
        self.playerView.loadWithVideoId("gnqYiHCS3Sc", playerVars: playerVars)
    }
    
    @IBAction func changeVideoClicked(sender: AnyObject) {
        
        if shouldShowSearchField == true {
            
            searchTextField.hidden = false
            setUpSearchFieldAnimation("slideDown")
            searchTextField.animate()
            searchTextField.becomeFirstResponder()
            
            shouldShowSearchField = false
        } else {
            setUpSearchFieldAnimation("fadeOut")
            self.searchTextField.animateNext({ () -> () in
                self.searchTextField.hidden = true
            })
            
            searchTextField.resignFirstResponder()
            
            shouldShowSearchField = true
        }
//        var askToChange = UIAlertView(title: "Change Video", message: "Please Enter the URL", delegate: self, cancelButtonTitle: "Cancel", otherButtonTitles: "Change")
//        askToChange.alertViewStyle = .PlainTextInput
//        askToChange.show()
    }
    
    func setUpSearchFieldAnimation(animation: String) {
        searchTextField.animation = animation
        if shouldShowSearchField {
            searchTextField.force = 1
            searchTextField.duration = 0.5
            searchTextField.damping = 1
        } else {
            
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField == searchTextField {
            var videoUrl = textField.text
            var playerVars = ["playsinline" : 1]
            self.playerView.loadWithVideoId(self.idFromUrl(videoUrl!), playerVars: playerVars)
            
            changeVideoClicked(self)
        }
        return true
    }
    
//    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
//        if buttonIndex == 1 {
//            var videoUrl = alertView.textFieldAtIndex(0)?.text
//            var playerVars = ["playsinline" : 1]
//            self.playerView.loadWithVideoId(self.idFromUrl(videoUrl!), playerVars: playerVars)
//        }
//    }
    
    func idFromUrl(videoUrl: String) -> String? {
        if(videoUrl.rangeOfString("watch") != nil) {
            return videoUrl.stringByReplacingOccurrencesOfString("https://www.youtube.com/watch?v=", withString: "", options: nil, range: nil)
        }
        return videoUrl.lastPathComponent
        
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(true)
        deregisterNotifications()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func playerView(playerView: YTPlayerView!, receivedError error: YTPlayerError) {
        println(error)
    }
    
    func playerViewDidBecomeReady(playerView: YTPlayerView!) {
        var videoId = self.idFromUrl(self.playerView.videoUrl().relativeString!)
        self.networkEngine.searchForTweets(videoId, completionHandler: { (tweetIds) -> Void in
            self.pageController?.twitterTable!.tweetIds = tweetIds!
            self.pageController?.twitterTable!.videoId = self.idFromUrl(self.playerView.videoUrl().relativeString!)
            self.pageController?.twitterTable!.loadTweetsOnRefresh()
            
            //self.pageController?.twitterTable!.tableView.reloadData()
        })
    }
    
    @IBAction func ShowSavedTweets(sender: AnyObject) {
        self.performSegueWithIdentifier("ShowSavedTweets", sender: self)
        
        
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "TwitterContainerSeg") {
            self.pageController = segue.destinationViewController as? ViewController
            
        }
        else if(segue.identifier == "ShowSavedTweets") {
            var tweetVC = segue.destinationViewController as? TwitterFeedTableViewController
            tweetVC?.viewingSavedTweets = true
        }
    }
    
    func stopActivityIndicator() {
        self.activityIndicator.stopAnimating()
    }
    
    //MARK: - Notifications
    
    func registerNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "stopActivityIndicator", name: tweetsDidLoadAsynchronously, object: nil)
    }
    
    func deregisterNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
}
