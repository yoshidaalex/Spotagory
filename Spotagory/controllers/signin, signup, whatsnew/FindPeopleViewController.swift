//
//  FindPeopleViewController.swift
//  Spotagory
//
//  Created by Admin on 29/11/2016.
//  Copyright © 2016 Spotagory. All rights reserved.
//

import UIKit

class FindPeopleViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    @IBOutlet weak var viewSegmenting: UIView!
    
    @IBOutlet weak var tableViewMain: UITableView!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        self.tableViewMain.tableFooterView = UIView()
        self.configureSegmentedControl()
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        gesture.cancelsTouchesInView = false
        self.tableViewMain.addGestureRecognizer(gesture)
        
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
    
    func configureSegmentedControl() {
        let segmentedControl = BetterSegmentedControl(frame: CGRectMake(10, 5, self.view.frame.size.width - 20, 39), titles: ["ALL", "NEARBY", "FACEBOOK"], index: 0, backgroundColor: UIColor(hex: 0xF5A623, alpha: 1), titleColor: UIColor.whiteColor(), indicatorViewBackgroundColor: UIColor.whiteColor(), selectedTitleColor: UIColor(hex: 0xF5A623, alpha: 1))
        segmentedControl.cornerRadius = 17
        segmentedControl.titleFont = UIFont(name: "BrandonGrotesque-Medium", size: 15)!
        segmentedControl.selectedTitleFont = UIFont(name: "BrandonGrotesque-Medium", size: 15)!
        
        self.viewSegmenting.addSubview(segmentedControl)
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
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
    
    @IBAction func actionAdd(sender: AnyObject) {
        let viewCon = self.storyboard?.instantiateViewControllerWithIdentifier("InviteFriendsViewController") as! InviteFriendsViewController!
        viewCon.addPeople = true
        self.presentViewController(viewCon!, animated: true, completion: nil)
    }
    
    
}