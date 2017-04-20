//
//  SignupTutorialViewController.swift
//  Spotagory
//
//  Created by Messia Engineer on 8/24/16.
//  Copyright © 2016 Spotagory. All rights reserved.
//

import UIKit
import iCarousel

class SignupTutorialViewController: UIViewController, iCarouselDataSource, iCarouselDelegate {
    
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var iCarouselMain: iCarousel!
    @IBOutlet weak var buttonGetStarted: UIButton!
    @IBOutlet weak var pageControl: UIPageControl!
    
    let welcomeImages = ["img_welcome_01", "img_welcome_02", "img_welcome_03", "img_welcome_04"]
    let welcomeTitles = ["Explore New Places", "The Science Of Superstitions", "The Amazing Hubble", "How To Build A PC"]
    let welcomeDescriptions = ["Well, ma, we talked about this, we're not gonna go to the lake, the car's wrecked. Believe me, Marty, you're better off not having to worry.",
                               "Well, ma, we talked about this, we're not gonna go to the lake, the car's wrecked. Believe me, Marty, you're better off not having to worry.",
                               "Well, ma, we talked about this, we're not gonna go to the lake, the car's wrecked. Believe me, Marty, you're better off not having to worry.",
                               "Well, ma, we talked about this, we're not gonna go to the lake, the car's wrecked. Believe me, Marty, you're better off not having to worry."]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.iCarouselMain.pagingEnabled = true
        self.pageControl.currentPage = 1
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBarHidden = true
        self.navigationController?.interactivePopGestureRecognizer?.enabled = false
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.buttonGetStarted.layer.borderColor = UIColor.whiteColor().CGColor
        self.buttonGetStarted.layer.borderWidth = 1
        self.buttonGetStarted.layer.cornerRadius = self.buttonGetStarted.frame.size.height / 2
    }
    
    func numberOfItemsInCarousel(carousel: iCarousel) -> Int {
        return 4
    }
    
    func carousel(carousel: iCarousel, viewForItemAtIndex index: Int, reusingView view: UIView?) -> UIView {
        let view = UIView(frame: CGRectMake(0, 0, self.iCarouselMain.frame.size.width - 60, self.iCarouselMain.frame.size.height))
        view.layer.cornerRadius = 10
        view.backgroundColor = UIColor.whiteColor()
        view.layer.masksToBounds = true
        
        let imageView = UIImageView(frame: CGRectMake(0, 0, self.iCarouselMain.frame.size.width - 60, self.iCarouselMain.frame.size.width - 60))
        imageView.image = UIImage(named: welcomeImages[index])
        view.addSubview(imageView)
        
        let titleLabel = UILabel(frame: CGRectMake(0, self.iCarouselMain.frame.size.width - 60, self.iCarouselMain.frame.size.width - 60, (self.iCarouselMain.frame.size.height - self.iCarouselMain.frame.size.width + 60) * 0.4))
        
        titleLabel.textColor = UIColor.blackColor()
        titleLabel.font = UIFont(name: "BrandonGrotesque-Regular", size: 20)
        titleLabel.textAlignment = .Center
        titleLabel.text = self.welcomeTitles[index]
        view.addSubview(titleLabel)
        
        let descriptionLabel = UILabel(frame: CGRectMake(20, self.iCarouselMain.frame.size.width - 60 + (self.iCarouselMain.frame.size.height - self.iCarouselMain.frame.size.width + 60) * 0.4, self.iCarouselMain.frame.size.width - 60 - 40, (self.iCarouselMain.frame.size.height - self.iCarouselMain.frame.size.width + 60) * 0.55))
        
        descriptionLabel.textColor = UIColor.blackColor()
        descriptionLabel.font = UIFont(name: "BrandonGrotesque-Regular", size: 12.5)
        descriptionLabel.textAlignment = .Center
        descriptionLabel.numberOfLines = 0
        descriptionLabel.text = self.welcomeDescriptions[index]
        view.addSubview(descriptionLabel)
        
        return view
    }
    
    func carouselItemWidth(carousel: iCarousel) -> CGFloat {
        return self.iCarouselMain.frame.size.width - 40
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
        self.pageControl.currentPage = carousel.currentItemIndex + 1
    }
    
    func carouselDidScroll(carousel: iCarousel) {
        
        if carousel.scrollOffset < -0.5 {
            
            self.performSelector(#selector(goBack), withObject: nil, afterDelay: 0.1)
            
        } else if carousel.scrollOffset > 3.5 {
            
            self.performSelector(#selector(goSignUp), withObject: nil, afterDelay: 0.1)
            
        }
    }
    
    func goBack() {
        if self.pageControl.currentPage == 1 {
            self.pageControl.currentPage = 0
            self.navigationController?.popViewControllerAnimated(true)
        }
    }
    
    func goSignUp() {
        if self.pageControl.currentPage == 4 {
            self.pageControl.currentPage = 5
            self.performSegueWithIdentifier("sid_signup", sender: nil)
        }
    }
    
}
