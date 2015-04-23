//
//  NetworkingEngine.swift
//  YouSay
//
//  Created by George Urick on 4/22/15.
//  Copyright (c) 2015 GameThrift. All rights reserved.
//

import UIKit
import TwitterKit

class NetworkingEngine: NSObject {
    
    
    func searchForTweets(searchTerm: NSURL?) {
        var tweetIdsArray = [String]()
        
        
        var videoUrlString = searchTerm?.relativeString
        var requestUrl = "https://api.twitter.com/1.1/search/tweets.json"
        
        let params = ["q" : videoUrlString!, "count" : "10"]
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
                    println(tweetIdsArray.description)
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
