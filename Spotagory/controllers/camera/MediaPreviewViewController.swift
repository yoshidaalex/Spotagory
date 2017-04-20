//
//  MediaPreviewViewController.swift
//  Spotagory
//
//  Created by Messia Engineer on 9/8/16.
//  Copyright © 2016 Spotagory. All rights reserved.
//

import UIKit
import AVFoundation

class MediaPreviewViewController: UIViewController {

    @IBOutlet weak var imageScrollView: ImageScrollView!
    @IBOutlet weak var labelPageTitle: UILabel!
    @IBOutlet weak var labelAddCaptionNote: UILabel!
    @IBOutlet weak var viewVideoContainer: UIView!
    @IBOutlet weak var viewVideoPreview: UIView!
    @IBOutlet weak var viewImageContainer: UIView!
    @IBOutlet weak var buttonAction: UIButton!
    
    var player : AVPlayer? = nil
    var capturedImage : UIImage? = nil
    var videoURL : NSURL? = nil
    
    var callback : MediaCallback? = nil
    
    var withoutCaptionInput : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        viewImageContainer.hidden = true
        viewVideoContainer.hidden = true
        
        self.labelPageTitle.text = "Preview"
        
        if self.withoutCaptionInput {
            self.buttonAction.setTitle("D O N E", forState: .Normal)
        } else {
            self.buttonAction.setTitle("N E X T", forState: .Normal)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if capturedImage != nil {
            
            viewImageContainer.hidden = false
            viewVideoContainer.hidden = true
            self.labelPageTitle.text = "Preview Image"
            self.labelAddCaptionNote.text = "Add caption"
            
            var imageSize = capturedImage!.size
            let containerSize = imageScrollView.frame.size
            
            if imageSize.width < containerSize.width {
                let ratio = containerSize.width / imageSize.width
                imageSize.width = containerSize.width
                imageSize.height = imageSize.height * ratio
            }
            
            if imageSize.height < containerSize.height {
                let ratio = containerSize.height / imageSize.height
                imageSize.height = containerSize.height
                imageSize.width = imageSize.width * ratio
            }
            
            imageScrollView.displayImage(capturedImage!.scaleToSize(imageSize))
        }
        
        if videoURL != nil {
            viewImageContainer.hidden = true
            viewVideoContainer.hidden = false
            self.labelPageTitle.text = "Preview Video"
            player = AVPlayer(URL: videoURL!)
            
            if player != nil {
                let layer = AVPlayerLayer(player: player)
                
                layer.frame = CGRectMake(0, 0, 375, 667)
                
                layer.backgroundColor = UIColor.blackColor().CGColor
                
                layer.videoGravity = AVLayerVideoGravityResizeAspectFill
                
                player!.actionAtItemEnd = AVPlayerActionAtItemEnd.None
                
                viewVideoPreview.layer.addSublayer(layer)
                
                player!.play()
                
                NSNotificationCenter.defaultCenter().addObserver(self,
                                                                 selector: #selector(playerItemDidReachEnd),
                                                                 name: AVPlayerItemDidPlayToEndTimeNotification,
                                                                 object: player!.currentItem)
            }
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBarHidden = true
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "sid_next" {
            let controller = segue.destinationViewController as! SelectCategoryViewController
            controller.fromCameraPage = true
        }
        
    }

    @IBAction func onBack(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
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
    
    @IBAction func onNext(sender: AnyObject) {
        
        if self.withoutCaptionInput {
            if self.callback != nil {
                if let method = self.callback!.imageTaken {
                    method(self.capturedImage, caption: nil, description: nil)
                }
            }
            self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
            
        } else {
            
            if capturedImage != nil {
                
                PostKeeper.keeper.mediaType = 0
                
                var imageSize = capturedImage!.size
                let containerSize = imageScrollView.frame.size
                
                if imageSize.width < containerSize.width {
                    let ratio = containerSize.width / imageSize.width
                    imageSize.width = containerSize.width
                    imageSize.height = imageSize.height * ratio
                }
                
                if imageSize.height < containerSize.height {
                    let ratio = containerSize.height / imageSize.height
                    imageSize.height = containerSize.height
                    imageSize.width = imageSize.width * ratio
                }
                
                imageScrollView.displayImage(capturedImage!.scaleToSize(imageSize))
                
                PostKeeper.keeper.imageTaken = capturedImage
                
            }
            
            if videoURL != nil {
                
                PostKeeper.keeper.mediaType = 1
                PostKeeper.keeper.videoTaken = videoURL
                
            }
            self.performSegueWithIdentifier("sid_add_caption", sender: nil)
            
        }
        
    }
    
    @IBAction func onAddCaption(sender: AnyObject) {
        
    }
}
