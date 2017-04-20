//
//  TabBarViewController.swift
//  Spotagory
//
//  Created by Messia Engineer on 8/25/16.
//  Copyright © 2016 Spotagory. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        addCenterButton()
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
    
    func addCenterButton() {
        
        let buttonImage = UIImage(named: "icon_tab_camera")
        let button = UIButton(type: .Custom)
        button.frame = CGRectMake(0.0, 0.0, buttonImage!.size.width, buttonImage!.size.height)
        let heightDifference = buttonImage!.size.height - self.tabBar.frame.size.height
        
        if heightDifference < 0 {
            button.center = self.tabBar.center
        } else {
            var center = self.tabBar.center
            center.y = center.y - heightDifference / 2
            button.center = center
        }
        
        button.addTarget(self, action: #selector(onCamera), forControlEvents: .TouchUpInside)
        button.setBackgroundImage(buttonImage, forState: .Normal)
        
        self.view.addSubview(button)

    }
    
    func onCamera() {
        self.performSegueWithIdentifier("sid_camera", sender: nil)
    }

}
