//
//  LocationSearchViewController.swift
//  Spotagory
//
//  Created by Messia Engineer on 8/26/16.
//  Copyright © 2016 Spotagory. All rights reserved.
//

import UIKit

class LocationSearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var constraintForNavigationHeight: NSLayoutConstraint!
    @IBOutlet weak var constraintForStatusBarHeight: NSLayoutConstraint!
    @IBOutlet weak var imageViewNavBack: UIImageView!
    @IBOutlet weak var tableViewMain: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        searchBar.backgroundImage = UIImage()
        searchBar.translucent = true
        
        for view in searchBar.subviews {
            for subview in view.subviews {
                if subview.isKindOfClass(UITextField) {
                    let textField : UITextField = subview as! UITextField
                    textField.backgroundColor = UIColor.whiteColor()
                    textField.font = UIFont(name: "BrandonGrotesque-Regular", size: 15)
                }
            }
        }
        
        if UIScreen.mainScreen().bounds.width >= 414 {
            
            self.constraintForNavigationHeight.constant = 62
            self.constraintForStatusBarHeight.constant = 18
            imageViewNavBack.image = UIImage(named: "bg_navbar_5.5in")
            
        } else {
            
            self.constraintForNavigationHeight.constant = 64
            self.constraintForStatusBarHeight.constant = 18
            
            if UIScreen.mainScreen().bounds.width >= 375 {
                imageViewNavBack.image = UIImage(named: "bg_navbar_4.7in")
            } else {
                imageViewNavBack.image = UIImage(named: "bg_navbar_4in")
            }
            
        }
        
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

    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func onCancel(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 64
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("AddressCell")
        return cell!
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        searchBar.resignFirstResponder()
    }
    
    func dismissKeyboard() {
        searchBar.resignFirstResponder()
    }
}
