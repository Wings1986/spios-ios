//
//  ProfileTableViewCell.swift
//
//  Created by Dom Bryan on 27/05/2015.
//  Modified by Andrew Mikhailov on 2015.06.17.
//  Copyright (c) 2015 Dom Bryan. All rights reserved.
//

import UIKit

class ProfileTableViewCell: UITableViewCell {

    @IBOutlet weak var reviewView: UITextView!
    @IBOutlet weak var cellLabel1: UILabel!
    @IBOutlet weak var cellImage: UIImageView!
    @IBOutlet weak var startMark: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var maskImage: UIImageView!
    
    override func awakeFromNib() {

        super.awakeFromNib()
        
        self.cellImage.layer.cornerRadius = self.cellImage.frame.width / 2.0
        self.cellImage.clipsToBounds = true
        self.maskImage.layer.cornerRadius = self.maskImage.frame.width / 2.0
        self.maskImage.clipsToBounds = true
        self.userInteractionEnabled = false
        self.selectionStyle = UITableViewCellSelectionStyle.None
    }
}