//
//  TwitterFeedTableViewController.swift
//  YouSay
//
//  Created by George Urick on 4/22/15.
//  Copyright (c) 2015 George Urick. All rights reserved.
//

import UIKit
import Parse
import TwitterKit

class TwitterFeedTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, TWTRTweetViewDelegate, UIAlertViewDelegate {
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet weak var noTweetsLabel: UILabel!
    @IBOutlet weak var twitterActivity: UIActivityIndicatorView!
    
    var refreshControl: UIRefreshControl!
    var selectedTweet: TWTRTweet?
    var networkingEngine = NetworkingEngine()
    var videoId: String?
    
    var tweetIds = [String]()
    var tweets: [TWTRTweet] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    var loaded: Bool?
    var viewingSavedTweets: Bool?
    
    let tweetTableReuseIdentifier = "TweetCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //for when viewing all related tweets
        self.noTweetsLabel.hidden = true
        self.twitterActivity.startAnimating()
        //for ending the table view pretty
        tableView.tableFooterView = UIView(frame: CGRect(x: 0,y: 0,width: 0,height: 0))
        tableView.registerClass(TWTRTweetTableViewCell.self, forCellReuseIdentifier: tweetTableReuseIdentifier)
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl.tintColor = UIColor.grayColor()
        self.refreshControl.addTarget(self, action: "loadTweetsOnRefresh", forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.addSubview(refreshControl)
        
    }
    
    override func viewWillAppear(animated: Bool) {
        if (self.viewingSavedTweets == true) {
            self.navigationItem.title = "Saved Tweets"
            
            //for when viewing only saved tweets.
            self.noTweetsLabel.hidden = true
            //Using parse database
            self.getTweetIdsFromParse()
        }
    }
    
    
    func getTweetIdsFromParse() {
        var query = PFQuery(className: "Tweets")
        //detects ownership
        query.whereKey("createdBy", equalTo:PFUser.currentUser()!.objectId!)
        query.findObjectsInBackgroundWithBlock({ (objects:[AnyObject]?, error:NSError?) -> Void in
            if self.refreshControl.refreshing {
                self.refreshControl.endRefreshing()
            }
            if self.twitterActivity.isAnimating() {
                self.twitterActivity.stopAnimating()
            }
            if error == nil {
                for object in objects! {
                    var newTweetId = object["TweetId"] as? String
                    if let index = find(self.tweetIds, newTweetId!) {
                        //do nothing
                    }
                    else if newTweetId != nil {
                        self.tweetIds.append((object["TweetId"] as? String)!)
                    }
                }
                if self.tweetIds.count > 0 {
                    //load saved tweets
                    self.loadTweetsUsingIds(self.tweetIds)
                }
                else {
                    self.noTweetsLabel.hidden = false
                }
            }
            else {
                AppUtils.showAlert("Oops", message: "Looks like something went wrong getting your saved tweet")
            }
        })
    }
    
    func loadTweetsUsingIds(tweetIds:[String]) {
        self.networkingEngine.loadTweetsWithIds(tweetIds, completionHandler: { (success, responseTweets, loaded) -> Void in
            if self.refreshControl.refreshing {
                self.refreshControl.endRefreshing()
            }
            if self.twitterActivity.isAnimating() {
                self.twitterActivity.stopAnimating()
            }
            if success {
                if responseTweets!.count > 0 {
                    self.tweets = responseTweets!
                    self.loaded = loaded
                    
                    return;
                }
            }
            else {
                AppUtils.showAlert("Oops!", message: "Could not load tweets")
                if self.twitterActivity.isAnimating() {
                    self.twitterActivity.stopAnimating()
                }
            }
        })
    }
    
    func loadTweetsOnRefresh() {
        self.noTweetsLabel.hidden = true
        if (self.viewingSavedTweets == false) {
            self.networkingEngine.searchForTweets(self.videoId, completionHandler: { (tweetIds, error) -> Void in
                if self.refreshControl.refreshing {
                    self.refreshControl.endRefreshing()
                }
                if self.twitterActivity.isAnimating() {
                    self.twitterActivity.stopAnimating()
                }
                if error == nil {
                    self.tweetIds = tweetIds!
                    self.loadTweetsUsingIds(self.tweetIds)
                }
                else {
                    AppUtils.showAlert("Oops!", message: "Could not load tweets")
                    
                }
            })
        }
        else {
            self.getTweetIdsFromParse()
        }
    }
    
    func tweetView(tweetView: TWTRTweetView!, didTapURL url: NSURL!) {
        let webViewController = UIViewController()
        let webView = UIWebView(frame: webViewController.view.bounds)
        webView.loadRequest(NSURLRequest(URL: url))
        webViewController.view = webView
        self.navigationController!.pushViewController(webViewController, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (self.tweets.count == 0 && self.loaded == true) {
            self.noTweetsLabel.hidden = false
        }
        if (self.viewingSavedTweets == false && self.loaded == true) {
            return self.tweets.count + 1
        }
        else {
            return self.tweets.count
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var checkForFeedOrSavedTweets = self.viewingSavedTweets == true ? 0 : -1
        
        if(indexPath.row == 0 && self.viewingSavedTweets == false) {
            let cell = tableView.dequeueReusableCellWithIdentifier("SendATweetCell", forIndexPath: indexPath) as! UITableViewCell
            cell.textLabel!.text = "Tweet about this video!"
            return cell
        }
            
        else {
            let tweet = tweets[indexPath.row + checkForFeedOrSavedTweets]
            let cell = tableView.dequeueReusableCellWithIdentifier(tweetTableReuseIdentifier, forIndexPath: indexPath) as! TWTRTweetTableViewCell
            cell.configureWithTweet(tweet)
            cell.tweetView.delegate = self
            return cell
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        var checkForFeedOrSavedTweets = self.viewingSavedTweets == true ? 0 : -1
        
        if(indexPath.row == 0 && self.viewingSavedTweets == false) {
            return 44
        }
        
        //if viewing all related tweets, indexPath.row 0 is reserved for Tweeting.
        let tweet = tweets[indexPath.row + checkForFeedOrSavedTweets]
        return TWTRTweetTableViewCell.heightForTweet(tweet, width:CGRectGetWidth(self.view.bounds))
    }
    
    func tweetView(tweetView: TWTRTweetView!, didSelectTweet tweet: TWTRTweet!) {
        self.selectedTweet = tweet
        if self.viewingSavedTweets == false {
            var saveTweetAlert = UIAlertView(title: "Save Tweet", message: "Do you want to save this tweet?", delegate: self, cancelButtonTitle: "Cancel", otherButtonTitles: "OK")
            saveTweetAlert.show()
        }
        else {
            var saveTweetAlert = UIAlertView(title: "Delete Tweet?", message: "Do you want to delete this tweet?", delegate: self, cancelButtonTitle: "Cancel", otherButtonTitles: "OK")
            saveTweetAlert.show()
        }
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        if(indexPath.row == 0) {
            self.tweetVideo({ () -> Void in
                self.loadTweetsOnRefresh()
            })
        }
    }
    
    
    func tweetVideo(completionHandler:() -> Void) {
        let composer = TWTRComposer()
        var text = "http://youtu.be/\(self.videoId!)"
        if self.videoId != nil {
            composer.setText(text)
        }
        
        composer.showWithCompletion { (result) -> Void in
            if (result == TWTRComposerResult.Cancelled) {
            }
            else {
                AppUtils.showAlert("Yay!", message: "You tweeted about this video!")
            }
        }
    }
    
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        if(buttonIndex == 1) {
            let user = PFUser.currentUser()
            if(self.viewingSavedTweets == false) {
                var tweetId = PFObject(className: "Tweets")
                tweetId["TweetId"] = self.selectedTweet?.tweetID
                tweetId["createdBy"] = user?.objectId
                user?.addObject(tweetId, forKey: "Tweets")
                user?.saveInBackground()
            }
            else {
                var query = PFQuery(className: "Tweets")
                query.whereKey("createdBy", equalTo: user!.objectId!)
                query.whereKey("TweetId", equalTo: self.selectedTweet!.tweetID)
                query.getFirstObjectInBackgroundWithBlock({ (object: PFObject?, error:NSError?) -> Void in
                    object?.deleteInBackgroundWithBlock({ (success, error) -> Void in
                        if error == nil {
                            if let index = find(self.tweetIds, self.selectedTweet!.tweetID) {
                                var indexPath = NSIndexPath(forRow: index, inSection: 0)
                                self.tableView.beginUpdates()
                                self.tweetIds.removeAtIndex(indexPath.row)
                                self.tweets.removeAtIndex(indexPath.row)
                                self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
                                self.tableView.endUpdates()
                            }
                            else {
                                AppUtils.showAlert("Oops", message: "Something went wrong in deleting the tweet")
                            }
                        }
                        else {
                            AppUtils.showAlert("Oops", message: "Something went wrong. Check your internet Connection")
                        }
                    })
                })
            }
        }
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return self.viewingSavedTweets!
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete {
            
            self.tweetIds.removeAtIndex(indexPath.row)
            self.tweets.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
            
            
        }
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
}
