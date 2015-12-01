//
//  PaymentPayView.swift
//  spios
//
//  Created by MobileGenius on 9/30/15.
//  Copyright (c) 2015 Studypool. All rights reserved.
//

import UIKit

class PaymentPayView: UIView {
    
    @IBOutlet weak var lbPrice: UILabel!
    @IBOutlet weak var lbBalence: UILabel!
    @IBOutlet weak var lbRemain: UILabel!
    
    var controller: PaymentPayViewController!

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    func updateLabels(result:NSMutableDictionary){
        
        balance = result["balance"] as! String
        self.lbBalence.text = String(format: "$ %@", balance)
        self.lbPrice.text = String(format: "$ %.2f", controller.paymentprice)
        self.lbRemain.text = String(format: "$ %.2f", controller.paymentprice - (balance as NSString).floatValue)
        remainingAmt = String(format: "$ %.2f", controller.paymentprice - (balance as NSString).floatValue)
        
    }
    
    func goWithdrawRelease(){
        
        var arraycontrollers = controller.navigationController!.viewControllers
        
        if(arraycontrollers[arraycontrollers.count-2].isKindOfClass(WithdrawPendingViewcontroller)){
            
            let withdraw = arraycontrollers[arraycontrollers.count-2] as! WithdrawPendingViewcontroller
            withdraw.actpayment("2",finalprice: currentprice)
            
        }
        
    }
    
    
    func goFinalRelease(){
        
        var arraycontrollers = controller.navigationController!.viewControllers
        
        if(arraycontrollers[arraycontrollers.count-2].isKindOfClass(AcceptQuestionViewController)){
            
            let accept = arraycontrollers[arraycontrollers.count-2] as! AcceptQuestionViewController
            
            accept.actpayment("2",finalprice: currentprice)
            
        }
        
    }
    
    func gobacktodetail(){
        
        var arraycontrollers = controller.navigationController!.viewControllers
        
        if(arraycontrollers[arraycontrollers.count-2].isKindOfClass(FeedViewController)){
            
            let feed = arraycontrollers[arraycontrollers.count-2] as! FeedViewController
            
        }else{
            
            let confirm = arraycontrollers[arraycontrollers.count-2] as! ConfirmTutorViewController
            confirm.performSegueWithIdentifier("animation", sender: confirm)
            
        }
        
    }

}
