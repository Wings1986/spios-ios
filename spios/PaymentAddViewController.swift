//
//  PaymentAddViewController.swift
//  spios
//
//  Created by user on 6/27/15.
//  Copyright (c) 2015 Studypool. All rights reserved.
//

import UIKit
import Analytics

protocol PaymentDelegate {
    func postQuestion(params: [String: AnyObject], image: UIImage, success: (response: AnyObject!) -> Void, failure: (error: NSError?) -> Void)
}

class PaymentAddViewController: UIViewController, CardIOPaymentViewControllerDelegate {
    
    var delegate: PaymentDelegate?
    
    
    var isFromQuestion = false
    var isFromFinalRelease = false
    var isFromWithdraw = false
    

    var questionsViewController: UIViewController!
    
    //URLS NEEDED FOR API CALLS
    let kBaseURL            :String = "https://www.studypool.com/"
    
    let stripePublishableKey = "pk_live_b1FmcVa6jcVXEm5ohHnsXHr5"
    let kSubmitPaypal          :String = "questions/apipaypaltokenstan"
    let kSubmitStripe          :String = "questions/apistripetokenstan"
    let kCheckToken            :String = "questions/apichecktokenstan"
    
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    
    
    var keyboardShown = false // Need to check whether keyboard is on the screen right now
    let pickerView = UIPickerView(frame: CGRect(x: 0, y: 0, width: 0, height: 0)) // Init UIPicker
    
    
    @IBOutlet weak var paymentaddview: PaymentAddView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.

        var swipe:UISwipeGestureRecognizer = UISwipeGestureRecognizer(target:self, action:"dismissKeyboard")
        
        swipe.direction = UISwipeGestureRecognizerDirection.Down
        
        self.view.addGestureRecognizer(swipe)
        self.view.userInteractionEnabled = true
    }
    func dismissKeyboard(){
       paymentaddview.tfCardNumber.resignFirstResponder()
        paymentaddview.tfCVC.resignFirstResponder()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        //self.setNavigationBarItem()
        
        NSLog("%@", String(format: "%.2f/mo", currentprice))
			paymentaddview.lbPrice.text = remainingAmt
		CardIOUtilities.preload()
		
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        paymentaddview.instantiatePickerTextField()
        self.addNotificationsObservers()
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        self.removeNotificationsObservers()
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
	@IBAction func scanCard(sender: AnyObject) {
		var scanViewController:CardIOPaymentViewController = CardIOPaymentViewController(paymentDelegate: self)
		
		self.presentViewController(scanViewController, animated: true, completion: nil)
	
	}
	func userDidCancelPaymentViewController(paymentViewController: CardIOPaymentViewController!) {
		println("Failed")
		paymentViewController.dismissViewControllerAnimated(true, completion: nil)
	}
	func userDidProvideCreditCardInfo(cardInfo: CardIOCreditCardInfo!, inPaymentViewController paymentViewController: CardIOPaymentViewController!) {
        paymentaddview.tfCardNumber.text =  cardInfo.cardNumber
        paymentaddview.tfCVC.text = cardInfo.cvv
        paymentaddview.monthButton.setTitle(String(cardInfo.expiryMonth), forState: UIControlState.Normal)
        paymentaddview.yearButton.setTitle(String(cardInfo.expiryYear), forState: UIControlState.Normal)

		paymentViewController.dismissViewControllerAnimated(true, completion: nil)
	}
    
    /**
    Adding observers to catch the moment when we need to slide the pop view up or down
    */
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
    
    //MARK: - happen on pop view appearing
    
    
    
    
    
    var normalFrame: CGRect! // Saving View frame to restore it on keyboard hide
    
    func keyboardWillShow(notification: NSNotification)
    {
        if keyboardShown
        {
            return
        }
        keyboardShown = true
        normalFrame = view.frame
        paymentaddview.topPopViewConstant = paymentaddview.topPopContraint.constant
        var rect = self.view.convertRect(paymentaddview.monthButton.bounds, fromView: paymentaddview.monthButton)
        var y = CGRectGetMaxY(rect)
        if (y > self.view.frame.size.height - 180)
        {
            var diff = y - self.view.frame.size.height + 180
            view.frame = CGRect(x: normalFrame.origin.x, y: normalFrame.origin.y - diff, width: normalFrame.width, height: normalFrame.height)
            paymentaddview.topPopContraint.constant -= diff
        }
        
        
        
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            self.view.layoutIfNeeded()
        })
    }
    
    func keyboardWillHide(notification: NSNotification)
    {
        var keyboardSize = notification.userInfo![UIKeyboardFrameBeginUserInfoKey]?.CGRectValue().size
        view.frame = normalFrame
        paymentaddview.topPopContraint.constant = paymentaddview.topPopViewConstant
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            self.view.layoutIfNeeded()
        })
        keyboardShown = false
    }
    
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
    
    @IBAction func onSelectMonth(sender: AnyObject) {
        paymentaddview.currentPickupView = paymentaddview.monthButton
        paymentaddview.pickerView.reloadAllComponents()
        paymentaddview.tvHiddenField.becomeFirstResponder()
    }
    @IBAction func onSelectYear(sender: AnyObject) {
        paymentaddview.currentPickupView = paymentaddview.yearButton
        paymentaddview.pickerView.reloadAllComponents()
        paymentaddview.tvHiddenField.becomeFirstResponder()
    }
    
    //MARK: METHODS FOR HTTP REQUESTS, CREATING AND SENDING TOKENS, SENDING API CALLS - EDITED BY NISHANTH
    
    //Helper method for HTTP request
    func http(request: NSURLRequest!, callback: (NSDictionary, String?) -> Void) {
        //    func http(request: NSURLRequest!, callback: (String, String?) -> Void) {
        var session = NSURLSession.sharedSession()
        var task = session.dataTaskWithRequest(request){
            (data, response, error) -> Void in
            if error != nil {
                //                callback("", error.localizedDescription)
            } else {
                var result = NSString(data: data, encoding:
                    NSASCIIStringEncoding)!
                var jsonResult: AnyObject? = NSJSONSerialization.JSONObjectWithData(data, options:NSJSONReadingOptions.AllowFragments, error: nil)
				println("printing result")
				println(jsonResult)
                //callback(jsonResult as! NSDictionary, nil)
                //callback(jsonResult as! String, nil)
            }
        }
        task.resume()
    }

	
    @IBAction func onAddCard(sender: AnyObject) {
        
        
        if paymentaddview.tfCardNumber.text.isEmpty || paymentaddview.tfCVC.text.isEmpty || paymentaddview.monthButton.titleForState(UIControlState.Normal) == "Month" ||
            paymentaddview.yearButton.titleForState(UIControlState.Normal) == "Year"
        {
            TAOverlay.showOverlayWithLabel("Please complete all fields", options: TAOverlayOptions.OverlaySizeRoundedRect|TAOverlayOptions.OverlayTypeError|TAOverlayOptions.AutoHide)
            return
        }
        cardnumber = paymentaddview.tfCardNumber.text
        
        let creditCard = STPCard()
        creditCard.number = paymentaddview.tfCardNumber.text
        creditCard.cvc = paymentaddview.tfCVC.text
        var monthStr:String = paymentaddview.monthButton.titleForState(UIControlState.Normal)!
        creditCard.expMonth = UInt(monthStr.toInt()!)
        var yearStr:String = paymentaddview.yearButton.titleForState(UIControlState.Normal)!
        creditCard.expYear = UInt(yearStr.toInt()!)
        
        var error: NSError?
        if (creditCard.validateCardReturningError(&error)){
            var stripeError: NSError!
            let apiClient = STPAPIClient(publishableKey: stripePublishableKey)
            apiClient.createTokenWithCard(creditCard, completion: { (stptoken, stripeError) -> Void in //Token is created here
                if (stripeError != nil){
                    TAOverlay.showOverlayWithLabel("There's an error creating your payment token.\n Please try again.", options: TAOverlayOptions.OverlaySizeRoundedRect|TAOverlayOptions.OverlayTypeError|TAOverlayOptions.AutoHide)
                }
                else {


					let paramters = [
						"token": token,
						"answer_id":answerid,
						"Mile[type_id]": 1,
						"Creditcard[card_num]":cardnumber,
						"Creditcard[scenario]":"--",
						"Billing":"",
						"stripe" : stptoken!.tokenId
					]
					
                    println(paramters)
                    
                    //set the global token
                    stripetoken = stptoken!.tokenId
                    
                    if(!self.isFromFinalRelease && !self.isFromWithdraw){
                        
                        MediumProgressViewManager.sharedInstance.showProgressOnView(self)
                        self.view.userInteractionEnabled = false
                        
                        NetworkUI.sharedInstance.acceptTutor(paramters as! [String : AnyObject], success: { (response) -> Void in
                            
                            MediumProgressViewManager.sharedInstance.hideProgressView(self)
                            self.view.userInteractionEnabled = true

                            let JSON = response as! NSDictionary
                            
                            if((JSON["error"]) != nil){
                                TAOverlay.showOverlayWithLabel("Your card was declined, Please add another one", options: TAOverlayOptions.OverlaySizeRoundedRect|TAOverlayOptions.OverlayTypeError|TAOverlayOptions.AutoHide)
                            }
                            else{
                                
                                TAOverlay.showOverlayWithLabel("Payment Success", options: TAOverlayOptions.OverlaySizeRoundedRect|TAOverlayOptions.OverlayTypeSuccess|TAOverlayOptions.AutoHide)
                                
                                if(!self.isFromQuestion){
                                    if(!self.isFromFinalRelease){
                                        if(!self.isFromWithdraw){
                                            self.navigationController?.popToRootViewControllerAnimated(true)
                                        }else{
                                            self.paymentaddview.goWithdrawRelease()
                                        }
                                    }else{
                                        self.paymentaddview.goFinalRelease()
                                    }
                                }else{
                                    self.paymentaddview.gobacktodetail()
                                }
                            }
                            // Clear tokens.
                            stripetoken = ""
                            }) { (error) -> Void in
                                MediumProgressViewManager.sharedInstance.hideProgressView(self)
                                self.view.userInteractionEnabled = true
                                TAOverlay.showOverlayWithLabel("We can not verify your payment", options: TAOverlayOptions.OverlaySizeRoundedRect|TAOverlayOptions.OverlayTypeError|TAOverlayOptions.AutoHide)
                                stripetoken = ""
                                
                        }

                    }
                    if (self.isFromFinalRelease)
                    {
                        self.paymentaddview.goFinalRelease()
                    }
                    else if (self.isFromWithdraw)
                    {
                        self.paymentaddview.goWithdrawRelease()
                    }
					
                }
            })
        }
        else {
            TAOverlay.showOverlayWithLabel("Please enter valid credit card details", options: TAOverlayOptions.OverlaySizeRoundedRect|TAOverlayOptions.OverlayTypeWarning|TAOverlayOptions.AutoHide)
            

        }
    }
    
    
    
    
    
}
