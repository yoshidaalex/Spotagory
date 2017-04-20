//
//  PostCell.swift
//  Spotagory
//
//  Created by Messia Engineer on 9/3/16.
//  Copyright © 2016 Spotagory. All rights reserved.
//

import UIKit

protocol PostCellDelegate {
    func postCell(cell : PostCell, shareWithData data:AnyObject?)
}

class PostCell: UITableViewCell {
    
    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var postUserAvatar: UIImageView!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblMilesLocation: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    
    @IBOutlet weak var viewComment: UIView!
    @IBOutlet weak var btnComment: UIButton!
    
    @IBOutlet weak var viewCategory: UIView!
    @IBOutlet weak var lblCategory: UILabel!
    @IBOutlet weak var btnCategory: UIButton!
    
    @IBOutlet weak var constraintForImageHeight: NSLayoutConstraint!
    @IBOutlet weak var constraintForButton: NSLayoutConstraint!
    
    @IBOutlet weak var lblLikeCount: UILabel!
    @IBOutlet weak var lblCommentCount: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    
    @IBOutlet weak var img_thumbnail: UIImageView!
    @IBOutlet weak var icon_video: UIImageView!
    @IBOutlet weak var btnSelectImage: UIButton!
    
    @IBOutlet weak var btnLike: UIButton!
    
    var delegate : PostCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func onShare(sender: AnyObject) {
        if delegate != nil {
            delegate!.postCell(self, shareWithData: nil)
        }
    }
    
}
