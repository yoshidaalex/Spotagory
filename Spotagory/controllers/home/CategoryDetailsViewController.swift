//
//  CategoryDetailsViewController.swift
//  Spotagory
//
//  Created by Admin on 29/11/2016.
//  Copyright © 2016 Spotagory. All rights reserved.
//

import UIKit
import MBProgressHUD
import AVKit
import AVFoundation

class CategoryDetailsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var isGrid = false
    var isAll = true
    var isPhoto = true
    
    @IBOutlet weak var category_title: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var btnAll: UIButton!
    @IBOutlet weak var btnPhoto: UIButton!
    @IBOutlet weak var btnVideo: UIButton!
    @IBOutlet weak var btnGridAndList: UIButton!
    
    @IBOutlet weak var m_constraintLeft: NSLayoutConstraint!
    
    var categoryData : NSDictionary?
    var categoryId : String?
    
    var category_AllData = [AnyObject]()
    var category_PhotoData = [AnyObject]()
    var category_VideoData = [AnyObject]()
    
    var page_number : Int = 1
    var more_load : Bool = false
    var offset : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.automaticallyAdjustsScrollViewInsets = false
        
        btnAll.setTitleColor(UIColor.init(colorLiteralRed: 215.0/255.0, green: 134.0/255.0, blue: 18.0/255.0, alpha: 1.0), forState: .Normal)
        
        collectionView.registerNib(UINib(nibName: "ProfileGrid", bundle: nil), forCellWithReuseIdentifier: "profGrid")
        collectionView.registerNib(UINib(nibName: "FeedViewCell", bundle: nil), forCellWithReuseIdentifier: "feedHomeCell")
        
        category_title.text = categoryData?.objectForKey("name") as? String
        categoryId = categoryData?.objectForKey("_id") as? String
        
        loadCategoryData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    @IBAction func actionBack(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func actionReport(sender: AnyObject) {
        
    }
    
    @IBAction func actionSelectStatus(sender: UIButton) {
        let active_color = UIColor.init(colorLiteralRed: 215.0/255.0, green: 134.0/255.0, blue: 18.0/255.0, alpha: 1.0)
        let color = UIColor.darkGrayColor()
        
        switch sender.tag {
            case 10:    //all
                isAll = true
                btnAll.setTitleColor(active_color, forState: .Normal)
                btnPhoto.setTitleColor(color, forState: .Normal)
                btnVideo.setTitleColor(color, forState: .Normal)
                
                UIView.animateWithDuration(0.3, animations: {
                    self.m_constraintLeft.constant = 0
                    self.view.layoutIfNeeded()
                    }, completion: { (bFinished: Bool) -> Void in
                        if (bFinished) {
                            
                        }
                })
                break
            case 11:    //photo
                isPhoto = true
                isAll = false
                btnPhoto.setTitleColor(active_color, forState: .Normal)
                btnAll.setTitleColor(color, forState: .Normal)
                btnVideo.setTitleColor(color, forState: .Normal)
                
                UIView.animateWithDuration(0.3, animations: {
                    self.m_constraintLeft.constant = UIScreen.mainScreen().bounds.size.width / 4.0
                    self.view.layoutIfNeeded()
                    }, completion: { (bFinished: Bool) -> Void in
                        if (bFinished) {
                            
                        }
                })
                break
            case 12:    //video
                isPhoto = false
                isAll = false
                btnVideo.setTitleColor(active_color, forState: .Normal)
                btnAll.setTitleColor(color, forState: .Normal)
                btnPhoto.setTitleColor(color, forState: .Normal)
                
                UIView.animateWithDuration(0.3, animations: {
                    self.m_constraintLeft.constant = UIScreen.mainScreen().bounds.size.width / 2.0
                    self.view.layoutIfNeeded()
                    }, completion: { (bFinished: Bool) -> Void in
                        if (bFinished) {
                            
                        }
                })
                break
            case 13:    //list or grid
                isGrid = !isGrid
                if isGrid {
                    btnGridAndList.setImage(UIImage(named: "icon_stack_black"), forState: .Normal)
                } else {
                    btnGridAndList.setImage(UIImage(named: "icon_list_black"), forState: .Normal)
                }
                break
            default:
                break
        }
        
        collectionView.reloadData()
    }
    
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        if isGrid {
            let length = (UIScreen.mainScreen().bounds.width) / 3
            return CGSizeMake(length - 1,length);
        } else {
            return CGSizeMake(UIScreen.mainScreen().bounds.width, 425)
        }
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if self.isAll {
            return self.category_AllData.count
        } else if self.isPhoto {
            return self.category_PhotoData.count
        } else {
            return self.category_VideoData.count
        }
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let profGrid = collectionView.dequeueReusableCellWithReuseIdentifier("profGrid", forIndexPath: indexPath) as! ProfileGrid
        let feedHomeCell = collectionView.dequeueReusableCellWithReuseIdentifier("feedHomeCell", forIndexPath: indexPath) as! FeedViewCell
        
        var item : NSDictionary?
        if self.isAll {
            item = self.category_AllData[indexPath.row] as! NSDictionary
        } else if self.isPhoto {
            item = self.category_PhotoData[indexPath.row] as! NSDictionary
        } else {
            item = self.category_VideoData[indexPath.row] as! NSDictionary
        }
        
        if isGrid {
            
            var thumbnail : String = ""
            
            if (item!.objectForKey("media_type") as? NSNumber)! == 1 {
                profGrid.video_icon.hidden = true
                thumbnail = (item!.objectForKey("media") as? String)!
            } else {
                profGrid.video_icon.hidden = false
                thumbnail = (item!.objectForKey("thumbnail") as? String)!
            }
            
            profGrid.thumbnail.sd_setImageWithURL(NSURL(string: thumbnail), placeholderImage: nil)
            
            profGrid.btnSelect.tag = indexPath.row
            profGrid.btnSelect.addTarget(self, action: #selector(CategoryDetailsViewController.goFullScreenImage(_:)), forControlEvents: .TouchUpInside)
            
            return profGrid
        } else  {
            
            feedHomeCell.viewContainer.layer.masksToBounds = true
            feedHomeCell.viewContainer.layer.cornerRadius = 10
            feedHomeCell.viewContainer.layer.shadowOffset = CGSizeMake(2, 2)
            feedHomeCell.viewContainer.layer.shadowColor = UIColor.lightGrayColor().CGColor
            feedHomeCell.viewContainer.layer.shadowRadius = 2
            feedHomeCell.viewComment.layer.cornerRadius = 13
            feedHomeCell.viewCategory.layer.cornerRadius = 12
            feedHomeCell.constraintForImageHeight.constant = 240
            feedHomeCell.contraintForButton.constant = 240
            
            let user_info = item!.objectForKey("owner") as! [String : AnyObject]
            let avatar_link = user_info["avatar"] as? String
            
            if (avatar_link != "") {
                feedHomeCell.postUserAvatar.sd_setImageWithURL(NSURL(string: avatar_link!), placeholderImage: nil)
            } else {
                feedHomeCell.postUserAvatar.image = UIImage(named:"img_profile_placeholder")
            }
            
            feedHomeCell.postUserAvatar.layer.masksToBounds = true
            feedHomeCell.postUserAvatar.layer.cornerRadius = 15
            feedHomeCell.postUserAvatar.layer.borderWidth = 1
            feedHomeCell.postUserAvatar.layer.borderColor = UIColor(colorLiteralRed: 199.0/255.0, green: 99.0/255.0, blue: 5.0/255.0, alpha: 1).CGColor
            
            feedHomeCell.lblUsername.text = String(format: "@%@", (user_info["username"] as? String)!)
            
            let category = item!.objectForKey("category") as? [String : AnyObject]
            
            feedHomeCell.viewCategory.backgroundColor = UIColor(hexString: (category!["color"] as? String)!)
            feedHomeCell.lblCategory.text = category!["name"] as? String
            
            feedHomeCell.lblLikeCount.text = String(format: "%d", (item!.objectForKey("like_count") as? Int)!)
            feedHomeCell.lblCommentCount.text = String(format: "%d", (item!.objectForKey("comment_count") as? Int)!)
            
            feedHomeCell.lblDescription.text = item!.objectForKey("caption") as? String
            
            var thumbnail : String = ""
            
            if (item!.objectForKey("media_type") as? NSNumber)! == 1 {
                feedHomeCell.icon_video.hidden = true
                thumbnail = (item!.objectForKey("media") as? String)!
            } else {
                feedHomeCell.icon_video.hidden = false
                thumbnail = (item!.objectForKey("thumbnail") as? String)!
            }
            
            feedHomeCell.img_thumbnail.sd_setImageWithURL(NSURL(string: thumbnail), placeholderImage: nil)
            
            feedHomeCell.btnSelectImage.tag = indexPath.row
            feedHomeCell.btnSelectImage.addTarget(self, action: #selector(CategoryDetailsViewController.goFullScreenImage(_:)), forControlEvents: .TouchUpInside)
            
//            feedHomeCell.lblMilesLocation.text = String(format: "%.2f Miles away", (item!.objectForKey("distance") as? Float)!)
            
            let time : String = (item!.objectForKey("createdAt") as? String)!
            feedHomeCell.lblTime.text = time.toDateTime().timeAgoSimple
            
            feedHomeCell.btnLike.tag = indexPath.row
            feedHomeCell.btnLike.addTarget(self, action: #selector(CategoryDetailsViewController.setLike(_:)), forControlEvents: .TouchUpInside)
            if let like_status = item!.objectForKey("like_status") as? Bool where like_status
            {
                feedHomeCell.btnLike.setImage(UIImage(named: "icon_like_active"), forState: UIControlState.Normal)
            } else {
                feedHomeCell.btnLike.setImage(UIImage(named: "icon_like_deactive"), forState: UIControlState.Normal)
            }
            
            feedHomeCell.btnComment.tag = indexPath.row
            feedHomeCell.btnComment.addTarget(self, action: #selector(CategoryDetailsViewController.goComment(_:)), forControlEvents: .TouchUpInside)
            
            if self.isAll {
                if indexPath.row == self.category_AllData.count - 1 {
                    if self.more_load {
                        self.offset = true
                        self.loadCategoryData()
                    }
                }
            } else if self.isPhoto {
                if indexPath.row == self.category_PhotoData.count - 1 {
                    if self.more_load {
                        self.offset = true
                        self.loadCategoryData()
                    }
                }
            } else {
                if indexPath.row == self.category_VideoData.count - 1 {
                    if self.more_load {
                        self.offset = true
                        self.loadCategoryData()
                    }
                }
            }
            
            return feedHomeCell
        }
    }
    
    func goComment(sender : UIButton) {
        var item : NSDictionary?
        if self.isAll {
            item = self.category_AllData[sender.tag] as! NSDictionary
        } else if self.isPhoto {
            item = self.category_PhotoData[sender.tag] as! NSDictionary
        } else {
            item = self.category_VideoData[sender.tag] as! NSDictionary
        }
        
        let viewCon = self.storyboard?.instantiateViewControllerWithIdentifier("ActivitiesViewController") as! ActivitiesViewController!
        viewCon.postId = item!.objectForKey("_id") as? String
        self.navigationController?.pushViewController(viewCon, animated: true)
    }
    
    func goFullScreenImage(sender : UIButton) {
        var item : NSDictionary?
        if self.isAll {
            item = self.category_AllData[sender.tag] as! NSDictionary
        } else if self.isPhoto {
            item = self.category_PhotoData[sender.tag] as! NSDictionary
        } else {
            item = self.category_VideoData[sender.tag] as! NSDictionary
        }
        
        if (item!.objectForKey("media_type") as? NSNumber)! == 1 {   //photo
            let viewCon = self.storyboard?.instantiateViewControllerWithIdentifier("MediaFullScreenViewController") as! MediaFullScreenViewController!
            viewCon.postItem = item
            self.presentViewController(viewCon!, animated: true, completion: nil)
        } else {    //video
            let video_url = item!.objectForKey("media") as? String
            playVideo(NSURL(string: video_url!)!)
        }
    }
    
    func playVideo(videoURL: NSURL){
        let player = AVPlayer(URL: videoURL)
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        self.presentViewController(playerViewController, animated: true) {
            playerViewController.player!.play()
        }
    }
    
    func setLike(sender: UIButton){
        
        var item : [String : AnyObject]?
        if self.isAll {
            item = self.category_AllData[sender.tag] as! [String : AnyObject]
        } else if self.isPhoto {
            item = self.category_PhotoData[sender.tag] as! [String : AnyObject]
        } else {
            item = self.category_VideoData[sender.tag] as! [String : AnyObject]
        }
        
        if let like_status = item!["like_status"] as? Bool where like_status
        {
            item!["like_status"] = false
            let like_count = item!["like_count"] as? Int
            item!["like_count"] = like_count! - 1
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.actionLike((item!["_id"] as? String)!, status: false)
            })
            
        } else {
            item!["like_status"] = true
            let like_count = item!["like_count"] as? Int
            item!["like_count"] = like_count! + 1
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.actionLike((item!["_id"] as? String)!, status: true)
            })
        }
        
        if self.isAll {
            self.category_AllData[sender.tag] = item!
        } else if self.isPhoto {
            self.category_PhotoData[sender.tag] = item!
        } else {
            self.category_VideoData[sender.tag] = item!
        }
        
        self.collectionView.reloadData()
    }
    
    func actionLike(postID : String, status : Bool) {
        
        let token = SpotagoryKeeper.keeper.getUserToken() as String
        
        var api_link : String = ""
        if status {
            api_link = "/posts/like"
        } else {
            api_link = "/posts/unlike"
        }
        let params = ["post":postID]
        
        SpotagoryAPI.sendPostRequest(api_link, token: token, params: params, completion: {(response, error) -> Void in
            
            if (response != nil) {
                MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
                
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
                MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
                print("error \(error)")
            }
        })
    }
    
    func loadCategoryData() {
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        
        let token = SpotagoryKeeper.keeper.getUserToken() as String
        
        let api_link = String(format: "/posts?category=%@&page=%d&per_page=5", self.categoryId!, page_number)
        
        SpotagoryAPI.sendGetRequest(api_link, token: token, params: nil, completion: {(response, error) -> Void in
            
            if (response != nil) {
                MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
                
                print("response \(response)")
                
                let _meta = response!.objectForKey("_meta") as? NSDictionary
                
                if let resultCode = _meta!.objectForKey("status_code") as? NSNumber {
                    if resultCode.intValue == 200 {
                        
                        let pagination = _meta!.objectForKey("pagination") as? NSDictionary
                        
                        let total_count = pagination!.objectForKey("total_count") as? Int
                        
                        if let value = response!.objectForKey("data") as? [AnyObject] {
                            
                            if self.offset {
                                for (v) in value {
                                    
                                    let media_type = v["media_type"] as? NSNumber
                                    
                                    self.category_AllData.append(v)
                                    
                                    if media_type == 1 {
                                        self.category_PhotoData.append(v)
                                    } else if media_type == 2 {
                                        self.category_VideoData.append(v)
                                    }
                                }
                            } else {
                                self.category_AllData = value
                                
                                for (v) in value {
                                    let media_type = v["media_type"] as? NSNumber
                                    if media_type == 1 {
                                        self.category_PhotoData.append(v)
                                    } else if media_type == 2 {
                                        self.category_VideoData.append(v)
                                    }
                                }
                            }
                            
                            if self.category_AllData.count < total_count
                            {
                                self.more_load = true
                                self.page_number += 1
                            } else {
                                self.more_load = false
                            }

                            
                            print(self.category_AllData)
                            print(self.category_PhotoData)
                            print(self.category_VideoData)
                            
                            self.collectionView.reloadData()
                            return
                        }
                        
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
                MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
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