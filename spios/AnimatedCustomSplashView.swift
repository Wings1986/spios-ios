//
//  AnimatedCustomSplashView.swift
//  spios
//
//  Created by MobileGenius on 9/23/15.
//  Copyright (c) 2015 Studypool. All rights reserved.
//

import UIKit

class AnimatedCustomSplashView: UIView {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

    
    @IBOutlet weak var imvBackground: UIImageView!
    
    @IBOutlet weak var imvBlurView: UIImageView!
    @IBOutlet weak var imvLogoView: UIImageView!
    @IBOutlet weak var imvLogoText: UIImageView!
    @IBOutlet weak var lblSlogan: UILabel!
    
    @IBOutlet weak var lbBelowFirst: UILabel!
    @IBOutlet weak var lbBelowSecond: UILabel!
    @IBOutlet weak var lbBelowThird: UILabel!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        
        
    }
    
    func initviews(){
        
        var image = self.imvBackground.image
        //add blur
        imvBlurView.image = image?.applyBlurWithRadius(5, tintColor: UIColor(white: 1.0, alpha: 0.0), saturationDeltaFactor: 1.0, maskImage: nil)
        imvBlurView.alpha = 0
        imvLogoView.alpha = 0
        imvLogoText.alpha = 0
        lblSlogan.alpha = 0
        lbBelowFirst.alpha = 0
        lbBelowSecond.alpha = 0
        lbBelowThird.alpha = 0
    }
    
    func viewdidappear(){
        
        NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: Selector("showBlur"), userInfo: nil, repeats: false)
        NSTimer.scheduledTimerWithTimeInterval(1.2, target: self, selector: Selector("showLogo"), userInfo: nil, repeats: false)
        NSTimer.scheduledTimerWithTimeInterval(1.6, target: self, selector: Selector("showLogoText"), userInfo: nil, repeats: false)
        
        NSTimer.scheduledTimerWithTimeInterval(2.7, target: self, selector: Selector("showBelowText1"), userInfo: nil, repeats: false)
        NSTimer.scheduledTimerWithTimeInterval(2.7, target: self, selector: Selector("showBelowText2"), userInfo: nil, repeats: false)
        NSTimer.scheduledTimerWithTimeInterval(2.7, target: self, selector: Selector("showBelowText3"), userInfo: nil, repeats: false)
        
        
        
    }
    
    func showBlur()
    {
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            self.imvBlurView.alpha = 1
        })
    }
    
    func showLogo()
    {
        self.imvLogoView.transform = CGAffineTransformMake(1, 0, 0, 1, 0, 10)
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            self.imvLogoView.alpha = 1
            self.imvLogoView.transform = CGAffineTransformIdentity
        })
    }
    
    func showLogoText()
    {
        self.imvLogoText.transform = CGAffineTransformMake(1, 0, 0, 1, 0, 10)
        self.lblSlogan.transform = CGAffineTransformMake(1, 0, 0, 1, 0, 10)
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            self.imvLogoText.alpha = 1
            self.imvLogoText.transform = CGAffineTransformIdentity
            self.lblSlogan.alpha = 1
            self.lblSlogan.transform = CGAffineTransformIdentity
        })
    }
    
    
    
    func showBelowText1()
    {
        self.lbBelowFirst.transform = CGAffineTransformMake(1, 0, 0, 1, 0, 10)
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            self.lbBelowFirst.alpha = 1
            self.lbBelowFirst.transform = CGAffineTransformIdentity
        })
    }
    
    func showBelowText2()
    {
        self.lbBelowSecond.transform = CGAffineTransformMake(1, 0, 0, 1, 0, 10)
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            self.lbBelowSecond.alpha = 1
            self.lbBelowSecond.transform = CGAffineTransformIdentity
        })
    }
    
    func showBelowText3()
    {
        self.lbBelowThird.transform = CGAffineTransformMake(1, 0, 0, 1, 0, 10)
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            self.lbBelowThird.alpha = 1
            self.lbBelowThird.transform = CGAffineTransformIdentity
        })
    }

}
