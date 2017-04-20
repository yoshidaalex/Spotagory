//
//  SignInViewController.swift
//  Spotagory
//
//  Created by Messia Engineer on 8/24/16.
//  Copyright © 2016 Spotagory. All rights reserved.
//

import UIKit
import MBProgressHUD

class SignUpViewController: UIViewController, UIActionSheetDelegate {
    
    var fErrorViewHeight: CGFloat = 0

    @IBOutlet weak var viewInputPanel: UIView!
    
    @IBOutlet weak var buttonSignIn: UIButton!
    @IBOutlet weak var buttonFacebookSignIn: UIButton!
    
    @IBOutlet weak var textfieldUsername: UITextField!
    
    @IBOutlet weak var textfieldEmail: UITextField!
    
    @IBOutlet weak var textfieldPassword: UITextField!
    
    
    @IBOutlet weak var alertView: UIView!
    @IBOutlet weak var alertMessage: UILabel!
    @IBOutlet weak var m_constraintErrorViewTop: NSLayoutConstraint!
    
    
    @IBOutlet weak var m_imgUserAvatar: UIImageView!
    let picker = UIImagePickerController()
    var selectedImage: UIImage? = nil
    var city : String = ""
    var country : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.edgesForExtendedLayout = .None

//        configureFacebook()
        picker.delegate = self
        
        // Do any additional setup after loading the view.
        SpotagoryKeeper.keeper.setAppAlreadyLaunched()
        self.viewInputPanel.layer.masksToBounds = true
        self.viewInputPanel.layer.cornerRadius = 10
        
        self.buttonSignIn.layer.cornerRadius = 22
        
        self.buttonFacebookSignIn.layer.masksToBounds = true
        self.buttonFacebookSignIn.layer.cornerRadius = 22
        
        fErrorViewHeight = CGRectGetHeight(self.alertView.bounds)
        
        self.m_constraintErrorViewTop.constant = -fErrorViewHeight
        
        let longitude :CLLocationDegrees = SpotagoryKeeper.keeper.getCurrentLongitude()
        let latitude :CLLocationDegrees = SpotagoryKeeper.keeper.getCurrentLatitude()
        let location = CLLocation(latitude: latitude, longitude: longitude)
        self.getAddressWithCoordinates(location)
        
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
                    self.performSelector(#selector(SignUpViewController.hideErrorMessage), withObject: nil, afterDelay: 1.0)
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

    @IBAction func actionAddAvatar(sender: AnyObject) {
        let actionsheet = UIActionSheet(title: "Choose Option", delegate: self, cancelButtonTitle: "Cancel", destructiveButtonTitle: nil, otherButtonTitles: "Camera", "Photo Library")
        actionsheet.showInView(self.view)
    }
    
    func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int) {
        switch buttonIndex {
            case 0:
                break;
            case 1:
                takePhoto()
                break;
            case 2:
                choosePhotoFromLibrary()
                break;
            default:
                break
        }
    }
    
    func takePhoto() {
        picker.sourceType = .Camera
        picker.allowsEditing = false
        presentViewController(picker, animated: true, completion: nil)
    }

    
    func choosePhotoFromLibrary() {
        picker.navigationBar.tintColor = UIColor.whiteColor()
        picker.navigationBar.titleTextAttributes = [ NSFontAttributeName: UIFont(name: "BrandonGrotesque-Medium", size: 20)!,
                                                     NSForegroundColorAttributeName: UIColor.whiteColor()]
        
        picker.allowsEditing = true
        picker.sourceType = .PhotoLibrary
        presentViewController(picker, animated: true, completion: nil)
    }
    
    @IBAction func onSignIn(sender: AnyObject) {
        for vc in self.navigationController!.viewControllers {
            if vc.isKindOfClass(SignInViewController) {
                self.navigationController!.popToViewController(vc, animated: true)
                return
            }
        }
        
        self.performSegueWithIdentifier("sid_signin", sender: nil)
    }
    
    @IBAction func onSignUp(sender: AnyObject) {
        
        self.view.endEditing(true)
        
        if self.textfieldUsername.text == "" {
            self.showErrorMessage("Please enter your username.")
            return
        }
        
        if self.textfieldEmail.text == "" {
            self.showErrorMessage("Please enter your E-mail address.")
            return
        }
        
        if (self.textfieldEmail.text?.isEmailValid == false) {
            self.showErrorMessage("Please enter a valid email address")
            return
        }
        
        if self.textfieldPassword.text == "" {
            self.showErrorMessage("Please enter your password.")
            return
        }
        
//        let device_token : String = SpotagoryKeeper.keeper.getDeviceToken() as String
        
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        
        let params = ["email":self.textfieldEmail.text!, "password":self.textfieldPassword.text!,"username":self.textfieldUsername.text!, "device_token":"0000000000", "city":self.city, "country":self.country]
        
        if selectedImage != nil {
            SpotagoryAPI.sendPostRequestWithPhoto("/register", token: nil, resourceData: UIImageJPEGRepresentation(selectedImage!, 50)!, mimeType: "image/jpeg", attachParamName: "avatar", params: params, completion: { (response, error) in
                
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
        } else {
            SpotagoryAPI.sendPostRequest("/register", token: nil, params: params, completion: {(response, error) -> Void in
                
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
    }
    
//    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!)
//    {
//        FBSDKGraphRequest.init(graphPath: "me", parameters: ["fields":"first_name, last_name, email, picture.type(large)"]).startWithCompletionHandler { (connection, result, error) -> Void in
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
    
    func getAddressWithCoordinates(location : CLLocation) -> Void {
        
        let geoCoder = CLGeocoder()
        
        geoCoder.reverseGeocodeLocation(location)
        {
            (placemarks, error) -> Void in
            
            if error != nil {
                return
            }
            
            let placeArray = placemarks as [CLPlacemark]!
            
            // Place details
            var placeMark: CLPlacemark!
            placeMark = placeArray?[0]
            
//            print(placeMark.country)
//            print(placeMark.locality)
//            print(placeMark.addressDictionary)
            
            if let city = placeMark.addressDictionary?["City"] as? String
            {
                self.city = city
            }
            
            if let country = placeMark.addressDictionary?["Country"] as? String
            {
                self.country = country
            }
        }
    }
}

extension SignUpViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        self.selectedImage = info[UIImagePickerControllerEditedImage] as? UIImage
        
        self.m_imgUserAvatar.image = self.selectedImage
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
}
