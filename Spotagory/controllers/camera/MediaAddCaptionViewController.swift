//
//  MediaAddCaptionViewController.swift
//  Spotagory
//
//  Created by Messia Engineer on 9/8/16.
//  Copyright © 2016 Spotagory. All rights reserved.
//

import UIKit

class MediaAddCaptionViewController: UIViewController {
    
    @IBOutlet weak var textViewMain: FLTextView!
    @IBOutlet weak var constraintForViewBottomSpace: NSLayoutConstraint!
    @IBOutlet weak var imageViewBackground: UIImageView!
    var callback : MediaCallback? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        textViewMain.placeholder = "Enter caption here."
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        textViewMain.becomeFirstResponder()
        
        self.navigationController?.navigationBarHidden = true
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(onKeyboardWillShow), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(onKeyboardWillChangeFrame), name: UIKeyboardWillChangeFrameNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(onKeyboardWillHide), name: UIKeyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "sid_next" {
            
            PostKeeper.keeper.mediaCaption = textViewMain.text
            
            let controller = segue.destinationViewController as! SelectCategoryViewController
            controller.shouldSelectOnlyOne = true
            controller.fromCameraPage = true
        }
    }

    @IBAction func onNext(sender: AnyObject) {
        
    }
    
    @IBAction func onClose(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func onKeyboardWillShow(notification : NSNotification) {
        if let info = notification.userInfo {
            if let value = info[UIKeyboardFrameEndUserInfoKey] as? NSValue {
                let keyboardSize = value.CGRectValue().size
                print("keyboard size \(keyboardSize)")
                constraintForViewBottomSpace.constant = keyboardSize.height
            }
        }
    }
    
    func onKeyboardWillChangeFrame(notification : NSNotification) {
        if let info = notification.userInfo {
            if let value = info[UIKeyboardFrameEndUserInfoKey] as? NSValue {
                let keyboardSize = value.CGRectValue().size
                print("keyboard size \(keyboardSize)")
                constraintForViewBottomSpace.constant = keyboardSize.height
            }
        }
    }
    
    func onKeyboardWillHide(notification : NSNotification) {
        constraintForViewBottomSpace.constant = 0
    }
}
