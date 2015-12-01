
//
//  PhoneVerficationViewController.swift
//  spios
//
//  Created by Stanley Chiang on 6/24/15.
//  Copyright (c) 2015 Studypool. All rights reserved.
//

import Foundation
import UIKit
import MBProgressHUD

/// phone number input screen
class PhoneVerificationViewController: UIViewController {
    
    
    @IBOutlet weak var phoneverification: PhoneVerificationView!
    
    

	override func viewDidLoad() {
		super.viewDidLoad()
        phoneverification.controller = self
        phoneverification.initviews()
		        
		
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        phoneverification.phoneNumber.becomeFirstResponder()
    }
    func dismissKeyboard(){
        phoneverification.phoneNumber.resignFirstResponder()
      
    }
    
    
    
    @IBAction func actBack(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // Picker View Methods 
    func updatedCountryValue(object: AnyObject) {
        
    }
    
    /**
        Hide keyboard notification
    */
    func hideKeyboard(notification: AnyObject)
    {
        phoneverification.phoneNumber.resignFirstResponder()
    }
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
    
    /**
        action for send phone number
    */
	
	@IBAction func sendNumber(sender: UIButton) {
        self.view.userInteractionEnabled = false
        phoneverification.phoneNumber.resignFirstResponder()
        phoneverification.countryCode.resignFirstResponder()
		
		var num: String!
		
		num = phoneverification.countryCodeString + phoneverification.phoneNumber.text
		phoneNum = num

		if phoneverification.phoneNumber.text.isEmpty {
            self.view.userInteractionEnabled = true
            TAOverlay.showOverlayWithLabel("Please enter a phone number", options: TAOverlayOptions.OverlaySizeRoundedRect|TAOverlayOptions.OverlayTypeError|TAOverlayOptions.AutoHide)
		
		} else {
            
            phoneverification.btnSendNumber.enabled = false
            
            NetworkUI.sharedInstance.getPhoneCode(["token": token, "number":num],
                success: { (response) -> Void in
                    
                    self.phoneverification.btnSendNumber.enabled = true
                    
                    if let result = response as? NSMutableDictionary {
                        if (result["status"] as! String == "duplicate") {
                            self.view.userInteractionEnabled = true
                            TAOverlay.showOverlayWithLabel("Phone number is already in use.", options: TAOverlayOptions.OverlaySizeRoundedRect|TAOverlayOptions.OverlayTypeError|TAOverlayOptions.AutoHide)
                        } else {
                            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                            appDelegate.bFirstSign = true
                            self.view.userInteractionEnabled = true
                            
                            self.performSegueWithIdentifier("verifySuccess", sender: self)
                        }
                        
                    }
                    else {
                        self.view.userInteractionEnabled = true
                        TAOverlay.showOverlayWithLabel("error\(response)", options: TAOverlayOptions.OverlaySizeRoundedRect|TAOverlayOptions.OverlayTypeError|TAOverlayOptions.AutoHide)
                    }
                    
                }) { (error) -> Void in
                    
                    self.view.userInteractionEnabled = true                    
                    TAOverlay.showOverlayWithLabel("Try Again", options: TAOverlayOptions.OverlaySizeRoundedRect|TAOverlayOptions.OverlayTypeError|TAOverlayOptions.AutoHide)
                    
            }
            
		}
	}
   
    @IBAction func countryCodeButtonPressed(sender: UIButton) {
        var picker = ActionSheetStringPicker(title: "Select Country", rows: self.phoneverification.countryArray, initialSelection: self.phoneverification.nCountry, doneBlock: { (picker, index, object) -> Void in
            
            self.phoneverification.nCountry = index;
            println("COUNTRY NAME: ")
            self.phoneverification.countryCode.text = String(format: "%@", self.phoneverification.countryArray[index])
            self.phoneverification.countryCodeString = String(format: "%@", self.phoneverification.countryPickerDataSourceShort[index]["code"] as! String)
			
            println("COUNTRY DIAL_CODE: ")
            println(self.phoneverification.countryCodeString)
			//self.phoneNumber.text = self.countryCodeString
			
            }, cancelBlock: { (picker) -> Void in
                
        }, origin: sender.superview!.superview)
        
        
        picker.showActionSheetPicker()
        
    }
    
    /**
        Edit text delegate
    */
	func textFieldShouldReturn(textField: UITextField) -> Bool {
		textField.resignFirstResponder() // Tells to hide keyboard
		return true
	}

	
}