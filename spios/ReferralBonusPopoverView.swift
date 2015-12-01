//
//  ReferralBonusPopoverView.swift
//  spios
//
//  Created by Nishanth Salinamakki on 6/26/15.
//  Copyright (c) 2015 Studypool. All rights reserved.
//

import UIKit

protocol ReferralBonusPopoverViewDelegate {
    func onDismiss()
}

class ReferralBonusPopoverView: UIView {
    
    var delegate : ReferralBonusPopoverViewDelegate?
    
    @IBOutlet weak var promoMoneyAmount: UILabel!
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    var originalPoint: CGPoint!

    @IBOutlet var friendSignupLabel: UILabel!
    @IBOutlet var signupTitle: UILabel!
    
    class func loadFromNibNamed(nibNamed: String, bundle : NSBundle? = nil) -> UIView? {
        
        let parameters = [
            "token": token,
        ]
        
        
                
        return UINib(
            nibName: nibNamed,
            bundle: bundle
            ).instantiateWithOwner(nil, options: nil)[0] as? UIView
    }
    
    func dragged(gestureRecognizer: UIPanGestureRecognizer) -> Void {
        var xDistance : CGFloat = gestureRecognizer.translationInView(self).x
        var yDistance: CGFloat! = gestureRecognizer.translationInView(self).y
        println("SWIPE CALLED!")
        
        switch(gestureRecognizer.state) {
        case UIGestureRecognizerState.Began:
            originalPoint = self.center
            break;
        case UIGestureRecognizerState.Changed:
            var rotationStrength: CGFloat = min(xDistance / 320, 1)
            //var rotationStrengthFloat: Float = Float(rotationStrength)
            var rotationAngle: CGFloat = (2 * CGFloat(M_PI)/16 * rotationStrength)
            var scaleStrength: CGFloat = 1 - fabs(rotationStrength) / 4
            var scale: CGFloat = max(scaleStrength, 0.93)
            var transform: CGAffineTransform = CGAffineTransformMakeRotation(rotationAngle)
            var scaleTransform: CGAffineTransform = CGAffineTransformScale(transform, scale, scale)
            transform = scaleTransform
            var center: CGPoint = CGPointMake(originalPoint.x + xDistance, originalPoint.y + yDistance)
            
            self.updateOverlay(xDistance)
            
            break;
        case UIGestureRecognizerState.Possible:
            break;
        case UIGestureRecognizerState.Cancelled:
            break;
        case UIGestureRecognizerState.Failed:
            break;
        default:
            break;
        }
    }
    
    func updateOverlay(distance: CGFloat) {
        if (distance > 0) {
            delegate?.onDismiss()
            println("SWIPE CALLED")
        }
    }
    
    @IBAction func onDismiss(sender: UIButton) {
        appDelegate.window?.rootViewController?.lew_dismissPopupView()
        delegate?.onDismiss()
    }
    
    @IBAction func awesomeButtonPressed(sender: UIButton) {
        appDelegate.window?.rootViewController?.lew_dismissPopupView()
        delegate?.onDismiss()
    }

}
