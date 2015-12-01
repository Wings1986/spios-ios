//
//  WelcomeBackPopoverView.swift
//  spios
//
//  Created by Nishanth Salinamakki on 6/26/15.
//  Copyright (c) 2015 Studypool. All rights reserved.
//

import UIKit

protocol WelcomeBackPopoverViewDelegate {
    func onDismiss()
}

class WelcomeBackPopoverView: UIView {
    
    var delegate : WelcomeBackPopoverViewDelegate?
    
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    var originalPoint: CGPoint!
    
    class func loadFromNibNamed(nibNamed: String, bundle : NSBundle? = nil) -> UIView? {
        
        //Error with creating a view (swipableView) in which the panGestureRecognizer is added
        
        var swipableView: SwipableView = SwipableView.alloc()
        swipableView.frame = UIScreen.mainScreen().bounds
        
        var panGestureRecognizer: UIPanGestureRecognizer = UIPanGestureRecognizer()
        panGestureRecognizer.addTarget(self, action: Selector("dragged:"))
        swipableView.addGestureRecognizer(panGestureRecognizer)
        
        let parameters = [
            "token": token,
        ]
        
        
        return UINib(
            nibName: nibNamed,
            bundle: bundle
            ).instantiateWithOwner(nil, options: nil)[0] as? UIView
    }
    
    // MARK: UIPanGestureRecognizer methods implemented; will dismiss popup with animation if swiped across a distance greater than 0
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
//        delegate?.onDismiss()
    }
    
    @IBAction func askQuestionButtonPressed(sender: UIButton) {
        
        var storyboard = UIStoryboard(name: "Feed", bundle: nil)
        let feedViewController = storyboard.instantiateViewControllerWithIdentifier("Feed") as! FeedViewController
        
        let nav = UINavigationController(rootViewController: feedViewController) as UINavigationController
        
        delegate?.onDismiss()
        
        let slidermenu =  self.appDelegate.window?.rootViewController as! SlideMenuController
        slidermenu.changeMainViewController(nav, close: true)
                appDelegate.window?.rootViewController?.lew_dismissPopupView()
    }

}
