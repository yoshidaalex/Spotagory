//
//  ChangeRadiusViewController.swift
//  Spotagory
//
//  Created by Admin on 05/12/2016.
//  Copyright © 2016 Spotagory. All rights reserved.
//

import UIKit

class ChangeRadiusViewController: UIViewController {
    
    let rangeSlider = RangeSlider(frame: CGRectZero)
    
    @IBOutlet weak var btnApply: UIButton!
    @IBOutlet weak var m_parentView: UIView!
    @IBOutlet weak var m_labelMiles: UILabel!
    
    var delegate : ChangeRadiusDelegate? = nil
    
    var max_radius : Double = 300
    var min_radius : Double = 50
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.automaticallyAdjustsScrollViewInsets = false
        
        m_parentView.addSubview(rangeSlider)
        
        rangeSlider.addTarget(self, action: #selector(ChangeRadiusViewController.rangeSliderValueChanged(_:)), forControlEvents: .ValueChanged)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
        let margin: CGFloat = 20.0
        let width = m_parentView.bounds.width - 2.0 * margin
        rangeSlider.frame = CGRect(x: margin, y: 105,
                                   width: width, height: 20.0)
        
        m_parentView.layer.cornerRadius = 10
        btnApply.layer.cornerRadius = 22
        
        let rectShape = CAShapeLayer()
        rectShape.bounds = self.m_labelMiles.frame
        rectShape.position = self.m_labelMiles.center
        rectShape.path = UIBezierPath(roundedRect: self.m_labelMiles.bounds, byRoundingCorners: [.TopRight, .TopLeft], cornerRadii: CGSize(width: 10, height: 20)).CGPath
        
        self.m_labelMiles.layer.mask = rectShape
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    
    func rangeSliderValueChanged(rangeSlider: RangeSlider) {
        print("Range slider value changed: (\(rangeSlider.lowerValue) \(rangeSlider.upperValue))")
        
        max_radius = rangeSlider.upperValue
        min_radius = rangeSlider.lowerValue
    }

    @IBAction func actionResetAll(sender: AnyObject) {
        
    }
    
    @IBAction func actionClose(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func actionApply(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
        
        if self.delegate != nil {
            self.delegate!.getRadius(Int(max_radius), min: Int(min_radius))
        }
    }
}