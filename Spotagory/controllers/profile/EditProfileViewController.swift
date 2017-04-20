//
//  ProfileViewController.swift
//  Spotagory
//
//  Created by Admin on 29/11/2016.
//  Copyright © 2016 Spotagory. All rights reserved.
//

import UIKit

class EditProfileViewController: UIViewController {
    
    @IBOutlet weak var txtFirstName: UITextField!
    @IBOutlet weak var txtLastName: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtBio: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.automaticallyAdjustsScrollViewInsets = false
        
        let user_info = SpotagoryKeeper.keeper.loadUserProfile()
        
        txtFirstName.text = user_info!.objectForKey("first_name") as? String
        txtLastName.text = user_info!.objectForKey("last_name") as? String
        txtEmail.text = user_info!.objectForKey("email") as? String
//        txtBio.text = user_info!.objectForKey("bio") as? String
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
    
    @IBAction func actionSave(sender: AnyObject) {
        self.view.endEditing(true)
        
        if self.txtFirstName.text == "" {
            self.showErroralert("Please enter your first name.")
            return
        }
        
        if self.txtLastName.text == "" {
            self.showErroralert("Please enter your last name.")
            return
        }

        
        if self.txtEmail.text == "" {
            self.showErroralert("Please enter your E-mail address.")
            return
        }
        
        if (self.txtEmail.text?.isEmailValid == false) {
            self.showErroralert("Please enter a valid email address")
            return
        }
        
        let params = ["first_name":self.txtFirstName.text!, "last_name":self.txtLastName.text!, "email":self.txtEmail.text!]
        
        let token = SpotagoryKeeper.keeper.getUserToken() as String
        let api_link = String(format: "/users/%@", SpotagoryKeeper.keeper.getUserId()!)
        
        SpotagoryAPI.sendPutRequest(api_link, token: token, params: params, completion: {(response, error) -> Void in
            
            if (response != nil) {
                
                print("response \(response)")
                
                let _meta = response!.objectForKey("_meta") as? NSDictionary
                
                if let resultCode = _meta!.objectForKey("status_code") as? NSNumber {
                    if resultCode.intValue == 200 {
                        
                        let data = response!.objectForKey("data") as? NSDictionary
                        
                        SpotagoryKeeper.keeper.removeSavedProfile()
                        SpotagoryKeeper.keeper.saveUserProfile(data!)
                        
                        self.showErroralert("Successfully Updated!")
                        
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
    
    @IBAction func actionChangePassword(sender: AnyObject) {
        let viewCon = self.storyboard?.instantiateViewControllerWithIdentifier("ChangePasswordViewController") as! ChangePasswordViewController!
        self.navigationController?.pushViewController(viewCon, animated: true)
    }
}
