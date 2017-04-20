//
//  WhatsNewViewController.swift
//  Spotagory
//
//  Created by Messia Engineer on 8/24/16.
//  Copyright © 2016 Spotagory. All rights reserved.
//

import UIKit
import iCarousel

class WhatsNewViewController: UIViewController, iCarouselDataSource, iCarouselDelegate {

    let carouselCounting = 4
    
    @IBOutlet weak var iCarouselMain: iCarousel!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var labelPositionIndicator: UILabel!
    
    @IBOutlet weak var labelTitle: UILabel!
    
    var titleOfPage = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        pageControl.transform = CGAffineTransformMakeRotation(CGFloat(M_PI_2))
        iCarouselMain.vertical = true
        iCarouselMain.pagingEnabled = true
        iCarouselMain.clipsToBounds = true
        labelPositionIndicator.text = NSString(format: "%d/%d", 1, carouselCounting) as String
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBarHidden = true
        
        if titleOfPage != "" {
            self.labelTitle.text = titleOfPage
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
    
    @IBAction func onClose(sender: AnyObject) {
//        self.navigationController?.popViewControllerAnimated(true)
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func onUp(sender: AnyObject) {
        if self.iCarouselMain.currentItemIndex > 0 {
            self.iCarouselMain.scrollToItemAtIndex(self.iCarouselMain.currentItemIndex - 1, animated: true)
        }
    }
    
    @IBAction func onDown(sender: AnyObject) {
        if self.iCarouselMain.currentItemIndex < 3 {
            
            self.iCarouselMain.scrollToItemAtIndex(self.iCarouselMain.currentItemIndex + 1, animated: true)
            
        }
    }
    
    
    func numberOfItemsInCarousel(carousel: iCarousel) -> Int {
        return carouselCounting
    }
    
    func carousel(carousel: iCarousel, viewForItemAtIndex index: Int, reusingView view: UIView?) -> UIView {
        let view = UIView(frame: CGRectMake(0, 0, self.view.frame.size.width - 50, self.iCarouselMain.frame.size.height))
        view.backgroundColor = UIColor.clearColor()
        view.layer.masksToBounds = true
        
        let descriptionText = "Hey Marty, I'm not your answering service, but you're outside pouting about the car, Jennifer Parker called you twice. No, get out of town, my mom thinks I'm going camping with the guys."
        let size = descriptionText.sizeForFont(UIFont(name: "BrandonGrotesque-Regular", size: 13)!, constrained: CGSizeMake(self.view.frame.size.width - 50 - 10, CGFloat.max))
        
        let descriptionLabel = UILabel(frame: CGRectMake(10, 0, size.width, min(size.height, view.frame.size.height)))
        
        descriptionLabel.textColor = UIColor.whiteColor()
        descriptionLabel.font = UIFont(name: "BrandonGrotesque-Regular", size: 13)
        descriptionLabel.textAlignment = .Left
        descriptionLabel.numberOfLines = 0
        descriptionLabel.text = descriptionText
        
        view.addSubview(descriptionLabel)
        
        return view
    }
    
    func carouselItemWidth(carousel: iCarousel) -> CGFloat {
        return self.iCarouselMain.frame.size.height
    }
    
    func carousel(carousel: iCarousel, valueForOption option: iCarouselOption, withDefault value: CGFloat) -> CGFloat {
        switch option {
        case .FadeMin:
            return 0
        case .FadeMax:
            return 0
        case .FadeRange:
            return 2
        default:
            return value
        }
    }
    
    func carouselCurrentItemIndexDidChange(carousel: iCarousel) {
        self.pageControl.currentPage = carousel.currentItemIndex
        
        labelPositionIndicator.text = NSString(format: "%d/%d", carousel.currentItemIndex + 1, carouselCounting) as String
    }

}
