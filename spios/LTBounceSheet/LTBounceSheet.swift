//
//  LTBounceSheet.swift
//  LTBounceSheet
//
//  Created by vale on 5/20/15.
//  Copyright (c) 2015 changweitu@gmail.com. All rights reserved.
//


// For better understanding I'd suggest looking through https://github.com/ltebean/LTBounceSheet/tree/master/LTBounceSheet
// centerHelperView & sideHelperView are used to create effects during animations
// centerHelperView - is in response for animation connected with height of the view and sideViewVelocity - with width
import UIKit
let duration = Double(0.1)
let sideViewDamping = CGFloat(0.87)
let sideViewVelocity = CGFloat(10)
let centerViewDamping = CGFloat(1.0)
let centerViewVelocity = CGFloat(8)
let footer = CGFloat(75)

protocol LTBounceSheetDelegate: NSObjectProtocol
{
    func onSheetAnimationEnded()
}

class LTBounceSheet: UIView {

    private var sideHelperView: UIView! // is used if we want to change the width of the view while animating
    private var centerHelperView: UIView! // is used if we want to change the height of the view while animating
    private var displayLink: CADisplayLink!
    private var contentView: UIView! // where all the footer views are
    private var bgColor: UIColor!
    
    private var shown: Bool!
    private var counter: Int!
    private var height: CGFloat!
    private let screenHeight: CGFloat!
    
    weak private var mDelegate:LTBounceSheetDelegate!
    
    init(height: CGFloat, bgColor: UIColor) {
        
        self.height = height
        self.bgColor = bgColor
        self.counter = 0
        self.shown = false // initially hidden
        let screenRect = UIScreen.mainScreen().bounds
        let screenWidth = CGRectGetWidth(screenRect)
        screenHeight = CGRectGetHeight(screenRect)
        
        super.init(frame: CGRect(x: 0, y:screenHeight-height , width: screenWidth, height: height))
        
        self.contentView = UIView(frame: CGRectMake(0, 0, screenWidth, screenHeight))
        self.contentView.transform = CGAffineTransformMakeTranslation(0, height-footer) // moves contentView to the bottom of the screen so we see only the first of the footer subviews
        self.contentView.backgroundColor = bgColor
        self.addSubview(self.contentView)
        
        var swipeUp = UISwipeGestureRecognizer(target: self, action: "respondToSwipeGesture:")
        swipeUp.direction = UISwipeGestureRecognizerDirection.Up
        self.contentView.addGestureRecognizer(swipeUp)
        
        var swipeDown = UISwipeGestureRecognizer(target: self, action: "respondToSwipeGesture:")
        swipeDown.direction = UISwipeGestureRecognizerDirection.Down
        self.contentView.addGestureRecognizer(swipeDown)
        
        self.sideHelperView = UIView(frame: CGRectMake(0, height-footer, 0, 0))
        self.sideHelperView.backgroundColor = UIColor.blackColor()
        self.addSubview(self.sideHelperView)
        
        self.centerHelperView = UIView(frame: CGRectMake(screenWidth/2, height-footer, 0, 0))
        self.addSubview(self.centerHelperView)
        
        self.backgroundColor = UIColor.clearColor()
        UIApplication.sharedApplication().keyWindow?.subviews.last!.addSubview(self) // adding this view to current view that user sees
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func respondToSwipeGesture(gesture: UISwipeGestureRecognizer) {
        
        if gesture.direction == UISwipeGestureRecognizerDirection.Up {
            
            self.show()
            
        } else {
            
         
            self.hide()
        }
    }
    func addView(view: UIView) {
        
        self.contentView.addSubview(view) // adds view, so we can see it
    }
    
    func toggle() { // programmatically show or hide view with animation
        
        if self.shown == true {
            
            self.hide()
            
        } else {
            
            self.show()
            
        }
    }
    
    
    func show() {
        
        if self.counter != 0 {
            
            return
        }
        self.shown = true
        
        self.start()
        self.animateSideHelperViewToPoint(CGPointMake(self.sideHelperView.center.x, 0)) // creates animation
        self.animateCenterHelperViewToPoint(CGPointMake(self.centerHelperView.center.x, 0)) // creates animation
        self.animateContentViewToHeight(0) // moves footer views up
        
    }
    
    func hide() {
        
        
        if self.counter != 0 {
            
            return
        }
        self.shown = false
        self.start()
        let height = CGRectGetHeight(self.bounds)
        self.animateSideHelperViewToPoint(CGPointMake(self.sideHelperView.center.x, height-footer)) // move SideHelperView to the bottom of the screen so we can see only the first view of footer
        self.animateCenterHelperViewToPoint(CGPointMake(self.centerHelperView.center.x, height-footer))
        // move CenterHelperView to the bottom of the screen so we can see only the first view of footer
        self.animateContentViewToHeight(self.height-footer)
        // move our footer down so we can see only the first view of it
    }
    
    func animateSideHelperViewToPoint(point: CGPoint) {
        
        UIView.animateWithDuration(duration, delay: 0.0, usingSpringWithDamping: sideViewDamping, initialSpringVelocity: sideViewVelocity, options: UIViewAnimationOptions(0), animations: { () -> Void in
            
            self.sideHelperView.center = point // moves sideHelperView to the point
            
            }) { (finished: Bool) -> Void in
                
                self.complete()
        }
    
    }
    
    func animateCenterHelperViewToPoint(point: CGPoint) {
        
        UIView.animateWithDuration(duration, delay: 0.0, usingSpringWithDamping: centerViewDamping, initialSpringVelocity: centerViewVelocity, options: UIViewAnimationOptions(0), animations: { () -> Void in
            
            self.centerHelperView.center = point // moves center helper view to the point with physics-kinda animation
            
            }) { (finished: Bool) -> Void in
                
                self.complete()
                self.mDelegate.onSheetAnimationEnded() // calls delegate in question view controller to tell that we're done animating
        }
    }
    func animateContentViewToHeight(height: CGFloat) {
        
        
        UIView.animateWithDuration(duration, delay: 0.0, usingSpringWithDamping: centerViewDamping, initialSpringVelocity: centerViewVelocity, options: UIViewAnimationOptions(0), animations: ({
            
            self.contentView.transform = CGAffineTransformMakeTranslation(0, height); // moves footer to the height given
            
        }), completion: nil)
        
    }
    
    func tick(displayLink: CADisplayLink) {
        
        self.setNeedsDisplay() // updates display to create animation
    }
    
    func start() {
        
        if self.displayLink == nil {
            
            self.displayLink = CADisplayLink(target: self, selector: "tick:") // should call 'tick' method
            self.displayLink.addToRunLoop(NSRunLoop.currentRunLoop(), forMode: NSDefaultRunLoopMode) // adds animation process (in tick method) to current run loop to synchronize drawing to the refresh rate of the display
            
            self.counter = 2
        }
    }
    
    func complete() {
        
        self.counter = self.counter-1
        if self.counter==0 { // if both center and side helper views finished animating
            
            self.displayLink.invalidate() // remove updating view from running loops
            self.displayLink = nil
          
        }
    }
    
    override func drawRect(rect: CGRect) {
        
        if self.counter == 0 { // is called when we enter question detail vc
            
            super.drawRect(rect)
            return
        }
        
        if self.sideHelperView.layer.presentationLayer() != nil { // is called each time we show or hide footer
            
            let sideLayer = self.sideHelperView.layer.presentationLayer() as! CALayer
            let sidePoint = sideLayer.frame.origin
            
            let centerLayer = self.centerHelperView.layer.presentationLayer() as! CALayer
            let centerPoint = centerLayer.frame.origin
            
            let path = UIBezierPath()
            self.bgColor.setFill()
            //Fill the view during animation
            path.moveToPoint(sidePoint)
            path.addQuadCurveToPoint(CGPointMake(320, sidePoint.y), controlPoint: centerPoint)
            path.addLineToPoint(CGPointMake(320, CGRectGetHeight(self.bounds)))
            path.addLineToPoint(CGPointMake(0, CGRectGetHeight(self.bounds)))
            path.closePath()
            path.fill()
        }
    }
    
    func setDelegate(delegate:LTBounceSheetDelegate)
    {
        mDelegate = delegate
    }
    
    func getFooter()->CGFloat
    {
        return footer;
    }
}
