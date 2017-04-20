//
//  PostKeeper.swift
//  Spotagory
//
//  Created by Messia Engineer on 10/13/16.
//  Copyright © 2016 Spotagory. All rights reserved.
//

import UIKit

class PostKeeper: NSObject {
    
    static let keeper = PostKeeper()
    
    var mediaType = 0       // 0 for image, 1 for video
    
    var imageTaken : UIImage? = nil
    var videoTaken : NSURL? = nil
    
    var mediaCaption = ""
    var postCategoryId = ""
    
    func clearKeeper() {
        mediaCaption = ""
        postCategoryId = ""
        imageTaken = nil
        videoTaken = nil
    }
    
}
