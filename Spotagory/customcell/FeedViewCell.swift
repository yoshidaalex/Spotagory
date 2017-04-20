//
//  FeedViewCell.swift
//  Spotagory-V2.0.1
//
//  Created by Abubakar on 2/6/16.
//  Copyright © 2016 Spotagory. All rights reserved.
//

import UIKit

class FeedViewCell: UICollectionViewCell {

    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var viewComment: UIView!
    @IBOutlet weak var btnComment: UIButton!
    
    @IBOutlet weak var postUserAvatar: UIImageView!
    @IBOutlet weak var lblUsername: UILabel!
    
    @IBOutlet weak var constraintForImageHeight: NSLayoutConstraint!
    @IBOutlet weak var contraintForButton: NSLayoutConstraint!
    
    @IBOutlet weak var lblMilesLocation: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    
    @IBOutlet weak var viewCategory: UIView!
    @IBOutlet weak var lblCategory: UILabel!
    
    @IBOutlet weak var lblLikeCount: UILabel!
    @IBOutlet weak var lblCommentCount: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    
    @IBOutlet weak var img_thumbnail: UIImageView!
    @IBOutlet weak var icon_video: UIImageView!
    @IBOutlet weak var btnSelectImage: UIButton!
    
    @IBOutlet weak var btnLike: UIButton!

}
