//
//  StringExtensions.swift
//  Spotagory
//
//  Created by Messia Engineer on 8/24/16.
//  Copyright © 2016 Spotagory. All rights reserved.
//

import UIKit

extension String {
    
    static func className(aClass: AnyClass) -> String {
        return NSStringFromClass(aClass).componentsSeparatedByString(".").last!
    }
    
    func sizeForFont(font:UIFont, constrained size:CGSize) -> CGSize {
        
        let attributes = [NSFontAttributeName : font]
        let frame = NSString(string: self).boundingRectWithSize(size, options: .UsesLineFragmentOrigin, attributes: attributes, context:nil)
        let height = ceil(Double(frame.size.height))
        let width = ceil(Double(frame.size.width))
        
        return CGSizeMake(CGFloat(width), CGFloat(height))
    }
    
    var isEmailValid: Bool {
        do {
            let regex = try NSRegularExpression(pattern: "(?:[a-z0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[a-z0-9!#$%\\&'*+/=?\\^_`{|}~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\\[(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])", options: .CaseInsensitive)
            return regex.firstMatchInString(self, options: NSMatchingOptions(rawValue: 0), range: NSMakeRange(0, self.characters.count)) != nil
        } catch {
            return false
        }
    }
    
    func toDateTime() -> NSDate
    {
        //Create Date Formatter
        let dateFormatter = NSDateFormatter()
        
        //Specify Format of String to Parse
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        
        //Parse into NSDate
        let dateFromString : NSDate = dateFormatter.dateFromString(self)!
        
        //Return Parsed Date
        return dateFromString
    }
}

extension NSDate {
    
    // shows 1 or two letter abbreviation for units.
    // does not include 'ago' text ... just {value}{unit-abbreviation}
    // does not include interim summary options such as 'Just now'
    public var timeAgoSimple: String {
        let components = self.dateComponents()
        
        if components.year > 0 {
            if components.year < 2 {
                return String(components.year) + " Year ago"
            } else {
                return String(components.year) + " Years ago"
            }
        }
        
        if components.month > 0 {
            if components.month < 2 {
                return String(components.month) + " Month ago"
            } else {
                return String(components.month) + " Months ago"
            }
        }
        
        // TODO: localize for other calanders
        if components.day >= 7 {
            let value = components.day/7
            if value .hashValue < 2 {
                return String(value) + " Week ago"
            } else {
                return String(value) + " Weeks ago"
            }
            
        }
        
        if components.day > 0 {
            if components.day < 2 {
                return String(components.day) + " Day ago"
            } else {
                return String(components.day) + " Days ago"
            }
        }
        
        if components.hour > 0 {
            if components.hour < 2 {
                return String(components.hour) + " Hour ago"
            } else {
                return String(components.hour) + " Hours ago"
            }
        }
        
        if components.minute > 0 {
            if components.minute < 2 {
                return String(components.minute) + " Minute ago"
            } else {
                return String(components.minute) + " Minutes ago"
            }
        }
        
        if components.second > 0 {
            if components.second < 2 {
                return String(components.second) + " Second ago"
            } else {
                return String(components.second) + " Seconds ago"
            }
        }
        
        return ""
    }
    
    
    private func dateComponents() -> NSDateComponents {
        let calander = NSCalendar.currentCalendar()
        return calander.components([.Second, .Minute, .Hour, .Day, .Month, .Year], fromDate: self, toDate: NSDate(), options: [])
    }
}
