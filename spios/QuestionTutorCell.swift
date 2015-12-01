//
//  QuestionTutorCell.swift
//  spios
//
//  Created by Administrator on 6/9/15.
//  Copyright (c) 2015 Studypool. All rights reserved.
//

import UIKit

// Tutor bid list cell view
class QuestionTutorCell: UITableViewCell {

    /// Tutor Avatar ImageView
    @IBOutlet weak var ivAvatar: UIImageView!
    /// Tutor Name Label
    @IBOutlet weak var lbName: UILabel!
    /// Title Label
    @IBOutlet weak var lbTitle: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
