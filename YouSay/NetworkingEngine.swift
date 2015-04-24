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
                completionHandler(success: "Failed")
            }
        }
    }
    
    func loadTweetsWithIds(tweetIds:[String], completionHandler:(success: Bool, tweets: [TWTRTweet]?, loaded: Bool?) -> Void) {
        var tweets: [TWTRTweet] = [] {
            didSet {
            }
        }
        Twitter.sharedInstance().APIClient.loadTweetsWithIDs(tweetIds) { tweets, error in
            if tweetIds.count > 0 {
                if let ts = tweets as? [TWTRTweet] {
                    completionHandler(success: true, tweets: ts, loaded: true)
                    
                    } else {
                    completionHandler(success: false, tweets: nil, loaded: nil)
                    println("Failed to load tweets: \(error.localizedDescription)")
                }
            }
        }
    }
    
    func searchForTweets(searchTerm: String?, completionHandler:(tweetIds:[String]?) -> Void) -> Void {
        var tweetIdsArray = [String]()
        
        
        var requestUrl = "https://api.twitter.com/1.1/search/tweets.json"
        
        let params = ["q" : "youtube.com/watch?v=\(searchTerm!) OR youtu.be/\(searchTerm!)", "count" : "10", "result_type" : "recent"]
        var clientError : NSError?
        let request = Twitter.sharedInstance().APIClient.URLRequestWithMethod("GET", URL: requestUrl, parameters: params, error: &clientError)
        
        if request != nil {
            Twitter.sharedInstance().APIClient.sendTwitterRequest(request) {(response, data, connectionError) -> Void in
                if(connectionError == nil) {
                    var jsonError : NSError?
                    let json : NSDictionary? = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: &jsonError) as? NSDictionary
                    var tweetsArray = json?.valueForKey("statuses") as? [NSDictionary]
                    //println(tweetsArray!.description)
                    for tweet in tweetsArray! {
                        var tweetId = (tweet.valueForKey("id") as? NSNumber)!
                        var idString = tweetId.stringValue
                        tweetIdsArray.append(idString)
                    }
                    
                    completionHandler(tweetIds: tweetIdsArray)
                    //println(tweetIdsArray.description)
                }
                else {
                    println("Error: \(connectionError)")
                }
            }
        }
        else {
            println("Error: \(clientError)")
        }
    }
    
}
