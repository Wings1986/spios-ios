//
//  DeclineQuestionViewController.swift
//  spios
//
//  Created by Артем Труханов on 29.05.15.
//  Copyright (c) 2015 Studypool. All rights reserved.
//

import UIKit

//Decline Tutor's Answer with Reason
class DeclineQuestionViewController: UIViewController {
    
    
    var questionId:Int!
    
    
    var questionTitle:String = ""
    var questionTimestamp:Double = 0.0
    var tutorName:String = ""
    var tutorImageUrl:String = ""
    var questionModel:QuestionModel!
    
    
    @IBOutlet weak var declineview:DeclineQuestionView!
    
    
    
    //MARK: - View functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        declineview.controller = self
        declineview.viewdidload()
    }
    
	
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
		declineview.viewwillappear()
        
    }
    
    override func viewWillDisappear(animated: Bool)
    {
        
        super.viewWillDisappear(animated)
        declineview.viewwilldisappear()
    }
    

    //MARK: - Actions
    /**
    Calls UIPickerView to show
    */
    @IBAction func showPicker(sender: AnyObject) {
        declineview.hiddenPickerTextField.becomeFirstResponder()
    }
    
    /**
    UIButton action, takes us to segue to FeedVC
    */
    func onClickProfile(sender: AnyObject) {
        
    }
    /**
    Call postDeclineAnswer api with parameters
    After api returns success, it goes withdraw page of QuestionDetailViewController
    */
    
    @IBAction func submitAction(sender: AnyObject) {
        
        if (declineview.enterReasonTextView.text.isEmpty || declineview.enterReasonTextView.text == "Further Explanation") {
            //tell the user to give a reason
            TAOverlay.showOverlayWithLabel("Please enter a reason", options: TAOverlayOptions.OverlaySizeRoundedRect|TAOverlayOptions.OverlayTypeWarning|TAOverlayOptions.AutoHide)
            
            return;
        }
        self.navigationController?.view.userInteractionEnabled = false
        declineview.confirmButton.userInteractionEnabled = false
        self.view.userInteractionEnabled = false
        
        
        declineview.enterReasonTextView.resignFirstResponder()
        
        var title:String = declineview.showReasonPicker.titleForState(.Normal)!
        if title == "Select Reason" {
            return;
        }
        
        let parameters = [
            "token": token,
            "question_id":NSNumber(integer: self.questionId),
            "Review":declineview.enterReasonTextView.text,
            "reason":title,
            "tutor_name":self.tutorName
        ]
        
        
        MediumProgressViewManager.sharedInstance.showProgressOnView(self)
        
        NetworkUI.sharedInstance.postDeclineAnswer(parameters,
            success: { (response) -> Void in
                TAOverlay.showOverlayWithLabel("Posted Successfully", options: TAOverlayOptions.OverlaySizeRoundedRect|TAOverlayOptions.OverlayTypeSuccess|TAOverlayOptions.AutoHide)
                MediumProgressViewManager.sharedInstance.hideProgressView(self)
                
                var qdSB:UIStoryboard = UIStoryboard(name: "Question_detail", bundle: nil)
                
                let applicationDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                
                if let questionDetailController = qdSB.instantiateViewControllerWithIdentifier("QuestionDetailViewController") as? QuestionDetailViewController {
                    
                    
                    questionDetailController.questionId = self.questionModel.question_id.toInt()
                    questionDetailController.questionModel = self.questionModel
                    questionDetailController.studentName = applicationDelegate.userlogin.username
                    questionDetailController.studentImageUrl = self.questionModel.avatar
                    
                    self.questionModel.withdrawed = "1" // Tell to QuestionDetailController, it is withdraw screen!
                    
                    if (self.questionModel.isUrgent == 0)
                    {
                        qUrgent = false
                    }
                    else if (self.questionModel.isUrgent == 1)
                    {
                        qUrgent = true
                        
                    }
                    
                    if (self.questionModel.isPrivate == 0)
                    {
                        qPrivate = false
                    }
                    else if (self.questionModel.isPrivate == 1)
                    {
                        qPrivate = true
                        
                    }
                    
                    if(self.questionModel.accept["status"] as! NSNumber == 1){
                        
                        questionDetailController.answerId = (self.questionModel.accept["answerid"] as! NSString).integerValue
                        
                    }
                    
                    let vcArray = self.navigationController?.viewControllers
                    var newVcArray = NSMutableArray()
                    newVcArray.addObject(vcArray![0])
                    newVcArray.addObject(questionDetailController)
                    self.navigationController?.setViewControllers(newVcArray as [AnyObject], animated: true)
                }
                
                
                //navigation to withdraw view controller
                
                
                
            }) { (error) -> Void in
                // Enable buttons
                self.navigationController?.view.userInteractionEnabled = true
                self.declineview.confirmButton.userInteractionEnabled = true
                self.view.userInteractionEnabled = true
                
                MediumProgressViewManager.sharedInstance.hideProgressView(self)
                TAOverlay.showOverlayWithLabel("Please try again", options: TAOverlayOptions.OverlaySizeRoundedRect|TAOverlayOptions.OverlayTypeWarning|TAOverlayOptions.AutoHide)
                println(error)
                
                
        }
        
    }
}
