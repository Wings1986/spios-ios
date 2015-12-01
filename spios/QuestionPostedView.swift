//
//  QuestionPostedView.swift
//  spios
//
//  Created by MobileGenius on 10/6/15.
//  Copyright (c) 2015 Studypool. All rights reserved.
//

import UIKit

class QuestionPostedView: UIView {

    @IBOutlet weak var actInd: UIActivityIndicatorView!
    @IBOutlet weak var yConstraint: NSLayoutConstraint!
    @IBOutlet weak var rocketView: UIImageView!
    @IBOutlet weak var btnExpand: UIButton!
    
    var controller: QuestionPostedViewController!
    
    func viewdidload(){
        self.layoutIfNeeded()
        
        self.yConstraint.constant = self.bounds.height / 2 + 200
        
        //animation first param its the duration in seconds.
        UIView.animateWithDuration(2.5, delay: 0, options: .CurveEaseOut, animations: {//1.4 previous value
            
            //update the constraints
            self.layoutIfNeeded()
            
            }, completion: { finished in
                
                self.controller.navigationController?.navigationBarHidden = false
                
                //now we need to segue directly to question_detail
                
                var qdSB:UIStoryboard = UIStoryboard(name: "Question_detail", bundle: nil)
                
                let applicationDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                
                //setup question detail vc with the question information
                if let questionDetailController = qdSB.instantiateViewControllerWithIdentifier("QuestionDetailViewController") as? QuestionDetailViewController {
                    
                    questionDetailController.questionId = self.controller.questionModel!.question_id.toInt()
                    questionDetailController.questionModel = self.controller.questionModel
                    questionDetailController.studentName = applicationDelegate.userlogin.username
                    questionDetailController.studentImageUrl = self.controller.questionModel!.avatar
                    
                    // Check urgent or private
                    if (self.controller.questionModel!.isUrgent == 0) {
                        qUrgent = false
                    } else if (self.controller.questionModel!.isUrgent == 1) {
                        qUrgent = true
                    }
                    
                    if (self.controller.questionModel!.isPrivate == 0) {
                        qPrivate = false
                    } else if (self.controller.questionModel!.isPrivate == 1) {
                        qPrivate = true
                    }
                    
                    /*
                    let nav = self.navigationController
                    self.navigationController?.popToRootViewControllerAnimated(false)
                    nav?.pushViewController(questionDetailController, animated: false)
                    */
                    
                    let vcArray = self.controller.navigationController?.viewControllers
                    var newVcArray = NSMutableArray()
                    newVcArray.addObject(vcArray![0])
                    newVcArray.addObject(questionDetailController)
                    self.controller.navigationController?.setViewControllers(newVcArray as [AnyObject], animated: true)
                    //self.navigationController?.popToRootViewControllerAnimated(false)
                    self.controller.navigationController?.popViewControllerAnimated(true)
                }
                
        })
        
        actInd.hidesWhenStopped = true
        actInd.startAnimating()
    }

}
