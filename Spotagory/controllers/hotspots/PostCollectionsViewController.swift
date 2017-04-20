//
//  PostCollectionsViewController.swift
//  Spotagory
//
//  Created by Messia Engineer on 9/12/16.
//  Copyright © 2016 Spotagory. All rights reserved.
//

import UIKit

class PostCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var viewCommentView: UIView!
    @IBOutlet weak var viewContainer: UIView!
    
}

class PostCollectionsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var collectionViewPosts: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.automaticallyAdjustsScrollViewInsets = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBarHidden = false
        
        let addUser = UIBarButtonItem(image: UIImage(named: "icon_add_user"), style: .Plain, target: self, action: #selector(onAddUser))
        addUser.tintColor = UIColor.whiteColor()
        self.navigationItem.leftBarButtonItem = addUser
        
        let navBarLogoWidth = 108 / 320.0 * UIScreen.mainScreen().bounds.width
        let navBarLogoHeight = 26 / 320.0 * UIScreen.mainScreen().bounds.width
        
        let logoTitleView = UIView(frame: CGRectMake(0, 0, navBarLogoWidth, navBarLogoHeight))
        let logoImageView = UIImageView(image: UIImage(named: "img_logo"))
        logoImageView.frame = CGRectMake(0, 0, navBarLogoWidth, navBarLogoHeight)
        logoTitleView.addSubview(logoImageView)
        
        self.navigationItem.titleView = logoTitleView

    }
    
    func onAddUser() {
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("PostCollectionView", forIndexPath: indexPath) as! PostCollectionCell
        
        cell.viewContainer.layer.masksToBounds = true
        cell.viewContainer.layer.borderWidth = 1
        cell.viewContainer.layer.borderColor = UIColor(white: 0.7, alpha: 0.7).CGColor
        cell.viewContainer.layer.cornerRadius = 10
        cell.viewCommentView.layer.cornerRadius = 12
        return cell
    }
    
    func collectionView(collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                               sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake((collectionView.frame.width - 30) / 2, (collectionView.frame.width - 30) / 2 * 200 / 160)
    }

}
