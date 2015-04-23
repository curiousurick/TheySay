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
    var refreshControl: UIRefreshControl!
    var selectedTweet: TWTRTweet?
    var networkingEngine = NetworkingEngine()
    var videoId: String?
    
    var tweets: [TWTRTweet] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    var loaded: Bool?
    var viewingSavedTweets: Bool?
    
    //@IBOutlet weak var loadingTweets: UIActivityIndicatorView!
    
    var tweetIds = [String]()
    
    let tweetTableReuseIdentifier = "TweetCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //tableView.estimatedRowHeight = 150
        //tableView.rowHeight = UITableViewAutomaticDimension
        tableView.tableFooterView = UIView(frame: CGRect(x: 0,y: 0,width: 0,height: 0))
        tableView.registerClass(TWTRTweetTableViewCell.self, forCellReuseIdentifier: tweetTableReuseIdentifier)
        
        if self.viewingSavedTweets == false {
            self.refreshControl = UIRefreshControl()
            self.refreshControl.tintColor = UIColor.grayColor()
            self.refreshControl.addTarget(self, action: "loadTweetsOnRefresh", forControlEvents: UIControlEvents.ValueChanged)
            self.tableView.addSubview(refreshControl)
        }
        else {
            self.navigationItem.title = "Saved Tweets"
            var query = PFQuery(className: "Tweets")
            query.whereKey("createdBy", equalTo:PFUser.currentUser()!.objectId!)
            query.findObjectsInBackgroundWithBlock({ (objects:[AnyObject]?, error:NSError?) -> Void in
                for object in objects! {
                    self.tweetIds.append((object["TweetId"] as? String)!)
                }
                self.networkingEngine.loadTweetsWithIds(self.tweetIds, completionHandler: { (success, tweets, loaded) -> Void in
                    if(success) {
                        self.tweets = tweets!
                        self.loaded = loaded
                        self.tableView.reloadData()
                    }
                    else {
                        var alert = UIAlertView(title: "Oops!", message: "Looks like something went wrong trying to load the tweets", delegate: nil, cancelButtonTitle: "OK")
                    }
                })
            })
        }
    }
    
    func loadTweetsOnRefresh() {
        self.networkingEngine.searchForTweets(self.videoId, completionHandler: { (tweetIds) -> Void in
            self.tweetIds = tweetIds!
            self.networkingEngine.loadTweetsWithIds(self.tweetIds, completionHandler: { (success, tweets, loaded) -> Void in
                if(success) {
                    self.tweets = tweets!
                    self.loaded = loaded
                    self.tableView.reloadData()
                    self.refreshControl.endRefreshing()
                    
                }
                else {
                    var alert = UIAlertView(title: "Oops!", message: "Looks like something went wrong trying to load the tweets", delegate: nil, cancelButtonTitle: "OK")
                }
            })
        })
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
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        if self.viewingSavedTweets == false {
            return self.tweets.count + 1
        }
        else {
            return self.tweets.count
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var checkForFeedOrSavedTweets = -1
        if self.viewingSavedTweets == true {
            checkForFeedOrSavedTweets = 0
        }
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
        var checkForFeedOrSavedTweets = -1
        if self.viewingSavedTweets == true {
            checkForFeedOrSavedTweets = 0
        }
        
        if(indexPath.row == 0 && self.viewingSavedTweets == false) {
            return 44
        }
        let tweet = tweets[indexPath.row + checkForFeedOrSavedTweets]
        return TWTRTweetTableViewCell.heightForTweet(tweet, width:CGRectGetWidth(self.view.bounds))
    }
    
    func tweetView(tweetView: TWTRTweetView!, didSelectTweet tweet: TWTRTweet!) {
        if self.viewingSavedTweets == false {
            self.selectedTweet = tweet
            var saveTweetAlert = UIAlertView(title: "Save Tweet", message: "Do you want to save this tweet?", delegate: self, cancelButtonTitle: "Cancel", otherButtonTitles: "OK")
            
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
    
    func tweetVideo(completionHandler:()-> Void) {
        let composer = TWTRComposer()
        var text = "http://youtu.be/\(self.videoId!)"
        if self.videoId != nil {
            composer.setText(text)
        }
        
        composer.showWithCompletion { (result) -> Void in
            if (result == TWTRComposerResult.Cancelled) {
                println("Tweet composition cancelled")
            }
            else {
                println("Sending tweet!")
            }
        }
    }
    
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        if(buttonIndex == 1) {
            var tweetId = PFObject(className: "Tweets")
            tweetId["TweetId"] = self.selectedTweet?.tweetID
            var user = PFUser.currentUser()
            tweetId["createdBy"] = user?.objectId
            user?.addObject(tweetId, forKey: "Tweets")
            user?.saveInBackground()
        }
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return self.viewingSavedTweets!
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete {
            var tweetId = PFObject(className: "Tweets")
            tweetId["TweetId"] = self.tweetIds[indexPath.row]
            var user = PFUser.currentUser()
            user?.removeObject(tweetId, forKey: "Tweets")
            user?.saveInBackground()
        }
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    // Return NO if you do not want the specified item to be editable.
    return true
    }
    */
    
    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    if editingStyle == .Delete {
    // Delete the row from the data source
    tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
    } else if editingStyle == .Insert {
    // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
    }
    */
    
    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
    
    }
    */
    
    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    // Return NO if you do not want the item to be re-orderable.
    return true
    }
    */
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    }
    */
    
}
