//
//  NewsFeedViewController.swift
//  Spotagory
//
//  Created by Messia Engineer on 9/2/16.
//  Copyright © 2016 Spotagory. All rights reserved.
//

import UIKit
import CoreLocation
import MBProgressHUD
import AVKit
import AVFoundation

enum TabTypes {
    case Local
    case Friend
}

protocol ChangeRadiusDelegate {
    func getRadius(max : Int, min : Int)
}

protocol FilterDelegate {
    func getCategoryFilter(categoryId : String)
}

class NewsFeedViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, PostCellDelegate, UIGestureRecognizerDelegate, CLLocationManagerDelegate, ChangeRadiusDelegate, FilterDelegate  {

    var bLoadedView: Bool = false
    var locationManager : CLLocationManager!
    var latitude : String = ""
    var longitude : String = ""
    
    var feed_data : [AnyObject]? = nil
    var max_distance : Int = 100000
    var min_distance : Int = 1
    var page_number : Int = 1
    var more_load : Bool = false
    var offset : Bool = false
    var categoryId : String = ""
    
    @IBOutlet weak var tableViewMain: UITableView!
    
    @IBOutlet weak var imgUserAvatar: UIImageView!
    @IBOutlet weak var lblNotificationCnt: UILabel!
    @IBOutlet weak var viewNotification: UIView!
    
    var delegate : MenuShowDelegate? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestWhenInUseAuthorization()
        
            locationManager.startUpdatingLocation()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if (bLoadedView) {
            return
        }
        
        bLoadedView = true
        
        self.navigationController?.navigationBarHidden = true
        
        imgUserAvatar.layer.masksToBounds = true
        imgUserAvatar.layer.cornerRadius = 15
        imgUserAvatar.layer.borderWidth = 1
        imgUserAvatar.layer.borderColor = UIColor.whiteColor().CGColor
        
        viewNotification.layer.cornerRadius = 10
        viewNotification.layer.borderWidth = 0.8
        viewNotification.layer.borderColor = UIColor(colorLiteralRed: 199.0/255.0, green: 99.0/255.0, blue: 5.0/255.0, alpha: 1).CGColor
        
        viewNotification.hidden = true
        
        let logged_user = SpotagoryKeeper.keeper.loadUserProfile()
        let avatar_link = logged_user?.objectForKey("avatar") as? String
        
        if (avatar_link != "") {
            imgUserAvatar.sd_setImageWithURL(NSURL(string: avatar_link!), placeholderImage: nil)
        } else {
            imgUserAvatar.image = UIImage(named:"img_profile_placeholder")
        }
        
        self.view.layoutIfNeeded()
    }
    
    override func viewDidAppear(animated: Bool) {
        self.more_load = false
        self.page_number = 1
        self.feed_data = nil
        self.offset = false
        if self.latitude == "" {
            self.latitude = String(SpotagoryKeeper.keeper.getCurrentLatitude())
            self.longitude = String(SpotagoryKeeper.keeper.getCurrentLongitude())
        }
        
        loadFeed()
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "sid_find_people" {
            let controller = segue.destinationViewController as! InviteFriendsViewController
            controller.isFromNewsFeed = true
        }
    }
    
    @IBAction func actionNotification(sender: AnyObject) {
        if self.delegate != nil {
            self.delegate!.showMenu()
        }
    }
    
    @IBAction func actionFilter(sender: AnyObject) {
        let viewCon = self.storyboard?.instantiateViewControllerWithIdentifier("FilterViewController") as! FilterViewController!
        viewCon.delegate = self
        self.presentViewController(viewCon!, animated: true, completion: nil)
    }
    
    @IBAction func actionChangeRadius(sender: AnyObject) {
        let viewCon = self.storyboard?.instantiateViewControllerWithIdentifier("ChangeRadiusViewController") as! ChangeRadiusViewController!
        viewCon.delegate = self
        self.presentViewController(viewCon!, animated: true, completion: nil)
    }
    
    func loadFeed() {
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        
        let token = SpotagoryKeeper.keeper.getUserToken() as String
        
        var api_link : String = ""
        if categoryId != "" {
            api_link = String(format: "/near-posts?longitude=%@&latitude=%@&max_distance=%d&min_distance=%d&page=%d&per_page=5&category=%@", longitude, latitude, max_distance, min_distance, page_number, categoryId)
        } else {
            api_link = String(format: "/near-posts?longitude=%@&latitude=%@&max_distance=%d&min_distance=%d&page=%d&per_page=5", longitude, latitude, max_distance, min_distance, page_number)
        }
        
        SpotagoryAPI.sendGetRequest(api_link, token: token, params: nil, completion: {(response, error) -> Void in
            
            if (response != nil) {
                MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
                
                print("response \(response)")
                
                let _meta = response!.objectForKey("_meta") as? NSDictionary
                
                if let resultCode = _meta!.objectForKey("status_code") as? NSNumber {
                    if resultCode.intValue == 200 {
                        
                        let pagination = _meta!.objectForKey("pagination") as? NSDictionary
                        
                        if let more = pagination!.objectForKey("more") as? Bool where more
                        {
                            self.more_load = true
                            self.page_number += 1
                        } else {
                            self.more_load = false
                        }
                        
                        if let value = response!.objectForKey("data") as? [AnyObject] {
                            
                            if self.offset {
                                for (v) in value {
                                    self.feed_data!.append(v)
                                }
                            } else {
                                self.feed_data = value
                            }
                            
                            print(self.feed_data)
                            
                            self.tableViewMain.reloadData()
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
    
    func onAddUser() {
        self.performSegueWithIdentifier("sid_find_people", sender: nil)
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.feed_data == nil || self.feed_data!.count == 0 {
            return 0
        }
        return self.feed_data!.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
            return 424
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("PostCell") as! PostCell
        cell.viewContainer.layer.masksToBounds = true
        cell.viewContainer.layer.cornerRadius = 10
        cell.viewContainer.layer.shadowOffset = CGSizeMake(2, 2)
        cell.viewContainer.layer.shadowColor = UIColor.lightGrayColor().CGColor
        cell.viewContainer.layer.shadowRadius = 2
        cell.viewComment.layer.cornerRadius = 13
        cell.constraintForImageHeight.constant = 240
        cell.constraintForButton.constant = 240
        cell.delegate = self
        cell.viewCategory.layer.cornerRadius = 12
        

        let item = self.feed_data![indexPath.row] as! NSDictionary
        
        let user_info = item.objectForKey("owner") as! [String : AnyObject]
        let avatar_link = user_info["avatar"] as? String
        
        if (avatar_link != "") {
            cell.postUserAvatar.sd_setImageWithURL(NSURL(string: avatar_link!), placeholderImage: nil)
        } else {
            cell.postUserAvatar.image = UIImage(named:"img_profile_placeholder")
        }
        cell.postUserAvatar.layer.masksToBounds = true
        cell.postUserAvatar.layer.cornerRadius = 15
        cell.postUserAvatar.layer.borderWidth = 1
        cell.postUserAvatar.layer.borderColor = UIColor(colorLiteralRed: 199.0/255.0, green: 99.0/255.0, blue: 5.0/255.0, alpha: 1).CGColor
        
        cell.lblUserName.text = String(format: "@%@", (user_info["username"] as? String)!)
        
        let category = item.objectForKey("category") as? [String : AnyObject]
        
        cell.viewCategory.backgroundColor = UIColor(hexString: (category!["color"] as? String)!)
        cell.lblCategory.text = category!["name"] as? String
        cell.btnCategory.tag = indexPath.row
        cell.btnCategory.addTarget(self, action: #selector(NewsFeedViewController.goCategorydata(_:)), forControlEvents: .TouchUpInside)
        
        cell.lblLikeCount.text = String(format: "%d", (item.objectForKey("like_count") as? Int)!)
        cell.lblCommentCount.text = String(format: "%d", (item.objectForKey("comment_count") as? Int)!)
        
        cell.lblDescription.text = item.objectForKey("caption") as? String
        
        var thumbnail : String = ""
        
        if (item.objectForKey("media_type") as? NSNumber)! == 1 {
            cell.icon_video.hidden = true
            thumbnail = (item.objectForKey("media") as? String)!
        } else {
            cell.icon_video.hidden = false
            thumbnail = (item.objectForKey("thumbnail") as? String)!
        }
        
        cell.img_thumbnail.sd_setImageWithURL(NSURL(string: thumbnail), placeholderImage: nil)
        
        cell.btnSelectImage.tag = indexPath.row
        cell.btnSelectImage.addTarget(self, action: #selector(NewsFeedViewController.goFullScreenImage(_:)), forControlEvents: .TouchUpInside)
        
//        let coordinate = item.objectForKey("coordinates") as? NSArray
//        let longitude :CLLocationDegrees = (coordinate![1] as? Double)!
//        let latitude :CLLocationDegrees = (coordinate![0] as? Double)!
//        
//        let location = CLLocation(latitude: latitude, longitude: longitude)
//        self.getAddressWithCoordinates(location) { (error, address) in
//            print(address)
            cell.lblMilesLocation.text = String(format: "%.2f Miles away", (item.objectForKey("distance") as? Float)!)
//        }
        
        let time : String = (item.objectForKey("createdAt") as? String)!
        cell.lblTime.text = time.toDateTime().timeAgoSimple
        
        cell.btnLike.tag = indexPath.row
        cell.btnLike.addTarget(self, action: #selector(NewsFeedViewController.setLike(_:)), forControlEvents: .TouchUpInside)
        if let like_status = item.objectForKey("like_status") as? Bool where like_status
        {
            cell.btnLike.setImage(UIImage(named: "icon_like_active"), forState: UIControlState.Normal)
        } else {
            cell.btnLike.setImage(UIImage(named: "icon_like_deactive"), forState: UIControlState.Normal)
        }
        
        cell.btnComment.tag = indexPath.row
        cell.btnComment.addTarget(self, action: #selector(NewsFeedViewController.goComment(_:)), forControlEvents: .TouchUpInside)
        
        if indexPath.row == self.feed_data!.count - 1 {
            if self.more_load {
                self.offset = true
                self.loadFeed()
            }
        }

        return cell
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func postCell(cell : PostCell, shareWithData data:AnyObject?) {
        let actionsheet = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
        actionsheet.addAction(UIAlertAction(title: "Report User", style: .Destructive, handler: nil))
        actionsheet.addAction(UIAlertAction(title: "Share on Facebook", style: .Default, handler: nil))
        actionsheet.addAction(UIAlertAction(title: "Twitter", style: .Default, handler: nil))
        actionsheet.addAction(UIAlertAction(title: "Delete", style: .Default, handler: nil))
        actionsheet.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        self.presentViewController(actionsheet, animated: true, completion: nil)
    }
    
    func goComment(sender : UIButton) {
        let item = self.feed_data![sender.tag] as! NSDictionary
        
        let viewCon = self.storyboard?.instantiateViewControllerWithIdentifier("ActivitiesViewController") as! ActivitiesViewController!
        viewCon.postId = item.objectForKey("_id") as? String
        self.navigationController?.pushViewController(viewCon, animated: true)
    }
    
    func goFullScreenImage(sender : UIButton) {
        let item = self.feed_data![sender.tag] as! NSDictionary
        
        if (item.objectForKey("media_type") as? NSNumber)! == 1 {   //photo
            let viewCon = self.storyboard?.instantiateViewControllerWithIdentifier("MediaFullScreenViewController") as! MediaFullScreenViewController!
            viewCon.postItem = item
            self.presentViewController(viewCon!, animated: true, completion: nil)
        } else {    //video
            let video_url = item.objectForKey("media") as? String
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
        var item = self.feed_data![sender.tag] as! [String : AnyObject]
        if let like_status = item["like_status"] as? Bool where like_status
        {
            item["like_status"] = false
            let like_count = item["like_count"] as? Int
            item["like_count"] = like_count! - 1
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.actionLike((item["_id"] as? String)!, status: false)
            })
            
        } else {
            item["like_status"] = true
            let like_count = item["like_count"] as? Int
            item["like_count"] = like_count! + 1
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.actionLike((item["_id"] as? String)!, status: true)
            })
        }
        
        self.feed_data![sender.tag] = item
        
        self.tableViewMain.reloadData()
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
    
    func goCategorydata(sender : UIButton) {
        var item = self.feed_data![sender.tag] as! [String : AnyObject]
        let category = item["category"] as? NSDictionary
        
        let viewCon = self.storyboard?.instantiateViewControllerWithIdentifier("CategoryDetailsViewController") as! CategoryDetailsViewController!
        viewCon.categoryData = category
        self.navigationController?.pushViewController(viewCon!, animated: true)
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation:CLLocation = locations[0] as CLLocation
        
        // Call stopUpdatingLocation() to stop listening for location updates,
        // other wise this function will be called every time when user location changes.
        
        // manager.stopUpdatingLocation()
        
//        print("test location:", userLocation.coordinate.latitude)
        
        self.latitude = String(userLocation.coordinate.latitude)
        self.longitude = String(userLocation.coordinate.longitude)
        
        SpotagoryKeeper.keeper.setCurrentLongitude(userLocation.coordinate.longitude)
        SpotagoryKeeper.keeper.setCurrentLatitude(userLocation.coordinate.latitude)

    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError)
    {
        print("Error \(error)")
    }
    
    func getAddressWithCoordinates(location : CLLocation, successBlock:((error:NSError?, address:String)->Void)) -> Void {
        var strAddress: String = "Unknown location"
        
        let geoCoder = CLGeocoder()
        
        geoCoder.reverseGeocodeLocation(location)
        {
            (placemarks, error) -> Void in
            
            if error != nil {
                successBlock(error: error, address: strAddress)
                
                return
            }
            
            strAddress = ""
            
            let placeArray = placemarks as [CLPlacemark]!
            
            // Place details
            var placeMark: CLPlacemark!
            placeMark = placeArray?[0]
            
            print(placeMark)
            // Location name
            if let _ = placeMark.addressDictionary?["Name"] as? String
            {
            }
            
            // Street address
            if let street = placeMark.addressDictionary?["Thoroughfare"] as? String
            {
                strAddress.appendContentsOf(street)
            }
            
            // City
            if let city = placeMark.addressDictionary?["City"] as? String
            {
                strAddress.appendContentsOf(", ")
                strAddress.appendContentsOf(city)
            }
            
            successBlock(error: error, address:strAddress)
        }
    }
    
    func getRadius(max : Int, min : Int) {
        print(max, min)
//        max_distance = max
        max_distance = 100000
        min_distance = min
    }
    
    func getCategoryFilter(categoryId : String) {
        print(categoryId)
        self.categoryId = categoryId
    }
}
