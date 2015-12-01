//
//  ImageCollectionCell.swift
//  spios
//
//  Created by Nhon Nguyen Van on 6/27/15.
//  Copyright (c) 2015 Studypool. All rights reserved.
//

import UIKit


/// ImageCollection cell for attached images
class ImageCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var btnDeleteImgae: UIButton!
    @IBOutlet weak var imvUpload: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.imvUpload.layer.cornerRadius = 4.0
        self.imvUpload.clipsToBounds = true
        self.imvUpload.layer.borderWidth = 4.0
        self.imvUpload.layer.borderColor = UIColor(white: 0.9, alpha: 1.0).CGColor
    }
}
