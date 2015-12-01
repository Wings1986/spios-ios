//
//  AnsweredQuestionPopoverView.swift
//  spios
//
//  Created by Administrator on 7/3/15.
//  Copyright (c) 2015 Studypool. All rights reserved.
//

import UIKit


protocol AnsweredQuestionPopoverViewDelegate {
    func onDismiss()
    func onGotoDetail(question:QuestionModel)
}



class AnsweredQuestionPopoverView: UIView {


    var delegate : AnsweredQuestionPopoverViewDelegate?

    var originalPoint: CGPoint!
    
    
    var question:QuestionModel!
    
    
    class func loadFromNibNamed(nibNamed: String, bundle : NSBundle? = nil) -> UIView? {
        
        //Error with creating a view (swipableView) in which the panGestureRecognizer is added
		let screenSize: CGRect = UIScreen.mainScreen().bounds
		let screenHeight = screenSize.height
		
	
        var swipableView: SwipableView = SwipableView.alloc()
        swipableView.frame = UIScreen.mainScreen().bounds
        
        var panGestureRecognizer: UIPanGestureRecognizer = UIPanGestureRecognizer()
        panGestureRecognizer.addTarget(self, action: Selector("dragged:"))
        swipableView.addGestureRecognizer(panGestureRecognizer)
        
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
        delegate?.onDismiss()
    }
    
    @IBAction func onOkay(sender: UIButton) {
        //if(question == nil){
            delegate?.onDismiss()
       // }else{
      //      delegate?.onGotoDetail(question)
      //  }
    }
    
}
