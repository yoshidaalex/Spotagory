//
//  MediaFullScreenViewController.swift
//  Spotagory
//
//  Created by Messia Engineer on 9/5/16.
//  Copyright © 2016 Spotagory. All rights reserved.
//

import UIKit

class MediaFullScreenViewController: UIViewController {

    var bShow : Bool = false
    var postItem : NSDictionary?
    
    @IBOutlet weak var imageScrollViewMain: ImageScrollView!

    @IBOutlet weak var postedImg: UIImageView!
    @IBOutlet weak var viewFollow: UIView!
    @IBOutlet weak var topContraint: NSLayoutConstraint!
    @IBOutlet weak var bottomContraint: NSLayoutConstraint!
    
    @IBOutlet weak var lblUsername: UILabel!
    @IBOutlet weak var lblMiles: UILabel!
    
    @IBOutlet weak var lblLikeCount: UILabel!
    @IBOutlet weak var lblCommentCount: UILabel!
    @IBOutlet weak var lblViewCount: UILabel!
    
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var img_userAvatar: UIImageView!
    
    var user_info : [String : AnyObject]?
    
    @IBOutlet weak var lblFollow: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        user_info = postItem!.objectForKey("owner") as! [String : AnyObject]
        
        lblUsername.text = String(format: "@%@", (user_info!["username"] as? String)!)
        
//        lblMiles.text = String(format: "%.2f Miles away", (postItem!.objectForKey("distance") as? Float)!)
//        
        let avatar_link = user_info!["avatar"] as? String
        
        img_userAvatar.layer.masksToBounds = true
        img_userAvatar.layer.cornerRadius = 15.0
        img_userAvatar.layer.borderWidth = 1
        img_userAvatar.layer.borderColor = UIColor(colorLiteralRed: 199.0/255.0, green: 99.0/255.0, blue: 5.0/255.0, alpha: 1).CGColor
        
        if (avatar_link != "") {
            img_userAvatar.sd_setImageWithURL(NSURL(string: avatar_link!), placeholderImage: nil)
        } else {
            img_userAvatar.image = UIImage(named:"img_profile_placeholder")
        }
        
        let time : String = (postItem!.objectForKey("createdAt") as? String)!
        lblTime.text = time.toDateTime().timeAgoSimple
        
        let thumbnail = (postItem!.objectForKey("media") as? String)!
        postedImg.sd_setImageWithURL(NSURL(string: thumbnail), placeholderImage: nil)
        
        lblLikeCount.text = String(format: "%d", (postItem!.objectForKey("like_count") as? Int)!)
        lblCommentCount.text = String(format: "%d", (postItem!.objectForKey("comment_count") as? Int)!)
        lblViewCount.text = String(format: "%d", (postItem!.objectForKey("views") as? Int)!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        viewFollow.layer.borderWidth = 1
        viewFollow.layer.borderColor = UIColor.whiteColor().CGColor
        viewFollow.layer.cornerRadius = viewFollow.frame.size.height / 2
        
    }
    @IBAction func actionClick(sender: AnyObject) {
        bShow = !bShow
        
        if bShow {
                UIView.animateWithDuration(0.3, animations: {
                    self.topContraint.constant = 0
                    self.bottomContraint.constant = 0
                    self.view.layoutIfNeeded()
                    }, completion: { (bFinished: Bool) -> Void in
                    if (bFinished) {
                    
                    }
                })
        } else {
            UIView.animateWithDuration(0.3, animations: {
                self.topContraint.constant = -90
                self.bottomContraint.constant = -60
                self.view.layoutIfNeeded()
                }, completion: { (bFinished: Bool) -> Void in
                    if (bFinished) {
                        
                    }
            })
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func onClose(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func actionProfile(sender: AnyObject) {
        let viewCon = self.storyboard?.instantiateViewControllerWithIdentifier("ProfileDetailsViewController") as! ProfileDetailsViewController
        viewCon.bNavigation = false
        viewCon.userData = user_info as? NSDictionary
        self.presentViewController(viewCon, animated: true, completion: nil)
        
    }
    
    @IBAction func actionFollow(sender: AnyObject) {
        self.lblFollow.text = "UnFollow"
//        self.lblFollow.text = "+Follow"
        
        setFollow()
//        setUnFollow()
    }
    
    func setFollow() {
        let token = SpotagoryKeeper.keeper.getUserToken() as String
        
        let user_id = self.user_info!["_id"] as? String
        let params = ["user": user_id!]
        
        SpotagoryAPI.sendPostRequest("/users/follow", token: token, params: params, completion: {(response, error) -> Void in
            
            if (response != nil) {
                
                print("response \(response)")
                
                let _meta = response!.objectForKey("_meta") as? NSDictionary
                
                if let resultCode = _meta!.objectForKey("status_code") as? NSNumber {
                    if resultCode.intValue == 200 {
                        
                        return
                        
                    } else {
                        if let error = _meta!.objectForKey("error") as? NSDictionary {
                            if let errorDescription = error.objectForKey("message") as? String {
                                self.showErroralert(errorDescription)
                                
                                return
                            }
                        }
                        
                    }
                }
                
            } else {
                print("error \(error)")
            }
        })
    }
    
    func setUnFollow() {
        let token = SpotagoryKeeper.keeper.getUserToken() as String
        
        let user_id = self.user_info!["_id"] as? String
        let params = ["user": user_id!]
        
        SpotagoryAPI.sendPostRequest("/users/unfollow", token: token, params: params, completion: {(response, error) -> Void in
            
            if (response != nil) {
                
                print("response \(response)")
                
                let _meta = response!.objectForKey("_meta") as? NSDictionary
                
                if let resultCode = _meta!.objectForKey("status_code") as? NSNumber {
                    if resultCode.intValue == 200 {
                        
                        return
                        
                    } else {
                        if let error = _meta!.objectForKey("error") as? NSDictionary {
                            if let errorDescription = error.objectForKey("message") as? String {
                                self.showErroralert(errorDescription)
                                
                                return
                            }
                        }
                        
                    }
                }
                
            } else {
                print("error \(error)")
            }
        })
    }
    
    func showErroralert(alert : String) {
        let alertController = UIAlertController(title: nil, message: alert, preferredStyle: .Alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
        self.presentViewController(alertController, animated: true, completion: nil)
    }
}
