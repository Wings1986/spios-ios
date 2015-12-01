    //
//  RetrieveViewController.swift
//  spios
//
//  Created by Stanley Chiang on 3/7/15.
//  Copyright (c) 2015 Stanley Chiang. All rights reserved.
//

import UIKit

class RetrieveViewController: UIViewController {

    
    @IBOutlet weak var retrieveview:RetrieveView!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        //change the placeholder text font to white, opacity to 0.7
        retrieveview.viewwillappear()

    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        retrieveview.controller = self;
        retrieveview.viewdidappear()
    }
	
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - happen on pop view appearing
    
    /**
    Creates toolbar for storing Done Button and adds it to keyboard
    */
    func addDoneButtonToKeyboard(textView: AnyObject)
    {
        var toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 44))
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
    
    @IBAction func backAction(sender: UIButton) {
        
        self.parentViewController?.navigationController?.popViewControllerAnimated(true)
    }
    
    /*
    * param: User email / username
    */
    
    @IBAction func onSend(sender: AnyObject) {
        self.view.userInteractionEnabled = false
        let userInput = retrieveview.tfEmail.text
        
        if (validateEmail(userInput) != true) {
            TAOverlay.showOverlayWithLabel("Invalid email address", options: TAOverlayOptions.OverlaySizeRoundedRect|TAOverlayOptions.OverlayTypeError|TAOverlayOptions.AutoHide)
            self.view.userInteractionEnabled = true
        } else {
            // User has input email
            NetworkUI.sharedInstance.retrievePassword(["userInput": userInput],
                success: { (response) -> Void in
                    if let result = response as? NSMutableDictionary {
                        if (result["status"] as! String) == "sent" {
                            TAOverlay.showOverlayWithLabel("Password retrieval successful. \n Please check your email.", options: TAOverlayOptions.OverlaySizeRoundedRect|TAOverlayOptions.OverlayTypeSuccess|TAOverlayOptions.AutoHide)
                            // Go to login page
                            self.performSegueWithIdentifier("goToLogin", sender: self)
                            self.view.userInteractionEnabled = true
                            self.dismissViewControllerAnimated(true, completion: nil)
                        } else {
                            TAOverlay.showOverlayWithLabel("error\(response)", options: TAOverlayOptions.OverlaySizeRoundedRect|TAOverlayOptions.OverlayTypeError|TAOverlayOptions.AutoHide)
                            self.view.userInteractionEnabled = true
                        }
                    }
                }) { (error) -> Void in
                    self.view.userInteractionEnabled = true                    
                    TAOverlay.showOverlayWithLabel("Email does not exist.", options: TAOverlayOptions.OverlaySizeRoundedRect|TAOverlayOptions.OverlayTypeError|TAOverlayOptions.AutoHide)
            }
        }
        

    }
    
    private func validateEmail(candidate: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluateWithObject(candidate)
    }
}
