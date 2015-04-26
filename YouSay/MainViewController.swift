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
    
    var playerVars = ["playsinline" : 1]
    var currentUrl: String?
    
    @IBOutlet var playerView: YTPlayerView!
    @IBOutlet var searchTextField: SpringTextField!
    @IBOutlet var searchButton: UIBarButtonItem!
    @IBOutlet var videoActivity: UIActivityIndicatorView!
    
    
    var tweetIds: [String]?
    var networkEngine: NetworkingEngine = NetworkingEngine()
    var pageController: PageViewController?
    
    var shouldShowSearchField = true
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.playerView.delegate = self
        self.videoActivity.startAnimating()
        //default video
        self.playerView.loadWithVideoId("gnqYiHCS3Sc", playerVars: self.playerVars)
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
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        self.shouldShowSearchField = false
        self.changeVideoClicked(self)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField == searchTextField && (textField.text.length > 0) {
            
            var videoUrl = textField.text
            self.playerView.loadWithVideoId(self.idFromUrl(videoUrl!), playerVars: self.playerVars)
            self.videoActivity.startAnimating()
            changeVideoClicked(self)
            
        }
        return true
    }
    func idFromUrl(videoUrl: String) -> String? {
        if(videoUrl.rangeOfString("https://www.youtube.com/watch?v=") != nil) {
            return videoUrl.stringByReplacingOccurrencesOfString("https://www.youtube.com/watch?v=", withString: "", options: nil, range: nil)
        }
        else if(videoUrl.rangeOfString("https://www.youtube.com/watch") != nil) {
            return videoUrl.stringByReplacingOccurrencesOfString("https://www.youtube.com/watch", withString: "", options: nil, range: nil)
        }
        return videoUrl.lastPathComponent
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    func playerViewDidBecomeReady(playerView: YTPlayerView!) {
        var videoId = self.idFromUrl(self.playerView.videoUrl().relativeString!)
        if self.videoActivity.isAnimating() {
            self.videoActivity.stopAnimating()
        }
        //error or no video loaded
        if videoId == " ?R4\\x01" || videoId == "" {
            self.playerView.loadWithVideoId(self.idFromUrl(self.currentUrl!), playerVars: self.playerVars)
            AppUtils.showAlert("Oops!", message: "Could not load tweets")
            return
        }
        
        self.currentUrl = self.playerView.videoUrl().relativeString!
        self.networkEngine.searchForTweets(videoId, completionHandler: { (tweetIds, error) -> Void in
            
             if error == nil {
                self.videoActivity.stopAnimating()
                self.pageController?.twitterTable.tweetIds = tweetIds!
                self.pageController?.twitterTable!.videoId = self.idFromUrl(self.playerView.videoUrl().relativeString!)
                if tweetIds!.count == 0 {
                    self.pageController?.twitterTable!.tweets = []
                    self.pageController?.twitterTable!.tableView.reloadData()
                }
                self.pageController?.twitterTable!.loadTweetsOnRefresh()
            }
            else {
                AppUtils.showAlert("Oops!", message: "Could not load tweets")
            }
        })
    }
    
    func playerView(playerView: YTPlayerView!, receivedError error: YTPlayerError) {
        AppUtils.showAlert("Oops", message: "Something went wrong loading the video. Check the URL!")
        if self.videoActivity.isAnimating() {
            self.videoActivity.stopAnimating()
        }
    }
    
    @IBAction func ShowSavedTweets(sender: AnyObject) {
        self.performSegueWithIdentifier("ShowSavedTweets", sender: self)
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "TwitterContainerSeg") {
            self.pageController = segue.destinationViewController as? PageViewController
            
        }
    }
    
    @IBAction func LogoutClicked(sender: AnyObject) {
        PFUser.logOut()
        self.performSegueWithIdentifier("Logout", sender: self)
    }
    
}
