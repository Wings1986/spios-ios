//
//  PaymentNotificationPopoverView.swift
//  spios
//
//  Created by Nishanth Salinamakki on 6/26/15.
//  Copyright (c) 2015 Studypool. All rights reserved.
//

import UIKit
import Analytics

protocol PaymentNotificationPopoverViewDelegate {
    func onDismiss()
}

class PaymentNotificationPopoverView: UIView {

    var delegate : PaymentNotificationPopoverViewDelegate?
    
    var title:String? = ""
    var timeStamp:Double? = 0
    var userName:String? = ""
    var price:String? = ""
    //FIXME: Fill with actual data
    var payPal:Double?
    var creditCard:Double?
    var balance:Double?
    
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    var originalPoint: CGPoint!

    
    @IBOutlet var subjectQuestionLabel: UILabel!
    @IBOutlet var currentDateLabel: UILabel!
    @IBOutlet var tutorNameLabel: UILabel!
    
    @IBOutlet var firstPaymentLabel: UILabel!
    @IBOutlet var firstPaymentAmount: UILabel!
    @IBOutlet var secondPaymentLabel: UILabel!
    @IBOutlet var secondPaymentAmount: UILabel!
    @IBOutlet var totalAmountLabel: UILabel!
    
    @IBOutlet weak var secondHeightConstraint: NSLayoutConstraint!
    @IBOutlet var totalTopConstraint: NSLayoutConstraint!
    
    class func loadFromNibNamed(nibNamed: String, bundle : NSBundle? = nil) -> UIView? {
        
        
        return UINib(
            nibName: nibNamed,
            bundle: bundle
            ).instantiateWithOwner(nil, options: nil)[0] as? UIView
    }
    
    func dragged(gestureRecognizer: UIPanGestureRecognizer) -> Void {
        var xDistance : CGFloat = gestureRecognizer.translationInView(self).x
        var yDistance: CGFloat! = gestureRecognizer.translationInView(self).y
        println("SWIPE CALLED!")
        
        switch(gestureRecognizer.state) {
        case UIGestureRecognizerState.Began:
            originalPoint = self.center
            break;
        case UIGestureRecognizerState.Changed:
            var rotationStrength: CGFloat = min(xDistance / 320, 1)
            //var rotationStrengthFloat: Float = Float(rotationStrength)
            var rotationAngle: CGFloat = (2 * CGFloat(M_PI)/16 * rotationStrength)
            var scaleStrength: CGFloat = 1 - fabs(rotationStrength) / 4
            var scale: CGFloat = max(scaleStrength, 0.93)
            var transform: CGAffineTransform = CGAffineTransformMakeRotation(rotationAngle)
            var scaleTransform: CGAffineTransform = CGAffineTransformScale(transform, scale, scale)
            transform = scaleTransform
            var center: CGPoint = CGPointMake(originalPoint.x + xDistance, originalPoint.y + yDistance)
            
            self.updateOverlay(xDistance)
            
            break;
        case UIGestureRecognizerState.Possible:
            break;
        case UIGestureRecognizerState.Cancelled:
            break;
        case UIGestureRecognizerState.Failed:
            break;
        default:
            break;
        }
    }
    
    func updateOverlay(distance: CGFloat) {
        if (distance > 0) {
            delegate?.onDismiss()
            println("SWIPE CALLED")
        }
    }
    
    func initValue() {
        subjectQuestionLabel.text = title
        
        var date = NSDate(timeIntervalSince1970: timeStamp!)
        
        currentDateLabel.text = date.stringDate
        
        self.tutorNameLabel.text = String(format: "has been paid to %@", userName!)
        
        fillLabels()
        
        isPaymentPopup = true
        
//        let startIndex = advance(totalAmountLabel.text!.startIndex, 1)
//        var finalCost = totalAmountLabel.text?.substringFromIndex(startIndex)
//        let segmentParams = ["price" as NSObject: finalCost as! AnyObject]
        SEGAnalytics.sharedAnalytics().screen("Payment", properties: [:])
//        SEGAnalytics.sharedAnalytics().track("Paid for Question", properties: segmentParams)
    }
    
    func fillLabels() {
        var strpayPal = ""
        var strCreditCard = ""
        var strBalance = ""
        if let _payPal = payPal {
            strpayPal = String(format: "$%.2f", _payPal)
        }
        if let _creditCard = creditCard {
            strCreditCard = String(format: "$%.2f", _creditCard)
        }
        if let _balance = balance {
            strBalance = String(format: "$%.2f", balance!)
        }

        
        let isPayPalPayed = payPal != nil
        let isCreditCardPayed = creditCard != nil
        if (balance == nil && (isPayPalPayed || isCreditCardPayed)) {
            firstPaymentLabel.text = isPayPalPayed ? "PayPal" :"Credit Card"
            firstPaymentAmount.text = isPayPalPayed ? strpayPal : strCreditCard
//            secondPaymentAmount.hidden = true
//            secondPaymentAmount.frame = CGRect(origin: self.secondPaymentAmount.frame.origin, size: CGSizeZero)
//            secondPaymentLabel.hidden = true
//            secondPaymentLabel.frame = CGRect(origin: self.secondPaymentLabel.frame.origin, size: CGSizeZero)
            secondHeightConstraint.constant = 0
            totalAmountLabel.text = firstPaymentAmount.text
//            totalTopConstraint.constant -= 28
        }
        else if (balance != nil && (isPayPalPayed || isCreditCardPayed)) {
            firstPaymentAmount.text = strBalance
            secondPaymentLabel.text = isPayPalPayed ? "PayPal" :"Credit Card"
            secondPaymentAmount.text = isPayPalPayed ? strpayPal : strCreditCard
            var totalAmountPayed = (isPayPalPayed ? payPal! : creditCard!) + balance!
            
            totalAmountLabel.text = String(format: "$%.2f", totalAmountPayed)
        }
        else if (balance != nil && !isPayPalPayed && isCreditCardPayed) {
            firstPaymentAmount.text = strBalance
//            secondPaymentAmount.hidden = true
//            secondPaymentAmount.frame = CGRect(origin: self.secondPaymentAmount.frame.origin, size: CGSizeZero)
//            secondPaymentLabel.hidden = true
//            secondPaymentLabel.frame = CGRect(origin: self.secondPaymentLabel.frame.origin, size: CGSizeZero)
            secondHeightConstraint.constant = 0
            totalAmountLabel.text = firstPaymentAmount.text
//            totalTopConstraint.constant -= 28
        }
        else {
            firstPaymentAmount.text = strBalance
            secondHeightConstraint.constant = 0
            totalAmountLabel.text = firstPaymentAmount.text
        }
    }
    
    override func didMoveToWindow() {
        
        super.didMoveToWindow()
        if (self.window == nil)
        {
            delegate?.onDismiss()
        }
    }
    @IBAction func onDismiss(sender: UIButton) {
        delegate?.onDismiss()
    }

    @IBAction func okayButtonPressed(sender: UIButton) {
        delegate?.onDismiss()
    }
}
