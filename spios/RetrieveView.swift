//
//  RetrieveView.swift
//  spios
//
//  Created by MobileGenius on 10/2/15.
//  Copyright (c) 2015 Studypool. All rights reserved.
//

import UIKit

class RetrieveView: UIView {

    @IBOutlet weak var sendpwButton: UIButton!
    @IBOutlet weak var sendPwConst: NSLayoutConstraint!
    
    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet weak var mailIconConst: NSLayoutConstraint!
    
    @IBOutlet weak var spLogo: UIImageView!
    @IBOutlet weak var forgetYourPass: UILabel!
    @IBOutlet weak var mailIcon: UIImageView!
    @IBOutlet weak var seperator: UIImageView!
    @IBOutlet weak var btLogin: UIButton!
    @IBOutlet weak var backConst: NSLayoutConstraint!
    
    var controller:RetrieveViewController!
    
    func viewwillappear(){
        self.tfEmail.attributedPlaceholder = NSAttributedString(string:"Please Enter Your Email Address", attributes:[NSForegroundColorAttributeName: UIColor(red: 255, green: 255, blue: 255, alpha: 0.7)])
        self.tfEmail.tintColor = UIColor(white: 1, alpha: 0.87)
    }
    
    func viewdidappear(){
        //no ufo animation necessary -- stanley
        animateForgetPass()
        controller.view.layoutIfNeeded()
        animateFromLeftAllOtherFields()
        
        // animateStudypoolLogo()
        
        
        
        // Do any additional setup after loading the view.
        self.sendpwButton.clipsToBounds = true
        self.sendpwButton.layer.cornerRadius = self.sendpwButton.bounds.size.height / 2
        controller.addDoneButtonToKeyboard(self.tfEmail)
    }
    
    func animateStudypoolLogo(){
        
        UIView.animateWithDuration(0.75, delay: 0.5, options: UIViewAnimationOptions.CurveEaseOut, animations: {
            
            self.spLogo.alpha = 0.0
            
            
            }, completion: nil)
    }
    func animateForgetPass(){
        self.forgetYourPass.alpha = 0.0
        
        UIView.animateWithDuration(1.35, delay: 0.5, options: nil, animations: {
            
            self.forgetYourPass.alpha = 1.0
            
            
            }, completion: nil)
    }
    func animateFromLeftAllOtherFields(){
        self.sendPwConst.constant = 0
        self.backConst.constant = 0
        self.mailIconConst.constant = 10
        
        self.mailIcon.alpha = 0.0
        self.seperator.alpha = 0.0
        
        self.btLogin.alpha = 0.0
        self.sendpwButton.alpha = 0.0
        self.tfEmail.alpha = 0.0
        
        
        UIView.animateWithDuration(1.35, animations: { () -> Void in
            self.forgetYourPass.alpha = 1.0
            self.mailIcon.alpha = 1.0
            self.seperator.alpha = 1.0
            
            self.btLogin.alpha = 1.0
            self.sendpwButton.alpha = 1.0
            self.tfEmail.alpha = 1.0
            //			self.fieldsView.transform = CGAffineTransformMakeTranslation(0, self.spLogo.frame.origin.y+225)
            
            self.controller.view.layoutIfNeeded()
            }) { (success) -> Void in
                
        }
    }

}
