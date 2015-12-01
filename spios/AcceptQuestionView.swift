//
//  AcceptQuestionView.swift
//  spios
//
//  Created by MobileGenius on 10/13/15.
//  Copyright (c) 2015 Studypool. All rights reserved.
//

import UIKit

class AcceptQuestionView: UIView , UITextViewDelegate, JWStarRatingViewDelegate, UIGestureRecognizerDelegate{
    
    var controller:AcceptQuestionViewController!

    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var lbDate: UILabel!
    @IBOutlet weak var ivAvatar: UIImageView!
    @IBOutlet weak var lbTutorName: UILabel!
    
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var toppopViewConstraint: NSLayoutConstraint! // Top Pop view constraint of the Pop view. Needs to be changed each time keyboard appears and disappears
    @IBOutlet weak var bottompopViewConstraint: NSLayoutConstraint! // Bottom Pop view constraint of the Pop view. Needs to be changed each time keyboard appears and disappears
    
    @IBOutlet weak var enterReasonTextView: UITextView! //The main text view, where user enters smth.
    @IBOutlet weak var textViewBackView: UIImageView!
    
    @IBOutlet weak var starRating: JWStarRatingView! // StarsRating
    
    var questionCountdownTimer: NSTimer!
    
    var keyboardShown = false // Need to check whether keyboard is on the screen right now
    
    var starsRatingCount:Int! = 5 // This is where you can grab user entered stars
    
    var isRated:Bool = false
    
    func viewdidload(){
        /// Continue question countdown timer
        questionCountdownTimer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: Selector("continueDeadlineTimer"), userInfo: nil, repeats: true)
        NSRunLoop.mainRunLoop().addTimer(questionCountdownTimer, forMode: NSRunLoopCommonModes)
        
        // init
        enterReasonTextView.text = "Leave a comment..."
        enterReasonTextView.font = UIFont(name: "OpenSans", size: 17)
        enterReasonTextView.delegate = self
        
        enterReasonTextView.textColor = UIColor.lightGrayColor()
        //        enterReasonTextView.becomeFirstResponder()
        lbTitle.text = controller.questionTitle
        lbTutorName.font = UIFont(name: "OpenSans-Semibold", size: 17)
        
        var date = NSDate(timeIntervalSince1970: controller.questionTimestamp)
        lbDate.text = date.stringDate
        
        controller.tutorImageUrl = controller.tutorImageUrl.stringByReplacingOccurrencesOfString(" ", withString: "%20", options: NSStringCompareOptions.RegularExpressionSearch, range: nil)
        if let url = NSURL(string: controller.tutorImageUrl) {
            ivAvatar.hnk_setImageFromURL(url)
        }
        lbTutorName.text = controller.tutorName.uppercaseString
        
        addDoneButtonToKeyboard(enterReasonTextView)
        
        
        setAllRounded()
        
        
        starRating.delegate = self
        
        starRating.starCount = 5
        
        
        // confirmButton.enabled = false
        
        
        var swipe:UISwipeGestureRecognizer = UISwipeGestureRecognizer(target:self, action:"dismissKeyboard")
        
        swipe.direction = UISwipeGestureRecognizerDirection.Down
        
        self.addGestureRecognizer(swipe)
    }
    
    func viewwillappear(){
        
        addNotificationsObservers()
        
        if let hamburguerViewController = controller.findHamburguerViewController() { // To not open burger menu on star swipings
            hamburguerViewController.gestureEnabled = false
        }
        
    }
    
    func viewwilldisappear(){
        hideKeyboard(NSNull())
        removeNotificationsObservers()
        if let hamburguerViewController = controller.findHamburguerViewController() { // To enable burger menu in another views
            hamburguerViewController.gestureEnabled = true
        }
    }
    
    func viewdiddisappear(){
        
        if (questionCountdownTimer != nil) {
            questionCountdownTimer.invalidate()
        }
    }
    
    func continueDeadlineTimer() {
        controller.questionModel.deadline = (controller.questionModel.deadline as! Int) - 1
    }
    
    /*
    Makes all the buttons and textviews rounded
    */
    func setAllRounded() {
        setViewRounded(enterReasonTextView)
        setViewRounded(confirmButton)
    }
    func setViewRounded(viewToMakeRound :UIView) {
        viewToMakeRound.layer.cornerRadius = 5.0 // creates rounded corners
        viewToMakeRound.clipsToBounds = true
    }
    
    func dismissKeyboard(){
        self.enterReasonTextView.resignFirstResponder()
        
    }
    
    //MARK: - Keyboard Functions
    /**
    Creates toolbar for storing Done Button and adds it to keyboard
    */
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
        (textView as! UITextView).inputAccessoryView = toolbar
    }
    
    var topPopViewConstant: CGFloat! // Saving constants to restore the view when keyboard hides
    var bottomPopViewConstant: CGFloat! // Saving constants to restore the view when keyboard hides
    
    /**
    Hides keyboard or the picker. If hides picker, than takes current value and sets it as the buttons title
    */
    func hideKeyboard(notification: AnyObject) {
        enterReasonTextView.resignFirstResponder()
    }
    
    var normalFrame: CGRect! // Saving View frame to restore it on keyboard hide
    
    func keyboardWillShow(notification: NSNotification) {
        if keyboardShown {
            return
        }
        
        let constrantConstantForKeyboard:CGFloat = 100
        
        keyboardShown = true
        normalFrame = frame
        bottomPopViewConstant = bottompopViewConstraint.constant
        topPopViewConstant = toppopViewConstraint.constant
        frame = CGRect(x: normalFrame.origin.x, y: normalFrame.origin.y - 150, width: normalFrame.width, height: normalFrame.height)
        
        bottompopViewConstraint.constant += constrantConstantForKeyboard // adding value to view 'Submit' button with keyboard opened
        toppopViewConstraint.constant -= constrantConstantForKeyboard
        
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            self.layoutIfNeeded()
        })
    }
    
    func keyboardWillHide(notification: NSNotification) {
        var keyboardSize = notification.userInfo![UIKeyboardFrameBeginUserInfoKey]?.CGRectValue().size
        // Prevent force unwrap of nil normalFrame value
        if let _normalFrame = normalFrame {
            frame = _normalFrame
            bottompopViewConstraint.constant = bottomPopViewConstant
            toppopViewConstraint.constant = topPopViewConstant
            // Keyboard pop up animation
            UIView.animateWithDuration(0.5, animations: { () -> Void in
                self.layoutIfNeeded()
            })
        }
        keyboardShown = false
    }
    
    //MARK: - working with swipes
    
    func textViewDidBeginEditing(enterReasonTextView: UITextView) {
        if enterReasonTextView.textColor == UIColor.lightGrayColor() {
            enterReasonTextView.text = nil
            enterReasonTextView.font = UIFont(name: "OpenSans", size: 17)
            enterReasonTextView.textColor = UIColor.blackColor()
        }
    }
    
    func textViewDidEndEditing(enterReasonTextView: UITextView) {
        if enterReasonTextView.text.isEmpty {
            enterReasonTextView.text = "Leave a comment..."
            enterReasonTextView.font = UIFont(name: "OpenSans", size: 17)
            enterReasonTextView.textColor = UIColor.lightGrayColor()
        }
        else
        {
            self.confirmButton.enabled = true
        }
    }
    
    /**
    We need to recognize when user touches JWStarRatingView to enable gestures
    */
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldReceiveTouch touch: UITouch) -> Bool {
        if touch.view.isKindOfClass(JWStarRating)
        {
            return false
        }
        return true;
    }
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder() // Tells to hide keyboard
        return true
    }
    
    /**
    When user began touching screen with open keyboard it tells us to hide keyboard
    */
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        self.endEditing(true)
    }
    /**
    Adding observers to catch the moment when we need to slide the pop view up or down
    */
    func addNotificationsObservers() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    /**
    Removing observers to prevent different conflicts
    */
    func removeNotificationsObservers() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    //MARK: - starsRating Delegate
    func starsValueChanged(starsCount: Int) {
        starsRatingCount = starsCount //JWStarRating delegate to get how many stars the user set
        isRated = true
        confirmButton.enabled = true
    }


}
