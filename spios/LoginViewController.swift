//
//  LoginViewController.swift
//  spios
//
//  Created by Stanley Chiang on 3/7/15.
//  Copyright (c) 2015 Stanley Chiang. All rights reserved.
//

import UIKit
import MBProgressHUD
import CoreData
import Analytics


class LoginViewController: UIViewController {

    ///Facebook login url
    let kFBURL          :String = "https://www.createpool.com/yiiauth/default/apiauth/provider/facebook/pin/sp86626728app#"
    ///Linkedin login url
    let kLINKEDINURL    :String = "https://www.createpool.com/yiiauth/default/apiauth/provider/linkedin/pin/sp86626728app#"
    ///Google login url
    let kGOOGLEURL      :String = "https://www.createpool.com/yiiauth/default/apiauth/provider/google/pin/sp86626728app#"
    
    ///core data for loing object
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    let kClientId = "820657394781-m70uvh44pb0fee2donh6pk8i34a7eg22.apps.googleusercontent.com"
    
    @IBOutlet weak var loginview:LoginView!
    
    // MARK: - View Setup
    override func viewDidLoad() {
        
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        loginview.controller = self
        loginview.initviews()
        
        //Dismiss keyboard by swipe down
        var swipe:UISwipeGestureRecognizer = UISwipeGestureRecognizer(target:self, action:"dismissKeyboard")
        swipe.direction = UISwipeGestureRecognizerDirection.Down
        self.view.addGestureRecognizer(swipe)
    }
    
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        loginview.viewwillappear()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        // add keyboard hide/show notification
        addNotificationsObservers()
        
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    /**
    Check Phone Verified
    */
    
    func isCheckPhoneVerified(success: (response: Bool) -> Void) {
        
        let version = NSBundle.mainBundle().infoDictionary?["CFBundleShortVersionString"] as! String
        
        let parameters = [
            "token": token,
            "version" : version
        ]
        
        NetworkUI.sharedInstance.isCheckPhoneVerification(parameters, success: { (response) -> Void in
            
            if let resultJSON = response as? NSDictionary {
                var status = resultJSON["status"] as! String
                if(status == "out_of_date"){
                    isUptodate = false
                    
                    if(isUptodate == false){
                        var refreshAlert = UIAlertController(title: "Studypool", message: "Your app is out of date, Please update your app", preferredStyle: UIAlertControllerStyle.Alert)
                        
                        
                        
                        refreshAlert.addAction(UIAlertAction(title: "Not, for now", style: .Default, handler: { (action: UIAlertAction!) in
                            
                        }))
                        
                        refreshAlert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { (action: UIAlertAction!) in
                            
                            UIApplication.sharedApplication().openURL(NSURL(string: "https://itunes.apple.com/us/app/studypool/id1033410225?mt=8")!)
                        }))
                        
                        
                        self.presentViewController(refreshAlert, animated: true, completion: nil)
                    }

                    
                }else if status == "verified" {
                    isUptodate = true
                    success(response: true)
                }
                else {
                    isUptodate = true
                    success(response: false)

                }
            }
            
            
            
            }) { (error) -> Void in
                
                return false
        }
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //signup action already modally segues to signup controller

    
    // MARK: - Actions
    
    /**
    Segue for social login
    */
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "google" {
            var socialVC = segue.destinationViewController as! SocialLoginViewController
            socialVC.parentview = self
            socialVC.socialURL = kGOOGLEURL
            socialVC.socialType = "Google"
            socialVC.black = true
        }
        if segue.identifier == "facebook" {
            var socialVC = segue.destinationViewController as! SocialLoginViewController
            socialVC.parentview = self
            socialVC.socialURL = kFBURL
            socialVC.socialType = "Facebook"
            socialVC.black = false
            
        }
        if segue.identifier == "likedin" {
            var socialVC = segue.destinationViewController as! SocialLoginViewController
            socialVC.parentview = self
            socialVC.socialURL = kLINKEDINURL
            socialVC.socialType = "LinkedIn"
            socialVC.black = false
            
        }
    }
    
    /**
    Facebook Social login
    */
    @IBAction func onFB(sender:UIButton){
        
        let overlay = SocialLoginView.loadFromNibNamed("SocialLoginView") as! SocialLoginView
        
        overlay.parentview = self
        overlay.frame = CGRectMake(0, 0, self.view.frame.width - 70, self.view.frame.height - 130)
        overlay.socialURL = kFBURL
        overlay.loadwebview()
        self.lew_presentPopupView(overlay, animation: LewPopupViewAnimationFade.alloc())
        
    }
    
    /**
    LinkedIn Social login
    */
    @IBAction func onLinkedIn(sender:UIButton){
        
        let overlay = SocialLoginView.loadFromNibNamed("SocialLoginView") as! SocialLoginView
        
        overlay.parentview = self
        overlay.frame = CGRectMake(0, 0, self.view.frame.width - 70, self.view.frame.height - 130)
        overlay.loadwebview()
        overlay.socialURL = kLINKEDINURL
        
        self.lew_presentPopupView(overlay, animation: LewPopupViewAnimationFade.alloc())
    }
    
    /**
    Google Social login
    */
    @IBAction func onGoogle(sender:UIButton){
        
        let overlay = SocialLoginView.loadFromNibNamed("SocialLoginView") as! SocialLoginView
        
        overlay.parentview = self
        overlay.frame = CGRectMake(0, 0, self.view.frame.width - 70, self.view.frame.height - 130)
        overlay.socialURL = kGOOGLEURL
        overlay.loadwebview()
        
        self.lew_presentPopupView(overlay, animation: LewPopupViewAnimationFade.alloc())
        
    }
    
    
    
    
    /**
    Adding observers to catch the moment when we need to slide the pop view up or down
    */
    @IBAction func onSignUp(sender: AnyObject) {
        
        self.performSegueWithIdentifier("signUp", sender: sender)
    }
    /**
    action for clicking login button
    */
    
    @IBAction func loginAction(sender: UIButton) {
        
        showHomeView()
        
    }
    
    
    /**
    Call Auth api and go to home page
    */
    func showHomeView() {
        var email = loginview.emailField.text
        var password = loginview.passwordField.text
        
        if loginview.emailField.text.isEmpty || loginview.passwordField.text.isEmpty{
            TAOverlay.showOverlayWithLabel("Please complete all fields", options: TAOverlayOptions.OverlaySizeRoundedRect|TAOverlayOptions.OverlayTypeWarning|TAOverlayOptions.AutoHide)
        } else{
            self.view.userInteractionEnabled = false
            
            NetworkUI.sharedInstance.confirmAuth(["email":email, "password":password, "callback":"asdf"], success: { (data) -> Void in
                
                NSOperationQueue.mainQueue().addOperationWithBlock{
                    if let good: AnyObject = data["id"]{
                        
                        
                        self.clearlogincoredata()
                        
                        
                        let newItem = NSEntityDescription.insertNewObjectForEntityForName("UserLogin", inManagedObjectContext: self.managedObjectContext!) as! UserLogin
                        newItem.id = data["id"] as! String
                        user_id = (newItem.id as NSString).integerValue
                        newItem.token = data["token"] as! String
                        newItem.username = data["username"]as! String
                        
                        
                        self.managedObjectContext?.save(nil)
                        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                        appDelegate.userlogin = newItem
                        println("good\(data)")
                        TAOverlay.hideOverlay()
                        
                        let defaults = NSUserDefaults.standardUserDefaults()
                        defaults.setValue(newItem.username, forKey: "username")
                        defaults.synchronize()
                        
                        self.loginview.enterFeed()
                        
                        
                        
                        self.view.userInteractionEnabled = true
                        
                        
                    } else {
                        self.view.userInteractionEnabled = true
                        TAOverlay.showOverlayWithLabel(data["error"] as! String, options: TAOverlayOptions.OverlaySizeRoundedRect|TAOverlayOptions.OverlayTypeWarning|TAOverlayOptions.AutoHide)
                    }
                    
                    //                        TAOverlay.hideOverlay()
                }
                
                }, failure: { (error) -> Void in
                    println(error)
                    self.view.userInteractionEnabled = true
                    TAOverlay.showOverlayWithLabel("Please try again", options: TAOverlayOptions.OverlaySizeRoundedRect|TAOverlayOptions.OverlayTypeWarning|TAOverlayOptions.AutoHide)
            })
            
        }
        
    }
    
    /**
    clear core data when logout
    */
    func clearlogincoredata(){
        var request = NSFetchRequest(entityName: "UserLogin")
        request.returnsObjectsAsFaults = false
        var dowjones = self.managedObjectContext!.executeFetchRequest(request, error: nil)!
        
        if dowjones.count > 0 {
            
            for result: AnyObject in dowjones{
                self.managedObjectContext!.deleteObject(result as! UserLogin)
                println("NSManagedObject has been Deleted")
            }
            self.managedObjectContext!.save(nil)
        }
    }
    
        
    // MARK: - Keyboard Functions
    
    var keyboardShown = false // Need to check whether keyboard is on the screen right now

    
    
    
    /**
    Hides keyboard or the picker. If hides picker, than takes current value and sets it as the buttons title
    */
    func hideKeyboard(notification: AnyObject)
    {
        loginview.emailField.resignFirstResponder()
        loginview.passwordField.resignFirstResponder()
    }
    
    var normalFrame: CGRect! // Saving View frame to restore it on keyboard hide\\
    
    var topPopViewConstant: CGFloat! // Saving constants to restore the view when keyboard hides
    var bottomPopViewConstant: CGFloat! // Saving constants to restore the view when keyboard hides
    
    /**
    Keyboard will be shown
    */
    func keyboardWillShow(notification: NSNotification)
    {
        if keyboardShown
        {
            return
        }
        keyboardShown = true
        normalFrame = view.frame
        topPopViewConstant = loginview.topPopViewConstraint.constant
        view.frame = CGRect(x: normalFrame.origin.x, y: (normalFrame.origin.y - 100), width: normalFrame.width, height: normalFrame.height)
        //topPopViewConstraint.constant -= 280.0
        
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            self.view.layoutIfNeeded()
        })
    }
    
    /**
    Keyboard will be hidden
    */
    func keyboardWillHide(notification: NSNotification)
    {
        var keyboardSize = notification.userInfo![UIKeyboardFrameBeginUserInfoKey]?.CGRectValue().size
        view.frame = normalFrame
        loginview.topPopViewConstraint.constant = topPopViewConstant
        
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            self.view.layoutIfNeeded()
        })
        keyboardShown = false
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder() // Tells to hide keyboard
        return true
    }
    
    ///dismissKeyboard by swipe down
    func dismissKeyboard(){
        loginview.emailField.resignFirstResponder()
        loginview.passwordField.resignFirstResponder()
    }
    
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

}


