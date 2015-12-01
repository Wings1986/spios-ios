//
//  OverlayView.swift
//  spios
//
//  Created by MobileGenius on 6/15/15.
//  Copyright (c) 2015 Studypool. All rights reserved.
//

import UIKit

protocol OverlayviewDelegate{
    func onDismiss()
    func onAnswer()
}

class OverlayView: UIView {

    var parentview : FeedViewController!
    var delegate : OverlayviewDelegate?
    
    class func loadFromNibNamed(nibNamed: String, bundle : NSBundle? = nil) -> UIView? {
        
        let parameters = [
            "token": token,
        ]
        
        
        
        
        return UINib(
            nibName: nibNamed,
            bundle: bundle
            ).instantiateWithOwner(nil, options: nil)[0] as? UIView
    }
    
    @IBAction func onSubscribe(sender:UIButton){
//        delegate?.showpaymentscreen()
        
    }
    
    @IBAction func onDismiss(sender:UIButton){
        delegate?.onDismiss()
    }
    
    @IBAction func onAnswerQuestion(sender:UIButton){
        delegate?.onAnswer()
    }

}
