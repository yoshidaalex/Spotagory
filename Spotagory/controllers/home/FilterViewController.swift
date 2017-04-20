//
//  FilterViewController.swift
//  Spotagory
//
//  Created by Admin on 30/11/2016.
//  Copyright © 2016 Spotagory. All rights reserved.
//

import UIKit
import MBProgressHUD

class FilterViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var categories : [AnyObject]? = nil
    var delegate : FilterDelegate? = nil
    
    @IBOutlet weak var filterCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.automaticallyAdjustsScrollViewInsets = false
        
        filterCollectionView.registerNib(UINib(nibName: "FilterCell", bundle: nil), forCellWithReuseIdentifier: "filterCell")
        
        loadCategories()

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
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func loadCategories() {
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        
        SpotagoryAPI.sendGetRequest("/categories?per_page=24", token: nil, params: nil, completion: {(response, error) -> Void in
            
            if (response != nil) {
                MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
                
                print("response \(response)")
                
                let _meta = response!.objectForKey("_meta") as? NSDictionary
                
                if let resultCode = _meta!.objectForKey("status_code") as? NSNumber {
                    if resultCode.intValue == 200 {
                        if let value = response!.objectForKey("data") as? [AnyObject] {
                            self.categories = value
                            self.filterCollectionView.reloadData()
                            return
                        }
                        
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
                MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
                print("error \(error)")
            }
        })
        
    }
    
    func showErroralert(alert : String) {
        let alertController = UIAlertController(title: nil, message: alert, preferredStyle: .Alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let length = (UIScreen.mainScreen().bounds.width) / 3
        return CGSizeMake(length - 1,length);
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.categories == nil || self.categories!.count == 0 {
            return 0
        }
        return self.categories!.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let filterCell = collectionView.dequeueReusableCellWithReuseIdentifier("filterCell", forIndexPath: indexPath) as! FilterCell
        
        let category = self.categories![indexPath.row] as! [String:AnyObject]
        
        let url = category["thumbnail"] as? String
        filterCell.img_background.sd_setImageWithURL(NSURL(string: url!), placeholderImage: nil)
        
        filterCell.lblCategoryTitle.layer.masksToBounds = true
        filterCell.lblCategoryTitle.layer.cornerRadius = 13
        filterCell.lblCategoryTitle.text = category["name"] as? String
        
        filterCell.lblCategoryTitle.backgroundColor = UIColor(hexString: (category["color"] as? String)!)
        
        filterCell.btnSelect.tag = indexPath.row
        filterCell.btnSelect.addTarget(self, action: #selector(FilterViewController.getCategoryFilter(_:)), forControlEvents: .TouchUpInside)
        
        return filterCell
    }
    
    func getCategoryFilter(sender: UIButton){
        let category = self.categories![sender.tag] as! [String:AnyObject]
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
        if self.delegate != nil {
            self.delegate!.getCategoryFilter((category["_id"] as? String)!)
        }
    }
    
}
