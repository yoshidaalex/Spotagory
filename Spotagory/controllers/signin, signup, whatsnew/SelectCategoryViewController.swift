//
//  SelectCategoryViewController.swift
//  Spotagory
//
//  Created by Messia Engineer on 8/24/16.
//  Copyright © 2016 Spotagory. All rights reserved.
//

import UIKit
import MBProgressHUD

protocol CategoryCellDelegate {
    func categoryCell(cell : CategoryCell, selected : Bool, forCategory : [String : AnyObject] )
}

class CategoryCell: UITableViewCell {
    
    @IBOutlet weak var buttonSelected: UIButton!
    @IBOutlet weak var labelCategoryName: UILabel!
    
    var category : [String : AnyObject]? = nil
    
    var delegate : CategoryCellDelegate? = nil
    
    @IBAction func onSelectCategory(sender: AnyObject) {
        
        (sender as! UIButton as UIButton!).selected = !((sender as! UIButton).selected)
        
        if self.delegate != nil {
            self.delegate!.categoryCell(self, selected: (sender as! UIButton as UIButton!).selected, forCategory: self.category!)
        }
        
    }
    
    func configureWithSelected(selected : Bool, category : [String : AnyObject]) {
        buttonSelected.selected = selected
        self.category = category
        self.labelCategoryName.text = category["name"] as? String
    }
    
}

class SelectCategoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CategoryCellDelegate {

    @IBOutlet weak var tableViewMain: UITableView!
    
    var fromProfilePage = false
    
    var fromCameraPage = false
    
    var categories : [AnyObject]? = nil
    
    var selectedCategoryIds = [String]()
    
    var shouldSelectOnlyOne = false
    var selectedCategoryId = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.automaticallyAdjustsScrollViewInsets = false
        self.tableViewMain.tableFooterView = UIView()
        
        self.loadCategories()
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
    }
    
    @IBAction func actionClose(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.categories == nil || self.categories!.count == 0 {
            return 0
        }
        return self.categories!.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("CategoryCell") as! CategoryCell
        let category = self.categories![indexPath.row] as! [String:AnyObject]
        cell.configureWithSelected(self.isSelectedCategory(category), category: category)
        cell.delegate = self
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView .deselectRowAtIndexPath(indexPath, animated: true)
        
        let category = self.categories![indexPath.row] as! [String:AnyObject]
        
        
        if self.isSelectedCategory(category) {
            self.removeCategory(category["_id"]! as! String)
        } else {
            self.selectedCategoryIds.append(category["_id"]! as! String)
            
            self.performSegueWithIdentifier("sid_camera", sender: nil)
        }
    }
    
    @IBAction func actionNext(sender: AnyObject) {
        if self.selectedCategoryIds.count == 0 {
            
            self.showErroralert("Please select at least 1 category")
            return
            
        }
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
                            self.tableViewMain.reloadData()
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
    
    func categoryCell(cell : CategoryCell, selected : Bool, forCategory : [String : AnyObject] ) {
        
        if selected {
            
            if !shouldSelectOnlyOne {
                self.selectedCategoryIds.append(forCategory["_id"]! as! String)
            }
        } else {
            
            if !shouldSelectOnlyOne {
                self.removeCategory(forCategory["_id"]! as! String)
            }
        }
    }
    
    func isSelectedCategory(category : [String : AnyObject]) -> Bool {
        
        if shouldSelectOnlyOne {
            if self.selectedCategoryId == category["_id"] as? String {
                return true
            }
            return false
        }
        
        for categoryId in self.selectedCategoryIds {
            if categoryId == category["_id"] as? String {
                return true
            }
        }
        
        return false
    }
    
    func removeCategory(categoryIdToRemove : String) {
        var index : Int = 0
        for categoryId in self.selectedCategoryIds {
            if categoryId == categoryIdToRemove {
                self.selectedCategoryIds.removeAtIndex(index)
                return
            }
            
            index = index + 1
        }
    }
    
    func processPost() {
        
        var files = [Dictionary<String, AnyObject>]()
        
        if PostKeeper.keeper.mediaType == 0 {
        
            let filename = "iosc\(NSDate().timeIntervalSince1970).jpg"
            
            files.append(["data" : UIImageJPEGRepresentation(PostKeeper.keeper.imageTaken!, 90)!,
                "name" : "media",
                "filename" : filename,
                "mimeType" : "image/jpeg"])
            
        } else {
            
            let videoURL = PostKeeper.keeper.videoTaken
            let filename = videoURL!.lastPathComponent
            print(filename)
            let mimeType = videoURL!.mimeType()
            print(mimeType)
            let videoData = NSData(contentsOfURL: videoURL!)
            print ("video data \(videoData?.length)")
            
            files.append(["data" : videoData!,
                "name" : "media",
                "filename" : filename!,
                "mimeType" : mimeType])
            
        }
        
//        print("files\(files)")
        
        let loader = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        loader.labelText = "Uploading..."
//        SpotagoryAPI.apiInstance.httpPostTo("upload_post",
//                                            files : files,
//                                            params: ["userid" : SpotagoryKeeper.keeper.getUserId()!,
//                                                "category_id" : PostKeeper.keeper.postCategoryId,
//                                                "caption" : PostKeeper.keeper.mediaCaption,
//                                                "type" : "\(PostKeeper.keeper.mediaType)"],
//                                            progressCallback: { (progress) in
//                                                print ("Post progress - \(progress)")
//                                                loader.detailsLabelText = NSString(format: "%.0f%%", progress * 100) as String
//                                            },
//                                            successCallback: { (response) in
//                                                loader.hide(true)
//                                                MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
//                                                
//                                                print("response \(response)")
//                                                
//                                                if response != nil {
//                                                    if let resp = response as? NSDictionary {
//                                                        if let resultCode = resp.objectForKey("res") as? NSNumber {
//                                                            if resultCode.intValue == 0 {
//                                                                
//                                                                if let error = resp.objectForKey("error") as? NSDictionary {
//                                                                    if let errorDescription = error.objectForKey("description") as? String {
//                                                                        self.showErroralert(errorDescription)
//                                                                        return
//                                                                    }
//                                                                }
//                                                                
//                                                            } else {
//                                                                
//                                                                /*
//                                                                 * {
//                                                                    res = 1;
//                                                                        value =     {
//                                                                        file = "iosc1476724986.28216.jpg";
//                                                                        "post_id" = 1;
//                                                                        };
//                                                                    }
//                                                                 */
//                                                                
////                                                                self.showErroralert("Successfully Posted.")
//                                                                
//                                                                self.gotoNextPage()
//                                                                
//                                                                NSNotificationCenter.defaultCenter().postNotification(NSNotification(name: SpotagoryConstants.gNotificationNewPostUploaded, object: resp.objectForKey("value")))
//                                                                
//                                                                return
//
//                                                                
//                                                            }
//                                                        }
//                                                    }
//                                                    
//                                                }
//                                                
//                                                self.showErroralert("Unknown Server Error")
//                                            },
//                                            failedCallback: { (error) in
//                                                
//                                                MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
//                                                print("error \(error)")
//                                                
////                                                let errorResponse = NSString(data: error?.userInfo["com.alamofire.serialization.response.error.data"] as! NSData, encoding: NSUTF8StringEncoding)
////                                                
////                                                print ("error response \(errorResponse)")
//                                                
//                                            })
    }

}
