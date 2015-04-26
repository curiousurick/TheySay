//
//  NetworkingEngine.swift
//  YouSay
//
//  Created by George Urick on 4/22/15.
//  Copyright (c) 2015 George Urick. All rights reserved.
//

import UIKit
import TwitterKit
import Parse

class NetworkingEngine: NSObject {
    
    
    //This uses Parse to login with Twitter.
    func loginWithTwitter(completionHandler:(success: String?) -> Void) {
        PFTwitterUtils.logInWithBlock {
            (user: PFUser?, error: NSError?) -> Void in
            if let user = user {
                if user.isNew {
                    completionHandler(success: "New")
                } else {
                    completionHandler(success: "Login")
                }
            } else {
                println(error)
                completionHandler(success: "Failed")
            }
        }
    }
    
    //This takes an array of IDs and loads all the tweets
    func loadTweetsWithIds(tweetIds:[String], completionHandler:(success: Bool, tweets: [TWTRTweet]?, loaded: Bool?) -> Void) {
        var tweets: [TWTRTweet] = []
        
        Twitter.sharedInstance().APIClient.loadTweetsWithIDs(tweetIds) { tweets, error in
            if tweetIds.count > 0 {
                if var ts = tweets as? [TWTRTweet] {
                    completionHandler(success: true, tweets: ts, loaded: true)
                    
                } else {
                    completionHandler(success: false, tweets: nil, loaded: true)
                }
            }
        }
    }
    
    //This gets the Tweet IDs related to the Youtube video being watched.
    func searchForTweets(searchTerm: String?, completionHandler:(tweetIds:[String]?, error: NSError?) -> Void) -> Void {
        var tweetIdsArray = [String]()
        
        var requestUrl = "https://api.twitter.com/1.1/search/tweets.json"
        
        let params = ["q" : "youtube.com/watch?v=\(searchTerm!) OR youtu.be/\(searchTerm!)", "count" : "10", "result_type" : "recent"]
        var clientError : NSError?
        let request = Twitter.sharedInstance().APIClient.URLRequestWithMethod("GET", URL: requestUrl, parameters: params, error: &clientError)
        
        
        //because so much is optional, crazy amount of if statements
        if request != nil {
            Twitter.sharedInstance().APIClient.sendTwitterRequest(request) {(response, data, connectionError) -> Void in
                if(connectionError == nil) {
                    var jsonError : NSError?
                    if let json : NSDictionary? = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: &jsonError) as? NSDictionary {
                        if var tweetsArray = json?.valueForKey("statuses") as? [NSDictionary] {
                            for tweet in tweetsArray {
                                if var tweetId = (tweet.valueForKey("id") as? NSNumber) {
                                    var idString = tweetId.stringValue
                                    tweetIdsArray.append(idString)
                                }
                            }
                        }
                        completionHandler(tweetIds: tweetIdsArray, error: nil)
                    }
                }
                else {
                    completionHandler(tweetIds: nil, error: connectionError)
                }
            }
        }
        else {
            completionHandler(tweetIds: nil, error: clientError)
        }
    }
}
