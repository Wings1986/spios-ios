//
//  ConfirmPhoneNumberView.swift
//  spios
//
//  Created by MobileGenius on 10/2/15.
//  Copyright (c) 2015 Studypool. All rights reserved.
//

import UIKit

class ConfirmPhoneNumberView: UIView {

    /// pin code text field
    @IBOutlet var textEntered: UITextField!
    
    var controller:ConfirmPhoneNumberViewController!
    
    func initviews(){
        
        let kForegroudColor = UIColor(red: 255, green: 255, blue: 255, alpha: 0.7)
        self.textEntered.attributedPlaceholder = NSAttributedString(string: self.textEntered.placeholder!,
            attributes:[NSForegroundColorAttributeName: kForegroudColor])
        self.textEntered.tintColor = UIColor(white: 1, alpha: 0.87)
        controller.addDoneButtonToKeyboard(textEntered)
        controller.view.userInteractionEnabled = true
        
    }

}
