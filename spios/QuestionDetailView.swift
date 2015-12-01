//
//  QuestionDetailView.swift
//  spios
//
//  Created by MobileGenius on 10/12/15.
//  Copyright (c) 2015 Studypool. All rights reserved.
//

import UIKit
import MessageUI

class QuestionDetailView: UIView, UITableViewDataSource,UITableViewDelegate, UIGestureRecognizerDelegate, QuestionBidFooterControllerDelegate, QuestionDetailAnsweredFooterControllerDelegate, TutorAnswerFooterControllerDelegate, BHInputbarDelegate, MFMailComposeViewControllerDelegate, PaymentNotificationPopoverViewDelegate,AnsweredQuestionPopoverViewDelegate {

    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var lbSubTitle: UILabel!
    @IBOutlet weak var lbWithdrawn: UILabel!
    @IBOutlet weak var mTableView: UITableView!
    @IBOutlet weak var mTitleView: UIView!
    @IBOutlet weak var mHowtoworks: UIView!
    @IBOutlet weak var mCompletedFooter: UIView!
    @IBOutlet weak var btnHowtoWorks: UIButton!
    @IBOutlet weak var tutorsAreViewing: UIView!
    @IBOutlet weak var btnCancel: UIButton!
    
    @IBOutlet weak var contraintTopTitle: NSLayoutConstraint!
    @IBOutlet weak var contraintTableBottom: NSLayoutConstraint!
    @IBOutlet weak var contraintTableTop: NSLayoutConstraint!
    @IBOutlet weak var contraintFooterBottom: NSLayoutConstraint!
    @IBOutlet weak var contraintCompletedFooterBottom: NSLayoutConstraint!
    
    @IBOutlet weak var discussBar: BHInputbar!
    @IBOutlet weak var discussBarHeight: NSLayoutConstraint!
    @IBOutlet weak var completedBarHeight: NSLayoutConstraint!
    @IBOutlet weak var completeddiscussBar: BHInputbar!
    
    @IBOutlet weak var titleView : UIView!
    @IBOutlet weak var withdrawnView : UIView!
    @IBOutlet weak var acceptTutorView : UIView!
    
    @IBOutlet weak var withdrawFooter : UIView!
    @IBOutlet weak var bidBackgroundView: UIView!
    
    /// footer for answered question
    var mFooterAnsweredController: QuestionDetailAnsweredFooterController!
    var mFooterTutorAnswerController: TutorAnswerFooterController!
    
    /// footer for bid list
    var mFooterBidController: QuestionBidFooterController!
    
    /// hiddden textview to calculate height of cell content
    var mTextView:UITextView?
    
    var questionattr : NSAttributedString!

    
    var controller:QuestionDetailViewController!
    
    var showFooter = false
    
    
    
    //// show spinner
    var showedBidSpinner = false
    
    
    
    // All customer service username
    let customerServiceNames = ["Studypool"]
    
    
    
    var questionCountdownTimer: NSTimer!
    
    var keyboardsize : CGRect!
    
    var temptablebottom: CGFloat!
    var tempfooterbottom: CGFloat!
    var tempfooterrect : CGRect!
    
    var startLocation : CGPoint!
    
    
    var picker: MFMailComposeViewController!
    
    
    
    
    
    
    var keyboardIsVisible :Bool = false
    
    
    // MARK: - View Functions
    func viewdidload(){
        
        mTextView = UITextView(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.width-18, 30))
        
        //mIsTutor = true;
        //token = "ba62ae1b93141487429027a5edccf8f9"
        //setup gesture recognizer
        qdEntered = true
        
        if( qdEntered == true){
            let alert = UIAlertView(title: "QD WAS ENTERED == true", message: "YAAAS", delegate: nil, cancelButtonTitle: "OK")
            //			alert.show()
        }
        if questionIDFromNotifications != nil {
            if questionIDFromNotifications == controller.questionModel.question_id {
                println(responseFromQuestion)
                
            }
        }
        counter = 0
        
        lbTitle.text = ""
        
        
        
        
        
        
        // Draw line between the views of 'bid' and 'tutors are viewing your questions'
        
        self.bidBackgroundView.layer.shadowOpacity = 0.4
        self.bidBackgroundView.layer.shadowColor = UIColor.blackColor().CGColor
        self.bidBackgroundView.layer.shadowOffset = CGSizeMake(0.0,5.0)
        self.bidBackgroundView.layer.masksToBounds = false
        self.bidBackgroundView.layer.shadowRadius = 2.5
        
        
        discussBar?.inputDelegate = self; // making this class delegate to know what actions are happening with toolbar
        discussBar?.textView.placeholder = "reply to tutor";
        discussBar?.textView.layer.cornerRadius = 5
        discussBar?.textView.maximumNumberOfLines = 5 // limits the size of input view
        
        
        discussBar?.layer.shadowOpacity = 0.3
        discussBar?.layer.cornerRadius = 3
        discussBar?.layer.shadowColor = UIColor.blackColor().CGColor
        discussBar?.layer.shadowOffset = CGSizeMake(0.0,2.0)
        discussBar?.layer.masksToBounds = false
        discussBar?.layer.shadowRadius = 1.5
        
        
        completeddiscussBar?.inputDelegate = self; // making this class delegate to know what actions are happening with toolbar
        completeddiscussBar?.textView.placeholder = "reply to tutor";
        completeddiscussBar?.textView.layer.cornerRadius = 5
        completeddiscussBar?.textView.maximumNumberOfLines = 5 // limits the size of input view
        
        
        completeddiscussBar?.layer.shadowOpacity = 0.3
        completeddiscussBar?.layer.cornerRadius = 3
        completeddiscussBar?.layer.shadowColor = UIColor.blackColor().CGColor
        completeddiscussBar?.layer.shadowOffset = CGSizeMake(0.0,2.0)
        completeddiscussBar?.layer.masksToBounds = false
        completeddiscussBar?.layer.shadowRadius = 1.5
        
        
        tutorsAreViewing.layer.shadowOpacity = 0.4
        tutorsAreViewing.layer.shadowColor = UIColor.blackColor().CGColor
        tutorsAreViewing.layer.shadowOffset = CGSizeMake(0.0,1.0)
        tutorsAreViewing.layer.masksToBounds = false
        tutorsAreViewing.layer.shadowRadius = 1.0
        
        //        discussBar.resizeTextView()
        //        completeddiscussBar.resizeTextView()
        
        
        
        addDoneButtonToKeyboard(discussBar.textView)
        addDoneButtonToKeyboard(completeddiscussBar.textView)
        
        self.bringSubviewToFront(mTitleView)
        
        
        //changes appearance if a tutor has no answers
        if controller.mIsTutor == true && controller.answerId == nil {
            mTableView.backgroundColor = UIColor(red: 240/255.0, green: 240/255.0, blue: 240/255.0, alpha: 1.0)
        }
        
        
        
        var swipe:UISwipeGestureRecognizer = UISwipeGestureRecognizer(target:self, action:"dismissKeyboard")
        
        swipe.direction = UISwipeGestureRecognizerDirection.Down
        
        self.addGestureRecognizer(swipe)
        
        self.bringSubviewToFront(bidBackgroundView)
        
        self.keyboardTriggerOffset = 57
        
        
        self.addKeyboardPanningWithFrameBasedActionHandler({ (keyboardFrameInView, opening, closing) -> Void in
            
            if(self.keyboardIsVisible == true){
                
                var different = keyboardFrameInView.origin.y - (self.frame.height - self.keyboardsize.height)
                
                self.contraintTableBottom.constant = self.temptablebottom - different
                if(self.withdrawFooter.hidden == false){
                    
                    if(self.tempfooterbottom - different > 0){
                        self.contraintFooterBottom.constant = self.tempfooterbottom - different
                    }else{
                        self.contraintFooterBottom.constant = 0
                        self.contraintTableBottom.constant = 57
                    }
                    
                    
                }else if(self.mCompletedFooter.hidden == false){
                    self.contraintCompletedFooterBottom.constant = self.tempfooterbottom - different
                }else if(self.mFooterAnsweredController.view.hidden == false){
                    
                    let frame = CGRectMake(self.tempfooterrect.origin.x, self.tempfooterrect.origin.y + different, self.tempfooterrect.width, self.tempfooterrect.height)
                    
                    if(frame.origin.y  < self.frame.size.height - frame.size.height){
                        self.mFooterAnsweredController.view?.frame = CGRectMake(self.tempfooterrect.origin.x, self.tempfooterrect.origin.y + different, self.tempfooterrect.width, self.tempfooterrect.height)
                    }else{
                        self.contraintTableBottom.constant = self.mFooterAnsweredController.view.frame.size.height - 95
                    }
                }
                
                
            }
            
            }, constraintBasedActionHandler: nil)
        
        
        let panRecognizer = UIPanGestureRecognizer(target: self, action: "panDetected:")
        panRecognizer.delegate = self
        
        self.mTableView.addGestureRecognizer(panRecognizer)
        
        btnCancel.titleLabel?.textAlignment = NSTextAlignment.Center
        
        //reload questions
        controller.refreshquestion()
        
        controller.navigationController?.view.userInteractionEnabled = true
        
        controller.refreshAndUpdateQuestionDeadline()
    }
    
    func panDetected(gesture: UIPanGestureRecognizer){
        
        if gesture.state == UIGestureRecognizerState.Began{
            
            startLocation = gesture.locationInView(self.mTableView)
            
            
        }else if gesture.state == UIGestureRecognizerState.Changed{
            
            let currentLocation = gesture.locationInView(self.mTableView)
            let dx = abs(startLocation.x - currentLocation.x)
            let dy = abs(currentLocation.y - startLocation.y)
            
            let distance = sqrt(dx*dx + dy*dy)
            
            let realvalue = (distance / (((self.mTableView.frame.width / 2) * 1.0) / 111)) / 6 * 4
            
            for cell in self.mTableView.visibleCells(){
                
                if(cell.isKindOfClass(QuestionDetailWithImageCell)){
                    let visibleCell = cell as! QuestionDetailWithImageCell
                    visibleCell.timestampContraint.constant = realvalue - 111
                    //                    visibleCell.textviewRightContraint.constant = 8 + realvalue + 101
                    visibleCell.lbTimestamp.hidden = false
                }
                
            }
            
        }else if gesture.state == UIGestureRecognizerState.Ended{
            for cell in self.mTableView.visibleCells(){
                
                UIView.animateWithDuration(0.7, delay: 0.0, options: .CurveEaseOut, animations: {
                    
                    if(cell.isKindOfClass(QuestionDetailWithImageCell)){
                        
                        let visibleCell = cell as! QuestionDetailWithImageCell
                        visibleCell.timestampContraint.constant = -111
                        visibleCell.textviewRightContraint.constant = 47
                        
                    }
                    }, completion: { finished in
                        
                })
                
            }
        }
        
    }
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    func viewwillappear(){
        
        isPaymentPopup = false
        
        controller.refreshquestion()
        
        if(controller.questionModel.withdrawed == "0"){
            controller.isWithdrwan = false
        }else{
            controller.isWithdrwan = true
        }
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector:"keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector:"keyboardDidShow:", name: UIKeyboardDidShowNotification, object: nil)
        
    }
    func viewdidappear(){
        // Check countdown timer
        if((controller.questionModel.accept["status"] as! Int) == 1 ){
            //            self.lbSubTitle.textColor = UIColor.darkGrayColor()
            self.lbSubTitle.hidden = false
            
            // Check for countdown mode
            for eachVC in controller.childViewControllers {
                if let qdafController = eachVC as? QuestionDetailAnsweredFooterController {
                    if ((qdafController.isViewLoaded()) &&
                        (qdafController.view.window != nil) &&
                        ( ( (self.lbSubTitle.text)!.rangeOfString("Pending") != nil) || ( (self.lbSubTitle.text)!.rangeOfString("Time") != nil) ) &&
                        (controller.questionModel.numBids > 0)) {
                            // Heart || Cross is showing
                            var secondsLeft = controller.questionModel.deadline as Double
                            if (secondsLeft > 0) {
                                // Fire countdown timer
                                questionCountdownTimer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: Selector("countdownTimerFromDeadline"), userInfo: nil, repeats: true)
                                NSRunLoop.mainRunLoop().addTimer(questionCountdownTimer, forMode: NSRunLoopCommonModes)
                            } else {
                                if (controller.isWithdrwan != true) {
                                    qdafController.overdue = true
                                    self.lbSubTitle.text = "Overdue"
                                }
                                
                            }
                    }
                }
            }
            self.withdrawnView.hidden = true
            self.acceptTutorView.hidden = true
            self.titleView.hidden = false
            self.lbSubTitle.hidden = false
        }
        //        bFinalPayment = true
        // if final payment is released, it shows PaymentNotificationPopoverView popover view
        if (controller.bFinalPayment == true) {
            controller.openCompletedView(controller.tutorName)
        }
    }
    
    func viewdiddisappear(){
        /* No longer listen for keyboard */
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardDidShowNotification, object: nil)
        
        
        if (questionCountdownTimer != nil) {
            questionCountdownTimer.invalidate()
        }
    }
    
    func viewdidlayoutsubviews(){
        if mFooterAnsweredController == nil {
            mFooterAnsweredController = controller.storyboard?.instantiateViewControllerWithIdentifier("QuestionDetailAnsweredFooterController") as! QuestionDetailAnsweredFooterController
            mFooterAnsweredController.delegate = self;
            controller.addChildViewController(mFooterAnsweredController)
            
            mFooterAnsweredController.view.frame = CGRectMake(0, self.frame.size.height - 155, self.frame.size.width,155)//height 152
            
            mFooterAnsweredController.footerview.constraintHeight.constant = 155
            
            self.addSubview(mFooterAnsweredController.view)
            mFooterAnsweredController.didMoveToParentViewController(controller)
            
            
            mFooterAnsweredController.view.hidden = true
            
        }
        
        if mFooterTutorAnswerController == nil {
            
            mFooterTutorAnswerController = controller.storyboard?.instantiateViewControllerWithIdentifier("TutorAnswerFooterController") as! TutorAnswerFooterController
            mFooterTutorAnswerController.delegate = self;
            controller.addChildViewController(mFooterTutorAnswerController)
            
            mFooterTutorAnswerController.view.frame = CGRectMake(0, self.frame.size.height-59, self.frame.size.width, 59);
            mFooterTutorAnswerController.footerview.constraintMessageHeight.constant = 0
            
            self.addSubview(mFooterTutorAnswerController.view)
            mFooterTutorAnswerController.didMoveToParentViewController(controller)
            
            
            mFooterTutorAnswerController.view.hidden = true
        }
        
        if mFooterBidController == nil {
            
            mFooterBidController = controller.storyboard?.instantiateViewControllerWithIdentifier("QuestionBidFooterController") as! QuestionBidFooterController
            mFooterBidController.delegate = self;
            controller.addChildViewController(mFooterBidController)
            
            var frame = self.frame;
            frame.origin.y = frame.size.height - 120.0;
            frame.size.height -= self.controller.getTopHeight();
            mFooterBidController.view.frame = frame
            self.contraintTableBottom.constant = 100
            
            self.addSubview(mFooterBidController.view)
            mFooterBidController.didMoveToParentViewController(controller)
            
            
            mFooterBidController.view.hidden = true
        }
    }
    
    func showTitleViews(){
        if(controller.isWithdrwan == true ){
            
            self.withdrawnView.hidden = true
            self.acceptTutorView.hidden = true
            self.titleView.hidden = false
            
            if (controller.questionModel.resolutionSolved == 0 && controller.questionModel.resolutionRefunded == 0) {
                self.lbSubTitle.text = "Please Check Your Email for Withdrawal Details"
                self.lbSubTitle.textColor = UIColor.redColor()
                
            }
            else if (controller.questionModel.resolutionSolved == 0 && controller.questionModel.resolutionRefunded == 1) {
                self.lbSubTitle.text = "Tutor Refunded"
            }
            else if (controller.questionModel.resolutionSolved == 1 && controller.questionModel.resolutionRefunded == 0) {
                self.lbSubTitle.text = "Withdrawal Declined"
                self.lbSubTitle.textColor = UIColor.redColor()
                
            }
            else if (controller.questionModel.resolutionSolved == 1 && controller.questionModel.resolutionRefunded == 1) {
                self.lbSubTitle.text = "Payment Refunded"
            }
                
            else if (controller.questionModel.withdrawed == "3") {
                self.lbSubTitle.text = "Withdrawal Declined"
                self.lbSubTitle.textColor = UIColor.redColor()
                
            }
            
            self.lbSubTitle.hidden = false
            
            
        }else if(controller.questionModel.paid == "1"){
            
            self.withdrawnView.hidden = true
            self.acceptTutorView.hidden = true
            self.titleView.hidden = false
            self.lbSubTitle.text = "Question Completed"
            self.lbSubTitle.hidden = false
            
            
        }else{
            
            self.withdrawnView.hidden = true
            self.acceptTutorView.hidden = true
            self.titleView.hidden = false
            self.lbSubTitle.hidden = false
        }
    }
    
    func countdownTimerFromDeadline() {
        var secondsLeft = controller.questionModel.deadline as Double
        if ( secondsLeft > 0 ) {
            // Initiate countdown if there is time left
            var (h,m,s) = self.secondsToHoursMinutesSeconds(Int(secondsLeft))
            
            var days = ""
            
            if (h>24) {
                days = String(h / 24) + " Days, "
                h %= 24
            }
            self.lbSubTitle.text = "Time remaining: " + days + padTime(h) + ":" + padTime(m) + ":" + padTime(s)
            
            controller.questionModel.deadline = secondsLeft - 1
        } else {
            for eachVC in controller.childViewControllers {
                if let qdafController = eachVC as? QuestionDetailAnsweredFooterController {
                    qdafController.overdue = true
                }
            }
            self.lbSubTitle.text = "Overdue"
        }
        
        
        
    }
    
    // Helper function to convert seconds to hour/minutes/seconds
    private func secondsToHoursMinutesSeconds (seconds : Int) -> (Int, Int, Int) {
        return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }
    
    // Helper function to pad time to have a '0' in front if it's a single digit
    private func padTime (timeValue: Int) -> String {
        if (timeValue < 10) {
            return "0" + String(timeValue)
        }
        return String(timeValue)
    }
    
    //MARK: Keyboard Related Functions
    
    
    func keyboardDidShow(notification:NSNotification){
        
        self.keyboardsize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.CGRectValue()
    }
    
    func keyboardWillShow(notification:NSNotification){
        
        
        
        if(mFooterTutorAnswerController != nil){
            if !self.withdrawFooter.hidden{
                
                UIView.animateWithDuration(0.3, delay: 0.0, options: .CurveEaseOut, animations: {
                    
                    var frame : CGRect = self.mFooterTutorAnswerController.view?.frame as CGRect!
                    
                    if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.CGRectValue() {
                        let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
                        self.keyboardsize = keyboardSize
                        frame.origin.y = self.frame.size.height - (frame.size.height-60) - keyboardSize.height
                        self.contraintTableBottom.constant = keyboardSize.height
                    }
                    
                    self.mFooterTutorAnswerController.view?.frame = frame; //sets toolbar with input textfield size
                    //                    self.contraintTableBottom.constant = self.view.frame.height - frame.origin.y
                    
                    self.temptablebottom = self.contraintTableBottom.constant
                    self.tempfooterrect = frame
                    
                    }, completion: { finished in
                        
                        self.keyboardIsVisible = true;
                        
                        self.tableViewScrollToBottom();
                })
                
            }
        }
        
        if(self.mCompletedFooter.hidden == false){
            
            UIView.animateWithDuration(0.5, delay: 0.0, options: .CurveEaseOut, animations: {
                
                var frame : CGRect = self.mCompletedFooter.frame as CGRect!
                
                if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.CGRectValue() {
                    let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
                    
                    frame.origin.y = self.frame.size.height - keyboardSize.height
                    self.contraintCompletedFooterBottom.constant = keyboardSize.height
                    self.contraintTableBottom.constant = keyboardSize.height
                    
                }
                
                //                self.mCompletedFooter.frame = frame; //sets toolbar with input textfield size
                self.temptablebottom = self.contraintTableBottom.constant
                self.tempfooterbottom = self.contraintCompletedFooterBottom.constant
                
                }, completion: { finished in
                    
                    self.keyboardIsVisible = true;
                    
                    self.tableViewScrollToBottom();
            })
            
        }
        
        if(mFooterAnsweredController != nil){
            if !mFooterAnsweredController.view.hidden{
                
                UIView.animateWithDuration(0.5, delay: 0.0, options: .CurveEaseOut, animations: {
                    
                    var frame : CGRect = self.mFooterAnsweredController.view?.frame as CGRect!
                    
                    if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.CGRectValue() {
                        let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
                        
                        frame.origin.y = self.frame.size.height - (frame.size.height-85) - keyboardSize.height
                        
                        
                    }
                    
                    self.mFooterAnsweredController.view?.frame = frame; //sets toolbar with input textfield size
                    self.contraintTableBottom.constant = self.frame.height - frame.origin.y - 100
                    self.contraintFooterBottom.constant = self.frame.height - frame.origin.y - 170
                    
                    self.temptablebottom = self.contraintTableBottom.constant
                    self.tempfooterbottom = self.contraintFooterBottom.constant
                    self.tempfooterrect = frame
                    
                    }, completion: { finished in
                        
                        self.keyboardIsVisible = true;
                        
                        self.tableViewScrollToBottom();
                })
                
            }
        }
        
        if(!self.withdrawFooter.hidden){
            
            UIView.animateWithDuration(0.5, delay: 0.0, options: .CurveEaseOut, animations: {
                
                var frame : CGRect = self.withdrawnView.frame as CGRect!
                
                if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.CGRectValue() {
                    let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
                    
                    frame.origin.y = self.frame.size.height - (frame.size.height) - keyboardSize.height
                    
                    
                }
                
                //                self.mFooterAnsweredController.view?.frame = frame; //sets toolbar with input textfield size
                self.contraintTableBottom.constant = self.frame.height - frame.origin.y - 60
                self.contraintFooterBottom.constant = self.frame.height - frame.origin.y - 130
                
                self.temptablebottom = self.contraintTableBottom.constant
                self.tempfooterbottom = self.contraintFooterBottom.constant
                
                }, completion: { finished in
                    
                    self.keyboardIsVisible = true;
                    
                    self.tableViewScrollToBottom();
            })
        }
        
    }
    
    func keyboardWillHide(notification:NSNotification){
        
        self.keyboardIsVisible = false;
        
        if( self.mFooterAnsweredController != nil){
            if !self.mFooterAnsweredController.view.hidden || !self.withdrawFooter.hidden {
                
                UIView.animateWithDuration(0.5, delay: 0.0, options: .CurveEaseOut, animations: {
                    
                    var frame : CGRect = self.mFooterAnsweredController.view?.frame as CGRect!
                    
                    frame.origin.y = self.frame.size.height - frame.size.height
                    
                    self.mFooterAnsweredController.view?.frame = frame;
                    self.contraintTableBottom.constant = self.mFooterAnsweredController.view.frame.size.height - 100
                    self.contraintFooterBottom.constant = 0
                    
                    }, completion: { finished in
                        
                        self.keyboardIsVisible = false;
                        self.tableViewScrollToBottom();
                        
                })
            }
        }
        if(self.mFooterTutorAnswerController != nil){
            if !self.mFooterTutorAnswerController.view.hidden || !self.withdrawFooter.hidden{
                
                UIView.animateWithDuration(0.3, delay: 0.0, options: .CurveEaseOut, animations: {
                    
                    var frame : CGRect = self.mFooterTutorAnswerController.view?.frame as CGRect!
                    
                    frame.origin.y = self.frame.size.height - frame.size.height
                    
                    self.mFooterTutorAnswerController.view?.frame = frame;
                    self.contraintTableBottom.constant = self.mFooterTutorAnswerController.view.frame.size.height
                    
                    
                    }, completion: { finished in
                        
                        self.keyboardIsVisible = false;
                        self.tableViewScrollToBottom();
                        
                })
            }
        }
        
        if(self.mCompletedFooter.hidden == false){
            
            UIView.animateWithDuration(0.5, delay: 0.0, options: .CurveEaseOut, animations: {
                
                self.contraintTableBottom.constant = 0
                self.contraintCompletedFooterBottom.constant = 0
                
                
                }, completion: { finished in
                    
                    self.keyboardIsVisible = false;
                    self.tableViewScrollToBottom();
            })
            
        }
        
        
    }
    
    func addDoneButtonToKeyboard(textView: AnyObject)
    {
        var toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.bounds.width, height: 44))
        var leftSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        var doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Done, target: self, action: Selector("hideKeyboard:"))
        toolbar.setItems([leftSpace, doneButton], animated: false)
        if textView.isKindOfClass(UITextField)
        {
            (textView as! UITextField).inputAccessoryView = toolbar
            return
        }
        if textView.isKindOfClass(BHExpandingTextView){
            (textView as! BHExpandingTextView).internalTextView.inputAccessoryView = toolbar
            return
        }
        (textView as! UITextView).inputAccessoryView = toolbar
    }
    
    func hideKeyboard(notification: AnyObject)
    {
        if discussBar.textView.isFirstResponder(){
            discussBar.textView.internalTextView.resignFirstResponder()
            discussBar.textView.resignFirstResponder()
            return
        }
        
        if discussBar.textView.internalTextView.isFirstResponder(){
            discussBar.textView.internalTextView.resignFirstResponder()
        }
        
        if completeddiscussBar.textView.isFirstResponder(){
            completeddiscussBar.textView.internalTextView.resignFirstResponder()
            completeddiscussBar.textView.resignFirstResponder()
            return
        }
        
        if completeddiscussBar.textView.internalTextView.isFirstResponder(){
            completeddiscussBar.textView.internalTextView.resignFirstResponder()
        }
    }
    
    
    func dismissKeyboard(){
        self.mTextView!.resignFirstResponder()
        
    }
    
    //MARK: UITableView Related Functions
    
    func tableViewScrollToUp() {
        let offset = CGPoint(x: 0, y: 0)
        mTableView.setContentOffset(offset, animated: true)
    }
    
    func tableViewScrollToBottom() {
        //        if mTableView.contentSize.height > mTableView.frame.size.height
        //        {
        //            let offset = CGPoint(x: 0, y: mTableView.contentSize.height - mTableView.frame.size.height)
        //            mTableView.setContentOffset(offset, animated: true)
        //        }
        tableViewScrollToBottom(true)
    }
    
    
    func tableViewScrollToBottom(animated: Bool) {
        
        let delay = 0.3 * Double(NSEC_PER_SEC)
        let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
        
        dispatch_after(time, dispatch_get_main_queue(), {
            
            let numberOfSections = self.mTableView.numberOfSections()
            let numberOfRows = self.mTableView.numberOfRowsInSection(numberOfSections-1)
            
            if numberOfRows > 0 {
                let indexPath = NSIndexPath(forRow: numberOfRows-1, inSection: (numberOfSections-1))
                self.mTableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: UITableViewScrollPosition.Bottom, animated: animated)
            }
            
        })
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat{ //Sets the height for row
        
        if indexPath.section == 0 { // question cell
            
            if controller.questionDetail == nil {
                return 114
            }
            else {
                
                
                
                var str = controller.questionDetail!["withtags"] as! String
                
                
                mTextView?.frame = CGRectMake(47, 0, UIScreen.mainScreen().bounds.width-47, 30)
                mTextView?.attributedText = self.questionattr
                //        mTextView?.sizeToFit()
                let maxHeight : CGFloat = 10000
                
                let rect = mTextView?.sizeThatFits(CGSizeMake(UIScreen.mainScreen().bounds.width-100, maxHeight))
                
                var profileHeight = rect!.height + 50
                //                return 76 + profileHeight + 10
                
                let photoarray = controller.questionDetail!["attachment_img"] as! NSArray
                let linkarray = controller.questionDetail!["attachment_link"] as! NSArray
                
                let nTotalCount = photoarray.count + linkarray.count;
                let nColumnCount = Int((self.frame.width - 17) / 70)
                
                var rowCount  = nTotalCount / nColumnCount
                
                if(nTotalCount % nColumnCount != 0){
                    rowCount = rowCount + 1
                }
                
                if (photoarray.count > 0){
                    
                    if(profileHeight < 0){
                        profileHeight = 0
                    }
                    
                    return profileHeight + CGFloat(75*rowCount)
                }else{
                    if(linkarray.count > 0){
                        if(profileHeight < 0){
                            profileHeight = 0
                        }
                        return profileHeight + CGFloat(75*rowCount)
                    }else{
                        if(profileHeight < 0){
                            profileHeight = 20
                        }
                        return profileHeight
                    }
                }
                
                
                
            }
        }
        else if indexPath.section == 1 {
            if controller.answerDetail == nil {
                return 160
            }
            
            return 160
        }
        else  { // discuss cell
            if(showFooter == true && indexPath.row == controller.discussDatas?.count){
                if(controller.isWithdrwan == false && controller.questionModel.paid == "1"){
                    return 70
                }
                else{
                    return 100
                }
            }
            if controller.discussDatas == nil {
                return 0
            }
            else {
                
                mTextView?.frame = CGRectMake(47, 0, UIScreen.mainScreen().bounds.width-47, 30)
                mTextView?.attributedText = controller.attributStrings[indexPath.row] as! NSAttributedString
                //        mTextView?.sizeToFit()
                let maxHeight : CGFloat = 10000
                
                let rect = mTextView?.sizeThatFits(CGSizeMake(UIScreen.mainScreen().bounds.width-100, maxHeight))
                
                var profileHeight = rect!.height - 10
                
                
                var strTime = controller.discussDatas![indexPath.row]["create_time"] as! String
                var date = NSDate(timeIntervalSince1970: (strTime as NSString).doubleValue)
                
                if(indexPath.row > 0 && (controller.discussDatas![indexPath.row]["sender"] as! String) == (controller.discussDatas![indexPath.row-1]["sender"] as! String)){
                    var prevTime = controller.discussDatas![indexPath.row-1]["create_time"] as! String
                    var prevDate = NSDate(timeIntervalSince1970: (prevTime as NSString).doubleValue)
                    
                    var distance = abs((prevDate.timeIntervalSinceDate(date) / 60))
                    
                    if(distance >= 60){
                        profileHeight = profileHeight + 30
                    }else{
                        //                      profileHeight -= 20
                    }
                }else{
                    profileHeight += 50
                }
                
                let photoarray = controller.discussDatas![indexPath.row]["attachment_img"] as! NSArray
                let linkarray = controller.discussDatas![indexPath.row]["attachment_link"] as! NSArray
                
                let nTotalCount = photoarray.count + linkarray.count;
                let nColumnCount = Int((self.frame.width - 17) / 70)
                
                var rowCount  = nTotalCount / nColumnCount
                
                if(nTotalCount % nColumnCount != 0){
                    rowCount = rowCount + 1
                }
                
                if (photoarray.count > 0){
                    
                    if(profileHeight < 0){
                        profileHeight = 20
                    }
                    
                    return profileHeight + CGFloat(75*rowCount)
                }else{
                    if(linkarray.count > 0){
                        if(profileHeight < 0){
                            profileHeight = 20
                        }
                        return profileHeight + CGFloat(75*rowCount)
                    }else{
                        if(profileHeight < 0){
                            profileHeight = 20
                        }
                        return profileHeight
                    }
                }
            }
        }
        
    }
    
    
    
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            return 1
        }
        else if section == 1 {
            //  if(self.questionModel.accept["status"] as! NSNumber == 1) {
            // return 0
            
            //  }
            if(controller.questionModel.accept["status"] as! NSNumber == 0) {
                
                return 1
                
                
            }
            
            
            
            return 0
        }
        else {
            if controller.discussDatas == nil {
                return 0
            }
            else {
                if(showFooter == true){
                    return controller.discussDatas!.count+1
                }
                else{
                    return controller.discussDatas!.count
                }
            }
        }
        
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            
            let cell = tableView.dequeueReusableCellWithIdentifier("QuestionDetailWithImageCell", forIndexPath: indexPath) as! QuestionDetailWithImageCell
            removeAllGesture(cell.lbName)
            removeAllGesture(cell.ivAvatar)
            
            cell.viewcontroller = controller
            
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            
            
            var tap = UITapGestureRecognizer(target: self.controller, action: "respondToTapAvatarGesture:")
            
            cell.backgroundColor = UIColor(red: 247/255.0, green: 247/255.0, blue: 247/255.0, alpha: 1.0)
            cell.ivMask.image = UIImage(named: "mask_dark")
            
            
            
            //            cell.lblRating.hidden = true
            
            if controller.questionDetail != nil {
                
                cell.lbName.text = controller.studentName
                if let url = NSURL(string: controller.studentImageUrl) {
                    cell.ivAvatar.hnk_setImageFromURL(url)
                    
                }
                cell.ivAvatar.tag = 1 // student
                
                cell.ivAvatar.layer.cornerRadius = cell.ivAvatar.frame.width / 2
                cell.ivAvatar.layer.masksToBounds = true
                
                
                cell.lbName.tag = 1
                cell.ivAvatar.hidden = false
                cell.lbName.hidden = false
                cell.ivMask.hidden = true
                
                cell.topMarginConstraint?.constant = 73
                
                
                // timestamp
                var date = NSDate(timeIntervalSince1970: controller.questionDetail!["create_time"] as! Double)
                //                cell.lbTimestamp.text = date.relativeTime
                
                var dateFormatter = NSDateFormatter()
                
                dateFormatter.dateFormat = "EEE MMM d hh:mm a" //format style. Browse online to get a format that fits your needs.
                var dateString = dateFormatter.stringFromDate(date)
                
                if date.relativeTime.rangeOfString("ago") != nil{
                    cell.lbMainTimestamp.text = dateString
                }else{
                    cell.lbMainTimestamp.text = date.relativeTime
                }
                
                cell.lbMainTimestamp.hidden = false
                
                
                var str = controller.questionDetail!["withtags"] as! String
                
                //wrap the html with font and color
                cell.lbDesc.attributedText = self.questionattr
                cell.lbDesc.sizeToFit()
                
                cell.profileview.hidden = false
                
                let photoarray = controller.questionDetail!["attachment_img"] as! NSArray
                let linkarray = controller.questionDetail!["attachment_link"] as! NSArray
                if (photoarray.count > 0 || linkarray.count > 0){
                    
                    cell.photoArray = photoarray
                    cell.linkArray = linkarray
                    cell.imvCamera.hidden =  true
                    cell.imageCollection.hidden = false
                    cell.imageCollection.reloadData()
                    
                    
                    let nTotalCount = photoarray.count + linkarray.count;
                    let nColumnCount = Int((self.frame.width - 17) / 70)
                    
                    
                    var rowCount  = nTotalCount / nColumnCount
                    
                    if(nTotalCount % nColumnCount != 0){
                        rowCount = rowCount + 1
                    }
                    
                    
                    cell.constraintImageHeight.constant = CGFloat(70 * rowCount)
                    cell.bottomMarginConstraint?.constant = CGFloat(70 * rowCount)
                    
                    
                    
                    //                    cell.imageCollection.transform = CGAffineTransformMakeTranslation(0, 30)
                }else{
                    
                    cell.imvCamera.hidden =  true
                    cell.imageCollection.hidden = true
                    cell.bottomMarginConstraint?.constant = 0
                    
                }
                
                cell.lbMainTimestamp.hidden = false
                
                cell.topMarginConstraint?.constant = 50
                //                cell.lbDetail.text = str
                //                cell.lbDetail.numberOfLines = 0
                //                cell.lbDetail.lineBreakMode = NSLineBreakMode.ByWordWrapping
            }else{
                cell.imvCamera.hidden =  true
            }
            
            return cell;
        }
        else if indexPath.section == 1 { // answer
            if controller.answerDetail == nil {
                
                let cell = tableView.dequeueReusableCellWithIdentifier("AnswerPendingCell", forIndexPath: indexPath) as! UITableViewCell
                cell.backgroundColor = UIColor.whiteColor()
                if (showedBidSpinner == true)
                {
                    (cell as! AnswerPendingCell).activity.hidden = true
                    (cell as! AnswerPendingCell).bidLabel.hidden = true
                }
                
                
                showedBidSpinner = true
                
                return cell;
            }
            else {
                if controller.questionModel.numBids == 0{
                    let cell = tableView.dequeueReusableCellWithIdentifier("AnswerPendingCell", forIndexPath: indexPath) as! UITableViewCell
                    cell.backgroundColor = UIColor.whiteColor()
                    (cell as! AnswerPendingCell).activity.hidden = true
                    (cell as! AnswerPendingCell).bidLabel.hidden = false
                    (cell as! AnswerPendingCell).bidLabel.text = "Bids pending"
                    
                    
                }
                
                let cell = tableView.dequeueReusableCellWithIdentifier("QuestionDetailWithImageCell", forIndexPath: indexPath) as! QuestionDetailWithImageCell
                cell.viewcontroller = controller
                cell.selectionStyle = UITableViewCellSelectionStyle.None
                removeAllGesture(cell.lbName)
                removeAllGesture(cell.ivAvatar)
                
                //                var tap = UITapGestureRecognizer(target: self.controller, action: "respondToTapAvatarGesture:")
                //                cell.ivAvatar.addGestureRecognizer(tap)
                //                cell.ivAvatar.userInteractionEnabled = true
                
                
                cell.backgroundColor = UIColor.whiteColor()
                
                cell.lbName.text = controller.tutorName
                //                cell.lbCount.text = "+" + String(tutorReviews)
                
                if let url = NSURL(string: controller.tutorImageUrl) {
                    
                    cell.ivAvatar.hnk_setImageFromURL(url)
                    controller.studentAvatar = cell.ivAvatar.image
                    
                    
                }
                cell.ivAvatar.tag = 2 // tutor
                cell.lbName.tag = 2
                
                var date = NSDate(timeIntervalSince1970: controller.answerDetail!["create_time"] as! Double)
                cell.lbTimestamp.text = date.relativeTime
                
                var str = controller.answerDetail!["answer"] as? String
                
                //wrap the html with font and color
                let finalString = String(format: "<html><head><style type=\"text/css\">\nbody {font-family: \"%@\"; font-size: %@; color:#%@;}\n</style></head><body>%@</body></html>",
                    "Open Sans", "14", "000000", str!);
                
                println(finalString)
                
                //                cell.lbDetail.loadHTMLString(finalString, baseURL: nil)
                if let photoarray = controller.answerDetail!["attach"] as? NSArray{
                    cell.imvCamera.hidden =  true
                }else{
                    cell.imvCamera.hidden =  true
                }
                cell.imvCamera.hidden =  true
                cell.imageCollection.hidden = true
                return cell;
            }
            
        }
        else {
            
            if(showFooter == true && indexPath.row == controller.discussDatas?.count){
                
                
                var myObject: AnyObject = UITableViewCell()
                myObject.contentView.backgroundColor = UIColor(red: 247/255.0, green: 247/255.0, blue: 247/255.0, alpha: 1.0)
                //                myObject.contentView.backgroundColor = UIColor.blackColor()
                
                return myObject as! UITableViewCell
            }
            
            let cell = tableView.dequeueReusableCellWithIdentifier("QuestionDetailWithImageCell", forIndexPath: indexPath) as! QuestionDetailWithImageCell
            removeAllGesture(cell.lbName)
            removeAllGesture(cell.ivAvatar)
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            cell.viewcontroller = controller
            
            var nameTap = UITapGestureRecognizer(target: self.controller, action: "respondToTapAvatarGesture:")
            var tap = UITapGestureRecognizer(target: self.controller, action: "respondToTapAvatarGesture:")
            
            var sender = controller.discussDatas![indexPath.row]["sender"] as! String
            
            
            if (sender != controller.questionModel.owner_id) {
                println("\(indexPath.section) \(indexPath.row)")
                
                
                cell.lbName.addGestureRecognizer(nameTap)
                cell.lbName.userInteractionEnabled = true
                
                cell.ivAvatar.addGestureRecognizer(tap)
                cell.ivAvatar.userInteractionEnabled = true
                // Decide whether message is from customer service or tutor
                let messageSender = controller.discussDatas![indexPath.row]["username"] as! String
                if contains( customerServiceNames, messageSender) {
                    // Customer service
                    cell.lbName.text = messageSender
                    if let url = NSURL(string: (controller.discussDatas![indexPath.row]["avatar"] as? String)!) {
                        cell.ivAvatar.hnk_setImageFromURL(url)
                    }
                } else {
                    // Tutor
                    cell.lbName.text = controller.questionModel.accept["tutorusername"] as? String
                    
                    var pictureUri = controller.questionModel.accept["tutoravatar"] as? String
                    pictureUri = pictureUri!.stringByReplacingOccurrencesOfString(" ", withString: "%20", options: NSStringCompareOptions.RegularExpressionSearch, range: nil)
                    
                    if let url = NSURL(string:pictureUri!) {
                        cell.ivAvatar.hnk_setImageFromURL(url)
                    }
                    controller.tutorId = sender
                    cell.ivAvatar.tag = 2 // tutor
                    cell.lbName.tag = 2
                }
                
                //                cell.backgroundColor = UIColor(red: 219/255.0, green: 240/255.0, blue: 246/255.0, alpha: 1.0)
                cell.backgroundColor = UIColor(red: 247/255.0, green: 247/255.0, blue: 247/255.0, alpha: 1.0)
                //                cell.backgroundColor = UIColor(red: 245/255.0, green: 245/255.0, blue: 243/255.0, alpha: 1.0)
                cell.ivMask.image = UIImage(named: "mask_light")
                cell.ivMask.hidden = true
                
            } else {
                
                cell.lbName.text = controller.studentName
                cell.lbCount.text = ""
                if let url = NSURL(string: controller.studentImageUrl) {
                    cell.ivAvatar.hnk_setImageFromURL(url)
                    
                }
                cell.ivAvatar.tag = 1 // tutor
                cell.lbName.tag = 1
                
                cell.backgroundColor = UIColor(red: 247/255.0, green: 247/255.0, blue: 247/255.0, alpha: 1.0)
                //                cell.backgroundColor = UIColor(red: 231/255.0, green: 231/255.0, blue: 226/255.0, alpha: 1.0)
                //                cell.ivMask.image = UIImage(named: "mask_dark")
                cell.ivMask.hidden = true
                //                cell.lblRating.hidden = true
            }
            
            
            cell.ivAvatar.layer.cornerRadius = cell.ivAvatar.frame.width / 2
            cell.ivAvatar.layer.masksToBounds = true
            
            
            if(indexPath.row > 0){
                
                if((controller.discussDatas![indexPath.row]["sender"] as! String) == (controller.discussDatas![indexPath.row-1]["sender"] as! String)){
                    cell.profileview.hidden = true
                    cell.topMarginConstraint?.constant = 0
                    
                }else{
                    
                    
                    cell.profileview.hidden = false
                    cell.topMarginConstraint?.constant = 50
                    
                }
                
            }else{
                cell.topMarginConstraint?.constant = 50
                cell.profileview.hidden = false
            }
            
            var strTime = controller.discussDatas![indexPath.row]["create_time"] as! String
            var date = NSDate(timeIntervalSince1970: (strTime as NSString).doubleValue)
            
            var dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "hh:mm a" //format style. Browse online to get a format that fits your needs.
            var dateString = dateFormatter.stringFromDate(date)
            cell.lbTimestamp.text = dateString
            
            
            
            if(indexPath.row > 0 && (controller.discussDatas![indexPath.row]["sender"] as! String) == (controller.discussDatas![indexPath.row-1]["sender"] as! String)){
                var prevTime = controller.discussDatas![indexPath.row-1]["create_time"] as! String
                var prevDate = NSDate(timeIntervalSince1970: (prevTime as NSString).doubleValue)
                
                var distance = abs((prevDate.timeIntervalSinceDate(date) / 60))
                
                if(distance <= 60){
                    cell.lbMainTimestamp.hidden = true
                    cell.timestampTopContraint.constant = -10
                    cell.topMarginConstraint?.constant = -20
                    
                }else{
                    cell.timestampTopContraint.constant = 0
                    cell.lbMainTimestamp.hidden = false
                    cell.topMarginConstraint?.constant = 10
                }
            }else{
                cell.lbMainTimestamp.hidden = false
                cell.topMarginConstraint?.constant = 30
            }
            
            dateFormatter.dateFormat = "EEE MMM d hh:mm a" //format style. Browse online to get a format that fits your needs.
            dateString = dateFormatter.stringFromDate(date)
            
            if date.relativeTime.rangeOfString("ago") != nil{
                cell.lbMainTimestamp.text = dateString
            }else{
                cell.lbMainTimestamp.text = date.relativeTime
            }
            
            
            //wrap the html with font and colo
            
            let photoarray = controller.discussDatas![indexPath.row]["attachment_img"] as! NSArray
            let linkarray = controller.discussDatas![indexPath.row]["attachment_link"] as! NSArray
            if (photoarray.count > 0 || linkarray.count > 0){
                
                cell.photoArray = photoarray
                cell.linkArray = linkarray
                cell.imvCamera.hidden =  true
                cell.imageCollection.hidden = false
                cell.imageCollection.reloadData()
                
                
                let nTotalCount = photoarray.count + linkarray.count;
                let nColumnCount = Int((self.frame.width - 17) / 70)
                
                
                var rowCount  = nTotalCount / nColumnCount
                
                if(nTotalCount % nColumnCount != 0){
                    rowCount = rowCount + 1
                }
                
                
                cell.constraintImageHeight.constant = CGFloat(70 * rowCount)
                cell.bottomMarginConstraint?.constant = CGFloat(70 * rowCount)
                
                
                
                //                    cell.imageCollection.transform = CGAffineTransformMakeTranslation(0, 30)
            }else{
                
                cell.imvCamera.hidden =  true
                cell.imageCollection.hidden = true
                cell.bottomMarginConstraint?.constant = 0
                
            }
            
            // NSLog("%d,%@", (discussDatas![indexPath.row]["withtags"] as? String)!)
            cell.lbDesc.attributedText = controller.attributStrings[indexPath.row] as! NSAttributedString
            
            return cell;
            
        }
        
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) { // when user taps on table row this will be called
        tableView.deselectRowAtIndexPath(indexPath, animated: false) // we deselect the selected row
        
        
        
    }
    
    func removeAllGesture(view :UIView!){
        if(view.gestureRecognizers == nil) {
            return
        }
        var gestures = view.gestureRecognizers as! [UIGestureRecognizer]
        for tap in gestures{
            view.removeGestureRecognizer(tap)
        }
    }
    
    // MARK: - QuestionBidFooterController delegate
    func showBidProfile(row: Int){
        
        let bidmodel = self.mFooterBidController.dataTutor[row] as! BidModel
        
        var storyboard = UIStoryboard(name: "Feed", bundle: nil)
        let profileViewController = storyboard.instantiateViewControllerWithIdentifier("Profile") as! ProfileViewController
        profileViewController.selectedUserID = bidmodel.owner_id
        controller.navigationController?.pushViewController(profileViewController, animated: true)
    }
    
    func selectBid(row: Int) {
        var bid = (self.mFooterBidController.dataTutor[row] as! BidModel)
        self.controller.selectBid(bid)
    }
    
    
    func closeBidView() {
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            self.mFooterBidController.view.transform = CGAffineTransformMakeTranslation(0, 0)
        }) { (finished: Bool) -> Void in
            self.mFooterBidController.footerview.mTableView.scrollEnabled = false
        }
    }
    func openBidView() {
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            self.mFooterBidController.view.transform = CGAffineTransformMakeTranslation(0, self.controller.getTopHeight() - self.mFooterBidController.view.frame.origin.y)
        }) { (finished: Bool) -> Void in
            self.mFooterBidController.footerview.mTableView.scrollEnabled = true
        }
    }
    // MARK: - QuestionDetailFooterAnsweredControllerDelegate
    
    func onComment(message:String) {
        self.controller.onComment(message)
    }
    
    
    
    func onAccept() {
        
        controller.onAccept()
    }
    
    func onDecline() {
        
        controller.onDecline()
    }
    
    func onInfo() {
        
        controller.onInfo()
        
    }
    
    func changeFrameHeight(height: Float) {
        
        
        
        var oriRect:CGRect = mFooterAnsweredController.view.frame
        var diff = oriRect.size.height - CGFloat(height)
        
        mFooterAnsweredController.view.frame = CGRectMake(0, mFooterAnsweredController.view.frame.origin.y + diff,
            self.frame.size.width, CGFloat(height));
        
        
        
        if(withdrawFooter.hidden == false){
            
            if(self.keyboardIsVisible == true){
                self.contraintTableBottom.constant = self.contraintTableBottom.constant + (100+CGFloat(height) - self.discussBarHeight.constant);
            }
            
            self.discussBarHeight.constant = 100 + CGFloat(height)
            
        }
        else if(mCompletedFooter.hidden == false){
            
            if(self.keyboardIsVisible == true){
                self.contraintTableBottom.constant = self.contraintTableBottom.constant + (40 + CGFloat(height) - self.completedBarHeight.constant);
            }
            
            
            self.completedBarHeight.constant = 40 + CGFloat(height)
            
        }else{
            //            if(self.keyboardIsVisible == true){
            self.contraintTableBottom.constant = self.contraintTableBottom.constant - diff;
            //            }
            
        }
        tableViewScrollToBottom()
        
    }
    
    // MARK: - TutorAnswerFooterController delegate
    func onSubmit(message:String) {
        
        controller.onSubmit(message)
        
    }
    
    
    func onAnswer() {
        
        controller.onAnswer()
        
        
    }
    func changeTutorFooterHeight(height:CGFloat) {
        
        
        
        if (mFooterTutorAnswerController.view.hidden == false) {
            
            
            var oriRect:CGRect = mFooterTutorAnswerController.view.frame
            var diff = oriRect.size.height - height
            
            mFooterTutorAnswerController.view.frame = CGRectMake(0, mFooterTutorAnswerController.view.frame.origin.y + diff,
                self.frame.size.width, CGFloat(height));
            
            self.contraintTableBottom.constant = self.contraintTableBottom.constant - diff;
            
            tableViewScrollToBottom()
        }
        
    }

    // MARK: - BHInputbar delegate
    
    func sendButtonPressed(inputText: NSAttributedString!) {
        if !(completeddiscussBar!.textView!.text.isEmpty) {
            onComment(completeddiscussBar!.textView!.text)
            completeddiscussBar.textView.text = ""
        }
        if !(discussBar!.textView!.text.isEmpty) {
            onComment(discussBar!.textView!.text)
            discussBar.textView.text = ""
        }
        hideKeyboard(inputText)
    }
    
    // MARK: - MailCompose Delegate
    func mailComposeController(controller: MFMailComposeViewController!, didFinishWithResult result: MFMailComposeResult, error: NSError!) {
        
        controller.dismissViewControllerAnimated(true, completion: nil)
        
        
    }
    
    func showSendMailErrorAlert() {
        let sendMailErrorAlert = UIAlertView(title: "Could Not Send Email", message: "Your device could not send e-mail.  Please check e-mail configuration and try again.", delegate: nil, cancelButtonTitle: "OK")
        sendMailErrorAlert.show()
    }
    
    //delegate function for PaymentNotificationPopoverViewDelegate
    func onDismiss() {
        
        //calling 3PL for popup animation
        controller.lew_dismissPopupViewWithanimation(LewPopupViewAnimationDrop.alloc())
        
        //if we just got 5 star review and we just showed the receipt page popup
        if((reviewRating == 5) && (isPaymentPopup == true)){
            
            //instantiate the rate by app class with the rate object
            var rate = RateMyApp.sharedInstance
            //set the app id
            rate.appID = "1033410225"
            
            //rate checks nsuserdefaults if this is the first time we ask or if they hit remind me later.
            if(rate.isFirstTime() == true){
                
                //instantiate popup object
                var refreshAlert = UIAlertController(title: "Studypool", message: "Enjoying Studypool?", preferredStyle: UIAlertControllerStyle.Alert)
                
                //tapping the action automatically dismisses the popup
                refreshAlert.addAction(UIAlertAction(title: "Not really", style: .Default, handler: { (action: UIAlertAction!) in
                    var refreshAlert = UIAlertController(title: "Studypool", message: "Would you mind giving us some feedback?", preferredStyle: UIAlertControllerStyle.Alert)
                    
                    refreshAlert.addAction(UIAlertAction(title: "No, thanks", style: .Default, handler: { (action: UIAlertAction!) in
                        
                    }))
                    
                    refreshAlert.addAction(UIAlertAction(title: "Ok, sure", style: .Default, handler: { (action: UIAlertAction!) in
                        
                        //if iphone email client is set up
                        if MFMailComposeViewController.canSendMail() {
                            self.controller.detailview.picker = MFMailComposeViewController()
                            self.controller.detailview.picker.mailComposeDelegate = self
                            
                            var emailTitle = "Feedback"
                            var messageBody = ""
                            var toRecipents = ["contact@studypool.com"]
                            var mc: MFMailComposeViewController = MFMailComposeViewController()
                            mc.mailComposeDelegate = self
                            mc.setSubject(emailTitle)
                            mc.setMessageBody(messageBody, isHTML: false)
                            mc.setToRecipients(toRecipents)
                            
                            self.controller.presentViewController(mc, animated: true, completion: {
                            })
                            
                            
                        } else {
                            self.showSendMailErrorAlert()
                        }
                        
                    }))
                    
                    self.controller.presentViewController(refreshAlert, animated: true, completion: nil)
                }))
                
                //yes button
                refreshAlert.addAction(UIAlertAction(title: "Yes", style: .Default, handler: { (action: UIAlertAction!) in
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        //shows 3 buttons rate now, remind me later, never
                        rate.trackAppUsage()
                    })
                }))
                
                controller.presentViewController(refreshAlert, animated: true, completion: nil)
            }
            
            
            
        }
        isPaymentPopup = false
    }
    
    
    
    
    func onGotoDetail(question: QuestionModel) {
        
        controller.lew_dismissPopupViewWithanimation(LewPopupViewAnimationDrop.alloc())
        
    }
    
    
    func expandingTextView(expandingTextView: BHExpandingTextView!, didChangeHeight height: Float) {
        
        //        contraintFooterBottom.constant +=  CGFloat(height)
        if(withdrawFooter.hidden == false){
            changeFrameHeight( height )
        }
        
        //        contraintCompletedFooterBottom.constant +=  CGFloat(height)
        if(mCompletedFooter.hidden == false){
            changeFrameHeight( height )
        }
    }
}
