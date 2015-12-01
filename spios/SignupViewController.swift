//
//  SignupViewController.swift
//  spios
//
//  Created by Stanley Chiang on 3/7/15.
//  Copyright (c) 2015 Stanley Chiang. All rights reserved.
//

import UIKit
import MBProgressHUD
import CoreData
import Analytics


class SignupViewController: UIViewController {
    
    ///Core data object to be used for retrieving and managing data
	let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    ///Computed property: An array containing all sign up text fields
    
    
//MARK: - VIEW CALL BACKS
    /**
        Setup of UI Elements such as textfields and keyboard.
        Animates begining transition of elements.
        Setup gesture recognizer for keyboard dismissal.
    */
    
    ///Facebook login url
    let kFBURL          :String = "https://www.createpool.com/yiiauth/default/apiauth/provider/facebook/pin/sp86626728app#"
    ///Linkedin login url
    let kLINKEDINURL    :String = "https://www.createpool.com/yiiauth/default/apiauth/provider/linkedin/pin/sp86626728app#"
    ///Google login url
    let kGOOGLEURL      :String = "https://www.createpool.com/yiiauth/default/apiauth/provider/google/pin/sp86626728app#"
    
    @IBOutlet weak var signupview: SignUpView!
    
    
	override func viewDidLoad() {
		super.viewDidLoad() 
        self.view.layoutIfNeeded()
        
        signupview.controller = self
        
        signupview.initviews()
        
        
	}
    
    /**
        Add notification for events where user interacts with the keyboard.
    */
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        addNotificationsObservers()
    }
    
    /**
        Removes notication observers to avoid memory leaks.
    */
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        removeNotificationsObservers()
    }
    

	
	/**
        Button to administer Facebook sign up. (Not yet implemented.)
	*/
    @IBAction func facebookSignUp(sender: AnyObject)     {
    }
    
    /**
        Button to administer LinkedIn sign up. (Not yet implemented.)
    */
    @IBAction func LinkedInSignUp(sender: AnyObject) {
    }
    
    /**
        Button to administer Google Plus sign up. (Not yet implemented.)
    */
    @IBAction func googleSignUp(sender: AnyObject) {
    }

    /**
        Button to trigger the completion of sign up.
    */
	@IBAction func signUpAction(sender: AnyObject) {
		var email = signupview.emailField.text
        var username = signupview.userNameField.text
        var password = signupview.passwordField.text
        var responseString: NSString!
        let promoCode = signupview.promocodeField.text
        var params = Dictionary<String, String>()
        
        if signupview.emailField.text.isEmpty || signupview.passwordField.text.isEmpty || username.isEmpty {
            // Empty fields
            TAOverlay.showOverlayWithLabel("Please complete all fields.", options: TAOverlayOptions.OverlaySizeRoundedRect|TAOverlayOptions.OverlayTypeError|TAOverlayOptions.AutoHide)
        } else if ( validateEmail(email) != true ) {
            // Email is invalid
            TAOverlay.showOverlayWithLabel("Email address is invalid", options: TAOverlayOptions.OverlaySizeRoundedRect|TAOverlayOptions.OverlayTypeError|TAOverlayOptions.AutoHide)
        } else if (count(password) < 4) {
             TAOverlay.showOverlayWithLabel("Password requires a minimum of 4 characters", options: TAOverlayOptions.OverlaySizeRoundedRect|TAOverlayOptions.OverlayTypeError|TAOverlayOptions.AutoHide)
        }else {
            
            let request = NSMutableURLRequest(URL: NSURL(string: "http://www.createpool.com/site/apisignupstan?email=\(email)&username=\(email)&password=\(password)&promo1=\(promoCode)&pin=sp86626728app&callback=asdf")!)
            request.HTTPMethod = "GET"
            
            // If promocode entered
            if ( count(promoCode) > 0) {
                params = ["email":email, "username":username, "password":password, "pin":"sp86626728app", "callback":"asdf", "promo":promoCode]
            } else {
                params = ["email":email, "username":username, "password":password, "pin":"sp86626728app", "callback":"asdf"]
            }
            
            NetworkUI.sharedInstance.signup(params, success: { (data) -> Void in
                NSOperationQueue.mainQueue().addOperationWithBlock{
                    self.view.userInteractionEnabled = false
                    if let error: AnyObject = data["error"]{
                        println("error\(data)")
                        TAOverlay.showOverlayWithLabel("Username: " + (data["error"] as! String) + " is already taken", options: TAOverlayOptions.OverlaySizeRoundedRect|TAOverlayOptions.OverlayTypeError|TAOverlayOptions.AutoHide)
                        self.view.userInteractionEnabled = true
                    } else {
                        println("good\(data)")
                        if let _token = data["token"] as? String {
                            token = _token
                            let newItem = NSEntityDescription.insertNewObjectForEntityForName("UserLogin", inManagedObjectContext: self.managedObjectContext!) as! UserLogin
                            newItem.id = data["user_id"] as! String
                            newItem.token = data["token"] as! String
                            newItem.username = data["username"]as! String
                            
                            self.managedObjectContext?.save(nil)
                            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                            appDelegate.userlogin = newItem
                            appDelegate.bFirstSign = true
                            
                            // If promocode entered
                            if ( count(promoCode) > 0) {
                                println("promoCode: \(promoCode)");
                                if let promoStatus:String = (data["promo"] as! [NSObject : AnyObject])["status"] as! String? {
                                    if promoStatus == "invalidPromo" {
                                        TAOverlay.showOverlayWithLabel("Your account is created successfully but \n promotion code was invalid", options: TAOverlayOptions.OverlaySizeRoundedRect|TAOverlayOptions.OverlayTypeSuccess|TAOverlayOptions.AutoHide)
                                    } else if promoStatus == "validPromo" {
                                        // Valid promo
                                        // Segment tracker
                                        SEGAnalytics.sharedAnalytics().track("Claimed Signup Promo", properties: (data["promo"] as! [NSObject : AnyObject])["segment"] as! [NSObject : AnyObject])
                                        TAOverlay.showOverlayWithLabel("Your account is created successfully with $10 with \(promoCode)!", options: TAOverlayOptions.OverlaySizeRoundedRect|TAOverlayOptions.OverlayTypeSuccess|TAOverlayOptions.AutoHide)
                                    } else {
                                        TAOverlay.showOverlayWithLabel("Error: " + promoStatus, options: TAOverlayOptions.OverlaySizeRoundedRect|TAOverlayOptions.OverlayTypeError|TAOverlayOptions.AutoHide)
                                    }
                                } else {
                                    TAOverlay.showOverlayWithLabel("Server failed to process your promo code. \n Please try again.", options: TAOverlayOptions.OverlaySizeRoundedRect|TAOverlayOptions.OverlayTypeError|TAOverlayOptions.AutoHide)
                                    return
                                }
                            } else {
                                TAOverlay.showOverlayWithLabel("Your account is created successfully", options: TAOverlayOptions.OverlaySizeRoundedRect|TAOverlayOptions.OverlayTypeSuccess|TAOverlayOptions.AutoHide)
                            }
                            
                            var storyboard = UIStoryboard(name: "Auth", bundle: nil)
                            
                            let phoneverify = storyboard.instantiateViewControllerWithIdentifier("PhoneVerVC") as! PhoneVerificationViewController
                            
                            self.presentViewController(phoneverify, animated: true, completion: nil)
                            self.view.userInteractionEnabled = true
                            
                            //SEGMENT_CODE: TRACKER
//                            SEGAnalytics.sharedAnalytics().track("Signed Up", properties: [:])
                        } else {
                            var errorMessage = "Error"
                            for errorString in (data["username"] as! NSArray){
                                errorMessage = errorString as! String
                            }
                            self.view.userInteractionEnabled = true
                            TAOverlay.showOverlayWithLabel(errorMessage, options: TAOverlayOptions.OverlaySizeRoundedRect|TAOverlayOptions.OverlayTypeError|TAOverlayOptions.AutoHide)
                        }
                        
                    }
                }
                }, failure: { (error) -> Void in
                    self.view.userInteractionEnabled = true
                    TAOverlay.showOverlayWithLabel("Please try again", options: TAOverlayOptions.OverlaySizeRoundedRect|TAOverlayOptions.OverlayTypeWarning|TAOverlayOptions.AutoHide)
            })
            
        }
	}
    
    
    private func validateEmail(candidate: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluateWithObject(candidate)
    }
	
	var keyboardShown = false // Need to check whether keyboard is on the screen right now
	
	
	
	var topPopViewConstant: CGFloat! // Saving constants to restore the view when keyboard hides
	var bottomPopViewConstant: CGFloat! // Saving constants to restore the view when keyboard hides
	
	/**
	Hides keyboard or the picker. If hides picker, than takes current value and sets it as the buttons title
	*/
	func hideKeyboard(notification: AnyObject)
	{
		signupview.emailField.resignFirstResponder()
		signupview.passwordField.resignFirstResponder()
		signupview.userNameField.resignFirstResponder()
	}
	
	var normalFrame: CGRect! // Saving View frame to restore it on keyboard hide
	
	func keyboardWillShow(notification: NSNotification)
	{

		if keyboardShown
		{
			return
		}
		keyboardShown = true
		normalFrame = view.frame
		topPopViewConstant = signupview.topPopViewConstraint.constant
		//        view.frame = CGRect(x: normalFrame.origin.x, y: normalFrame.origin.y - 150, width: normalFrame.width, height: normalFrame.height)
		
		//        var rect = self.view.convertRect(signInButton.bounds, fromView: signInButton)
		
		//
		view.frame = CGRect(x: normalFrame.origin.x, y: (normalFrame.origin.y - 100), width: normalFrame.width, height: normalFrame.height)
		//topPopViewConstraint.constant -= 280.0
		
		UIView.animateWithDuration(0.5, animations: { () -> Void in
			self.view.layoutIfNeeded()
		})
	}
	
	func keyboardWillHide(notification: NSNotification)
	{
		var keyboardSize = notification.userInfo![UIKeyboardFrameBeginUserInfoKey]?.CGRectValue().size
		view.frame = normalFrame
		signupview.topPopViewConstraint.constant = topPopViewConstant
		
		UIView.animateWithDuration(0.5, animations: { () -> Void in
			self.view.layoutIfNeeded()
		})
		keyboardShown = false
	}
	
	func textFieldShouldReturn(textField: UITextField) -> Bool {
		textField.resignFirstResponder() // Tells to hide keyboard
		return true
	}
	
	/**
	Adding observers to catch the moment when we need to slide the pop view up or down
	*/
	func addNotificationsObservers()
	{
		NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
		NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
	}/**
	Removing observers to prevent different conflicts
	*/
	func removeNotificationsObservers()
	{
		NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
		NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
	}
	
	@IBAction func existingUserAction(sender: UIButton) {
//		self.parentViewController?.navigationController?.popViewControllerAnimated(true)
        self.dismissViewControllerAnimated(true, completion: nil)
	}
    @IBAction func seeTOS(sender: AnyObject) {
        //        self.performSegueWithIdentifier("seeTOS", sender: self)
        UIApplication.sharedApplication().openURL(NSURL(string: "http://www.studypool.com/terms")!)
    }
    /**
    Facebook Social login
    */
    @IBAction func onFB(sender:UIButton){
        
        let overlay = SocialLoginView.loadFromNibNamed("SocialLoginView") as! SocialLoginView
        
        overlay.signupview = self
        overlay.frame = CGRectMake(0, 0, self.view.frame.width - 70, self.view.frame.height - 130)
        overlay.socialURL = kFBURL
        overlay.loadwebview()
        self.lew_presentPopupView(overlay, animation: LewPopupViewAnimationFade.alloc())
        
    }
    
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "google" {
            var socialVC = segue.destinationViewController as! SocialLoginViewController
            socialVC.signupview = self
            socialVC.socialURL = kGOOGLEURL
            socialVC.socialType = "Google"            
            socialVC.black = true
        }
        if segue.identifier == "facebook" {
            var socialVC = segue.destinationViewController as! SocialLoginViewController
            socialVC.signupview = self
            socialVC.socialURL = kFBURL
            socialVC.socialType = "Facebook"            
            socialVC.black = false
            
        }
        if segue.identifier == "likedin" {
            var socialVC = segue.destinationViewController as! SocialLoginViewController
            socialVC.signupview = self
            socialVC.socialURL = kLINKEDINURL
            socialVC.socialType = "LinkedIn"             
            socialVC.black = false
            
        }
    }
    
    
    /**
    this function is called after signup,
    check phone verification status, if yes, go to feed page, if no, go to phone verification page
    */
    func enterFeed(){
        
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        token = appDelegate.userlogin.token
        
        self.isCheckPhoneVerified { (response) -> Void in
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
                
                self.presentViewController(phoneverify, animated: true, completion: nil)
                
            }
        }
        
    }
    
    /**
    Check Phone Verified
    **/
    
    func isCheckPhoneVerified(success: (response: Bool) -> Void) {
        
        let parameters = [
            "token": token,
        ]
        
        NetworkUI.sharedInstance.isCheckPhoneVerification(parameters, success: { (response) -> Void in
            
            if let resultJSON = response as? NSDictionary {
                var status = resultJSON["status"] as! String
                if status == "verified" {
                    success(response: true)
                }
                else {
                    success(response: false)
                    
                }
            }
            
            
            
            }) { (error) -> Void in
                
                return false
        }
        
    }

}

