//
//  AddImageCollectionCell.swift
//  spios
//
//  Created by Jose Enrique on 10/6/15.
//  Copyright (c) 2015 Studypool. All rights reserved.
//

import UIKit

class AddImageCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var lblAdd: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.lblAdd.layer.cornerRadius = 4.0
        self.lblAdd.clipsToBounds = true
        self.lblAdd.layer.borderWidth = 4.0
        self.lblAdd.layer.borderColor = UIColor(white: 0.9, alpha: 1.0).CGColor
    }
}