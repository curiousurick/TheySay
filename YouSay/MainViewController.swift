//
//  MainViewController.swift
//  YouSay
//
//  Created by George Urick on 4/22/15.
//  Copyright (c) 2015 GameThrift. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, YTPlayerViewDelegate {

    var name: String?
    var email: String?
    @IBOutlet var playerView: YTPlayerView!
    @IBAction func playButtonClicked(sender: AnyObject) {
        self.playerView.playVideo()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.playerView.delegate = self
        var playerVars = ["playsinline" : 1]
        self.playerView.loadWithVideoId("M7lc1UVf-VE", playerVars: playerVars)
        
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(animated: Bool) {
    //self.playerView.loadVideoByURL("https://www.youtube.com/watch?v=GttoIyB_lEQ", startSeconds: 0.0, suggestedQuality: YTPlaybackQuality.Medium)
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func playerView(playerView: YTPlayerView!, receivedError error: YTPlayerError) {
        println(error)
    }
    
    func playerViewDidBecomeReady(playerView: YTPlayerView!) {
        self.playerView.playVideo()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
