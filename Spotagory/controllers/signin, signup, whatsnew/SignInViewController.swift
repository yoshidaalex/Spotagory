//
//  SignInViewController.swift
//  Spotagory
//
//  Created by Messia Engineer on 8/24/16.
//  Copyright © 2016 Spotagory. All rights reserved.
//

import UIKit
import MBProgressHUD

class SignInViewController: UIViewController {

    var fErrorViewHeight: CGFloat = 0
    
    @IBOutlet weak var viewInputPanel: UIView!
    
    @IBOutlet weak var buttonSignIn: UIButton!
    @IBOutlet weak var buttonFacebookSignIn: UIButton!
    @IBOutlet weak var textfieldUsername: UITextField!
    @IBOutlet weak var textfieldPassword: UITextField!
    
    @IBOutlet weak var alertView: UIView!
    @IBOutlet weak var alertMessage: UILabel!
    @IBOutlet weak var m_constraintErrorViewTop: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
//        configureFacebook()
        self.edgesForExtendedLayout = .None
        
        SpotagoryKeeper.keeper.setAppAlreadyLaunched()
        
        self.viewInputPanel.layer.masksToBounds = true
        self.viewInputPanel.layer.cornerRadius = 10
        
        self.buttonSignIn.layer.cornerRadius = 22
        
        self.buttonFacebookSignIn.layer.masksToBounds = true
        self.buttonFacebookSignIn.layer.cornerRadius = 22
        
        
        fErrorViewHeight = CGRectGetHeight(self.alertView.bounds)
        
        self.m_constraintErrorViewTop.constant = -fErrorViewHeight
        
        self.view.layoutIfNeeded()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated:Bool) {
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
    
    func showErrorMessage(message: String) {
        UIApplication.sharedApplication().setStatusBarHidden(true, withAnimation: .Slide)
        
        self.alertMessage.text = message
        
        UIView.animateWithDuration(0.3, animations: {
            self.m_constraintErrorViewTop.constant = 0
            self.view.layoutIfNeeded()
            }, completion: { (bCompleted) -> Void in
                if (bCompleted) {
                    self.performSelector(#selector(SignInViewController.hideErrorMessage), withObject: nil, afterDelay: 1.0)
                }
        })
    }
    
    func hideErrorMessage() {
        UIApplication.sharedApplication().setStatusBarHidden(false, withAnimation: .Slide)
        
        UIView.animateWithDuration(0.3, animations: {
            self.m_constraintErrorViewTop.constant = -self.fErrorViewHeight
            self.view.layoutIfNeeded()
        })
    }

    @IBAction func onSignIn(sender: AnyObject) {
        
        self.view.endEditing(true)
        
        if self.textfieldUsername.text == "" {
            self.showErrorMessage("Please enter your username (or E-mail).")
            return
        }
        
        if self.textfieldPassword.text == "" {
            self.showErrorMessage("Please enter your password.")
            return
        }
        
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        
        let params = ["username":self.textfieldUsername.text!, "password":self.textfieldPassword.text!, "device_token":"0000000000"]
        
        SpotagoryAPI.sendPostRequest("/login", token: nil, params: params, completion: {(response, error) -> Void in
            
            if (response != nil) {
                MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
                
                print("response \(response)")
                
                let _meta = response!.objectForKey("_meta") as? NSDictionary
                
                if let resultCode = _meta!.objectForKey("status_code") as? NSNumber {
                    if resultCode.intValue == 200 {
                        let data = response!.objectForKey("data") as? NSDictionary
                        
                        SpotagoryKeeper.keeper.saveUserProfile(data!)
                        
                        let access_token : String = (_meta!.objectForKey("token") as? String)!
                        
                        SpotagoryKeeper.keeper.setUserToken(access_token)
                        
                        let viewCon = self.storyboard?.instantiateViewControllerWithIdentifier("MainTabViewController")
                        self.navigationController?.pushViewController(viewCon!, animated: true)
                        
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
                MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
                print("error \(error)")
            }
        })
    }
    
//    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!)
//    {
//        FBSDKGraphRequest.init(graphPath: "me", parameters: ["fields":"name, first_name, last_name, email, picture.type(large)"]).startWithCompletionHandler { (connection, result, error) -> Void in
//            
//            let strFirstName: String = (result.objectForKey("first_name") as? String)!
//            let strLastName: String = (result.objectForKey("last_name") as? String)!
//            let strPictureURL: String = (result.objectForKey("picture")?.objectForKey("data")?.objectForKey("url") as? String)!
//            let strEmail : String = (result.objectForKey("email") as? String)!
//        }
//    }
//    
//    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!)
//    {
//        let loginManager: FBSDKLoginManager = FBSDKLoginManager()
//        loginManager.logOut()
//    }
//    
//    //    MARK: Other Methods
//    
//    func configureFacebook()
//    {
//        buttonFacebookSignIn.readPermissions = ["public_profile", "email", "user_friends"];
//        buttonFacebookSignIn.delegate = self
//    }
}
