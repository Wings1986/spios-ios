//
//  DeclineQuestionView.swift
//  spios
//
//  Created by MobileGenius on 10/13/15.
//  Copyright (c) 2015 Studypool. All rights reserved.
//

import UIKit

class DeclineQuestionView: UIView, UITextViewDelegate, PickerViewDelegate, JWStarRatingViewDelegate, UIGestureRecognizerDelegate {
    
    var controller:DeclineQuestionViewController!

    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var lbDate: UILabel!
    @IBOutlet weak var ivAvatar: UIImageView!
    @IBOutlet weak var lbTutorName: UILabel!
    
    
    /**
    Goes to FeedVC
    */
    
    @IBOutlet weak var hiddenPickerTextField: UITextField! // Hidded text field needed for UIPicker to appear
    let pickerView = UIPickerView(frame: CGRect(x: 0, y: 0, width: 0, height: 0)) // Init UIPicker
    var keyboardShown = false // Need to check whether keyboard is on the screen right now
    
    @IBOutlet weak var showReasonPicker: UIButton! // Button to show the UIPicker and which title we set when using UIPicker
    
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var toppopViewConstraint: NSLayoutConstraint! // Top Pop view constraint of the Pop view. Needs to be changed each time keyboard appears and disappears
    @IBOutlet weak var bottompopViewConstraint: NSLayoutConstraint! // Bottom Pop view constraint of the Pop view. Needs to be changed each time keyboard appears and disappears
    @IBOutlet weak var starRating: JWStarRatingView! // StarsRating
    @IBOutlet weak var enterReasonTextView: UITextView! //The main text view, where user enters smth.
    
    var pickerViewDataDelegate = PickerViewDataSourceDelegate() // UIPicker DataSource and Delegate. There you set data for UIPicker. Also has the Delegate method "Updated Value"
    var panGestureRecognizer: UIPanGestureRecognizer! // Gesture recognizer for swipes
    var blurView: UIVisualEffectView! // View with blur effect, that lays under Pop view
    
    
    var starsRatingCount:Int!  // This is where you can grab user entered stars
    var pickerResult:AnyObject! // This is where you can grab what user selected within the picker
    
    func viewdidload(){
        // init
        lbTitle.text = controller.questionTitle
        
        var date = NSDate(timeIntervalSince1970: controller.questionTimestamp)
        lbDate.text = date.stringDate
        enterReasonTextView.text = "Further Explanation"
        enterReasonTextView.font = UIFont(name: "OpenSans", size: 17)
        
        enterReasonTextView.delegate = self
        
        enterReasonTextView.textColor = UIColor.lightGrayColor()
        controller.tutorImageUrl = controller.tutorImageUrl.stringByReplacingOccurrencesOfString(" ", withString: "%20", options: NSStringCompareOptions.RegularExpressionSearch, range: nil)
        
        if let url = NSURL(string: controller.tutorImageUrl) {
            ivAvatar.hnk_setImageFromURL(url)
        }
        lbTutorName.text = controller.tutorName
        
        
        var button:UIButton = UIButton();
        button.setImage(UIImage(named: "top_man"), forState: .Normal)
        button.frame = CGRectMake(0, 0, 40, 40)
        button.targetForAction("onClickProfile", withSender: nil)
        
        
        
        setAllRounded()
        var swipe:UISwipeGestureRecognizer = UISwipeGestureRecognizer(target:self, action:"dismissKeyboard")
        
        swipe.direction = UISwipeGestureRecognizerDirection.Down
        
        self.addGestureRecognizer(swipe)
        addDoneButtonToKeyboard(enterReasonTextView)
        pickerView.selectRow(1, inComponent: 0, animated: false)
        showReasonPicker.setTitle("Requirements not Met", forState: UIControlState.allZeros)
        //        showReasonPicker.titleLabel?.textAlignment = NSTextAlignment.Center
        showReasonPicker.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Left
        showReasonPicker.contentEdgeInsets = UIEdgeInsetsMake(0, 15.0, 0, 0)

    }
    
    func viewwillappear(){
        instantiatePickerTextField()
        addNotificationsObservers()
        
        starRating.delegate = self
        addDoneButtonToKeyboard(enterReasonTextView)
        
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
    
    /*
    Makes all the views rounded
    */
    func setAllRounded()
    {
        setViewRounded(showReasonPicker)
        setViewRounded(enterReasonTextView)
        setViewRounded(confirmButton)
    }
    
    func setViewRounded(viewToMakeRound :UIView)
    {
        viewToMakeRound.layer.cornerRadius = 5.0 // creates rounded corners
        viewToMakeRound.clipsToBounds = true
    }
    
    //MARK: - Keyboard Functions
    /**
    Creates toolbar for storing Done Button and adds it to keyboard
    */
    func addDoneButtonToKeyboard(textView: AnyObject)
    {
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
    
    /**
    Hides keyboard or the picker. If hides picker, than takes current value and sets it as the buttons title
    */
    func hideKeyboard(notification: AnyObject)
    {
        if hiddenPickerTextField.isFirstResponder()
        {
            let row = pickerView.selectedRowInComponent(0)
            let title = pickerViewDataDelegate.pickerDataSource[row]
            showReasonPicker.setTitle(title, forState: UIControlState.allZeros)
            hiddenPickerTextField.resignFirstResponder()
            return
        }
        enterReasonTextView.resignFirstResponder()
    }
    
    var bottomPopViewConstant: CGFloat! // Saving constants to restore the view when keyboard hides
    var topPopViewConstant: CGFloat! // Saving constants to restore the view when keyboard hides
    var normalFrame: CGRect! // Saving View frame to restore it on keyboard hide
    
    func keyboardWillShow(notification: NSNotification)
    {
        if keyboardShown
        {
            return
        }
        keyboardShown = true
        normalFrame = frame
        bottomPopViewConstant = bottompopViewConstraint.constant
        topPopViewConstant = toppopViewConstraint.constant
        frame = CGRect(x: normalFrame.origin.x, y: normalFrame.origin.y - 100, width: normalFrame.width, height: normalFrame.height)
        
        var keyboardSize = notification.userInfo![UIKeyboardFrameEndUserInfoKey]?.CGRectValue().size
        
        bottompopViewConstraint.constant += 150 // adding value to view 'Submit' button with keyboard opened
        toppopViewConstraint.constant += 150
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            self.layoutIfNeeded()
        })
    }
    
    func keyboardWillHide(notification: NSNotification)
    {
        var keyboardSize = notification.userInfo![UIKeyboardFrameBeginUserInfoKey]?.CGRectValue().size
        if let _normalFrame = normalFrame {
            frame = _normalFrame
            bottompopViewConstraint.constant = bottomPopViewConstant
            toppopViewConstraint.constant = topPopViewConstant
            
            UIView.animateWithDuration(0.5, animations: { () -> Void in
                self.layoutIfNeeded()
            })
        }
        
        keyboardShown = false
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        self.endEditing(true)
    }
    /**
    Adding observers to catch the moment when we need to slide the pop view up or down
    */
    func addNotificationsObservers()
    {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    /**
    Removing observers to prevent different conflicts
    */
    func removeNotificationsObservers()
    {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func dismissKeyboard(){
        self.enterReasonTextView.resignFirstResponder()
        
    }
    func textViewDidBeginEditing(enterReasonTextView: UITextView) {
        if enterReasonTextView.textColor == UIColor.lightGrayColor() {
            enterReasonTextView.text = nil
            enterReasonTextView.font = UIFont(name: "OpenSans", size: 17)
            enterReasonTextView.textColor = UIColor.blackColor()
        }
    }
    func textViewDidEndEditing(enterReasonTextView: UITextView) {
        if enterReasonTextView.text.isEmpty {
            enterReasonTextView.text = "Further Explanation"
            enterReasonTextView.font = UIFont(name: "OpenSans", size: 17)
            enterReasonTextView.textColor = UIColor.lightGrayColor()
        }
    }
    
    //MARK: - picker view delegate
    /**
    Picker view delegate, updates button title with what user selected for reason
    */
    func updatedValue(object: AnyObject) {
        showReasonPicker.setTitle(object as? String, forState: UIControlState.allZeros)
        pickerResult = object
    }
    
    //MARK: - starsRating
    func starsValueChanged(starsCount: Int) {
        starsRatingCount = starsCount //JWStarRating delegate to get how many stars the user set
    }
    
    //MARK: - happen on pop view appearing
    /**
    Sets the picker view (delegate, datasource), adds Done button
    */
    func instantiatePickerTextField()
    {
        pickerView.showsSelectionIndicator = true;
        pickerView.dataSource = pickerViewDataDelegate;
        pickerView.delegate = pickerViewDataDelegate;
        pickerViewDataDelegate.delegate = self
        hiddenPickerTextField.inputView = pickerView;
        addDoneButtonToKeyboard(hiddenPickerTextField)
    }

}
