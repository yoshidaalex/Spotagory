//
//  SpotagoryKeeper.swift
//  Spotagory
//
//  Created by Messia Engineer on 9/26/16.
//  Copyright © 2016 Spotagory. All rights reserved.
//

import UIKit
import CoreLocation

class SpotagoryKeeper: NSObject {
    
    static let keeper = SpotagoryKeeper()
    
    func appAlreadyLaunched() -> Bool {
        return NSUserDefaults.standardUserDefaults().boolForKey("already_launched")
    }
    
    func setAppAlreadyLaunched() {
        NSUserDefaults.standardUserDefaults().setBool(true, forKey: "already_launched")
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    func saveUserProfile(profile : NSDictionary) {
        NSUserDefaults.standardUserDefaults().setBool(true, forKey: "user_saved")
        NSUserDefaults.standardUserDefaults().setObject(profile, forKey: "user_profile")
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    func userProfileSaved() -> Bool {
        return NSUserDefaults.standardUserDefaults().boolForKey("user_saved")
    }
    
    func removeSavedProfile() {
        NSUserDefaults.standardUserDefaults().removeObjectForKey("user_profile")
        NSUserDefaults.standardUserDefaults().removeObjectForKey("user_saved")
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    func loadUserProfile() -> NSDictionary? {
        if let profile = NSUserDefaults.standardUserDefaults().objectForKey("user_profile") as? NSDictionary {
            return profile
        }
        
        return nil
    }
    
    func getUserId() -> String? {
        if let userProfile = loadUserProfile() {
            return userProfile["_id"] as? String
        } else {
            return nil
        }
    }
    
    func setDeviceToken(token : NSString) {
        NSUserDefaults.standardUserDefaults().setValue(token, forKeyPath: "device_token")
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    func getDeviceToken() -> NSString {
        if let device_token = NSUserDefaults.standardUserDefaults().objectForKey("device_token") as? NSString {
            return device_token
        }
        
        return ""
    }
    
    func setCurrentLatitude(latitude : Double) {
        NSUserDefaults.standardUserDefaults().setValue(latitude, forKeyPath: "user_latitude")
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    func getCurrentLatitude() -> Double {
        if let user_latitude = NSUserDefaults.standardUserDefaults().objectForKey("user_latitude") as? Double {
            return user_latitude
        }
        
        return 0
    }
    
    func setCurrentLongitude(longitude : Double) {
        NSUserDefaults.standardUserDefaults().setValue(longitude, forKeyPath: "user_longitude")
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    func getCurrentLongitude() -> Double {
        if let user_longitude = NSUserDefaults.standardUserDefaults().objectForKey("user_longitude") as? Double {
            return user_longitude
        }
        
        return 0
    }
    
    func setUserToken(token : NSString) {
        NSUserDefaults.standardUserDefaults().setValue(token, forKeyPath: "access_token")
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    func getUserToken() -> NSString {
        if let access_token = NSUserDefaults.standardUserDefaults().objectForKey("access_token") as? NSString {
            return access_token
        }
        
        return ""
    }

}
