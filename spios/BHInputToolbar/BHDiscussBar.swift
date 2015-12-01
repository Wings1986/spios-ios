//
//  BHDiscussBar.swift
//  spios
//
//  Created by Nhon Nguyen Van on 7/14/15.
//  Copyright (c) 2015 Studypool. All rights reserved.
//

import UIKit

protocol BHDiscussBarDelegate {
      func enteredMessage(message: String)
}

class BHDiscussBar: UIView,BHExpandingTextViewDelegate {

    var  delegate: BHDiscussBarDelegate?
    var  inputButton: UIButton!
    var  textView:BHExpandingTextView!
    
    var inputButtonY:CGFloat! = 0
    var isReturned:Bool! = false
    var isEditing:Bool! = false
    var isInit:Bool! = false
    var viewFrame:CGRect!
    var inputFrame:CGRect!
    var buttonFrame:CGRect!
    
    override func awakeFromNib() {
        self.backgroundColor = UIColor(red: 243/255.0, green: 243/255.0, blue: 241/255.0, alpha: 1)
    }

    override func layoutSubviews() {
        if (!isInit) {
            isInit = true;
            setUpDiscussBar()
        }
    }
    
    func setUpDiscussBar(){
        self.layer.shadowOpacity = 0.5
        self.layer.shadowColor = UIColor.blackColor().CGColor;
        self.layer.shadowOffset = CGSizeMake(0.0,2.0);
        self.layer.masksToBounds = false;
        
        inputButton = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
        inputButtonY = (self.frame.size.height-28)/2-2.0;
        inputButton.frame = CGRectMake(self.frame.size.width - 35, (self.frame.size.height-28)/2+2, 28, 28);
        inputButton.setImage(UIImage(named: "btnsend"), forState: UIControlState.Normal)
        inputButton.addTarget(self, action: "inputButtonPressed", forControlEvents: UIControlEvents.TouchDown)
        inputButton.autoresizingMask = UIViewAutoresizing.FlexibleRightMargin
        self.addSubview(inputButton)
        
        textView = BHExpandingTextView(frame: CGRectMake(8, (self.frame.size.height-30)/2-3, self.bounds.size.width - 47, 30))
        self.textView.setMaximumNumberOfLines(10)
        self.textView.backgroundColor = UIColor.whiteColor();
        //    self.textView.internalTextView.scrollIndicatorInsets = UIEdgeInsetsMake(4.0f, 0.0f,-10.0f, 0.0f);
        self.textView.autoresizingMask = UIViewAutoresizing.FlexibleRightMargin | UIViewAutoresizing.FlexibleWidth;
        self.textView.delegate = self;
        self.textView.layer.cornerRadius = 4;
        //    self.textView.layer.borderWidth = 1;
        //    self.textView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        self.textView.placeholder = "Write a message";
        
        self.textView.layer.shadowOpacity = 0.3;
        self.textView.layer.shadowColor = UIColor.blackColor().CGColor;
        self.textView.layer.shadowOffset = CGSizeMake(0.0,1.0);
        self.textView.layer.masksToBounds = false;
        self.textView.layer.shadowRadius = 1.5;

        self.textView.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0);
        
        self.addSubview(self.textView)
        
        /* Disable button initially */
        inputButton.enabled = false
        addDoneButtonToKeyboard(textView)
    }
    
    func inputButtonPressed(){
        if (self.delegate != nil) {
            self.delegate?.enteredMessage(self.textView.internalTextView.text)
        }
        self.textView.internalTextView.text = "";
    }
    
    func expandingTextViewDidChange(expandingTextView: BHExpandingTextView!) {
        inputButton.enabled = expandingTextView.hasText()
    }

	func addDoneButtonToKeyboard( view: UIView)
	{
		var toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 44))
		var leftSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
		var doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Done, target: self, action: Selector("hideKeyboard:"))
		toolbar.setItems([leftSpace, doneButton], animated: false)
	
		(textView.internalTextView as UITextView).inputAccessoryView = toolbar
	}
	func hideKeyboard(notification: AnyObject)
	{
		
		if textView.internalTextView.isFirstResponder(){
            //textView.clearText()
			textView.internalTextView.resignFirstResponder()
            
			return
		}
	}
    func expandingTextView(expandingTextView: BHExpandingTextView!, willChangeHeight height: Float) {
        /* Adjust the height of the toolbar when the input component expands */
        let diff:Float = (Float(self.textView.frame.height) - height)
        var r: CGRect = self.frame;
        r.origin.y += CGFloat(diff)
        r.size.height -= CGFloat(diff)
        self.frame = r;
        viewFrame = r;
        var frame : CGRect = inputButton.frame;
        frame.origin.y = self.frame.size.height - inputButtonY - inputButton.frame.size.height
        inputButton.frame = frame;
        buttonFrame = frame;
        
        inputFrame = self.textView.frame;
    }
    
    func expandingTextViewShouldReturn(expandingTextView: BHExpandingTextView!) -> Bool {
        expandingTextView.clearText()
        return true
    }
    
}
