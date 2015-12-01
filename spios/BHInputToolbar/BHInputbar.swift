//
//  BHInputbar.swift
//  spios
//
//  Created by Nhon Nguyen Van on 7/14/15.
//  Copyright (c) 2015 Studypool. All rights reserved.
//

import UIKit

@objc protocol BHInputbarDelegate:BHExpandingTextViewDelegate {
    optional func sendButtonPressed(inputText : NSAttributedString!)
    optional func attachButtonPressed(inputText: NSAttributedString!)
}

class BHInputbar: UIView,BHExpandingTextViewDelegate {
    
    var textView: BHExpandingTextView!
    var inputButton: UIButton!
    var toggleButton: UIButton!
    
    var inputDelegate: BHInputbarDelegate!
    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        self.setupToolbar()
//    }

//    required init(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//        self.setupToolbar()
//    }
    override func awakeFromNib() {
        self.setupToolbar()
    }
//    override func layoutSubviews() {
//
//            self.setupToolbar()
//        
//    }
    
    func resizeToolbar(){
        inputButton.hidden = true
        
        if (textView != nil) {
            textView.frame = CGRectMake(5, (self.frame.size.height-38)/2, self.bounds.size.width - 10, 38);
        }
    }
    
    func resizeTextView(){
        textView.frame = CGRectMake(textView.frame.origin.x, textView.frame.origin.y, textView.frame.width - 30, textView.frame.height)
    }
    
    override func drawRect(rect: CGRect){
        inputButton.frame = CGRectMake(self.frame.size.width - 39, self.frame.size.height - 39, 28, 28);
    }
    
    func setupToolbar()
    {
        
        /* Create custom send buttofn*/
        inputButton = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
        inputButton.frame = CGRectMake(self.frame.size.width - 35, (self.frame.size.height-28)/2, 28, 28);
        inputButton.backgroundColor = UIColor(red: 42/255.0, green: 191.0/255.0, blue: 255/255.0, alpha: 1)
        inputButton.layer.cornerRadius = inputButton.frame.size.width/2;
        inputButton.setImage(UIImage(named: "paperplane"), forState: UIControlState.Normal)
        inputButton.addTarget(self, action: "inputButtonPressed", forControlEvents: UIControlEvents.TouchDown)
        inputButton.autoresizingMask = UIViewAutoresizing.FlexibleTopMargin;
        self.addSubview(inputButton)
        
        /* Disable button initially */
        inputButton.enabled = false
        
        /* Create UIExpandingTextView input */
        NSLog("withd=%f", self.frame.size.width)
        textView = BHExpandingTextView(frame: CGRectMake(8, (self.frame.size.height-35)/2, self.frame.size.width - 57, 30))
        
        NSLog("%f,%f", textView.frame.width, textView.frame.height)
        self.textView.backgroundColor = UIColor.whiteColor()
        //    self.textView.internalTextView.scrollIndicatorInsets = UIEdgeInsetsMake(4.0f, 0.0f,-10.0f, 0.0f);
//        self.textView.autoresizingMask = UIViewAutoresizing.FlexibleRightMargin | UIViewAutoresizing.FlexibleWidth;
        self.textView.delegate = self;
        self.addSubview(textView)
        
        self.clipsToBounds = true;
        
        /* Right align the toolbar button */
        
        //    self.toggleButton               = [[UIButton alloc] initWithFrame:CGRectMake(0, 5, 15, 20)];
        //    self.toggleButton.titleLabel.font         = [UIFont boldSystemFontOfSize:15.0f];
        //    self.toggleButton.titleLabel.shadowOffset = CGSizeMake(0, -1);
        //    [self.toggleButton setTitle:@"..." forState:UIControlStateNormal];
        //    [self.toggleButton addTarget:self action:@selector(toggleAction) forControlEvents:UIControlEventTouchDown];
        //    [self addSubview:self.toggleButton];

    }
    
    func inputButtonPressed(){
        
        if ((self.inputDelegate?.respondsToSelector(Selector("sendButtonPressed:"))) == true) {
            self.inputDelegate?.sendButtonPressed!(textView.internalTextView.attributedText)
        }
        
        /* Remove the keyboard and clear the text */
        textView.resignFirstResponder()
        textView.clearText()
    }
    
    func expandingTextView(expandingTextView: BHExpandingTextView!, willChangeHeight height: Float) {

        
        var diff:CGFloat = (self.textView.frame.size.height - CGFloat(height));
        var r:CGRect = self.frame;
        r.origin.y += diff;
        r.size.height -= diff;
        self.frame = r;
        
        NSLog("%f", height)
        
        if ((self.inputDelegate?.respondsToSelector(Selector("expandingTextView:willChangeHeight:"))) == true) {
            self.inputDelegate?.expandingTextView!(expandingTextView, willChangeHeight: height)
        }
    }
    
    func expandingTextViewDidChange(expandingTextView: BHExpandingTextView!) {
        if (count(expandingTextView.text) > 0){
            inputButton.enabled = true
        }else{
            inputButton.enabled = false
        }
        
        if ((self.inputDelegate?.respondsToSelector(Selector("expandingTextViewDidChange:"))) == true) {
            self.inputDelegate?.expandingTextViewDidChange!(expandingTextView)
        }

    }
    
    func expandingTextViewShouldReturn(expandingTextView: BHExpandingTextView!) -> Bool {
        
        if ((self.inputDelegate?.respondsToSelector(Selector("expandingTextViewShouldReturn:"))) == true) {
            self.inputDelegate?.expandingTextViewShouldReturn!(expandingTextView)
        }
        
        return true
    }
    
    func expandingTextViewShouldBeginEditing(expandingTextView: BHExpandingTextView!) -> Bool {
        if ((self.inputDelegate?.respondsToSelector(Selector("expandingTextViewShouldBeginEditing:"))) == true) {
            self.inputDelegate?.expandingTextViewShouldBeginEditing!(expandingTextView)
        }
        
        return true
    }

    func expandingTextViewShouldEndEditing(expandingTextView: BHExpandingTextView!) -> Bool {
        if ((self.inputDelegate?.respondsToSelector(Selector("expandingTextViewShouldEndEditing:"))) == true) {
            self.inputDelegate?.expandingTextViewShouldEndEditing!(expandingTextView)
        }
        
        return true
    }

    func expandingTextViewDidBeginEditing(expandingTextView: BHExpandingTextView!) {
        if ((self.inputDelegate?.respondsToSelector(Selector("expandingTextViewDidBeginEditing:"))) == true) {
            self.inputDelegate?.expandingTextViewDidBeginEditing!(expandingTextView)
        }
        
    }

    func expandingTextViewDidEndEditing(expandingTextView: BHExpandingTextView!) {
        if ((self.inputDelegate?.respondsToSelector(Selector("expandingTextViewDidEndEditing:"))) == true) {
            self.inputDelegate?.expandingTextViewDidEndEditing!(expandingTextView)
        }
    }

    func expandingTextView(expandingTextView: BHExpandingTextView!, shouldChangeTextInRange range: NSRange, replacementText text: String!) -> Bool {
        if ((self.inputDelegate?.respondsToSelector(Selector("expandingTextView:shouldChangeTextInRange:replacementText:"))) == true) {
            self.inputDelegate?.expandingTextView!(expandingTextView, shouldChangeTextInRange: range, replacementText: text)
        }
        
        return true
    }
    
    func expandingTextView(expandingTextView: BHExpandingTextView!, didChangeHeight height: Float) {
        if ((self.inputDelegate?.respondsToSelector(Selector("expandingTextView:didChangeHeight:"))) == true) {
            self.inputDelegate?.expandingTextView!(expandingTextView, didChangeHeight: height)
        }
        
    }
    
    func expandingTextViewDidChangeSelection(expandingTextView: BHExpandingTextView!) {
        if ((self.inputDelegate?.respondsToSelector(Selector("expandingTextViewDidChangeSelection:"))) == true) {
            self.inputDelegate?.expandingTextViewDidChangeSelection!(expandingTextView)
        }
    }

}
