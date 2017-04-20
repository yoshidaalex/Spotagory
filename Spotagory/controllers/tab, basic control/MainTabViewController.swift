//
//  MainTabViewController.swift
//  Tied
//
//  Created by Admin on 18/06/16.
//  Copyright © 2016 DevStar. All rights reserved.
//

import UIKit

protocol MenuShowDelegate {
    func showMenu()
}

protocol MainViewDelegate {
    func showFeed()
}

class MainTabViewController: UIViewController, MenuShowDelegate, MainViewDelegate {

    var curNaviCon: UINavigationController? = nil
    var nCurTabIndex: Int = 1
    
    var bLoadedView: Bool = false
    var bShowedMenu: Bool = false
    
    var fMenuViewWidth: CGFloat = 0
    
    @IBOutlet weak var m_subView: UIView!
    
    @IBOutlet weak var m_imgLocation: UIImageView!
    @IBOutlet weak var m_imgAddUser: UIImageView!
    
    @IBOutlet weak var m_menuView: UIView!
    @IBOutlet weak var m_constraintSeperator: NSLayoutConstraint!
    
    @IBOutlet weak var m_subConstraintSeperator: NSLayoutConstraint!
    
    @IBOutlet weak var m_profileContraintSeperator: NSLayoutConstraint!
    
    @IBOutlet weak var m_closeContraint: NSLayoutConstraint!
    
    @IBOutlet weak var lblFollowerCnt: UILabel!
    @IBOutlet weak var lblFollowingCnt: UILabel!
    
    
    @IBOutlet weak var img_userAvatar: UIImageView!
    @IBOutlet weak var lblUsername: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
        
        m_imgLocation.image = UIImage(named: "icon_active_home_location")
        
        addTabView()
        
        fMenuViewWidth = CGRectGetWidth(self.m_menuView.bounds)

        self.m_constraintSeperator.constant = fMenuViewWidth
        self.m_subConstraintSeperator.constant = -fMenuViewWidth
        self.m_profileContraintSeperator.constant = -fMenuViewWidth
        self.m_closeContraint.constant = -400
        
        let user_infor = SpotagoryKeeper.keeper.loadUserProfile()
        
        if let val = user_infor!["first_name"] {
            lblUsername.text = String(format: "%@ %@", (user_infor?.objectForKey("first_name") as? String)!, (user_infor?.objectForKey("last_name") as? String)!)
        } else {
            lblUsername.text = String(format: "%@", (user_infor?.objectForKey("username") as? String)!)
        }
        
        let avatar_link = user_infor!.objectForKey("avatar") as? String
        
        if (avatar_link != "") {
            img_userAvatar.sd_setImageWithURL(NSURL(string: avatar_link!), placeholderImage: nil)
        } else {
            img_userAvatar.image = UIImage(named:"img_profile_placeholder")
        }
        
        img_userAvatar.layer.masksToBounds = true
        img_userAvatar.layer.cornerRadius = 25
        img_userAvatar.layer.borderWidth = 1
    }
    
    override func viewWillAppear(animated: Bool) {
        self.view.layoutIfNeeded()
    }
    
    func showMenu() {
        bShowedMenu = true
        
        UIView.animateWithDuration(0.3, animations: {
            self.m_constraintSeperator.constant = 0
            self.m_subConstraintSeperator.constant = 0
            self.m_profileContraintSeperator.constant = 15
            self.m_closeContraint.constant = 0
            self.view.layoutIfNeeded()
            }, completion: { (bFinished: Bool) -> Void in
                if (bFinished) {
                    
                }
        })
        
        loadFollowCount()
    }
    
    func showFeed() {
        m_imgLocation.image = UIImage(named: "icon_active_home_location")
        m_imgAddUser.image = UIImage(named: "icon_add_friend.png")
        
        nCurTabIndex = 1
        
        addTabView()
    }
    
    func addTabView() {
        if ((curNaviCon != nil && nCurTabIndex != 2)) {
            curNaviCon?.willMoveToParentViewController(nil)
            curNaviCon?.view.removeFromSuperview()
            curNaviCon?.removeFromParentViewController()
        }
        
        switch nCurTabIndex {
            case 1:
                let viewCon = self.storyboard?.instantiateViewControllerWithIdentifier("NewsFeedViewController") as! NewsFeedViewController
                
                curNaviCon = UINavigationController.init(rootViewController: viewCon)
                curNaviCon!.navigationBarHidden = true
            
                viewCon.delegate = self
            
            case 3:
                let viewCon = self.storyboard?.instantiateViewControllerWithIdentifier("FindPeopleViewController") as! FindPeopleViewController
                
                curNaviCon = UINavigationController.init(rootViewController: viewCon)
                curNaviCon!.navigationBarHidden = true
                
            case 2:
                self.performSegueWithIdentifier("sid_category", sender: nil)
            
            default:
                curNaviCon = nil
        }
        
        if nCurTabIndex != 2 {
            if (curNaviCon != nil) {
                self.addChildViewController(curNaviCon!)
                self.m_subView.addSubview((curNaviCon?.view)!)
                curNaviCon?.didMoveToParentViewController(self)
            }
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
    @IBAction func actionLocation(sender: AnyObject) {
        
        m_imgLocation.image = UIImage(named: "icon_active_home_location")
        m_imgAddUser.image = UIImage(named: "icon_add_friend.png")
        
        nCurTabIndex = 1
        
        addTabView()
    }

    @IBAction func actionAddUser(sender: AnyObject) {
        m_imgLocation.image = UIImage(named: "icon_home_location")
        m_imgAddUser.image = UIImage(named: "icon_active_add_friend")
        
        nCurTabIndex = 3
        
        addTabView()
    }
    
    @IBAction func actionPlus(sender: AnyObject) {
        nCurTabIndex = 2
        
        addTabView()
    }
    
    @IBAction func actionViewProfile(sender: AnyObject) {
        
        UIView.animateWithDuration(0.3, animations: {
            self.m_constraintSeperator.constant = self.fMenuViewWidth
            self.m_subConstraintSeperator.constant = -self.fMenuViewWidth
            self.m_profileContraintSeperator.constant = -self.fMenuViewWidth
            self.m_closeContraint.constant = -400
            self.view.layoutIfNeeded()
            }, completion: { (bCompleted) -> Void in
                if (bCompleted) {
                    self.bShowedMenu = false
                }
        })
        
        let viewCon = self.storyboard?.instantiateViewControllerWithIdentifier("ProfileDetailsViewController") as! ProfileDetailsViewController!
        viewCon.delegate = self
        viewCon.userData = SpotagoryKeeper.keeper.loadUserProfile()
        
        curNaviCon = UINavigationController.init(rootViewController: viewCon)
        curNaviCon!.navigationBarHidden = true
        
        self.addChildViewController(curNaviCon!)
        self.m_subView.addSubview((curNaviCon?.view)!)
        curNaviCon?.didMoveToParentViewController(self)
        
//        self.navigationController?.pushViewController(viewCon, animated: true)
    }
    
    @IBAction func actionEditProfile(sender: AnyObject) {
        
//        UIView.animateWithDuration(0.3, animations: {
//            self.m_constraintSeperator.constant = self.fMenuViewWidth
//            self.m_subConstraintSeperator.constant = -self.fMenuViewWidth
//            self.m_profileContraintSeperator.constant = -self.fMenuViewWidth
//            self.m_closeContraint.constant = -400
//            self.view.layoutIfNeeded()
//            }, completion: { (bCompleted) -> Void in
//                if (bCompleted) {
//                    self.bShowedMenu = false
//                }
//        })
        
        let viewCon = self.storyboard?.instantiateViewControllerWithIdentifier("EditProfileViewController") as! EditProfileViewController!
        
//        curNaviCon = UINavigationController.init(rootViewController: viewCon)
//        curNaviCon!.navigationBarHidden = true
//        
//        self.addChildViewController(curNaviCon!)
//        self.m_subView.addSubview((curNaviCon?.view)!)
//        curNaviCon?.didMoveToParentViewController(self)
        
        self.navigationController?.pushViewController(viewCon, animated: true)
    }
    
    @IBAction func actionClose(sender: AnyObject) {
        UIView.animateWithDuration(0.3, animations: {
            self.m_constraintSeperator.constant = self.fMenuViewWidth
            self.m_subConstraintSeperator.constant = -self.fMenuViewWidth
            self.m_profileContraintSeperator.constant = -self.fMenuViewWidth
            self.m_closeContraint.constant = -400
            self.view.layoutIfNeeded()
            }, completion: { (bCompleted) -> Void in
                if (bCompleted) {
                    self.bShowedMenu = false
                }
        })
    }
    
    @IBAction func actionSignOut(sender: AnyObject) {
        SpotagoryKeeper.keeper.removeSavedProfile()
        let viewCon = self.storyboard?.instantiateViewControllerWithIdentifier("SignInViewController")
        self.navigationController?.pushViewController(viewCon!, animated: true)
    }
    
    @IBAction func actionNotification(sender: AnyObject) {
        let viewCon = self.storyboard?.instantiateViewControllerWithIdentifier("NotificationViewController") as! NotificationViewController!
        self.navigationController?.pushViewController(viewCon, animated: true)
    }
    
    @IBAction func actionSocial(sender: AnyObject) {
        let viewCon = self.storyboard?.instantiateViewControllerWithIdentifier("SocialViewController") as! SocialViewController!
        self.navigationController?.pushViewController(viewCon, animated: true)
    }
    
    @IBAction func actionFeedback(sender: AnyObject) {
    }
    
    @IBAction func actionRateUs(sender: AnyObject) {
    }
    
    @IBAction func actionAbout(sender: AnyObject) {
        let vieCon = self.storyboard?.instantiateViewControllerWithIdentifier("WhatsNewViewController") as! WhatsNewViewController!
        self.presentViewController(vieCon, animated: true, completion: nil)
    }
    
    @IBAction func actionFollower(sender: UIButton) {
        let viewCon = self.storyboard?.instantiateViewControllerWithIdentifier("FollowerViewController") as! FollowerViewController!
        self.presentViewController(viewCon, animated: true, completion: nil)
    }
    
    @IBAction func actionFollowing(sender: UIButton) {
        let viewCon = self.storyboard?.instantiateViewControllerWithIdentifier("FollowingViewController") as! FollowingViewController!
        self.presentViewController(viewCon, animated: true, completion: nil)
    }

    
    func loadFollowCount() {
        
        let api_link = String(format: "/users/%@/follows-count", SpotagoryKeeper.keeper.getUserId()!)
        
        let token = SpotagoryKeeper.keeper.getUserToken() as String
        
        SpotagoryAPI.sendGetRequest(api_link, token: token, params: nil, completion: {(response, error) -> Void in
            
            if (response != nil) {
                
                print("response \(response)")
                
                let _meta = response!.objectForKey("_meta") as? NSDictionary
                
                if let resultCode = _meta!.objectForKey("status_code") as? NSNumber {
                    if resultCode.intValue == 200 {
                        
                        let data = response!.objectForKey("data") as? NSDictionary
                        
                        let follower_cnt = data?.objectForKey("follower_count") as? Int
                        let following_cnt = data?.objectForKey("following_count") as? Int
                        
                        self.lblFollowerCnt.text = String(format: "%d", follower_cnt!)
                        self.lblFollowingCnt.text = String(format: "%d", following_cnt!)
                        
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
