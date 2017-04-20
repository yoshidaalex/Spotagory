//
//  WelcomeViewController.swift
//  Spotagory
//
//  Created by Messia Engineer on 8/23/16.
//  Copyright © 2016 Spotagory. All rights reserved.
//

import UIKit
import AVFoundation

class WelcomeViewController: UIViewController {
    
    @IBOutlet weak var buttonSignUp: UIButton!
    
    @IBOutlet weak var viewVideoContainer: UIView!
    
    var player : AVPlayer? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.buttonSignUp.layer.borderWidth = 1
        self.buttonSignUp.layer.borderColor = UIColor.whiteColor().CGColor
        self.buttonSignUp.layer.cornerRadius = 22
        
        addSwipeGesture()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBarHidden = true
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if player == nil {
            self.addVideo()
        } else {
            player?.play()
        }
    }
    
    override func viewDidDisappear(animated: Bool) {
        if player != nil {
            player?.pause()
        }
    }
    
    func addSwipeGesture() {
        let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(gotoSignup))
        swipeGesture.direction = .Left
        self.view.addGestureRecognizer(swipeGesture)
    }
    
    func gotoSignup() {
        self.performSegueWithIdentifier("sid_signup", sender: nil)
    }
    
    func addVideo() {
        
        player = AVPlayer(URL: NSBundle.mainBundle().URLForResource("intro", withExtension: "mp4")!)
        
        if player != nil {
            let layer = AVPlayerLayer(player: player)
            
            layer.frame = CGRectMake(0, 0, 375, 667)
            
            layer.backgroundColor = UIColor.blackColor().CGColor
            
            layer.videoGravity = AVLayerVideoGravityResizeAspectFill
            
            player!.actionAtItemEnd = AVPlayerActionAtItemEnd.None
            
            self.viewVideoContainer.layer.addSublayer(layer)
            
            player!.play()
            
            NSNotificationCenter.defaultCenter().addObserver(self,
                                                             selector: #selector(playerItemDidReachEnd),
                                                             name: AVPlayerItemDidPlayToEndTimeNotification,
                                                             object: player!.currentItem)
        }

    }
    
    func playerItemDidReachEnd(notification: NSNotification) {
        if let playerItem: AVPlayerItem = notification.object as? AVPlayerItem {
            playerItem.seekToTime(kCMTimeZero)
        }
    }
    
    @IBAction func onPlayVideo(sender: AnyObject) {
        if player != nil {
            player!.play()
        }
    }
    

}
