//
//  QuestionDetailAnsweredFooterView.swift
//  spios
//
//  Created by MobileGenius on 10/12/15.
//  Copyright (c) 2015 Studypool. All rights reserved.
//

import UIKit

class QuestionDetailAnsweredFooterView: UIView, BHInputbarDelegate, UITextFieldDelegate {
    
    var controller:QuestionDetailAnsweredFooterController!

    @IBOutlet weak var heightBox: NSLayoutConstraint!
    @IBOutlet weak var widthBox: NSLayoutConstraint!
    @IBOutlet weak var btnComment: UIButton!
    @IBOutlet weak var btnDecline: UIButton!
    @IBOutlet weak var btnInfo: UIButton!
    @IBOutlet weak var btnAccept: UIButton!
    
    
    @IBOutlet weak var viewDecline: UIView!
    @IBOutlet weak var viewInfo: UIView!
    @IBOutlet weak var viewAccept: UIView!
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var leftButtonWidth: NSLayoutConstraint!
    @IBOutlet weak var centerButtonWidth: NSLayoutConstraint!
    @IBOutlet weak var rightButtonWidth: NSLayoutConstraint!
    @IBOutlet weak var rightWidth: NSLayoutConstraint!
    @IBOutlet weak var centerWidth: NSLayoutConstraint!
    @IBOutlet weak var leftWidth: NSLayoutConstraint!
    @IBOutlet weak var rightToCenter: NSLayoutConstraint!
    @IBOutlet weak var leftToCenter: NSLayoutConstraint!
    @IBOutlet weak var footerView: UIView!
    @IBOutlet weak var middeToTop: NSLayoutConstraint!
    
    
    @IBOutlet weak var messageBox: BHInputbar!
    @IBOutlet weak var constraintHeight: NSLayoutConstraint!
    
    
    func viewdidload(){
        var swipe:UISwipeGestureRecognizer = UISwipeGestureRecognizer(target:self, action:"dismissKeyboard")
        swipe.direction = UISwipeGestureRecognizerDirection.Down
        self.addGestureRecognizer(swipe)
        
        addDoneButtonToKeyboard(messageBox.textView)
        
       
        self.setUpViews()
    }
    
    /// Set up view layouts
    private func setUpViews() {
        // Do any additional setup after loading the view.
        
//        self.widthBox.constant = 178 * (self.frame.size.width / 375.0 )
//        //self.heightBox.constant = 70 * (self.view.frame.size.height / 667.0 )
//        self.leftToCenter.constant = -54 * (self.frame.size.width / 375.0 )
//        self.rightToCenter.constant = 54 * (self.frame.size.width / 375.0 )
//        self.leftWidth.constant = 70 * (self.frame.size.width / 375.0 )
//        self.centerWidth.constant = 35 * (self.frame.size.width / 375.0 )
//        self.rightWidth.constant = 70 * (self.frame.size.width / 375.0 )
//        self.leftButtonWidth.constant = 60 * (self.frame.size.width / 375.0 )
//        self.centerButtonWidth.constant = 30 * (self.frame.size.width / 375.0 )
//        self.rightButtonWidth.constant = 60 * (self.frame.size.width / 375.0 )
//        self.middeToTop.constant = 7.5 * (self.frame.size.width / 375.0 )
//        
//        self.layoutIfNeeded()
//        btnDecline.layer.cornerRadius = btnDecline.frame.size.width/2;
//        btnDecline.layer.shadowOpacity = 0.3
//        btnDecline.layer.shadowColor = UIColor.blackColor().CGColor
//        btnDecline.layer.shadowOffset = CGSizeMake(0.0,3.0)
//        btnDecline.layer.masksToBounds = false
//        btnDecline.layer.shadowRadius = 2.5
//        
//        viewDecline.layer.cornerRadius = viewDecline.frame.size.width/2;
//        
//        btnInfo.layer.cornerRadius = btnInfo.frame.size.width/2;
//        btnInfo.layer.shadowOpacity = 0.3
//        btnInfo.layer.shadowColor = UIColor.blackColor().CGColor
//        btnInfo.layer.shadowOffset = CGSizeMake(0.0,3.0)
//        btnInfo.layer.masksToBounds = false
//        btnInfo.layer.shadowRadius = 2.5
//        
//        viewInfo.layer.cornerRadius = viewInfo.frame.size.width/2;
//        
//        btnAccept.layer.cornerRadius = btnAccept.frame.size.width/2;
//        btnAccept.layer.shadowOpacity = 0.3
//        btnAccept.layer.shadowColor = UIColor.blackColor().CGColor
//        btnAccept.layer.shadowOffset = CGSizeMake(0.0,3.0)
//        btnAccept.layer.masksToBounds = false
//        btnAccept.layer.shadowRadius = 2.5
//        
//        viewAccept.layer.cornerRadius = viewAccept.frame.size.width/2;
        
        messageBox?.inputDelegate = self; // making this class delegate to know what actions are happening with toolbar
        messageBox?.textView.placeholder = "reply to tutor";
        messageBox?.textView.layer.cornerRadius = 5
        messageBox?.textView.maximumNumberOfLines = 5 // limits the size of input view
        
        messageBox?.layer.shadowOpacity = 0.3
        messageBox?.layer.cornerRadius = 3
        messageBox?.layer.shadowColor = UIColor.blackColor().CGColor
        messageBox?.layer.shadowOffset = CGSizeMake(0.0,2.0)
        messageBox?.layer.masksToBounds = false
        messageBox?.layer.shadowRadius = 1.5
        
        btnDecline.titleLabel?.textColor = UIColor.redColor()
    }
    
    func dismissKeyboard(){
        messageBox?.textView.resignFirstResponder()
        
    }
    
    func addDoneButtonToKeyboard(textView: AnyObject) {
        var toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: bounds.width, height: 44))
        var leftSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        var doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Done, target: self, action: Selector("hideKeyboard:"))
        toolbar.setItems([leftSpace, doneButton], animated: false)
        if textView.isKindOfClass(UITextField)
        {
            (textView as! UITextField).inputAccessoryView = toolbar
            return
        }
        if textView.isKindOfClass(BHExpandingTextView){
            (textView as! BHExpandingTextView).internalTextView.inputAccessoryView = toolbar
            return
        }
        (textView as! UITextView).inputAccessoryView = toolbar
    }
    
    func hideKeyboard(notification: AnyObject) {
        if messageBox.textView.isFirstResponder(){
            messageBox.textView.internalTextView.resignFirstResponder()
            messageBox.textView.resignFirstResponder()
            return
        }
        if messageBox.textView.internalTextView.isFirstResponder(){
            messageBox.textView.internalTextView.resignFirstResponder()
        }
    }
    
    func clearComment() {
        messageBox!.textView.clearText()
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // MARK expanding TextView
    
    func expandingTextView(expandingTextView: BHExpandingTextView!, didChangeHeight height: Float) {
        
        constraintHeight.constant = 120 + CGFloat(height)
        controller.delegate?.changeFrameHeight( Float(constraintHeight.constant) )
    }

    func sendButtonPressed(inputText: NSAttributedString!) {
        if !(messageBox!.textView!.text.isEmpty) {
            self.controller.onComment(messageBox!.textView!.text)
            messageBox!.textView.text = ""
        }
        hideKeyboard(inputText)
    }
}
