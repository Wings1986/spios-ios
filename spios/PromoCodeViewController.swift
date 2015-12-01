//
//  PromoCodeViewController.swift
//  spios
//
//  Created by MobileGenius on 6/18/15.
//  Copyright (c) 2015 Studypool. All rights reserved.
//

import UIKit

class PromoCodeViewController: UIViewController {

    @IBOutlet weak var tfPromocode: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addDoneButtonToKeyboard(tfPromocode)
        tfPromocode.layer.sublayerTransform = CATransform3DMakeTranslation(5, 0, 0)

        // Do any additional setup after loading the view.
        var swipe:UISwipeGestureRecognizer = UISwipeGestureRecognizer(target:self, action:"dismissKeyboard")
        
        swipe.direction = UISwipeGestureRecognizerDirection.Down
        
        self.view.addGestureRecognizer(swipe)
    }
    func dismissKeyboard(){
        self.tfPromocode.resignFirstResponder()
      
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onSubmit(sender:UIButton){
        let parameters = [
            "token": token,
            "v_promo":tfPromocode.text//token
        ]
        
        MediumProgressViewManager.sharedInstance.showProgressOnView(self)
        
        NetworkUI.sharedInstance .submitPromocode(parameters, success: { (response) -> Void in
            MediumProgressViewManager.sharedInstance.hideProgressView(self)
            
            var responsestring = response as! String
            
            responsestring = responsestring.stringByReplacingOccurrencesOfString("\"", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)

            
            let sendMailErrorAlert = UIAlertView(title: "StudyPool", message: responsestring, delegate: self, cancelButtonTitle: "OK")
            sendMailErrorAlert.show()
            }) { (error) -> Void in
                MediumProgressViewManager.sharedInstance.hideProgressView(self)
                TAOverlay.showOverlayWithLabel("Please try again", options: TAOverlayOptions.OverlaySizeRoundedRect|TAOverlayOptions.OverlayTypeWarning|TAOverlayOptions.AutoHide)
        }
    }
    
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
    
    func hideKeyboard(notification: AnyObject)
    {
        tfPromocode.resignFirstResponder()
    }



}
