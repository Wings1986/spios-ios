//
//  PromotionViewController.swift
//  spios
//
//  Created by user on 6/15/15.
//  Copyright (c) 2015 Studypool. All rights reserved.
//

import UIKit
import Analytics


class PromotionViewController: UIViewController, ReferralBonusPopoverViewDelegate {
    

    @IBOutlet weak var promotionview: PromotionView!
    
    @IBOutlet weak var topMarginConstraint: NSLayoutConstraint?
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        //adjust because we used an image for the uitextfield
        
//		self.shareButton.rotate360Degrees()
        promotionview.initViews()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNavigationBarItem()
        // Do any additional setup after loading the view.
        var swipe:UISwipeGestureRecognizer = UISwipeGestureRecognizer(target:self, action:"dismissKeyboard")
        
        swipe.direction = UISwipeGestureRecognizerDirection.Down
        addDoneButtonToKeyboard(promotionview.tfPromocode)
        self.view.addGestureRecognizer(swipe)
        
        let params = ["token":token]
        linkToReferral = ""
        NetworkUI.sharedInstance.getReferralLink(params,
            success: { (response) -> Void in
                if let result = response as? NSMutableDictionary {
                    linkToReferral = (result["link"] as! String)
                }
            }) { (error) -> Void in
        }
    }
    
    func onDismiss() {
        self.lew_dismissPopupViewWithanimation(LewPopupViewAnimationDrop.alloc())
    }
    
    func dismissKeyboard(){
        promotionview.tfPromocode.resignFirstResponder()

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
		
		if promotionview.tfPromocode.isFirstResponder(){
			promotionview.tfPromocode.resignFirstResponder()
			return
		}
	}
	
    
    
    func setAnchorPoint(anchor: CGPoint, forview: UIView){
        var newPoint = CGPointMake(view.bounds.size.width * anchor.x, view.bounds.size.height * anchor.y)
        var oldPoint = CGPointMake(view.bounds.size.width * view.layer.anchorPoint.x, view.bounds.size.height * view.layer.anchorPoint.y)
        
        newPoint = CGPointApplyAffineTransform(newPoint, view.transform)
        oldPoint = CGPointApplyAffineTransform(oldPoint, view.transform)
        
        var position = view.layer.position
        
        position.x -= oldPoint.x;
        position.x += newPoint.x;
        
        position.y -= oldPoint.y;
        position.y += newPoint.y;
        
        view.layer.position = position;
        view.layer.anchorPoint = anchor;
    }
    
    @IBAction func onSubmit(sender: UIButton) {
        let parameters = [
            "token": token,
            "v_promo":promotionview.tfPromocode.text//token
        ]
        
        MediumProgressViewManager.sharedInstance.showProgressOnView(self)
        self.view.userInteractionEnabled = false
        
        NetworkUI.sharedInstance .submitPromocode(parameters, success: { (response) -> Void in
            MediumProgressViewManager.sharedInstance.hideProgressView(self)
            
            let result = response! as! NSMutableDictionary
            
            var responsestring = result["status"] as! String
            
            responsestring = responsestring.stringByReplacingOccurrencesOfString("\"", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
            if (responsestring == "success") {
                SEGAnalytics.sharedAnalytics().track("Claimed Promo", properties: result["segment"] as! [NSObject : AnyObject])
                // Show success screen
                let screenSize: CGRect = UIScreen.mainScreen().bounds
                let popView = ReferralBonusPopoverView.loadFromNibNamed("ReferralBonusPopoverView", bundle: nil) as! ReferralBonusPopoverView
                popView.delegate = self
                popView.frame = CGRectMake(0, 0, screenSize.width - 70, 430)
                self.lew_presentPopupView(popView, animation: LewPopupViewAnimationDrop.alloc())
            } else if (responsestring == "invalid2") {
                TAOverlay.showOverlayWithLabel("Not allowed to use your\n own promotion code", options: TAOverlayOptions.OverlaySizeRoundedRect|TAOverlayOptions.OverlayTypeWarning|TAOverlayOptions.AutoHide)
            } else if (responsestring == "used") {
                TAOverlay.showOverlayWithLabel("You have already redeemed your promotion.", options: TAOverlayOptions.OverlaySizeRoundedRect|TAOverlayOptions.OverlayTypeWarning|TAOverlayOptions.AutoHide)
            } else if (responsestring == "already used") {
                TAOverlay.showOverlayWithLabel("You have already redeemed a promo.", options: TAOverlayOptions.OverlaySizeRoundedRect|TAOverlayOptions.OverlayTypeWarning|TAOverlayOptions.AutoHide)
            } else if (responsestring == "code not found") {
                TAOverlay.showOverlayWithLabel("This promo code does not exist.", options: TAOverlayOptions.OverlaySizeRoundedRect|TAOverlayOptions.OverlayTypeWarning|TAOverlayOptions.AutoHide)
            } else if (responsestring == "no promo") {
                TAOverlay.showOverlayWithLabel("Please enter a promo code.", options: TAOverlayOptions.OverlaySizeRoundedRect|TAOverlayOptions.OverlayTypeWarning|TAOverlayOptions.AutoHide)
            } else if (responsestring == "invalid1") {
                TAOverlay.showOverlayWithLabel("Promotion is not valid in your area.", options: TAOverlayOptions.OverlaySizeRoundedRect|TAOverlayOptions.OverlayTypeWarning|TAOverlayOptions.AutoHide)
            } else {
                TAOverlay.showOverlayWithLabel("Promotion code is invalid.", options: TAOverlayOptions.OverlaySizeRoundedRect|TAOverlayOptions.OverlayTypeWarning|TAOverlayOptions.AutoHide)
            }
            self.view.userInteractionEnabled = true


            
            
            /*
            let sendMailErrorAlert = UIAlertView(title: "StudyPool", message: responsestring, delegate: self, cancelButtonTitle: "OK")
            sendMailErrorAlert.show()
            */
            
            
            }) { (error) -> Void in
                self.view.userInteractionEnabled = true                
                MediumProgressViewManager.sharedInstance.hideProgressView(self)
                TAOverlay.showOverlayWithLabel("Please try again", options: TAOverlayOptions.OverlaySizeRoundedRect|TAOverlayOptions.OverlayTypeWarning|TAOverlayOptions.AutoHide)
        }

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
extension UIView {
	func rotate360Degrees(duration: CFTimeInterval = 1.0, completionDelegate: AnyObject? = nil) {
		let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation")
		rotateAnimation.fromValue = 0.0
		rotateAnimation.toValue = CGFloat(M_PI * 2.0)
		rotateAnimation.duration = duration
		
		if let delegate: AnyObject = completionDelegate {
			rotateAnimation.delegate = delegate
		}
		self.layer.addAnimation(rotateAnimation, forKey: nil)
	}
}
