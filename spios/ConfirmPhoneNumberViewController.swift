//
//  textIsCorrect.swift
//  spios
//
//  Created by Stanley Chiang on 6/25/15.
//  Copyright (c) 2015 Studypool. All rights reserved.
//

import Foundation
import UIKit

/// pin verification screen
class ConfirmPhoneNumberViewController: UIViewController {
    
	var textCode: String = ""
	
    @IBOutlet var confirmphonenumberview:ConfirmPhoneNumberView!

	override func viewDidLoad() {
		super.viewDidLoad()
        
        confirmphonenumberview.controller = self
		
	}
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        confirmphonenumberview.textEntered.becomeFirstResponder()
    }
    
    /**
        add done button to keyboard
    */
    func addDoneButtonToKeyboard(textView: AnyObject)
    {
        var toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 44))
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
        hide keyboard
    */
    func hideKeyboard(notification: AnyObject)
    {
        confirmphonenumberview.textEntered.resignFirstResponder()
    }
    
    @IBAction func actBack(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    /**
        send sms pin code, verify and move to choose avatar page
    */
	@IBAction func verifyCode(sender: UIButton) {
        self.view.userInteractionEnabled = false

        confirmphonenumberview.textEntered.resignFirstResponder()
        if confirmphonenumberview.textEntered.text.isEmpty {
            TAOverlay.showOverlayWithLabel("Please enter verification code.", options: TAOverlayOptions.OverlaySizeRoundedRect|TAOverlayOptions.OverlayTypeWarning|TAOverlayOptions.AutoHide)
            self.view.userInteractionEnabled = true
            return
        }
        
        NetworkUI.sharedInstance.getPhoneConfirm(["token": token, "code":confirmphonenumberview.textEntered.text],
            success: { (response) -> Void in
                
                // MediumProgressViewManager.sharedInstance.hideProgressView(self)
                
                if let result = response as? NSMutableDictionary {
                    
                    TAOverlay.hideOverlay()
                    
                    if(result["status"] as! String == "success"){
                        
                        let parameters = [
                            "token": token
                        ]
                        
                        // MediumProgressViewManager.sharedInstance.showProgressOnView(self)

                        NetworkUI.sharedInstance.getAvatarList(parameters, success: { (response) -> Void in
                            
                        // MediumProgressViewManager.sharedInstance.hideProgressView(self)

                            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                            appDelegate.bFirstSign = true

                            let overlay = ChooseAvatarView.loadFromNibNamed("ChooseAvatarView") as! ChooseAvatarView
                            
                            overlay.parentview = self
                            overlay.frame = CGRectMake(0, 0, self.view.frame.width, self.view.frame.height)
                            overlay.layer.borderColor = UIColor.whiteColor().CGColor
                            overlay.initviews(response as! NSArray)
                            
                            self.lew_presentPopupView(overlay, animation: LewPopupViewAnimationFade.alloc())
                            self.view.userInteractionEnabled = true
                            }) { (error) -> Void in
                                self.view.userInteractionEnabled = true
                                TAOverlay.showOverlayWithLabel("Please try again", options: TAOverlayOptions.OverlaySizeRoundedRect|TAOverlayOptions.OverlayTypeWarning|TAOverlayOptions.AutoHide)
                                
                        }
                        
                    } else {
                        self.view.userInteractionEnabled = true
                        TAOverlay.showOverlayWithLabel("Code is incorrect", options: TAOverlayOptions.OverlaySizeRoundedRect|TAOverlayOptions.OverlayTypeWarning|TAOverlayOptions.AutoHide)

                    }
                    
                }
                else {
                    self.view.userInteractionEnabled = true
                    TAOverlay.showOverlayWithLabel("Please try again", options: TAOverlayOptions.OverlaySizeRoundedRect|TAOverlayOptions.OverlayTypeWarning|TAOverlayOptions.AutoHide)
                    
                }
                
            }) { (error) -> Void in
                self.view.userInteractionEnabled = true
                TAOverlay.showOverlayWithLabel("Please try again", options: TAOverlayOptions.OverlaySizeRoundedRect|TAOverlayOptions.OverlayTypeWarning|TAOverlayOptions.AutoHide)
                
        }

	}
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
    
    func addAvataImage(nIndex : Int, strURL:String){
        let parameters = [
            "token": token,
            "path": strURL//token
        ]
        
        
       NetworkUI.sharedInstance.setAvatarImagePath(parameters, success: { (response) -> Void in
        
                self.lew_dismissPopupViewWithanimation(LewPopupViewAnimationFade.alloc())
        
                self.enterFeed()
        
            }) { (error) -> Void in
                
        }
    }
    
    
    func enterFeed(){
        
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        token = appDelegate.userlogin.token
        appDelegate.createMenuView()
        
    }
}