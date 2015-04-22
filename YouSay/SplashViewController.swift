//
//  ViewController.swift
//  YouSay
//
//  Created by George Urick on 4/21/15.
//  Copyright (c) 2015 GameThrift. All rights reserved.
//

import UIKit
import Parse
import TwitterKit

class SplashViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let logInButton = TWTRLogInButton(logInCompletion: { (session: TWTRSession!, error: NSError!) in
            println(session.userName)
            self.performSegueWithIdentifier("Login", sender: self)
        })
        logInButton.center = self.view.center
        self.view.addSubview(logInButton)
        
}

@IBAction func facebookLoginClicked(sender: AnyObject) {
    var permissions = ["public_profile", "email"]
    PFFacebookUtils.logInInBackgroundWithReadPermissions(permissions, block: { (user: PFUser?, error: NSError?) -> Void in
        if let user = user {
            if user.isNew {
                println("Logged in new")
                self.performSegueWithIdentifier("Login", sender: self)
            }
            else {
                println("Logged in")
                self.performSegueWithIdentifier("Login", sender: self)
            }
        }
        else {
            println("Something went wrong")
        }
    })
}

@IBAction func twitterLoginClicked(sender: AnyObject) {
    
    PFTwitterUtils.logInWithBlock {
        (user: PFUser?, error: NSError?) -> Void in
        if let user = user {
            if user.isNew {
                println("User signed up and logged in with Twitter!")
                self.performSegueWithIdentifier("Login", sender: self)
            } else {
                println("User logged in with Twitter!")
                self.performSegueWithIdentifier("Login", sender: self)
            }
        } else {
            println("Uh oh. The user cancelled the Twitter login.")
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

