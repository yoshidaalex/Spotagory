//
//  FindPeopleViewController.swift
//  Spotagory
//
//  Created by Admin on 29/11/2016.
//  Copyright © 2016 Spotagory. All rights reserved.
//

import UIKit
import MBProgressHUD

class FollowerViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    @IBOutlet weak var tableViewMain: UITableView!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var lblTitle: UILabel!
    
    var user_data : [AnyObject]? = nil
    var total_count : Int = 0
    
    var page_number : Int = 1
    var more_load : Bool = false
    var offset : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        self.tableViewMain.tableFooterView = UIView()
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        gesture.cancelsTouchesInView = false
        self.tableViewMain.addGestureRecognizer(gesture)
        
        loadFollower()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBarHidden = true
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.user_data == nil || self.user_data!.count == 0 {
            return 0
        }
        return self.user_data!.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("PeopleCell") as! PeopleCell
        cell.configure()
        
        let item = self.user_data![indexPath.row] as! NSDictionary
        let folower = item.objectForKey("follower") as! [String : AnyObject]
        
        cell.img_userAvatar.layer.masksToBounds = true
        cell.img_userAvatar.layer.cornerRadius = 30
        cell.img_userAvatar.layer.borderWidth = 1
        
        let avatar_link = folower["avatar"] as? String
        
        if (avatar_link != "") {
            cell.img_userAvatar.sd_setImageWithURL(NSURL(string: avatar_link!), placeholderImage: nil)
        } else {
            cell.img_userAvatar.image = UIImage(named:"img_profile_placeholder")
        }
        
        cell.lblLocation.text = String(format: "%@, %@", (folower["city"] as? String)!, (folower["country"] as? String)!)
        
        cell.btnFollow.addTarget(self, action: #selector(FollowerViewController.setFollowing(_:)), forControlEvents: .TouchUpInside)
        
        if indexPath.row == self.user_data!.count - 1 {
            if self.more_load {
                self.offset = true
                self.loadFollower()
            }
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let item = self.user_data![indexPath.row] as! NSDictionary
        
        let viewCon = self.storyboard?.instantiateViewControllerWithIdentifier("ProfileDetailsViewController") as! ProfileDetailsViewController
        viewCon.bNavigation = false
        viewCon.userData = item.objectForKey("follower") as? NSDictionary
        self.presentViewController(viewCon, animated: true, completion: nil)
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        searchBar.resignFirstResponder()
    }
    
    func dismissKeyboard() {
        searchBar.resignFirstResponder()
    }
    
    @IBAction func actionClose(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func loadFollower() {
        
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        
        let token = SpotagoryKeeper.keeper.getUserToken() as String
        
        let api_link = String(format: "/users/%@/followers?page=%d", SpotagoryKeeper.keeper.getUserId()!, self.page_number)
        
        SpotagoryAPI.sendGetRequest(api_link, token: token, params: nil, completion: {(response, error) -> Void in
            
            if (response != nil) {
                
                MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
                
                print("response \(response)")
                
                let _meta = response!.objectForKey("_meta") as? NSDictionary
                
                if let resultCode = _meta!.objectForKey("status_code") as? NSNumber {
                    if resultCode.intValue == 200 {
                        
                        let pagination = _meta!.objectForKey("pagination") as? NSDictionary
                        
                        self.total_count = (pagination?.objectForKey("total_count") as? Int)!
                        
                        if let data = response!.objectForKey("data") as? [AnyObject] {
                            if self.offset {
                                for (v) in data {
                                    self.user_data!.append(v)
                                }
                            } else {
                                self.user_data = data
                            }
                            
                            if self.user_data?.count < self.total_count {
                                self.more_load = true
                                self.page_number += 1
                            } else {
                                self.more_load = false
                            }
                            
                            self.tableViewMain.reloadData()
                        }
                        
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
    
    func showErroralert(alert : String) {
        let alertController = UIAlertController(title: nil, message: alert, preferredStyle: .Alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func setFollowing(sender : UIButton) {
        var item = self.user_data![sender.tag] as! [String : AnyObject]
        
    }
}