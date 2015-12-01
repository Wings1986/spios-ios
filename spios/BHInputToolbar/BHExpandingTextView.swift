//
//  BHExpandingTextView.swift
//  spios
//
//  Created by Nhon Nguyen Van on 7/14/15.
//  Copyright (c) 2015 Studypool. All rights reserved.
//

import UIKit

@objc protocol BHExpandingTextViewDelegate:NSObjectProtocol {
    optional func expandingTextViewShouldBeginEditing(expandingTextView : BHExpandingTextView!)-> Bool
    optional func expandingTextViewShouldEndEditing(expandingTextView : BHExpandingTextView!)-> Bool
    
    optional func expandingTextViewDidBeginEditing(expandingTextView : BHExpandingTextView!)
    optional func expandingTextViewDidEndEditing(expandingTextView : BHExpandingTextView!)
    
    optional func expandingTextView(expandingTextView : BHExpandingTextView!,shouldChangeTextInRange range:NSRange,replacementText text:String!)-> Bool
    optional func expandingTextViewDidChange(expandingTextView : BHExpandingTextView!)
    
    optional func expandingTextView(expandingTextView : BHExpandingTextView!,willChangeHeight height:Float)
    optional func expandingTextView(expandingTextView : BHExpandingTextView!,didChangeHeight height:Float)
    
    optional func expandingTextViewDidChangeSelection(expandingTextView : BHExpandingTextView!)
    optional func expandingTextViewShouldReturn(expandingTextView : BHExpandingTextView!)-> Bool
}

class BHExpandingTextView: UIView,UITextViewDelegate {

    let kTextInsetX : Float! =  4
    let kTextInsetBottom :Int! = 0
    var internalTextView :UITextView = UITextView()
    
    var maximumNumberOfLines :UInt!
    var minimumNumberOfLines :UInt!
    var animateHeightChange :Bool!
    
    var delegate :BHExpandingTextViewDelegate?
    var text :String!{
        get{
            return self.internalTextView.text
        }
        set(text){
            self.internalTextView.text = text
//            NSTimer.scheduledTimerWithTimeInterval(0, target: self, selector: "textViewDidChange:", userInfo: self.internalTextView, repeats: false)
        }
    }
    var font :UIFont!{
        get{
            return self.internalTextView.font
        }
        set(afont){
            self.internalTextView.font = afont
            self.setMaximumNumberOfLines(self.maximumNumberOfLines)
            self.setMinimumNumberOfLines(self.minimumNumberOfLines)
        }
    }
    var textColor :UIColor!{
        get{
            return self.internalTextView.textColor
        }
        set(color){
            self.internalTextView.textColor = color
        }
    }
    var textAlignment :NSTextAlignment!{
        get{
            return self.internalTextView.textAlignment
        }
        set(aligment){
            self.internalTextView.textAlignment = aligment
        }
    }
    var selectedRange :NSRange!{
        get{
            return self.internalTextView.selectedRange
        }
        set(range){
            self.internalTextView.selectedRange = range
        }
    }
    var editable :Bool!{
        get{
            return self.internalTextView.editable
        }
        set(editable){
            self.internalTextView.editable = editable
        }
    }
//    var returnKeyType: UIReturnKeyType!{
//        get{
//            return self.internalTextView.returnKeyType
//        }
//        set(returnKeyType){
//            return self.internalTextView.returnKeyType = returnKeyType
//        }
//    }
    var textViewBackgroundImage :UIImageView!
    var placeholder :String!{
        get{
            return self.placeholderLabel.text
        }
        set(placeholders){
            self.placeholderLabel.text = placeholders
        }
    }
    
    var placeholderLabel :UILabel!
    
    var minimumHeight :Float! = 0
    var maximumHeight :Float! = 0
    
    var forceSizeUpdate :Bool!

    override init (frame : CGRect) {
        super.init(frame : frame)
        initFrame(frame)
    }
    
    convenience init () {
        self.init(frame:CGRectZero)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func initFrame(frame: CGRect){
        self.forceSizeUpdate = false
        self.autoresizingMask = UIViewAutoresizing.FlexibleWidth;
        var backgroundFrame: CGRect = frame;
        backgroundFrame.origin.y = 0;
        backgroundFrame.origin.x = 0;
        
        //        CGRect textViewFrame = CGRectInset(backgroundFrame, kTextInsetX, 0);
        
        /* set placeholder */
        self.placeholderLabel = UILabel(frame: CGRectMake(8,3,self.bounds.size.width - 16,self.bounds.size.height))
        self.placeholderLabel.text = self.placeholder;
//        self.placeholderLabel.font = UIFont().fontWithSize(17)
        self.placeholderLabel.backgroundColor = UIColor.clearColor()
        self.placeholderLabel.textColor = UIColor.grayColor()
        
        /* Internal Text View component */
        internalTextView = BHExpandingTextViewInternal(frame: backgroundFrame)
        self.internalTextView.delegate        = self;
//        self.internalTextView.font            = UIFont(name: self.internalTextView.font.fontName, size: 17)
        self.internalTextView.textContainerInset    = UIEdgeInsetsMake(7,0,0,5);
        self.internalTextView.scrollEnabled   = false
        self.internalTextView.opaque          = false
        self.internalTextView.backgroundColor = UIColor.clearColor()
        self.internalTextView.showsHorizontalScrollIndicator = false
        self.internalTextView.sizeToFit()
        self.internalTextView.clipsToBounds = true
        self.internalTextView.autoresizingMask = UIViewAutoresizing.FlexibleWidth;
        self.internalTextView.autocorrectionType = UITextAutocorrectionType.Yes
//        self.internalTextView.returnKeyType = UIReturnKeyType.Done
//        self.internalTextView.text            = "-";
        
        self.internalTextView.addSubview(self.placeholderLabel)
        
        /* Custom Background image */
        self.textViewBackgroundImage = UIImageView(frame:backgroundFrame)
        self.textViewBackgroundImage.image          = UIImage(named: "bg_input_toolbar_textfield")
        self.textViewBackgroundImage.contentMode    = UIViewContentMode.ScaleToFill
//        self.textViewBackgroundImage.contentStretch = CGRectMake(0.5, 0.5, 0, 0);
        
        //        [self addSubview:self.textViewBackgroundImage];
        self.addSubview(self.internalTextView)
        
        /* Calculate the text view height */
        var internalView: UIView = self.internalTextView.subviews[0] as! UIView
        self.minimumHeight = Float(internalView.frame.height)
        self.setMinimumNumberOfLines(1)
        self.animateHeightChange = true
//        self.internalTextView.text = ""
        self.setMaximumNumberOfLines(13)
    }
    
    func setFrame(aframe :CGRect!)
    {
        var backgroundFrame :CGRect!   = aframe;
        backgroundFrame.origin.y = 0;
        backgroundFrame.origin.x = 0;
        var textViewFrame :CGRect! = CGRectInset(backgroundFrame, CGFloat(kTextInsetX), 0)
        self.internalTextView.frame   = textViewFrame;
        backgroundFrame.size.height  -= 8;
        self.textViewBackgroundImage.frame = backgroundFrame;
        self.forceSizeUpdate = true
        super.frame = aframe
    }
    
    override func sizeToFit()
    {
        var r :CGRect! = self.frame
        if (count(self.text) > 0)
        {
            /* No need to resize is text is not empty */
            return;
        }
        //    r.size.height = self.minimumHeight + kTextInsetBottom;
        self.frame = r;
    }
    
    func setMaximumNumberOfLines(n:UInt){
        var didChange : Bool!  = false
        var saveText :String!        = self.internalTextView.text
        var newText :String!        = "-";
        self.internalTextView.hidden   = true
        self.internalTextView.delegate = nil;
        
        for (var i: UInt = 2; i < n; ++i)
        {
            newText = newText.stringByAppendingString("\n|W|")
        }
        self.internalTextView.text     = newText
        
        if(floor(NSFoundationVersionNumber)>NSFoundationVersionNumber_iOS_6_1) {
            didChange = (self.maximumHeight != self.measureHeightOfUITextView(self.internalTextView))
        }
        else {
            didChange = (self.maximumHeight != Float(self.internalTextView.contentSize.height))
        }
        if(floor(NSFoundationVersionNumber)>NSFoundationVersionNumber_iOS_6_1) {
            self.maximumHeight             = self.measureHeightOfUITextView(self.internalTextView)
        } else {
            self.maximumHeight             = Float(self.internalTextView.contentSize.height)
        }
        
        maximumNumberOfLines      = n
        self.internalTextView.text     = saveText;
        self.internalTextView.hidden   = false
        self.internalTextView.delegate = self;
        if (didChange == true) {
            self.forceSizeUpdate = false
            self.textViewDidChange(self.internalTextView)
        }
    }
    
    func measureHeightOfUITextView(textView : UITextView!)-> Float{
        if (textView.respondsToSelector(Selector("snapshotViewAfterScreenUpdates:")))
        {
            // This is the code for iOS 7. contentSize no longer returns the correct value, so
            // we have to calculate it.
            //
            // This is partly borrowed from HPGrowingTextView, but I've replaced the
            // magic fudge factors with the calculated values (having worked out where
            // they came from)
            
            var frame :CGRect! = textView.bounds
            
            // Take account of the padding added around the text.
            
            var textContainerInsets :UIEdgeInsets! = textView.textContainerInset
            var contentInsets :UIEdgeInsets! = textView.contentInset
            
            var leftRightPadding :CGFloat! = textContainerInsets.left + textContainerInsets.right + textView.textContainer.lineFragmentPadding * 2 + contentInsets.left + contentInsets.right
            var topBottomPadding :CGFloat! = textContainerInsets.top + textContainerInsets.bottom + contentInsets.top + contentInsets.bottom
            
            frame.size.width -= leftRightPadding;
            frame.size.height -= topBottomPadding;
            
            var textToMeasure :String! = textView.text
            if (textToMeasure.hasSuffix("\n"))
            {
                textToMeasure = textView.text+"-"
            }
            
            // NSString class method: boundingRectWithSize:options:attributes:context is
            // available only on ios7.0 sdk.
            
            var paragraphStyle :NSMutableParagraphStyle! = NSMutableParagraphStyle()
            paragraphStyle.lineBreakMode = NSLineBreakMode.ByWordWrapping
            var attributes :NSDictionary! = [NSFontAttributeName: textView.font, NSParagraphStyleAttributeName : paragraphStyle]
            
            var size :CGRect! = NSString(string: textToMeasure).boundingRectWithSize(CGSizeMake(CGRectGetWidth(frame), CGFloat(MAXFLOAT)), options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: attributes! as [NSObject : AnyObject], context: nil)
            var measuredHeight :Float! = ceilf(Float(CGRectGetHeight(size) + topBottomPadding))
            return measuredHeight+8.0
        }
        else
        {
            return Float(textView.contentSize.height)
        }

    }
    
    func setMinimumNumberOfLines(m: UInt){
        var saveText :String!        = self.internalTextView.text
        var newText  :String!       = "-"
        self.internalTextView.hidden   = false
        self.internalTextView.delegate = nil;
        for (var i :UInt = 2; i < m; ++i)
        {
            newText = newText+"\n|W|"
        }
        self.internalTextView.text     = newText;
        if(floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1) {
            self.minimumHeight = self.measureHeightOfUITextView(self.internalTextView)
        }
        else {
            self.minimumHeight = Float(self.internalTextView.contentSize.height)
        }
        self.internalTextView.text     = saveText;
        self.internalTextView.hidden   = false
        self.internalTextView.delegate = self;
        self.sizeToFit()
        minimumNumberOfLines = m;
    }
    
    func hasText()->Bool{
        return self.internalTextView.hasText()
    }
    
    func scrollRangeToVisible(range: NSRange){
        self.internalTextView.scrollRangeToVisible(range)
    }
    
    func clearText(){
        self.text = ""
        self.textViewDidChange(self.internalTextView)
    }

    func didChangeText(){
        self.textViewDidChange(self.internalTextView)
    }
    
    func getHeight()-> Int{
        var width :CGFloat! = self.internalTextView.frame.size.width // whatever your desired width is
        var rect :CGRect! = NSString(string: self.internalTextView.text).boundingRectWithSize(CGSizeMake(width-10, 10000), options: NSStringDrawingOptions.UsesLineFragmentOrigin | NSStringDrawingOptions.UsesFontLeading, attributes: nil, context: nil)

        return Int(rect.size.height)+18;
    }
    
    func textViewDidChange(textView:UITextView){
        if(count(textView.text) == 0){
            self.placeholderLabel.alpha = 1
        }else{
            self.placeholderLabel.alpha = 0
        }
        
        var newHeight :NSInteger!
        /*if(floor(NSFoundationVersionNumber)>NSFoundationVersionNumber_iOS_6_1) {
        newHeight = [self measureHeightOfUITextView:self.internalTextView];
        }else {
        newHeight = self.internalTextView.contentSize.height;
        }*/
        
        newHeight = NSInteger(measureHeightOfUITextView(self.internalTextView))
        if(Float(newHeight) < self.minimumHeight || !self.internalTextView.hasText())
        {
            newHeight = Int (self.minimumHeight)
        }
        var size :CGSize = self.internalTextView.frame.size;
        if ((self.internalTextView.frame.height != CGFloat(newHeight)) || self.forceSizeUpdate == true)
        {
            self.forceSizeUpdate = false
            if ((Float(newHeight) > self.maximumHeight) && (Float(self.internalTextView.frame.height) <= self.maximumHeight))
            {
                newHeight = Int(self.maximumHeight)
            }
            if (Float(newHeight) <= self.maximumHeight)
            {
                if(self.animateHeightChange == true)
                {
                    UIView.beginAnimations("", context: nil)
                    UIView.setAnimationDelegate(self)
                    UIView.setAnimationDidStopSelector(Selector("growDidStop"))
                    UIView.setAnimationBeginsFromCurrentState(true)
                }
                
                if (self.delegate?.respondsToSelector(Selector("expandingTextView:willChangeHeight:")) == true){
                    self.delegate?.expandingTextView!(self, willChangeHeight: Float(newHeight + kTextInsetBottom))
                }
                
                /* Resize the frame */
                var r :CGRect! = self.frame;
                r.size.height = CGFloat(newHeight + kTextInsetBottom)
                self.frame = r;
                r.origin.y = 0;
                r.origin.x = 0;
                self.internalTextView.frame = CGRectInset(r, CGFloat(kTextInsetX), 0)
                r.size.height -= 8;
                self.textViewBackgroundImage.frame = r;
                
                if(self.animateHeightChange == true)
                {
                    UIView.commitAnimations()
                }
                if (self.delegate?.respondsToSelector(Selector("expandingTextView:didChangeHeight:")) == true)
                {
                    self.delegate?.expandingTextView!(self, didChangeHeight: Float(newHeight + kTextInsetBottom))
                }
            }
            
            if (Float(newHeight) >= self.maximumHeight)
            {
                /* Enable vertical scrolling */
                if(!self.internalTextView.scrollEnabled)
                {
                    self.internalTextView.scrollEnabled = true
                    self.internalTextView.flashScrollIndicators()
                }
            }
            else
            {
                /* Disable vertical scrolling */
                self.internalTextView.scrollEnabled = false
            }
        }
        if (self.delegate?.respondsToSelector(Selector("expandingTextViewDidChange:")) == true)
        {
            self.delegate?.expandingTextViewDidChange!(self)
        }

    }
    
// MARK: UIExpandingTextViewDelegate
    
    func textViewShouldBeginEditing(textView: UITextView) -> Bool {
        if ((self.delegate?.respondsToSelector(Selector("expandingTextViewShouldBeginEditing:"))) == true) {
            return self.delegate?.expandingTextViewShouldBeginEditing!(self) as Bool!
        }else{
            return true
        }
    }
    
    func textViewShouldEndEditing(textView: UITextView) -> Bool {
        if ((self.delegate?.respondsToSelector(Selector("expandingTextViewShouldEndEditing:"))) == true) {
            return self.delegate?.expandingTextViewShouldEndEditing!(self) as Bool!
        }else{
            return true
        }
    }
    
    func textViewDidBeginEditing(textView: UITextView) {
        if ((self.delegate?.respondsToSelector(Selector("expandingTextViewDidBeginEditing:"))) == true) {
            self.delegate?.expandingTextViewDidBeginEditing!(self)
        }
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        if ((self.delegate?.respondsToSelector(Selector("expandingTextViewDidEndEditing:"))) == true) {
            self.delegate?.expandingTextViewDidEndEditing!(self)
        }
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if (!textView.hasText() && text.isEmpty){
            return false
        }
        if (text == "\n"){
            /*
            if ((self.delegate?.respondsToSelector(Selector("expandingTextViewShouldReturn:"))) == true){
                //self.delegate?.expandingTextViewShouldReturn!(self)
                //textView.resignFirstResponder()
                return false
            }else{
                return true
            }*/
            return true
        }
        return true
    }
    
    func textViewDidChangeSelection(textView: UITextView) {
        if ((self.delegate?.respondsToSelector(Selector("expandingTextViewDidChangeSelection:"))) == true) {
            self.delegate?.expandingTextViewDidChangeSelection!(self)
        }
    }

}
