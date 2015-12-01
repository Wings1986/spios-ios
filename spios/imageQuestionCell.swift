//
//  imageQuestionCell.swift
//  spios
//
//  Created by Stanley Chiang on 7/9/15.
//  Copyright (c) 2015 Studypool. All rights reserved.
//

import UIKit

/// Tableview cell for discussion

class ImageQuestionCell : UICollectionViewCell {
    
    @IBOutlet weak var IMG: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // make image round corner
        self.IMG.layer.cornerRadius = 3.0
        self.IMG.layer.borderWidth = 3.0
        self.IMG.layer.borderColor = UIColor.grayColor().CGColor
        
        //this is important, or else the image will overflow the view, and the border will be inside the view.
        self.IMG.clipsToBounds = true
        
        // make shadow border
        self.IMG.layer.shadowColor = UIColor.darkGrayColor().CGColor
        self.IMG.layer.shadowOffset = CGSizeMake(0, 1)
        self.IMG.layer.shadowOpacity = 1
        self.IMG.layer.shadowRadius = 2
        
    }
    
}