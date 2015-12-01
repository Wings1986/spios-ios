//
//  PaymentPayViewController.swift
//  spios
//
//  Created by user on 6/27/15.
//  Copyright (c) 2015 Studypool. All rights reserved.
//

import UIKit
import Analytics

class PaymentPayViewController: UIViewController , PayPalPaymentDelegate, PayPalFuturePaymentDelegate{

    @IBOutlet weak var paymentview: PaymentPayView!
    
    var isFromQuestion = false
    var isFromFinalRelease = false
    var isFromWithdraw = false
    
    var paymentprice : Float!
    var finalparameters : [String : AnyObject]!
    
    var payPalConfig = PayPalConfiguration() // default

	
    override func viewDidLoad() {
        super.viewDidLoad()
        
        paymentview.controller = self
        
//         SEGAnalytics.sharedAnalytics().screen("Payment", properties: [:])
        
        // Do any additional setup after loading the view.
        payPalConfig.acceptCreditCards = true;
        payPalConfig.merchantName = "Studypool, Inc."
        payPalConfig.merchantPrivacyPolicyURL = NSURL(string: "https://www.paypal.com/webapps/mpp/ua/privacy-full")
        payPalConfig.merchantUserAgreementURL = NSURL(string: "https://www.paypal.com/webapps/mpp/ua/useragreement-full")
        
        // Update balance first
        self.updateBalance()
        
        
        currentprice = paymentprice
        
        

    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
//        self.setNavigationBarItem()
        PayPalMobile.initializeWithClientIdsForEnvironments([PayPalEnvironmentProduction:"AfbaCBABFP_vD5LGej9Gj_EE6JZQZgfvsql5ZdgQ6Iy6z1Zt_ZxCV-RPgaS7"])
        PayPalMobile.preconnectWithEnvironment(PayPalEnvironmentProduction)

    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        self.navigationController?.view.userInteractionEnabled = true
        self.view.userInteractionEnabled = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func updateBalance() {
        
        let params = ["token":token]
        NetworkUI.sharedInstance.getBalance(params, success: { (response) -> Void in
            if let result = response as? NSMutableDictionary {
                println(result)
                self.paymentview.updateLabels(result)
            }
            }) { (error) -> Void in
                TAOverlay.showOverlayWithLabel("Please try again", options: TAOverlayOptions.OverlaySizeRoundedRect|TAOverlayOptions.OverlayTypeWarning|TAOverlayOptions.AutoHide)
        }

    }
    
    @IBAction func onPaypal(sender:UIButton){
        self.view.userInteractionEnabled = false
        self.navigationController?.view.userInteractionEnabled = false
        
        var item4 = PayPalItem(name: "Studypool Payment", withQuantity: 1, withPrice: NSDecimalNumber(string: "8.85"), withCurrency: "USD", withSku: "sp001")
        
        
        let items = [item4]//, item2, item3]
        let subtotal = PayPalItem.totalPriceForItems(items)
        
        // Optional: include payment details
        let shipping = NSDecimalNumber(string: "0.02")
        let tax = NSDecimalNumber(string: "0.01")
        let paymentDetails = PayPalPaymentDetails(subtotal: subtotal, withShipping: shipping, withTax: tax)
        
        let total = subtotal.decimalNumberByAdding(shipping).decimalNumberByAdding(tax)
        
        let payment = PayPalPayment(amount: total, currencyCode: "USD", shortDescription: "Studypool payment", intent: .Sale)
        
        payment.items = items
        payment.paymentDetails = paymentDetails
        
        if (payment.processable) {
            
            let futurePaymentViewController = PayPalFuturePaymentViewController(configuration: self.payPalConfig, delegate: self)
            self.presentViewController(futurePaymentViewController, animated: true, completion: nil)
            
        }
        else {
            // This particular payment will always be processable. If, for
            // example, the amount was negative or the shortDescription was
            // empty, this payment wouldn't be processable, and you'd want
            // to handle that here.
            TAOverlay.showOverlayWithLabel("Your payment was not processable.", options: TAOverlayOptions.OverlaySizeRoundedRect|TAOverlayOptions.OverlayTypeError|TAOverlayOptions.AutoHide)
            println("Payment not processable: \(payment)")
        }
    }
    
    // PayPalPaymentDelegate
    
    func payPalPaymentDidCancel(paymentViewController: PayPalPaymentViewController!) {
        println("PayPal Payment Cancelled")
        //        resultText = ""
        //        successView.hidden = true
        paymentViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func payPalPaymentViewController(paymentViewController: PayPalPaymentViewController!, didCompletePayment completedPayment: PayPalPayment!) {
        println("PayPal Payment Success !")
        paymentViewController?.dismissViewControllerAnimated(true, completion: { () -> Void in
            // send completed confirmaion to your server
            println("Here is your proof of payment:\n\n\(completedPayment.confirmation)\n\nSend this to your server for confirmation and fulfillment.")
            
            //            self.resultText = completedPayment!.description
            //            self.showSuccess()
            let futurePaymentViewController = PayPalFuturePaymentViewController(configuration: self.payPalConfig, delegate: self)
            self.presentViewController(futurePaymentViewController, animated: true, completion: nil)
        })
    }
    
    
    func payPalFuturePaymentDidCancel(futurePaymentViewController: PayPalFuturePaymentViewController!)
    {
        self.view.userInteractionEnabled = true
        self.navigationController?.view.userInteractionEnabled = true
        println("PayPal Future Payment Authorizaiton Canceled")
        //        successView.hidden = true
        futurePaymentViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func payPalFuturePaymentViewController(futurePaymentViewController: PayPalFuturePaymentViewController!, didAuthorizeFuturePayment futurePaymentAuthorization: [NSObject : AnyObject]!)
    {
        println("PayPal Future Payment Authorization Success!")
        // send authorizaiton to your server to get refresh token.
        futurePaymentViewController?.dismissViewControllerAnimated(true, completion: { () -> Void in
            var error: NSError?
	
            paypaltoken = futurePaymentAuthorization.description

			//if we are coming from confirm Tutor
              
            let parameters = [
                "token": token,
                "answer_id": answerid,
                "Mile[type_id]": 2,
                "Creditcard[card_num]": cardnumber,
                "Billing": "",
                "paypal_raw": paypaltoken
            ]
            
            MediumProgressViewManager.sharedInstance.showProgressOnView(self)
            if (self.isFromFinalRelease == true) {
                // Use final release variables
                self.finalparameters["Pay[pay_type]"] = "2"
                println (self.finalparameters)
                
                if paypaltoken != "" {
                    self.finalparameters["paypal_raw"] = paypaltoken
                }
                if stripetoken != "" {
                    self.finalparameters["stripe"] = stripetoken
                }
                self.view.userInteractionEnabled = false
                self.navigationController?.view.userInteractionEnabled = false
                NetworkUI.sharedInstance.releaseFinalPayment(self.finalparameters as [String : AnyObject], success: { (response) -> Void in
                    
                    MediumProgressViewManager.sharedInstance.hideProgressView(self)
                    
                    let JSON = response as! NSDictionary
                    if((JSON["error"]) != nil){
                        TAOverlay.showOverlayWithLabel("Your card was declined, Please add another one", options: TAOverlayOptions.OverlaySizeRoundedRect|TAOverlayOptions.OverlayTypeError|TAOverlayOptions.AutoHide)
                        self.view.userInteractionEnabled = true
                        self.navigationController?.view.userInteractionEnabled = true
                        
                    }else{
                        TAOverlay.showOverlayWithLabel("Payment Successful", options: TAOverlayOptions.OverlaySizeRoundedRect|TAOverlayOptions.OverlayTypeSuccess|TAOverlayOptions.AutoHide)
                        
                        if(!self.isFromQuestion){
                            if(!self.isFromFinalRelease){
                                if(!self.isFromWithdraw){
                                    self.navigationController?.popToRootViewControllerAnimated(true)
                                }else{
                                    self.paymentview.goWithdrawRelease()
                                }
                            }else{
                                self.paymentview.goFinalRelease()
                            }
                        }else{
                            self.paymentview.gobacktodetail()
                        }
                    }
                    // Clear tokens.
                    paypaltoken = ""
                    
                    
                    }) { (error) -> Void in
                        MediumProgressViewManager.sharedInstance.hideProgressView(self)
                        self.view.userInteractionEnabled = true
                        self.navigationController?.view.userInteractionEnabled = true
                        
                        TAOverlay.showOverlayWithLabel("We can not verify your payment", options: TAOverlayOptions.OverlaySizeRoundedRect|TAOverlayOptions.OverlayTypeError|TAOverlayOptions.AutoHide)
                        // Clear tokens.
                        paypaltoken = ""
                        
                }
            } else {
                
                NetworkUI.sharedInstance.acceptTutor(parameters as! [String : AnyObject], success: { (response) -> Void in
                    
                    MediumProgressViewManager.sharedInstance.hideProgressView(self)
                    self.view.userInteractionEnabled = false
                    self.navigationController?.view.userInteractionEnabled = false
                    let JSON = response as! NSDictionary
                    if((JSON["error"]) != nil){
                        TAOverlay.showOverlayWithLabel("Your card was declined, Please add another one", options: TAOverlayOptions.OverlaySizeRoundedRect|TAOverlayOptions.OverlayTypeError|TAOverlayOptions.AutoHide)
                            self.view.userInteractionEnabled = true
                            self.navigationController?.view.userInteractionEnabled = true
                        
                    }else{
                        TAOverlay.showOverlayWithLabel("Payment Successful", options: TAOverlayOptions.OverlaySizeRoundedRect|TAOverlayOptions.OverlayTypeSuccess|TAOverlayOptions.AutoHide)
                        if(!self.isFromQuestion){
                            if(!self.isFromFinalRelease){
                                if(!self.isFromWithdraw){
                                    self.navigationController?.popToRootViewControllerAnimated(true)
                                }else{
                                    self.paymentview.goWithdrawRelease()
                                }
                            }else{
                                self.paymentview.goFinalRelease()
                            }
                        }else{
                            self.paymentview.gobacktodetail()
                        }
                    }
                    // Clear tokens.
                    paypaltoken = ""
                    
                    
                    }) { (error) -> Void in
                        MediumProgressViewManager.sharedInstance.hideProgressView(self)
                        self.view.userInteractionEnabled = true
                        self.navigationController?.view.userInteractionEnabled = true
                        
                        TAOverlay.showOverlayWithLabel("We can not verify your payment", options: TAOverlayOptions.OverlaySizeRoundedRect|TAOverlayOptions.OverlayTypeError|TAOverlayOptions.AutoHide)
                        // Clear tokens.
                        paypaltoken = ""
                        
                }
            }

          
                  })
    }
    
    
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "addcard") {
            let addPayment : PaymentAddViewController = segue.destinationViewController as! PaymentAddViewController
            addPayment.isFromFinalRelease = isFromFinalRelease
            addPayment.isFromQuestion = isFromQuestion
            addPayment.isFromWithdraw = isFromWithdraw
        }
    }

}
