//
//  QuestionDetailCell.swift
//  spios
//
//  Created by Administrator on 6/9/15.
//  Copyright (c) 2015 Studypool. All rights reserved.
//

import UIKit

class QuestionDetailCell: UITableViewCell {

    @IBOutlet weak var ivAvatar: UIImageView!
    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var lbCount: UILabel!
    @IBOutlet weak var lbTimestamp: UILabel!
//    @IBOutlet weak var lbDetail: UILabel!
    @IBOutlet weak var imageEmboss: UIImageView!
    @IBOutlet weak var lbDetail: UIWebView!
    
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        // Initialization code
        
        lbName.text = ""
        ivAvatar.image = nil
        lbCount.text = ""
        lbTimestamp.text = ""
        
        imageEmboss.layer.cornerRadius = imageEmboss.frame.size.width/2
        imageEmboss.clipsToBounds = true
      //  ivAvatar.layer.cornerRadius = 	ivAvatar.frame.size.width/2
        //ivAvatar.layer.borderWidth = 5;
        //ivAvatar.layer.borderColor = UIColor(red: 245/255.0, green: 245/255.0, blue: 245/255.0, alpha: 1.0).CGColor
        ivAvatar.clipsToBounds = true
        lbDetail.userInteractionEnabled = false
        lbDetail.scrollView.scrollEnabled = false
        lbDetail.scrollView.bounces = false
        lbDetail.opaque = false;
        lbDetail.backgroundColor = UIColor.clearColor()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
