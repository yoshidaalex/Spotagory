//
//  ProfileViewController.swift
//  Spotagory
//
//  Created by Admin on 29/11/2016.
//  Copyright © 2016 Spotagory. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.automaticallyAdjustsScrollViewInsets = false
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
    
    @IBAction func actionViewProfile(sender: AnyObject) {
        let viewCon = self.storyboard?.instantiateViewControllerWithIdentifier("ProfileDetailsViewController") as! ProfileDetailsViewController!
        self.presentViewController(viewCon, animated: true, completion: nil)
    }
    
    @IBAction func actionEditProfile(sender: AnyObject) {
        self.performSegueWithIdentifier("sid_edit_profile", sender: nil)
    }
    
    @IBAction func actionClose(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func actionSignOut(sender: AnyObject) {
        
    }
    
    @IBAction func actionNotification(sender: AnyObject) {
        let vieCon = self.storyboard?.instantiateViewControllerWithIdentifier("NotificationViewController") as! NotificationViewController!
        self.presentViewController(vieCon, animated: true, completion: nil)
    }
    
    @IBAction func actionSocial(sender: AnyObject) {
        let vieCon = self.storyboard?.instantiateViewControllerWithIdentifier("SocialViewController") as! SocialViewController!
        self.presentViewController(vieCon, animated: true, completion: nil)
    }
    
    @IBAction func actionFeedback(sender: AnyObject) {
    }
    
    @IBAction func actionRateUs(sender: AnyObject) {
    }
    
    @IBAction func actionAbout(sender: AnyObject) {
        let vieCon = self.storyboard?.instantiateViewControllerWithIdentifier("WhatsNewViewController") as! WhatsNewViewController!
        self.presentViewController(vieCon, animated: true, completion: nil)
    }
}
