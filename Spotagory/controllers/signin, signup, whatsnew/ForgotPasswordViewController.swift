//
//  ForgotPasswordViewController.swift
//  Spotagory
//
//  Created by Messia Engineer on 8/24/16.
//  Copyright © 2016 Spotagory. All rights reserved.
//

import UIKit

class ForgotPasswordViewController: UIViewController {

    var fErrorViewHeight: CGFloat = 0
    
    @IBOutlet weak var textfieldEmailAddress: UITextField!
    @IBOutlet weak var buttonSend: UIButton!
    
    @IBOutlet weak var alertView: UIView!
    @IBOutlet weak var txt_alertText: UILabel!
    @IBOutlet weak var m_topContraint: NSLayoutConstraint!    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.textfieldEmailAddress.layer.borderColor = UIColor.whiteColor().CGColor
        self.textfieldEmailAddress.layer.borderWidth = 1
        self.textfieldEmailAddress.layer.masksToBounds = true
        self.textfieldEmailAddress.layer.cornerRadius = 24
        
        self.buttonSend.layer.cornerRadius = 24
        
        fErrorViewHeight = CGRectGetHeight(self.alertView.bounds)
        
        self.m_topContraint.constant = -fErrorViewHeight
        
        self.view.layoutIfNeeded()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBarHidden = true
    }
    
    func showErrorMessage(message: String) {
        UIApplication.sharedApplication().setStatusBarHidden(true, withAnimation: .Slide)
        
        self.txt_alertText.text = message
        
        UIView.animateWithDuration(0.3, animations: {
            self.m_topContraint.constant = 0
            self.view.layoutIfNeeded()
            }, completion: { (bCompleted) -> Void in
                if (bCompleted) {
                    self.performSelector(#selector(ForgotPasswordViewController.hideErrorMessage), withObject: nil, afterDelay: 1.0)
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func onBack(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }

    @IBAction func onCreateNewAccount(sender: AnyObject) {
        self.performSegueWithIdentifier("sid_signup", sender: nil)
    }
    
    @IBAction func actionSend(sender: AnyObject) {
        self.view.endEditing(true)
        
        if self.textfieldEmailAddress.text == "" {
            self.showErrorMessage("Please enter your E-mail address.")
            return
        }
        
        if (self.textfieldEmailAddress.text?.isEmailValid == false) {
            self.showErrorMessage("Please enter a valid email address")
            return
        }
        
        let params = ["email":self.textfieldEmailAddress.text!]
        
        SpotagoryAPI.sendPostRequest("/reset-password", token: nil, params: params, completion: {(response, error) -> Void in
            
            if (response != nil) {
                print("response \(response)")
                
                let _meta = response!.objectForKey("_meta") as? NSDictionary
                
                if let resultCode = _meta!.objectForKey("status_code") as? NSNumber {
                    if resultCode.intValue == 200 {
                        
                        self.performSegueWithIdentifier("sid_signin", sender: nil)
                        
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
