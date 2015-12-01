//
//  PromotionShareViewController.swift
//  spios
//
//  Created by user on 6/15/15.
//  Copyright (c) 2015 Studypool. All rights reserved.
//

import UIKit
import MessageUI
import Social
import Analytics

class PromotionShareViewController: UIViewController, MFMailComposeViewControllerDelegate, MFMessageComposeViewControllerDelegate, SphereMenuDelegate {

    @IBOutlet weak var promoCode: UITextField!
    @IBOutlet weak var bottomView: UIView!
    
    override func viewWillAppear(animated: Bool) {
        //adjust because we used an image for the uitextfield
       // let spacerView = UIView(frame: CGRectMake(0, 0, 15, 10))
      //  self.promoCode.leftViewMode = UITextFieldViewMode.Always
       // self.promoCode.leftView = spacerView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
//        promoCode.text = "studypool6537a"
        // Do any additional setup after loading the view.
        
        self.promoCode.text = ""
        
        
        
        let parameters = [
            "token": token
        ]

        MediumProgressViewManager.sharedInstance.showProgressOnView(self)
        
        NetworkUI.sharedInstance .getPromocode(parameters, success: { (response) -> Void in
            
                MediumProgressViewManager.sharedInstance.hideProgressView(self)
            
                if let responseString = response as? String {
                    //get rid of double quotes
                    if responseString != "\"\"" {
                        self.promoCode.text = responseString.stringByReplacingOccurrencesOfString("\"", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
                    } else{
                        self.promoCode.text = "studypool"
                    }
                }
            
            
            }) { (error) -> Void in

                MediumProgressViewManager.sharedInstance.hideProgressView(self)
                TAOverlay.showOverlayWithLabel("Please try again", options: TAOverlayOptions.OverlaySizeRoundedRect|TAOverlayOptions.OverlayTypeWarning|TAOverlayOptions.AutoHide)
                
        }
        
        
        
        let start = UIImage(named: "btnshare")
        let image1 = UIImage(named: "promotion_facebook")
        let image2 = UIImage(named: "promotion_twitter")
        let image3 = UIImage(named: "promotion_reddit")
        var images:[UIImage] = [image1!,image2!]    
        var menu = SphereMenu(startPoint: CGPointMake(self.view.frame.width/2, self.view.frame.height - 40), startImage: start!, submenuImages:images, tapToDismiss:true)

        menu.delegate = self
        self.view.addSubview(menu)
        
        menu.expandSubmenu()

        
        var swipe:UISwipeGestureRecognizer = UISwipeGestureRecognizer(target:self, action:"dismissKeyboard")
        
        swipe.direction = UISwipeGestureRecognizerDirection.Down
        
        self.view.addGestureRecognizer(swipe)
        
        
        SEGAnalytics.sharedAnalytics().screen("Free Help", properties: [:])
    }
    func dismissKeyboard(){
        self.promoCode.resignFirstResponder()
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onCopy(sender: UIButton) {
        UIPasteboard.generalPasteboard().string = self.promoCode.text
        SEGAnalytics.sharedAnalytics().track("Copied Promo Code")        
        TAOverlay.showOverlayWithLabel("Copied to Clipboard", options: TAOverlayOptions.OverlaySizeRoundedRect|TAOverlayOptions.OverlayTypeSuccess|TAOverlayOptions.AutoHide)
    }
    
    @IBAction func onEmailInvite(sender: AnyObject) {
        let mailComposeViewController = configuredMailComposeViewController()
        if MFMailComposeViewController.canSendMail() {
            SEGAnalytics.sharedAnalytics().track("Email Invite")
            self.presentViewController(mailComposeViewController, animated: true, completion: nil)
        } else {
            self.showSendMailErrorAlert()
        }
    }
    
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self // Extremely important to set the --mailComposeDelegate-- property, NOT the --delegate-- property
        mailComposerVC.setSubject("Invitaton to Studypool")
        mailComposerVC.setMessageBody(String(format: "Hey! Here’s a free question to try Studypool, it’s my favorite way to get homework help. \n Sign up with my code \"%@\" and I’ll get a free question too. Redeem it at %@", self.promoCode.text!, linkToReferral), isHTML: false)
        
        return mailComposerVC
    }
    
    func showSendMailErrorAlert() {
        let sendMailErrorAlert = UIAlertView(title: "Could Not Send Email", message: "Your device could not send e-mail.  Please check e-mail configuration and try again.", delegate: self, cancelButtonTitle: "OK")
        sendMailErrorAlert.show()
    }
    
    // MARK: MFMailComposeViewControllerDelegate
    
    func mailComposeController(controller: MFMailComposeViewController!, didFinishWithResult result: MFMailComposeResult, error: NSError!) {
        controller.dismissViewControllerAnimated(true, completion: nil)
        
    }

    @IBAction func onTextInvite(sender: AnyObject) {
        // MARK : empty parameters for now
        
        if (MFMessageComposeViewController.canSendText()) {
            SEGAnalytics.sharedAnalytics().track("Text Invite")
            let controller = MFMessageComposeViewController()
            controller.body = String(format: "Use my invite code: \"%@\", and get free homework help for up to $10. \n Redeem it at %@", self.promoCode.text!, linkToReferral)
//            controller.recipients = [phoneNumber.text]
            controller.messageComposeDelegate = self
            self.presentViewController(controller, animated: true, completion: nil)
        }else {
            let sendMailErrorAlert = UIAlertView(title: "Could Not Send SMS", message: "Your device does not support SMS...", delegate: self, cancelButtonTitle: "OK")
            sendMailErrorAlert.show()
        }
    }
    
    
    func messageComposeViewController(controller: MFMessageComposeViewController!, didFinishWithResult result: MessageComposeResult) {
        //... handle sms screen actions
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.navigationController?.navigationBarHidden = false
    }

    @IBAction func onShare(sender: UIButton){
        
        
    }
    func sphereDidSelected(index: Int) {
        
        
        //put implementation here
        println("\(index)")
        if (index == 0)
        {
            shareFacebook()
        }
        if (index == 1)
        {
            shareTwitter()
        }
        if (index == 2)
        {
            //gmail
        }
    }
    
    func shareTwitter(){
        // MARK : empty parameters for now


        
        
        if SLComposeViewController.isAvailableForServiceType(SLServiceTypeTwitter){
            var twitterSheet:SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
            SEGAnalytics.sharedAnalytics().track("Twitter Invite")
            twitterSheet.setInitialText(String(format: "Stuck on homework? Use Studypool and get $10 in credit! @studypool %@", linkToReferral))
            self.presentViewController(twitterSheet, animated: true, completion: nil)
        } else {
            var alert = UIAlertController(title: "Accounts", message: "Please login to a Twitter account to share.", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    func shareFacebook(){
        if SLComposeViewController.isAvailableForServiceType(SLServiceTypeFacebook){
            SEGAnalytics.sharedAnalytics().track("Facebook Invite")
            var facebookSheet:SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
        facebookSheet.setInitialText(String (format: "Get $10 off homework help at %@", linkToReferral))
            self.presentViewController(facebookSheet, animated: true, completion: nil)
        } else {
            var alert = UIAlertController(title: "Accounts", message: "Please login to a Facebook account to share.", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
}
