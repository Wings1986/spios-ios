//
//  QuestionTutorCell.swift
//  spios
//
//  Created by Administrator on 6/9/15.
//  Copyright (c) 2015 Studypool. All rights reserved.
//

import UIKit


/// Question List tableview Cell at FeedViewController
public class QuestionBidCell: UITableViewCell {

    /// Avatar Imageview
    @IBOutlet weak var ivAvatar: UIImageView!
    /// Not used for now
    @IBOutlet weak var ivMask: UIImageView!
    /// Question Name Label
    @IBOutlet weak var lbName: UILabel!
    /// Price label
    @IBOutlet weak var lbPrice: UILabel!
    /// Rating Label
    @IBOutlet weak var lbRating: UILabel!
    /// Deadline Label
    @IBOutlet weak var lbDeadline: UILabel!
    /// Detail Button
    @IBOutlet weak var btnDetail: UIButton!
    @IBOutlet weak var btnDetail1: UIButton!
    /// UnRead Count Label
    @IBOutlet weak var lbUnread: UILabel!
    /// UnRead Background View
    @IBOutlet weak var unreadView: UIView!
    /// DetailView
    @IBOutlet weak var detailview: UIView!
    /// Tutor Rating Label
    @IBOutlet weak var tutorRating: UILabel!
    
    @IBOutlet weak var lblUniversity: UILabel!
    @IBOutlet weak var recommendedBadge: UIView!
    @IBOutlet weak var recommendedBadgeSmall: UIView!

    override public func awakeFromNib() {
        super.awakeFromNib()
        
        //Make avatar circle image
        ivAvatar.layer.cornerRadius = 	ivAvatar.frame.size.width/2
        ivAvatar.clipsToBounds = true
        
        ivMask.layer.cornerRadius = 	ivMask.frame.size.width/2
        ivMask.clipsToBounds = true
        
        recommendedBadge.layer.cornerRadius = 3
        recommendedBadgeSmall.layer.cornerRadius = 3
    }

    override public func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func loadBid(bid:BidModel) {
        
        ImageLoader.sharedLoader.imageForUrl(bid.avatar, imageview: self.ivAvatar, completionHandler:{(image: UIImage?, url: String) in
        })
        
        self.ivAvatar.layer.cornerRadius = self.ivAvatar.frame.width / 2
        self.ivAvatar.layer.masksToBounds = true
        
        let strRating = NSString(format: "%@", bid.rating)
        let rating = strRating.floatValue as Float
        
        self.lbRating.text = String(format: "%.01f", rating)
        self.lbName.text = bid.tutorname
        self.lblUniversity.text = bid.university
        
        if (bid.recommended) {
            let hasLongName = count(bid.tutorname) > 15;
            self.recommendedBadge.hidden = hasLongName;
            self.recommendedBadgeSmall.hidden = !hasLongName;
        }
        else {
            self.recommendedBadge.hidden = true;
            self.recommendedBadgeSmall.hidden = true;
        }
        
        self.lbPrice.text = String(format: "$%@", String((bid.price as NSString)))
        self.lbDeadline.text = String(format: "%@ %@", bid.deliverin, bid.timetype)
        
        if (bid.bid_notifications > 0) {
            self.unreadView.hidden = false
            self.lbUnread.text = String(bid.bid_notifications)
            self.lbUnread.hidden = false
            self.detailview.hidden = true
        }
        else {
            self.lbUnread.hidden = true
            self.unreadView.hidden = true
            self.detailview.hidden = false
        }
    }

}
