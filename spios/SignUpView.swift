//
//  SignUpView.swift
//  spios
//
//  Created by MobileGenius on 10/1/15.
//  Copyright (c) 2015 Studypool. All rights reserved.
//

import UIKit

class SignUpView: UIView {

    ///Text field where user inputs their email
    @IBOutlet weak var emailField: UITextField!
    ///Text field where user inputs their chosen password
    @IBOutlet weak var passwordField: UITextField!
    ///Text field where user inputs their chosen user name
    @IBOutlet weak var userNameField: UITextField!
    ///Text field where user inputs a promo code
    @IBOutlet weak var promocodeField: UITextField!
    ///Autolayout contraint, to be used for animation
    @IBOutlet weak var fieldVertConstraint: NSLayoutConstraint!
    ///Signup Button, the user clicks this when finished
    @IBOutlet weak var btnSignup: UIButton!
    ///Image View holding Studypool Logo
    @IBOutlet weak var spLogo: UIImageView!
    ///Button which links to facebook sign up
    @IBOutlet weak var facebook: UIButton!
    ///Button which links to Linkedin sign up
    @IBOutlet weak var linkedin: UIButton!
    ///Button which links to Google Plus sign up
    @IBOutlet weak var gplus: UIButton!
    ///Button which links to the Terms of Services
    @IBOutlet weak var agree: UIButton!
    ///Autolayout contraints to move the screen up when the keyboard pops up
    @IBOutlet weak var topPopViewConstraint: NSLayoutConstraint!
    ///Area View that hold all text fields
    @IBOutlet weak var fieldsView: UIView!
    
    var controller:SignupViewController!
    
    var allTextFields:Array<UITextField> {
        return [self.emailField, self.passwordField, self.userNameField, self.promocodeField]
    }
    
    func initviews(){
        self.fieldVertConstraint.constant = -150
        
        setupSignupButton()
        setupKeyboard()
        setupTextFields()
        
        hideSocialMediaLogo()
        animateStudypoolLogo()
        animateFields()
        
        setupSwipeRecognizer()
    }
    
    //MARK - SETUP METHODS
    
    /**
    Setup the keyboard to add a done button on top of it.
    */
    func setupKeyboard() {
        for textField in allTextFields {
            addDoneButtonToKeyboard(textField)
        }
    }
    
    /**
    Modifies the text fields to put an attributedPlaceholder.
    */
    func setupTextFields() {
        let kForegroudColor = UIColor(red: 255, green: 255, blue: 255, alpha: 0.7)
        for textField in allTextFields {
            textField.attributedPlaceholder = NSAttributedString(string: textField.placeholder!,
                attributes:[NSForegroundColorAttributeName: kForegroudColor])
            textField.tintColor = UIColor(white: 1, alpha: 0.87)
        }
    }
    
    
    
    /**
    Create a gesture recognizer so that when the user swipes down, the keyboard dismisses.
    */
    func setupSwipeRecognizer() {
        var swipe:UISwipeGestureRecognizer = UISwipeGestureRecognizer(target:self, action:"dismissKeyboard")
        swipe.direction = UISwipeGestureRecognizerDirection.Down
        controller.view.addGestureRecognizer(swipe)
    }
    
    /**
    Setup the 'Signup button' so that it has a round shape.
    */
    func setupSignupButton() {
        self.btnSignup.layer.cornerRadius = self.btnSignup.bounds.size.height / 2
    }
    
    /**
    Hides the social media logos (Facebook, Google, LinkedIn) for animation purposes.
    */
    func hideSocialMediaLogo() {
        self.facebook.alpha = 0.0
        self.linkedin.alpha = 0.0
        self.gplus.alpha = 0.0
    }
    
    /**
    Animates the Studypool Logo. Fades out the Studypool logo while fading in the social media buttons.
    */
    func animateStudypoolLogo(){
        
        UIView.animateWithDuration(1.75, delay: 0.5, options: UIViewAnimationOptions.CurveEaseOut, animations: {
            self.spLogo.alpha = 0.0
            
            }, completion: nil)
        
        
        UIView.animateWithDuration(1.75, delay: 0.5, options: UIViewAnimationOptions.CurveEaseIn, animations: {
            self.facebook.alpha = 1.0
            self.linkedin.alpha = 1.0
            self.gplus.alpha = 1.0
            }, completion: nil)
        
    }
    
    /**
    Animates the text fields. Linear transform movement from above to center.
    */
    func animateFields(){
        self.fieldVertConstraint.constant = -200
        UIView.animateWithDuration(1.5, delay:0.0, options: nil, animations: {
            self.controller.view.layoutIfNeeded()
            }) { (success) -> Void in
                
                
        }
    }
    
    /**
    Dismisses the keyboard.
    */
    func dismissKeyboard(){
        for textField in allTextFields {
            textField.resignFirstResponder()
        }
    }
    
    //MARK: - happen on pop view appearing
    
    /**
    Creates toolbar for storing Done Button and adds it to keyboard
    */
    func addDoneButtonToKeyboard(textView: AnyObject)
    {
        var toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: controller.view.bounds.width, height: 44))
        var leftSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        var doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Done, target: textView, action: Selector("resignFirstResponder"))
        toolbar.setItems([leftSpace, doneButton], animated: false)
        if textView.isKindOfClass(UITextField)
        {
            (textView as! UITextField).inputAccessoryView = toolbar
            return
        }
        (textView as! UITextView).inputAccessoryView = toolbar
    }

}
