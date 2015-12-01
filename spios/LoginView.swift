//
//  LoginView.swift
//  spios
//
//  Created by MobileGenius on 9/29/15.
//  Copyright (c) 2015 Studypool. All rights reserved.
//

import UIKit

class LoginView: UIView {

    ///email edittext
    @IBOutlet weak var emailField: UITextField!
    ///password edittext
    @IBOutlet weak var passwordField: UITextField!
    /// retrive password button
    @IBOutlet weak var btnRetievePass: UIButton!
    /// login button
    @IBOutlet weak var btnLogin: UIButton!
    /// top constraint
    @IBOutlet weak var topPopViewConstraint: NSLayoutConstraint!
    
    var controller:LoginViewController!
    
    func initviews(){
        self.btnLogin.layer.cornerRadius = self.btnLogin.bounds.size.height/2
        
        addDoneButtonToKeyboard(emailField)
        addDoneButtonToKeyboard(passwordField)
        
        self.emailField.tintColor = UIColor(white: 1, alpha: 0.87)
        self.passwordField.tintColor = UIColor(white: 1, alpha: 0.87)
    }
    
    func viewwillappear(){
        //show previous user name after logout.
        let defaults = NSUserDefaults.standardUserDefaults()
        if let usrname = defaults.valueForKey("username") as? String{
            self.emailField.text = usrname
        }
    }
    
    /**
    Creates toolbar for storing Done Button and adds it to keyboard
    */
    func addDoneButtonToKeyboard(textView: AnyObject)
    {
        var toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: controller.view.bounds.width, height: 44))
        var leftSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        var doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Done, target: self.controller, action: Selector("hideKeyboard:"))
        toolbar.setItems([leftSpace, doneButton], animated: false)
        if textView.isKindOfClass(UITextField)
        {
            (textView as! UITextField).inputAccessoryView = toolbar
            return
        }
        (textView as! UITextView).inputAccessoryView = toolbar
    }
    
    /**
    Enter feedscreen
    */
    func enterFeed(){
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        token = appDelegate.userlogin.token
        
        controller.isCheckPhoneVerified { (response) -> Void in
            if (response) {
                // create viewController code...
                let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                token = appDelegate.userlogin.token
                appDelegate.createMenuView()
            }
            else {
                TAOverlay.showOverlayWithLabel("Please verify with your phone number", options: TAOverlayOptions.OverlaySizeRoundedRect|TAOverlayOptions.OverlayTypeWarning|TAOverlayOptions.AutoHide)
                
                var storyboard = UIStoryboard(name: "Auth", bundle: nil)
                
                let phoneverify = storyboard.instantiateViewControllerWithIdentifier("PhoneVerVC") as! PhoneVerificationViewController
                
                self.controller.presentViewController(phoneverify, animated: true, completion: nil)
                
            }
        }
    }



}
