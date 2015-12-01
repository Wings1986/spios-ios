//
//  BHExpandingTextViewInternal.swift
//  spios
//
//  Created by Nhon Nguyen Van on 7/16/15.
//  Copyright (c) 2015 Studypool. All rights reserved.
//

import UIKit

class BHExpandingTextViewInternal: UITextView {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        self.font = UIFont(name: "helvetica", size: 17)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.font = UIFont().fontWithSize(17)
        
    }

}
