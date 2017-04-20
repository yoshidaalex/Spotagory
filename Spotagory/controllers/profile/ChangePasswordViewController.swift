//
//  ProfileViewController.swift
//  Spotagory
//
//  Created by Admin on 29/11/2016.
//  Copyright © 2016 Spotagory. All rights reserved.
//

import UIKit

class ChangePasswordViewController: UIViewController {
    
    var fErrorViewHeight: CGFloat = 0
    
    @IBOutlet weak var alertView: UIView!
    @IBOutlet weak var m_alertLabel: UILabel!
    @IBOutlet weak var m_topContraint: NSLayoutConstraint!
    
    @IBOutlet weak var m_txtOldPassword: UITextField!
    @IBOutlet weak var m_txtNewPassword: UITextField!
    @IBOutlet weak var m_txtConfirmPassword: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.automaticallyAdjustsScrollViewInsets = false
        
        fErrorViewHeight = CGRectGetHeight(self.alertView.bounds)
        
        self.m_topContraint.constant = -fErrorViewHeight
        
        self.view.layoutIfNeeded()
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
    
    func showErrorMessage(message: String) {
        UIApplication.sharedApplication().setStatusBarHidden(true, withAnimation: .Slide)
        
        self.m_alertLabel.text = message
        
        UIView.animateWithDuration(0.3, animations: {
            self.m_topContraint.constant = 0
            self.view.layoutIfNeeded()
            }, completion: { (bCompleted) -> Void in
                if (bCompleted) {
                    self.performSelector(#selector(ChangePasswordViewController.hideErrorMessage), withObject: nil, afterDelay: 1.0)
                }
        })
    }
    
    func hideErrorMessage() {
        UIApplication.sharedApplication().setStatusBarHidden(false, withAnimation: .Slide)
        
        UIView.animateWithDuration(0.3, animations: {
            self.m_topContraint.constant = -self.fErrorViewHeight
            self.view.layoutIfNeeded()
        })
    }
    
    @IBAction func actionBack(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func actionSave(sender: AnyObject) {
        self.view.endEditing(true)
        
        if self.m_txtOldPassword.text == "" {
            self.showErrorMessage("Please enter current password.")
            return
        }
        
        if self.m_txtNewPassword.text == "" {
            self.showErrorMessage("Please enter new password.")
            return
        }
        
        if self.m_txtConfirmPassword.text == "" {
            self.showErrorMessage("Please enter confirm password.")
            return
        }
        
        if self.m_txtConfirmPassword.text != self.m_txtNewPassword.text {
            self.showErrorMessage("Sorry, password to not match")
            return
        }
        
        var token = SpotagoryKeeper.keeper.getUserToken() as String
        let params = ["current_password":self.m_txtOldPassword.text!, "password":self.m_txtNewPassword.text!]
        
        SpotagoryAPI.sendPostRequest("/change-password", token: token, params: params, completion: {(response, error) -> Void in
            
            if (response != nil) {
                
                print("response \(response)")
                
                let _meta = response!.objectForKey("_meta") as? NSDictionary
                
                if let resultCode = _meta!.objectForKey("status_code") as? NSNumber {
                    if resultCode.intValue == 200 {
                        
                        return
                        
                    } else {
                        if let error = _meta!.objectForKey("error") as? NSDictionary {
                            if let errorDescription = error.objectForKey("message") as? String {
                                self.showErrorMessage(errorDescription)
                                
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
}
