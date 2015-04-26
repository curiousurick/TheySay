//
//  SplashViewController.swift
//  YouSay
//
//  Created by George Urick on 4/21/15.
//  Copyright (c) 2015 George Urick. All rights reserved.
//

import UIKit
import Parse
import TwitterKit

class SplashViewController: UIViewController {
    
    @IBOutlet weak var twitterloginButton: TWTRLogInButton!
    var networkingEngine = NetworkingEngine()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //Attemps to log in to Twitter.
    @IBAction func twitterLoginClicked(sender: AnyObject) {
        if UIApplication.sharedApplication().canOpenURL(NSURL(string: "twitter:///user?screen_name=senior")!) == true {
            self.networkingEngine.loginWithTwitter { (success) -> Void in
                if(success == "New") {
                    self.performSegueWithIdentifier("Login", sender: self)
                }
                else if(success == "Login") {
                    self.performSegueWithIdentifier("Login", sender: self)
                }
                else if(success == "Failed") {
                    
                    AppUtils.showAlert("Login Failed", message: "Looks like we messed up somewhere, please try again")
                }
            }
        }
        //error
        else {
            AppUtils.showAlert("Sorry", message: "Looks like you don't have access to Twitter")
        }
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

