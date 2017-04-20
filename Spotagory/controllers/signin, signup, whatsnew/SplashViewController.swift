//
//  SplashViewController.swift
//  Spotagory
//
//  Created by Messia Engineer on 8/23/16.
//  Copyright © 2016 Spotagory. All rights reserved.
//

import UIKit
import CoreLocation

class SplashViewController: UIViewController, CLLocationManagerDelegate {
    
    var locationManager : CLLocationManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestWhenInUseAuthorization()
            
            locationManager.startUpdatingLocation()
            //            locationManager.startUpdatingHeading()
        }
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBarHidden = true
        
        if SpotagoryKeeper.keeper.appAlreadyLaunched() {
            
            if SpotagoryKeeper.keeper.userProfileSaved() {
                let viewCon = self.storyboard?.instantiateViewControllerWithIdentifier("MainTabViewController")
                self.navigationController?.pushViewController(viewCon!, animated: true)
            } else {
                self.gotoSign()
            }
            
        } else {

            self.performSelector(#selector(goMain), withObject: nil, afterDelay: 1.0)

        }
        
    }
    
    func goMain() {
        self.performSegueWithIdentifier("sid_show", sender: nil)
    }
    
    func gotoSign() {
        self.performSegueWithIdentifier("sid_signin", sender: nil)
    }
    
    func gotoTab() {
        self.performSegueWithIdentifier("sid_tab", sender: nil)
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation:CLLocation = locations[0] as CLLocation
        
        // Call stopUpdatingLocation() to stop listening for location updates,
        // other wise this function will be called every time when user location changes.
        
        // manager.stopUpdatingLocation()
        
//        print(userLocation.coordinate.latitude)
        
        SpotagoryKeeper.keeper.setCurrentLatitude(userLocation.coordinate.latitude)
        SpotagoryKeeper.keeper.setCurrentLongitude(userLocation.coordinate.longitude)
        
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError)
    {
        print("Error \(error)")
    }

}
