//
//  ActivitiesViewController.swift
//  Spotagory
//
//  Created by Messia Engineer on 9/3/16.
//  Copyright © 2016 Spotagory. All rights reserved.
//

import UIKit

class LikePeopleCell: UITableViewCell {
    
    @IBOutlet weak var userAvatar: UIImageView!
    @IBOutlet weak var viewAction: UIView!
    
    func configure() {
        
        userAvatar.layer.borderColor = UIColor.grayColor().CGColor
        userAvatar.layer.borderWidth = 1
        userAvatar.layer.cornerRadius = userAvatar.frame.size.height / 2
        
        viewAction.layer.borderColor = UIColor.lightGrayColor().CGColor
        viewAction.layer.borderWidth = 1
        viewAction.layer.cornerRadius = viewAction.frame.size.height / 2
    }
}

class CommentCell: UITableViewCell {
    
    @IBOutlet weak var userAvatar: UIImageView!
    
    func configure() {
        
        userAvatar.layer.borderColor = UIColor(colorLiteralRed: 199.0/255.0, green: 99.0/255.0, blue: 5.0/255.0, alpha: 1).CGColor
        userAvatar.layer.borderWidth = 1
        userAvatar.layer.cornerRadius = userAvatar.frame.size.height / 2
    }
}

class ActivitiesViewController: UIViewController, UITextViewDelegate {

    var postId : String?
    
    @IBOutlet weak var viewSegmenting: UIView!
    var tabControl : BetterSegmentedControl!
    
    @IBOutlet weak var tableViewMain: UITableView!
    @IBOutlet weak var textViewCommentsInput: FLTextView!
    @IBOutlet weak var viewInputPanel: UIView!
    @IBOutlet weak var constraintForInputViewHeight: NSLayoutConstraint!
    @IBOutlet weak var constraintForInputViewBottomSpace: NSLayoutConstraint!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        configureSegmentedControl()
        
        constraintForInputViewHeight.constant = 0
        
        tableViewMain.tableFooterView = UIView()
        textViewCommentsInput.placeholder = "Add comments..."
        textViewCommentsInput.delegate = self
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        gesture.cancelsTouchesInView = true
        self.tableViewMain.addGestureRecognizer(gesture)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBarHidden = true
        
        configureNotifications()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    @IBAction func actionBack(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }

    func configureSegmentedControl() {
        tabControl = BetterSegmentedControl(frame: CGRectMake(10, 5, self.view.frame.size.width - 20, 39), titles: ["LIKES", "COMMENTS"], index: 0, backgroundColor: UIColor(hex: 0xF5A623, alpha: 1), titleColor: UIColor.whiteColor(), indicatorViewBackgroundColor: UIColor.whiteColor(), selectedTitleColor: UIColor(hex: 0xF5A623, alpha: 1))
        tabControl.cornerRadius = 17
        tabControl.titleFont = UIFont(name: "BrandonGrotesque-Medium", size: 15)!
        tabControl.selectedTitleFont = UIFont(name: "BrandonGrotesque-Medium", size: 15)!
        tabControl.addTarget(self, action: #selector(onTabChanged), forControlEvents: .ValueChanged)
        
        self.viewSegmenting.addSubview(tabControl)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tabControl.index == 0 {
            return 5
        } else {
            return 10
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if tabControl.index == 0 {
            return 85
        } else {
            return 120
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if tabControl.index == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier("LikePeopleCell") as! LikePeopleCell
            cell.configure()
            return cell
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier("CommentCell") as! CommentCell
            cell.configure()
            return cell
        }
    }
    
    func configureNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(onKeyboardWillShow), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(onKeyboardWillChangeFrame), name: UIKeyboardWillChangeFrameNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(onKeyboardWillHide), name: UIKeyboardWillHideNotification, object: nil)
        
    }
    
    func onKeyboardWillShow(notification : NSNotification) {
        if let info = notification.userInfo {
            if let value = info[UIKeyboardFrameEndUserInfoKey] as? NSValue {
                let keyboardSize = value.CGRectValue().size
                print("keyboard size \(keyboardSize)")
                constraintForInputViewBottomSpace.constant = keyboardSize.height - 50
            }
        }
    }
    
    func onKeyboardWillHide(notification : NSNotification) {
        constraintForInputViewBottomSpace.constant = 0
    }
    
    func onKeyboardWillChangeFrame(notification : NSNotification) {
        if let info = notification.userInfo {
            if let value = info[UIKeyboardFrameEndUserInfoKey] as? NSValue {
                let keyboardSize = value.CGRectValue().size
                constraintForInputViewBottomSpace.constant = keyboardSize.height - 50
            }
        }
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        let mutableString = NSMutableString(string: textViewCommentsInput.text)
        mutableString.replaceCharactersInRange(range, withString: text)
        
        let replacedString = NSString(string: mutableString) as String
        let height = replacedString.sizeForFont(textViewCommentsInput.font, constrained: CGSizeMake(textViewCommentsInput.textContainer.size.width, CGFloat.max)).height
        let numberOfLines = height / textView.font!.lineHeight
        
        constraintForInputViewHeight.constant = (numberOfLines - 1) * textViewCommentsInput.font.lineHeight + 55
        
        return true
    }
    
    func dismissKeyboard() {
        textViewCommentsInput.resignFirstResponder()
    }
    
    func onTabChanged(segmentedControl : BetterSegmentedControl) {
        if segmentedControl.index == 0 {
            textViewCommentsInput.text = ""
            textViewCommentsInput.resignFirstResponder()
            constraintForInputViewHeight.constant = 0
        } else {
            constraintForInputViewHeight.constant = 55
        }
        
        tableViewMain.reloadData()
    }
    
    @IBAction func onSend(sender: AnyObject) {
        textViewCommentsInput.text = ""
        constraintForInputViewHeight.constant = 55
    }
    
}
