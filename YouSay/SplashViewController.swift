//
//  ViewController.swift
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
    
    
    
    @IBAction func twitterLoginClicked(sender: AnyObject) {
        self.networkingEngine.loginWithTwitter { (success) -> Void in
            if(success == "New") {
                self.performSegueWithIdentifier("Login", sender: self)
            }
            else if(success == "Login") {
                self.performSegueWithIdentifier("Login", sender: self)
            }
            else if(success == "Failed") {
                self.failedToLoginAlert()
            }
        }
    }
    
    func failedToLoginAlert() {
        var alert = UIAlertView(title: "Login Failed", message: "Looks like we messed up somewhere, please try again", delegate: nil, cancelButtonTitle: "OK")
        
        alert.show()
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "Login") {
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

