//
//  ViewController.swift
//  YouSay
//
//  Created by George Urick on 4/21/15.
//  Copyright (c) 2015 GameThrift. All rights reserved.
//

import UIKit
import Parse

class SplashViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func facebookLoginClicked(sender: AnyObject) {
        var permissions = ["public_profile", "email"]
        PFFacebookUtils.logInInBackgroundWithReadPermissions(permissions, block: { (user: PFUser?, error: NSError?) -> Void in
            if let user = user {
                if user.isNew {
                    println("Logged in new")
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
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "Login") {
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

