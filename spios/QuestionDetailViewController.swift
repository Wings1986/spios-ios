//
//  QuestionDetailViewController.swift
//  spios
//
//  Created by Stanley Chiang on 4/23/15.
//  Copyright (c) 2015 Studypool. All rights reserved.
//

import UIKit
import Haneke
import Alamofire
import Analytics
import MessageUI
///Question Detail class


class QuestionDetailViewController: UIViewController, AcceptQuestionViewControllerDelegate, HowTobidPopOverDelegate, UIAlertViewDelegate {
    
    @IBOutlet weak var detailview:QuestionDetailView!
    
    var isConfirmTutor : Bool!
    
    var isWithdrwan : Bool = false
    
  
    /// isTutor
    var mIsTutor:Bool? = false
    
    var bFinalPayment: Bool = false
    
    /// student avatar image
    var studentAvatar: UIImage!
    
    /// question detail dictionary
    var questionDetail: NSMutableDictionary? = nil
    
    /// answer detil dictionary
    var answerDetail: NSMutableDictionary? = nil
    
    /// chat history array
    var discussDatas : NSMutableArray? = nil
    
    /// student name
    var studentName:String = ""
    
    /// student image url
    var studentImageUrl:String = ""
    
    /// tutor name
    var tutorName:String = ""
    
    /// tutor image url
    var tutorImageUrl:String = ""
    
    /// tutor reviews rating
    //    var tutorReviews:Int = 0
    
    /// selected tutor ID
    var tutorId:String = ""
    
    /// Question Model
    var questionModel : QuestionModel!
    
    /// Question ID
    var questionId:Int!
    
    /// Answer ID
    var answerId:Int!
    
    var cash: Double?
    var payPal: Double?
    var crediCard: Double?
    
    
    /// attributed string for chat
    var attributStrings = NSMutableArray()
    
  
    
    override func viewDidLoad() {
        detailview.controller = self
        detailview.viewdidload()
    }
    
    // Update deadline properly
    func refreshAndUpdateQuestionDeadline() {
        let params = ["token":token, "questions_id":self.questionModel.question_id]
        
        NetworkUI.sharedInstance.getDeadline(params, success: { (response) -> Void in
            if let result = response as? NSMutableDictionary {
                self.questionModel.deadline = result["deadline"] as! NSNumber
            }
            }) { (error) -> Void in
                TAOverlay.showOverlayWithLabel("Please try again", options: TAOverlayOptions.OverlaySizeRoundedRect|TAOverlayOptions.OverlayTypeWarning|TAOverlayOptions.AutoHide)
        }
    }
    
    func refreshquestion(){
        MediumProgressViewManager.sharedInstance.showProgressOnView(self)
        
        NetworkUI.sharedInstance.getQuestionDetail(["token": token, "question_id":NSNumber(integer: self.questionId)],
            success: { (response) -> Void in
                
                MediumProgressViewManager.sharedInstance.hideProgressView(self)
                
                self.questionDetail = response as? NSMutableDictionary
                
                var str = self.questionDetail!["title"] as! String
                
                self.detailview.lbTitle.text = str
                
                var strDetail = self.questionDetail!["withtags"] as! String
                
                
                var attrString = DDHTMLAttribute.attributedStringFromHTML(strDetail, normalFont: UIFont(name: "Open Sans", size: 14)!, boldFont: UIFont(name: "Open Sans", size: 14)!, italicFont: UIFont(name: "Open Sans", size: 14)!) as NSAttributedString
                
                self.detailview.questionattr = attrString
                
                
                self.detailview.mTableView.reloadData()
                self.detailview.tableViewScrollToBottom()
                
                //activity spinner deactivated
                
                self.detailview.showTitleViews()
                
                if(self.questionModel.accept["status"] as! NSNumber == 0){
                    
                    MediumProgressViewManager.sharedInstance.showProgressOnView(self)
                    
                    NetworkUI.sharedInstance.getBidList(["token": token, "questions_id":NSNumber(integer: self.questionId)],
                        success: { (response) -> Void in
                            
                            MediumProgressViewManager.sharedInstance.hideProgressView(self)
                            
                            
                            if let array = response as? NSArray {
                                var bidlist :[BidModel] = [BidModel]()
                                
                                if(array.count > 0){
                                    
                                    let arrayJSON = response as! NSArray
                                    for dic in arrayJSON{
                                        var model = BidModel(dic: dic as! NSDictionary)
                                        bidlist.append(model)
                                        //                TAOverlay.hideOverlay()
                                        
                                        
                                    }
                                    
                                    self.detailview.mFooterBidController.dataTutor = bidlist
                                    self.detailview.mFooterBidController.reloadBidList()
                                    self.detailview.mFooterBidController.view.hidden = false;
                                    
                                    //self.showBidGuidPopupview()
                                    self.detailview.mHowtoworks.hidden = true
                                    self.view.bringSubviewToFront(self.detailview.mHowtoworks)
                                    self.detailview.btnHowtoWorks.hidden = false
                                    
                                }else{
                                    self.detailview.btnHowtoWorks.hidden = true
                                    
                                }
                                
                                
                                
                            }else{
                                self.detailview.mHowtoworks.hidden = false;
                                
                                self.detailview.btnHowtoWorks.hidden = true
                            }
                            
                        }) { (error) -> Void in
                            
                            println(error)
                            
                            TAOverlay.showOverlayWithLabel("Please try again", options: TAOverlayOptions.OverlaySizeRoundedRect|TAOverlayOptions.OverlayTypeWarning|TAOverlayOptions.AutoHide)
                            
                    }
                    
                }else if(self.isWithdrwan == false && self.questionModel.paid == "1"){
                    self.detailview.mCompletedFooter.hidden = false
                    self.detailview.contraintTableBottom.constant = 0
                }
                
            }) { (error) -> Void in
                TAOverlay.showOverlayWithLabel("Please try again", options: TAOverlayOptions.OverlaySizeRoundedRect|TAOverlayOptions.OverlayTypeWarning|TAOverlayOptions.AutoHide)
                
        }
    }
    /**
    Adding observers listion when keyboard hides and appears
    */
    override func viewWillAppear(animated: Bool) {
        
        detailview.viewwillappear()
        
        
        
    }

    override func viewDidAppear(animated: Bool) {
        detailview.viewdidappear()
    }
    
    
    
    
    
    func openCompletedView(tutorName:String) {
        
        NetworkUI.sharedInstance.getAnswerDetail(["token": token,"answer_id":self.answerId],
            success: { (response) -> Void in
                
                MediumProgressViewManager.sharedInstance.hideProgressView(self)
                
                if response != nil {
                    self.answerDetail = response as? NSMutableDictionary
                    self.detailview.mTableView.reloadData()
                    self.detailview.tableViewScrollToBottom()
                    self.cash = response["cash"] as? Double
                    self.crediCard = response["stripe"] as? Double
                    self.payPal = response["paypal"] as? Double
                    
                    
                    let screenSize: CGRect = UIScreen.mainScreen().bounds
                    
                    //instantiate the receipt view
                    let popView = PaymentNotificationPopoverView.loadFromNibNamed("PaymentNotificationPopoverView", bundle: nil) as! PaymentNotificationPopoverView
                    
                    //set this controller as the delegate of the view. meaning this controller will be defining the functions defined in the view with the the code in the controller
                    popView.delegate = self.detailview
                    
                    popView.title = self.questionModel.title
                    popView.timeStamp = Double(self.questionModel.create_time)
                    popView.userName = tutorName
                    popView.price = self.questionModel.price
                    
                    if let stripe = self.answerDetail!.objectForKey("stripe") as? NSString {
                        popView.creditCard = stripe.doubleValue
                    }
                    if let balance = self.answerDetail!.objectForKey("cash") as? NSString {
                        popView.balance = balance.doubleValue
                    }
                    
                    if let paypal = self.answerDetail!.objectForKey("paypal") as? NSString {
                        popView.payPal = paypal.doubleValue
                    }
                    
                    
                    popView.initValue()
                    
                    
                    popView.frame = CGRectMake(0, 0, screenSize.width - 70, 430)
                    
                    self.lew_presentPopupView(popView, animation: LewPopupViewAnimationDrop.alloc())
                }
                
            }) { (error) -> Void in
               
                
        }
        
        
    }
    
    
    
    
    
    func getAnswerDetail(answerId:Int, userId:Int) {
        // answer user profile
        // get answer details
        
//        MediumProgressViewManager.sharedInstance.showProgressOnView(self)
        
//        NetworkUI.sharedInstance.getAnswerDetail(["token": token,"answer_id":answerId],
//            success: { (response) -> Void in
//                
//                MediumProgressViewManager.sharedInstance.hideProgressView(self)
//                
//                if response != nil {
//                    self.answerDetail = response as? NSMutableDictionary
//                    self.detailview.mTableView.reloadData()
//                    self.detailview.tableViewScrollToBottom()
//                    self.cash = response["cash"] as? Double
//                    self.crediCard = response["stripe"] as? Double
//                    self.payPal = response["paypal"] as? Double
//                }
//                
//            }) { (error) -> Void in
////                TAOverlay.showOverlayWithLabel("Please try again", options: TAOverlayOptions.OverlaySizeRoundedRect|TAOverlayOptions.OverlayTypeWarning|TAOverlayOptions.AutoHide)
//                
//        }
      
        // get discuss details
        
        //        TAOverlay.showOverlayWithLabel("Loading...", options: TAOverlayOptions.OverlaySizeRoundedRect|TAOverlayOptions.OverlayTypeActivityBlur)
        MediumProgressViewManager.sharedInstance.showProgressOnView(self)
        
        
        NetworkUI.sharedInstance.getDiscussions(["token": token,"answer_id":answerId],
            success: { (response) -> Void in
                
                if response != nil {
                    if response!.count == 0 {
                        self.discussDatas = NSMutableArray()
                    }
                    else {
                        self.discussDatas = NSMutableArray(array: (response as? NSArray)!)
                    }
                    
                    let arrayJSON = response as! NSArray
                    
                    for dict in arrayJSON{
                        
                        var str = String(format: "%@", (dict["withtags"] as? String)!)
                        
                        
                        //wrap the html with font and color
                        
                        var attrString = DDHTMLAttribute.attributedStringFromHTML(str, normalFont: UIFont(name: "Open Sans", size: 14)!, boldFont: UIFont(name: "Open Sans", size: 14)!, italicFont: UIFont(name: "Open Sans", size: 14)!) as NSAttributedString
                        self.attributStrings.addObject(attrString)
                        
                    }
                    if(self.questionModel.resolutionSolved == 1){
                        self.detailview.mCompletedFooter.hidden = false
                        self.detailview.contraintTableBottom.constant = 0
                    }else if(self.isWithdrwan == true){
                        self.detailview.mFooterAnsweredController.footerview.containerView.hidden = true
                        self.detailview.withdrawFooter.hidden = true
                    }else{
                        if(self.questionModel.paid == "1") {
                            self.detailview.mFooterAnsweredController.footerview.containerView.hidden = false
                        }else{
                            
                            
                            if(self.detailview.mFooterAnsweredController.overdue){
                                self.detailview.mFooterAnsweredController.view.hidden = false
                            }else{
                                self.detailview.mCompletedFooter.hidden = false
                                self.detailview.contraintTableBottom.constant = 0
                            }
                            
                        }
                    }
                    
                    
                    
                    
                    
                    self.detailview.showFooter = true
                    
                    
                    
                    self.detailview.contraintTableBottom.constant = self.detailview.mFooterAnsweredController.view.frame.size.height - 100
                    
                    MediumProgressViewManager.sharedInstance.hideProgressView(self)
                    
                    if(self.questionModel.paid == "1"){
                        self.detailview.contraintTableBottom.constant = 0
                    }else if(self.isWithdrwan == true){
                        self.detailview.contraintTableBottom.constant = 57
                    }
                    
                    self.detailview.mTableView.reloadData()
                    
                    self.detailview.tableViewScrollToBottom()
                    
                }
                
                
            }) { (error) -> Void in
                TAOverlay.showOverlayWithLabel("Please try again", options: TAOverlayOptions.OverlaySizeRoundedRect|TAOverlayOptions.OverlayTypeWarning|TAOverlayOptions.AutoHide)
                
        }
        
    }
    
    override func viewDidLayoutSubviews() {
        
        
        detailview.viewdidlayoutsubviews()
        
    }
    
    
    
    
    
    
    
    func respondToTapAvatarGesture(gesture: UITapGestureRecognizer){
        var storyboard = UIStoryboard(name: "Feed", bundle: nil)
        let profileViewController = storyboard.instantiateViewControllerWithIdentifier("Profile") as! ProfileViewController
        
        if(gesture.view?.tag == 1){
            profileViewController.selectedUserID = self.questionModel.owner_id //student
        }else{
            profileViewController.selectedUserID = self.tutorId // tutor
        }
        self.navigationController?.pushViewController(profileViewController, animated: true)
    }
    
    
    
    
    
    
    
    /**
    Removing observers listion when keyboard hides and appears, removing footerView
    */
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        detailview.viewdiddisappear()
    }
    
    
    func refreshDiscuss(){
        
        NetworkUI.sharedInstance.getDiscussions(["token": token,"answer_id":(self.questionModel.accept["answerid"] as! NSString).integerValue],
            success: { (response) -> Void in
                
                if response!.count == 0 {
                    self.discussDatas = NSMutableArray()
                    
                }
                else {
                    self.discussDatas = NSMutableArray(array: response as! NSArray)
                    
                }
                
                let temparray = NSMutableArray()
                
                let arrayJSON = response as! NSArray
                
                for dict in arrayJSON{
                    
                    
                    var str = String(format: "%@", (dict["withtags"] as? String)!)
                    
                    
                    //wrap the html with font and color
                    
                    var attrString = DDHTMLAttribute.attributedStringFromHTML(str, normalFont: UIFont(name: "Open Sans", size: 14)!, boldFont: UIFont(name: "Open Sans", size: 14)!, italicFont: UIFont(name: "Open Sans", size: 14)!) as NSAttributedString
                    
                    temparray.addObject(attrString)
                    
                }
                
                self.attributStrings.removeAllObjects()
                self.attributStrings.addObjectsFromArray(temparray as [AnyObject])
                
                self.detailview.mTableView.reloadData()
                self.detailview.tableViewScrollToBottom()
                
                MediumProgressViewManager.sharedInstance.hideProgressView(self)
                //					self.tableViewScrollToUp()
                
            }) { (error) -> Void in
                TAOverlay.showOverlayWithLabel("Please try again", options: TAOverlayOptions.OverlaySizeRoundedRect|TAOverlayOptions.OverlayTypeWarning|TAOverlayOptions.AutoHide)
                
        }
        
    }
    
    
    
    
    
    
    func onSubmit(message:String) {
        
        MediumProgressViewManager.sharedInstance.showProgressOnView(self)
        
        NetworkUI.sharedInstance.postTutorAnswerSubmit(["token": token,"questionid":self.questionId, "Answers":message],
            success: { (response) -> Void in
                
                MediumProgressViewManager.sharedInstance.hideProgressView(self)
                
                if let result = response as? NSDictionary {
                    
                    if (result["answered"] as! Int == 1) {
                        
                        self.detailview.mFooterTutorAnswerController.footerview.clearComment()
                        
                    }
                }
                
                
            }) { (error) -> Void in
                TAOverlay.showOverlayWithLabel("Please try again", options: TAOverlayOptions.OverlaySizeRoundedRect|TAOverlayOptions.OverlayTypeWarning|TAOverlayOptions.AutoHide)
                
        }
        
    }
    
    
    func onAnswer() {
        
        MediumProgressViewManager.sharedInstance.showProgressOnView(self)
        
        NetworkUI.sharedInstance.getTutorAnswerTaken(["token": token,"qid":self.questionId],
            success: { (response) -> Void in
                
                MediumProgressViewManager.sharedInstance.hideProgressView(self)
                
                if let result = response as? NSDictionary {
                    
                    if (result["taken"] as! Int == 1) {
                        
                        self.detailview.mFooterTutorAnswerController.footerview.setAnswered(true)
                        
                    }
                    
                }
                else {
                    // somebody already answered here
                    NSOperationQueue.mainQueue().addOperationWithBlock{
                        
                        let alertView = UIAlertView(title: "StudyPool", message: "Someone is already working on that question", delegate: nil, cancelButtonTitle: "OK")
                        alertView.show()
                        
                    }
                }
                
                
            }) { (error) -> Void in
                TAOverlay.showOverlayWithLabel("Please try again", options: TAOverlayOptions.OverlaySizeRoundedRect|TAOverlayOptions.OverlayTypeWarning|TAOverlayOptions.AutoHide)
                
        }
        
        
    }
    
    func onAccept() {
        
//        if answerDetail != nil {
        
            var vc = storyboard?.instantiateViewControllerWithIdentifier("AcceptQuestionVC") as! AcceptQuestionViewController
            
            vc.delegate = self;
            
            vc.answerId = (questionModel.accept["answerid"] as! NSString).integerValue
            vc.questionModel = questionModel
            vc.questionTitle = questionDetail!["title"] as! String
            vc.questionTimestamp = questionDetail!["create_time"] as! Double
            vc.tutorName = questionModel.accept["tutorusername"] as! String;
            vc.tutorImageUrl = questionModel.accept["tutoravatar"] as! String
            
            navigationController?.showViewController(vc, sender: self)
            
//        }
    }
    
    func onDecline() {
        
        var vc = storyboard?.instantiateViewControllerWithIdentifier("DeclineQuestionVC") as! DeclineQuestionViewController
        
        vc.questionId = questionId
        
        vc.questionTitle = questionDetail!["title"] as! String
        vc.questionTimestamp = questionDetail!["create_time"] as! Double
        vc.tutorName = questionModel.accept["tutorusername"] as! String;
        vc.tutorImageUrl = questionModel.accept["tutoravatar"] as! String
        vc.questionModel = questionModel
        
        navigationController?.showViewController(vc, sender: self)
    }
    
    func onInfo() {
        
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        let popView = AnsweredQuestionPopoverView.loadFromNibNamed("AnsweredQuestionPopoverView", bundle: nil) as! AnsweredQuestionPopoverView
        
        popView.question = nil
        popView.delegate = detailview
        
        popView.frame = CGRectMake(0, 0, screenSize.width - 70, 430)
        
        lew_presentPopupView(popView, animation: LewPopupViewAnimationDrop.alloc())
        
    }
    
    
    // MARK popup
    func openPopoverView(tutorName:String) {
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        let popView = PaymentNotificationPopoverView.loadFromNibNamed("PaymentNotificationPopoverView", bundle: nil) as! PaymentNotificationPopoverView
        
        popView.delegate = detailview
        
        popView.title = questionDetail!["title"] as? String
        popView.timeStamp = questionDetail!["create_time"] as? Double
        popView.userName = tutorName
        popView.price = questionModel.price
        isPaymentPopup = true
        //TODO: Fill with actual data
        popView.creditCard = crediCard
        popView.balance = cash
        popView.payPal = payPal
        
        popView.initValue()
        
        popView.frame = CGRectMake(0, 0, screenSize.width - 70, 430)
        
        self.lew_presentPopupView(popView, animation: LewPopupViewAnimationDrop.alloc())
    }
    
    func onComment(message:String) {
        
        var commentString = NSMutableAttributedString(string: message, attributes: [NSFontAttributeName: UIFont(name: "Open Sans", size: 14)!])
        commentString.addAttribute(NSForegroundColorAttributeName, value: UIColor.grayColor(), range: NSMakeRange(0, commentString.length))
        attributStrings.addObject(commentString)
        
        var myObject = NSDate()
        let timeSinceNow = myObject.timeIntervalSince1970
        
        let addedlocalmessage = [
            "create_time":String(format: "%f",timeSinceNow),
            "withtags":message,
            "sender":questionModel.owner_id,
            "attachment_img":[],
            "attachment_link":[]
        ]
        discussDatas?.addObject(addedlocalmessage)
        
        
        detailview.mTableView.reloadData()
        detailview.tableViewScrollToBottom()
        
        var parameters = Dictionary<String, String>() as NSDictionary
        
        if (isWithdrwan == false)
        {
            parameters = [
                "token": token,
                "answer_id":(questionModel.accept["answerid"] as! NSString).integerValue,
                "message":message
            ]
        }
            
        else if (isWithdrwan == true)
        {
            parameters = [
                "token": token,
                "answer_id":(questionModel.accept["answerid"] as! NSString).integerValue,
                "Appeal":message
            ]
            
        }
        
        MediumProgressViewManager.sharedInstance.showProgressOnView(self)
        NetworkUI.sharedInstance.postComment(parameters as! [String : AnyObject], success: { (response) -> Void in
            
            self.refreshDiscuss()
            
            
            
            }) { (error) -> Void in
                TAOverlay.showOverlayWithLabel("Please try again", options: TAOverlayOptions.OverlaySizeRoundedRect|TAOverlayOptions.OverlayTypeWarning|TAOverlayOptions.AutoHide)
                
        }
        
        
        
    }
    
    @IBAction func submitAction(sender: AnyObject) {
        
        self.onAccept()
        
    }
    
    func actpayment(type: String, finalprice:Float){
        
        let finalparameters = [
            "token": token,
            "answer_id":questionModel.accept["answerid"] as! String,
            "Pay[Money]":finalprice.description,
            "review_special":"18",
            "Transaction[0][money]":((self.questionModel.price as NSString).floatValue).description,
            "tip":finalprice.description,
            "Pay[pay_type]":type,
            "Creditcard[card_num]":"",
            "Billing":"",
            "stripe" : stripetoken,
            "paypal" : paypaltoken
            
        ]
        
        
        NetworkUI.sharedInstance.releaseFinalPayment(finalparameters, success: { (response) -> Void in
            MediumProgressViewManager.sharedInstance.hideProgressView(self)
            TAOverlay.showOverlayWithLabel("Success", options: TAOverlayOptions.OverlaySizeRoundedRect|TAOverlayOptions.OverlayTypeSuccess|TAOverlayOptions.AutoHide)
            self.navigationController?.popViewControllerAnimated(true)
            }, failure: { (error) -> Void in
                TAOverlay.showOverlayWithLabel("Please try again", options: TAOverlayOptions.OverlaySizeRoundedRect|TAOverlayOptions.OverlayTypeWarning|TAOverlayOptions.AutoHide)
                
        })
        
        
    }
    
    func gotopayment(price: Float){
        
        var paymentStoryboard = UIStoryboard(name: "Payment", bundle: nil)
        let paymentPayViewController = paymentStoryboard.instantiateViewControllerWithIdentifier("PaymentPayViewController") as! PaymentPayViewController
        paymentPayViewController.paymentprice = price
        paymentPayViewController.isFromQuestion = true
        
        self.navigationController?.pushViewController(paymentPayViewController, animated: true)
        
//        var paymentNav = UINavigationController(rootViewController: paymentPayViewController);
//        answerid = questionModel.accept["answerid"] as! String
//        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
//        var slidemenu = appDelegate.window?.rootViewController as! SlideMenuController
//        slidemenu.changeMainViewController(paymentNav, close: true)
    }
    
    
    func selectBid(bid:BidModel) {
        
        var vc = self.storyboard?.instantiateViewControllerWithIdentifier("ConfirmTutorViewController") as! ConfirmTutorViewController
        vc.tutorModel = bid
        vc.studentImageUrl = self.studentImageUrl
        vc.tutorImageUrl = bid.avatar
        vc.studentAvatar = (self.detailview.mTableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0)) as! QuestionDetailWithImageCell).ivAvatar.image
        vc.questionModel = self.questionModel
        vc.studentName = self.studentName
        
        self.navigationController?.showViewController(vc, sender: self)
    }
    
    func showBidGuidPopupview() {
        
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        let popView = HowTobidPopOverView.loadFromNibNamed("HowTobidPopOverView", bundle: nil) as! HowTobidPopOverView
        
        popView.delegate = self
        
        popView.frame = CGRectMake(0, 0, screenSize.width - 70, 430)
        
        self.lew_presentPopupView(popView, animation: LewPopupViewAnimationDrop.alloc())
    }
    
    func onDismiss() {
        lew_dismissPopupViewWithanimation(LewPopupViewAnimationDrop.alloc())
    }
    
    // MARK accepted Delgate
    func onPaymentRelease(tutorName: String) {
        
        openPopoverView(tutorName)
        
    }
    
    
    @IBAction func showHowToWorks(sender: AnyObject){
        self.showBidGuidPopupview()
    }
    
    @IBAction func titleAction(sender: UIButton) {
        var top:NSIndexPath = NSIndexPath(forRow: NSNotFound, inSection: 0)
        self.detailview.mTableView.scrollToRowAtIndexPath(top, atScrollPosition: UITableViewScrollPosition.Top, animated: true)
    }
    
    // Returns the y coordinate where the visible part of the controller's view starts,
    // taking into account the status bar and the navigation bar.
    func getTopHeight() -> CGFloat {
        var height:CGFloat = 0.0;
        height += UIApplication.sharedApplication().statusBarFrame.height;
        if let navController = self.navigationController {
            height += navController.navigationBar.frame.size.height;
        }
        return height;
    }
    
}

extension String {
    var html2AttributedString:NSAttributedString {
        return NSAttributedString(data: dataUsingEncoding(NSUTF8StringEncoding)!, options:[NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType, NSCharacterEncodingDocumentAttribute: NSUTF8StringEncoding], documentAttributes: nil, error: nil)!
    }
}

