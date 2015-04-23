
//  FeedTableViewController.swift
//  Video Feed
//
//  Created by Benji on 4/22/15.
//  Copyright (c) 2015 Ben Heutmaker. All rights reserved.
//

import UIKit

class FeedTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var posts: [String]!
    @IBOutlet var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        posts = [
            "Tweet",
            "Facebook Post",
            "Google Plus Post"
        ]
    }
    
    func setDataSource(ds: NSObject) {
        tableView.dataSource = ds as? UITableViewDataSource
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
        cell.textLabel?.text = "post post post"
        cell.imageView?.image = UIImage(named: "facebook-profile")
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
