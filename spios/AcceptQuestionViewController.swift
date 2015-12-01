//
//  AcceptQuestionViewController.swift
//  spios
//
//  Created by Артем Труханов on 29.05.15.
//  Copyright (c) 2015 Studypool. All rights reserved.
//

import UIKit
import Haneke

protocol AcceptQuestionViewControllerDelegate {
    func onPaymentRelease(tutorName:String)
}

//Accept Tutor's answer, Release final payment and leave the Rating/Review

class AcceptQuestionViewController: UIViewController, PaymentNotificationPopoverViewDelegate {
    
    
    
    
    var delegate : AcceptQuestionViewControllerDelegate?
    
    
    var answerId:Int!
    
    var questionTitle:String = ""
    var questionTimestamp:Double = 0.0
    var tutorName:String = ""
    var tutorImageUrl:String = ""
    var questionModel:QuestionModel!
    var finalparameters: [String : AnyObject]!
    var questionCountdownTimer: NSTimer!
    
    @IBOutlet weak var acceptview:AcceptQuestionView!
    
    
    
    // MARK: - View Setup
    
    override func viewDidLoad() {
        super.viewDidLoad()
        acceptview.controller = self
        acceptview.viewdidload()
        
    }
        
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        acceptview.viewwillappear()
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        
        super.viewWillDisappear(animated)
        
        acceptview.viewwilldisappear()
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        
        acceptview.viewdiddisappear()
    }
    
    // MARK: - Actions
    
    func onClickProfile(sender: AnyObject) {
        
    }
    
    @IBAction func submitAction(sender: AnyObject) {
        
        if (self.acceptview.enterReasonTextView.text.isEmpty || self.acceptview.enterReasonTextView.text == "Leave a comment...") {
            TAOverlay.showOverlayWithLabel("Please enter a review", options: TAOverlayOptions.OverlaySizeRoundedRect|TAOverlayOptions.OverlayTypeWarning|TAOverlayOptions.AutoHide)
            return;
        }
        
        // Disable buttons
        self.navigationController?.view.userInteractionEnabled = false
        self.acceptview.confirmButton.userInteractionEnabled = false
        
        
        acceptview.enterReasonTextView.resignFirstResponder()
        
        MediumProgressViewManager.sharedInstance.showProgressOnView(self)
        
        
        var finalValue:Float = 0.00
        
        if (qUrgent == true && (self.questionModel.chargeForUrgent == 1))
        {
            finalValue += 2.85
        }
        
        if (qPrivate == true)
        {
            finalValue += 2.85
        }
        
        let checkparamters = [
            "token": token,
            "price": ((self.questionModel.price as NSString).floatValue).description
        ]
        
        if (finalValue == 0) {
            // Do not have to pay -- segue to the end if there's no addons
            self.actpayment("1", finalprice: finalValue)
            return
        }
        // Check payment method from webapi
        // 1 means stripe token, 2 means paypal token
        // if user has payment method, it goes to actpayment function, otherwise go to payment page
        NetworkUI.sharedInstance.checkPaymentToken(checkparamters, success: { (response) -> Void in
            
            MediumProgressViewManager.sharedInstance.hideProgressView(self)
            
            let JSON = response as! NSDictionary
            
            
            let returntype = JSON["type"] as! Int
            
            if(returntype == 1){
                
                self.actpayment("1", finalprice: finalValue)
                
            }else if(returntype == 2){
                self.actpayment("2", finalprice: finalValue)
                
            }else{
                if(stripetoken != ""){
                    
                    self.actpayment("1", finalprice: finalValue)
                    
                }else if(paypaltoken != ""){
                    
                    self.actpayment("2", finalprice: finalValue)
                    
                }else{
                    
                    TAOverlay.showOverlayWithLabel("Please add your payment method", options: TAOverlayOptions.OverlaySizeRoundedRect|TAOverlayOptions.OverlayTypeInfo|TAOverlayOptions.AutoHide)
                    self.finalparameters = [
                        
                        "token": token,
                        "answer_id":NSNumber(integer: self.answerId),
                        "Pay[Money]":finalValue.description,
                        "review_special":"18",
                        "Transaction[0][money]":((self.questionModel.price as NSString).floatValue).description,
                        "tip":(self.questionModel.price as NSString).floatValue / 5.0,
                        "Pay[pay_type]":String(0),
                        "Creditcard[card_num]":"",
                        "Billing":"",
                        "stripe" : stripetoken,
                        "paypal" : paypaltoken
                        
                    ]
                    self.gotopayment(finalValue)
                }
            }
            
            
            }) { (error) -> Void in
                // Enable buttons
                self.navigationController?.view.userInteractionEnabled = true
                self.acceptview.confirmButton.userInteractionEnabled = true
                
                MediumProgressViewManager.sharedInstance.hideProgressView(self)
                TAOverlay.showOverlayWithLabel("Please try again", options: TAOverlayOptions.OverlaySizeRoundedRect|TAOverlayOptions.OverlayTypeWarning|TAOverlayOptions.AutoHide)
        }
        
    }
    
    /**
    final payment api
    call releaseFinalPayment api with final parameters.
    after api returns success, it goes to AcceptedQuestion page of QuestionDetailViewController and shows PaymentNotificationPopoverView with final payment information
    */
    func actpayment(type: String, finalprice:Float){
        
        let parameters = [
            "token": token,
            "answer_id":NSNumber(integer: self.answerId),
            "rating":NSNumber(integer: acceptview.starsRatingCount),
            "review": acceptview.enterReasonTextView.text
        ]
        
        
        self.finalparameters = [
            
            "token": token,
            "answer_id":NSNumber(integer: self.answerId),
            "Pay[Money]":finalprice.description,
            "review_special":"18",
            "Transaction[0][money]":((self.questionModel.price as NSString).floatValue).description,
            // MARK : 'tip' will NOT be used. Variable is kept for legacy
            "tip":(self.questionModel.price as NSString).floatValue / 5.0,
            "Pay[pay_type]":String(type),
            "Creditcard[card_num]":"",
            "Billing":"",
            "stripe" : stripetoken,
            "paypal" : paypaltoken
            
        ]
        
        MediumProgressViewManager.sharedInstance.showProgressOnView(self)
        
        NetworkUI.sharedInstance.releaseFinalPayment(self.finalparameters, success: { (response) -> Void in
            
            NetworkUI.sharedInstance.postAcceptAnswer(parameters, success: { (response) -> Void in
                
                MediumProgressViewManager.sharedInstance.hideProgressView(self)
                
                TAOverlay.showOverlayWithLabel("Success", options: TAOverlayOptions.OverlaySizeRoundedRect|TAOverlayOptions.OverlayTypeSuccess|TAOverlayOptions.AutoHide)
                
                var qdSB:UIStoryboard = UIStoryboard(name: "Question_detail", bundle: nil)
                
                let applicationDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                
                if let questionDetailController = qdSB.instantiateViewControllerWithIdentifier("QuestionDetailViewController") as? QuestionDetailViewController {
                    /// Set up variables for QuestionDetailViewController
                    questionDetailController.questionId = self.questionModel.question_id.toInt()
                    questionDetailController.questionModel = self.questionModel
                    questionDetailController.studentName = applicationDelegate.userlogin.username
                    questionDetailController.studentImageUrl = self.questionModel.avatar
                    questionDetailController.bFinalPayment = true// show payment receipt popupview at QuestionDetailViewController
                    questionDetailController.tutorName = self.tutorName
                    reviewRating = self.acceptview.starsRatingCount
                    self.questionModel.withdrawed = "0"
                    self.questionModel.paid = "1"
                    
                    // Check urgent
                    if (self.questionModel.isUrgent == 0) {
                        qUrgent = false
                    } else if (self.questionModel.isUrgent == 1) {
                        qUrgent = true
                    }
                    
                    // Check private
                    if (self.questionModel.isPrivate == 0) {
                        qPrivate = false
                    } else if (self.questionModel.isPrivate == 1) {
                        qPrivate = true
                    }
                    
                    if (self.questionModel.accept["status"] as! NSNumber == 1){
                        questionDetailController.answerId = (self.questionModel.accept["answerid"] as! NSString).integerValue
                    }
                    
                    if let vcArray = self.navigationController?.viewControllers {
                        var newVcArray = NSMutableArray()
                        newVcArray.addObject(vcArray[0])
                        newVcArray.addObject(questionDetailController)
                        self.navigationController?.setViewControllers(newVcArray as [AnyObject], animated: true)
                    }
                    // Enable buttons
                    self.navigationController?.view.userInteractionEnabled = true
                    self.acceptview.confirmButton.userInteractionEnabled = true
                    
                }
                }, failure: { (error) -> Void in
                    println(error)
                    // Enable buttons
                    self.navigationController?.view.userInteractionEnabled = true
                    self.acceptview.confirmButton.userInteractionEnabled = true
                    
                    MediumProgressViewManager.sharedInstance.hideProgressView(self)
                    TAOverlay.showOverlayWithLabel("Please try again", options: TAOverlayOptions.OverlaySizeRoundedRect|TAOverlayOptions.OverlayTypeWarning|TAOverlayOptions.AutoHide)
                    
            })
            }, failure: { (error) -> Void in
                println(error)
                // Enable buttons
                self.navigationController?.view.userInteractionEnabled = true
                self.acceptview.confirmButton.userInteractionEnabled = true
                MediumProgressViewManager.sharedInstance.hideProgressView(self)
                TAOverlay.showOverlayWithLabel("Please try again", options: TAOverlayOptions.OverlaySizeRoundedRect|TAOverlayOptions.OverlayTypeWarning|TAOverlayOptions.AutoHide)
                
        })
    }
    
    
    func openPopoverView(tutorName:String) {
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        let popView = PaymentNotificationPopoverView.loadFromNibNamed("PaymentNotificationPopoverView", bundle: nil) as! PaymentNotificationPopoverView
        
        popView.delegate = self
        popView.title = questionModel.title
        popView.timeStamp = Double(questionModel.create_time)
        popView.userName = tutorName
        popView.price = questionModel.price
        
        //TODO: Fill with actual data
        popView.creditCard = NSString(string: questionModel.creditCardWithdrawal!).doubleValue
        popView.balance = NSString(string: questionModel.balanceWithdrawal!).doubleValue
        popView.payPal = NSString(string: questionModel.paypalWithdrawal!).doubleValue
        
        popView.initValue()
        popView.frame = CGRectMake(0, 0, screenSize.width - 70, 430)
        
        self.lew_presentPopupView(popView, animation: LewPopupViewAnimationDrop.alloc())
    }
    
    /**
    Go to Payment page if user has no payment method
    */
    func gotopayment(price: Float){
        
        var paymentStoryboard = UIStoryboard(name: "Payment", bundle: nil)
        let paymentPayViewController = paymentStoryboard.instantiateViewControllerWithIdentifier("PaymentPayViewController") as! PaymentPayViewController
        paymentPayViewController.paymentprice = price
        paymentPayViewController.isFromFinalRelease = true
        answerid = questionModel.accept["answerid"] as! String
        println (self.finalparameters)
        
        paymentPayViewController.finalparameters = self.finalparameters
        self.navigationController?.pushViewController(paymentPayViewController, animated: true)
        
        // Enable buttons
        self.navigationController?.view.userInteractionEnabled = true
        acceptview.confirmButton.userInteractionEnabled = true
    }
    
    
    
    func onDismiss(){
        self.lew_dismissPopupViewWithanimation(LewPopupViewAnimationDrop.alloc())
    }
}
