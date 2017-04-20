//
//  MediaCallback.swift
//  Spotagory
//
//  Created by Messia Engineer on 9/27/16.
//  Copyright © 2016 Spotagory. All rights reserved.
//

import UIKit

@objc protocol MediaCallback {
    
    optional func imageTaken(image : UIImage?, caption : String?, description : String?)
    optional func videoTaken(videoUrl : NSURL?, caption : String?, description : String?)
    
}
