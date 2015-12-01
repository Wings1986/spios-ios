//
//  PromotionView.swift
//  spios
//
//  Created by MobileGenius on 9/30/15.
//  Copyright (c) 2015 Studypool. All rights reserved.
//

import UIKit

class PromotionView: UIView {
    
    @IBOutlet weak var tfPromocode: UITextField!
    @IBOutlet weak var shareButton: UIButton!
    
    @IBOutlet weak var view1: UIView!
    @IBOutlet weak var view2: UIView!
    @IBOutlet weak var view3: UIView!
    @IBOutlet weak var view4: UIView!
    
    @IBOutlet weak var imag: UIImageView!
    
    @IBOutlet weak var banner: UIImageView!
    @IBOutlet weak var ufo: UIImageView!
    
    @IBOutlet weak var topMarginConstraint: NSLayoutConstraint?

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    func initViews(){
        let spacerView = UIView(frame: CGRectMake(0, 0, 15, 10))
        self.tfPromocode.leftViewMode = UITextFieldViewMode.Always
        self.tfPromocode.leftView = spacerView
        //        ufo.frame = CGRectMake(ufo.frame.origin.x, -200, ufo.frame.width, ufo.frame.height)
        
        
        animate()
        animateUFO()
    }
    
    func animateUFO(){
        println(self.banner.frame.origin.y)
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            self.ufo.transform = CGAffineTransformMakeTranslation(0, self.banner.frame.origin.y-44)
            }) { (success) -> Void in
                UIView.animateWithDuration(0.5/2, animations: { () -> Void in
                    self.ufo.transform = CGAffineTransformMakeTranslation(0, self.banner.frame.origin.y-20)
                    }) { (success) -> Void in
                        UIView.animateWithDuration(0.5/2, animations: { () -> Void in
                            self.ufo.transform = CGAffineTransformMakeTranslation(0, self.banner.frame.origin.y-44)
                            }) { (success) -> Void in
                                
                        }
                        
                }
        }
        
    }
    
    
    func animate(){
        
        //        imag.layoutIfNeeded()
        //        UIView.animateWithDuration(3, animations: {
        //            self.topMarginConstraint?.constant = 5
        //            self.imag.layoutIfNeeded()
        //        })
        
        
        UIView.animateWithDuration(1.5, delay: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
            
            
            self.view1.transform = CGAffineTransformMakeTranslation(3,2)
            self.view2.transform = CGAffineTransformMakeTranslation(-3,2)
            self.view3.transform = CGAffineTransformMakeTranslation(3,2)
            self.view4.transform = CGAffineTransformMakeTranslation(-3,2)
            }) { (success) -> Void in
                UIView.animateWithDuration(1.5, delay: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
                    self.view1.transform = CGAffineTransformMakeTranslation(-3,-2)
                    self.view2.transform = CGAffineTransformMakeTranslation(3,-2)
                    self.view3.transform = CGAffineTransformMakeTranslation(-3,-2)
                    self.view4.transform = CGAffineTransformMakeTranslation(3,-2)
                    
                    
                    }) { (success) -> Void in
                        self.animate()
                }
        }
        
        
        
    }
}
