//
//  InviteFriendsViewController.swift
//  Spotagory
//
//  Created by Messia Engineer on 8/24/16.
//  Copyright © 2016 Spotagory. All rights reserved.
//

import UIKit

class PeopleCell: UITableViewCell {
    
    @IBOutlet weak var img_userAvatar: UIImageView!
    @IBOutlet weak var lblUsername: UILabel!
    @IBOutlet weak var lblLocation: UILabel!
    
    @IBOutlet weak var viewAction: UIView!
    @IBOutlet weak var lblFollow: UILabel!
    @IBOutlet weak var btnFollow: UIButton!
    
    func configure() {
        viewAction.layer.borderColor = UIColor.lightGrayColor().CGColor
        viewAction.layer.borderWidth = 1
        viewAction.layer.cornerRadius = viewAction.frame.size.height / 2
    }
}

class InviteFriendsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {

    @IBOutlet weak var viewSegmenting: UIView!
    
    @IBOutlet weak var tableViewMain: UITableView!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var constraintForNextButtonViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var btnSkip: UIButton!
    @IBOutlet weak var btnClose: UIButton!
    
    var isFromNewsFeed = false
    var addPeople = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.tableViewMain.tableFooterView = UIView()
        self.configureSegmentedControl()

        let gesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        gesture.cancelsTouchesInView = false
        self.tableViewMain.addGestureRecognizer(gesture)
        
        if isFromNewsFeed {
            constraintForNextButtonViewHeight.constant = 0
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBarHidden = true
        
        if addPeople {
            btnBack.hidden = true
            btnSkip.hidden = true
            btnClose.hidden = false
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

    func configureSegmentedControl() {
        let segmentedControl = BetterSegmentedControl(frame: CGRectMake(10, 5, self.view.frame.size.width - 20, 39), titles: ["FACEBOOK", "EMAIL", "SMS"], index: 0, backgroundColor: UIColor(hex: 0xF5A623, alpha: 1), titleColor: UIColor.whiteColor(), indicatorViewBackgroundColor: UIColor.whiteColor(), selectedTitleColor: UIColor(hex: 0xF5A623, alpha: 1))
        segmentedControl.cornerRadius = 17
        segmentedControl.titleFont = UIFont(name: "BrandonGrotesque-Medium", size: 15)!
        segmentedControl.selectedTitleFont = UIFont(name: "BrandonGrotesque-Medium", size: 15)!
        
        self.viewSegmenting.addSubview(segmentedControl)
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    @IBAction func actionBack(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func actionSkip(sender: AnyObject) {
        
//        self.performSegueWithIdentifier("new_feeds", sender: nil)
        let viewCon = self.storyboard?.instantiateViewControllerWithIdentifier("MainTabViewController")
        self.navigationController?.pushViewController(viewCon!, animated: true)
    }
    
    @IBAction func actionClose(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("PeopleCell") as! PeopleCell
        cell.configure()
        return cell
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        searchBar.resignFirstResponder()
    }
    
    func dismissKeyboard() {
        searchBar.resignFirstResponder()
    }

}
