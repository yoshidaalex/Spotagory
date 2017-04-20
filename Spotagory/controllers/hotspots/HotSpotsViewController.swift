//
//  HotSpotsViewController.swift
//  Spotagory
//
//  Created by Messia Engineer on 8/26/16.
//  Copyright © 2016 Spotagory. All rights reserved.
//

import UIKit

class HotSpotsViewController: UIViewController {

    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelDescription1: UILabel!
    @IBOutlet weak var labelDescription2: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        if UIScreen.mainScreen().bounds.size.height <= 568 {
            labelTitle.font = UIFont(name: labelTitle.font!.fontName, size: 18)
            labelDescription1.font = UIFont(name: labelDescription1.font!.fontName, size: 10)
            labelDescription2.font = UIFont(name: labelDescription2.font!.fontName, size: 10)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBarHidden = false
        self.navigationItem.title = "HotSpots"
        
        let rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "icon_plus_white"), style: .Plain, target: self, action: #selector(onAdd))
        rightBarButtonItem.tintColor = UIColor.whiteColor()
        self.navigationItem.rightBarButtonItem = rightBarButtonItem
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func onAdd() {
        self.performSegueWithIdentifier("sid_add", sender: nil)
    }

}
