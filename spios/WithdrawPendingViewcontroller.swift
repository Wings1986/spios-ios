//
//  ConfirmTutorViewController.swift
//  spios
//
//  Created by MobileGenius on 6/29/15.
//  Copyright (c) 2015 Studypool. All rights reserved.
//

import UIKit
import Analytics

/// Witdrahw PendingViewcontroller ( this view is merged with QuestionDetaillViewController, not used for now)
class WithdrawPendingViewcontroller: UIViewController,UITableViewDataSource,UITableViewDelegate, BHDiscussBarDelegate {
    
    @IBOutlet weak var titleView: UIView!
    @IBOutlet weak var messageView: UIView!
    @IBOutlet weak var buttonView: UIView!
    @IBOutlet weak var tablview: UITableView!
    @IBOutlet weak var discussBar: BHDiscussBar!
    
    @IBOutlet weak var button: UIButton!
    
    @IBOutlet weak var textviewMarginConstraint: NSLayoutConstraint?
    
    var dataArray :[DiscussionModel] = [DiscussionModel]()
    
    var keyboardSize : CGRect!
    
    var questionModel: QuestionModel!
    
    var answerId : String!
    
    
    var heightWebView = NSMutableDictionary()
    var mWebView:UIWebView?
    var heightImageView = NSMutableDictionary()
    
    var fromDeclinePage : Bool!
    
    var mTextView:UITextView?
    var attributStrings = NSMutableArray()
    
    
    var studentName : String?
    //    var studentImageUrl : String?
    //    var tutorModel : BidModel?
    var tutorID : String?
    // MARK: - View Setup
    override func viewDidLoad() {
        super.viewDidLoad()
        
        discussBar.delegate = self
        
        titleView.layer.shadowOpacity = 0.3
        titleView.layer.shadowColor = UIColor.blackColor().CGColor
        titleView.layer.shadowOffset = CGSizeMake(0.0,2.0)
        titleView.layer.masksToBounds = false
        titleView.layer.shadowRadius = 1.5
        
        mTextView = UITextView(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.width-18, 30))
        
        
        buttonView.layer.shadowOpacity = 0.3
        buttonView.layer.shadowColor = UIColor.blackColor().CGColor
        buttonView.layer.shadowOffset = CGSizeMake(0.0,-1.0)
        buttonView.layer.masksToBounds = false
        buttonView.layer.shadowRadius = 1.5
        
        self.automaticallyAdjustsScrollViewInsets = false
        

        button?.titleLabel?.lineBreakMode = NSLineBreakMode.ByWordWrapping;
        var swipe:UISwipeGestureRecognizer = UISwipeGestureRecognizer(target:self, action:"dismissKeyboard")
        
        swipe.direction = UISwipeGestureRecognizerDirection.Down
        
        self.view.addGestureRecognizer(swipe)
		addDoneButtonToKeyboard(mTextView!)
    }
    func dismissKeyboard(){
        self.mTextView!.resignFirstResponder()

    }
	
	func addDoneButtonToKeyboard(textView: AnyObject)
	{
		var toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 44))
		var leftSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
		var doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Done, target: self, action: Selector("hideKeyboard:"))
		toolbar.setItems([leftSpace, doneButton], animated: false)
		if textView.isKindOfClass(UITextField)
		{
			(textView as! UITextField).inputAccessoryView = toolbar
			return
		}
		(textView as! UITextView).inputAccessoryView = toolbar
	}
	func hideKeyboard(notification: AnyObject)
	{
		
		if mTextView!.isFirstResponder(){
			mTextView!.resignFirstResponder()
			return
		}
	}
	
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        
        //        var date = NSDate(timeIntervalSince1970:tutorModel!.created_time as Double)
        
        
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector :"keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
        
        let parameters = [
            "token": token,
            "answer_id":questionModel.accept["answerid"] as! String
        ]
//        TAOverlay.showOverlayWithLabel("Loading...", options: TAOverlayOptions.OverlaySizeRoundedRect|TAOverlayOptions.OverlayTypeActivityBlur)
        MediumProgressViewManager.sharedInstance.showProgressOnView(self)
        
        NetworkUI.sharedInstance.getDiscussions(parameters,
            success: { (response) -> Void in
                
                self.dataArray.removeAll(keepCapacity: true)
                
                let arrayJSON = response as! NSArray
                
                for dic in arrayJSON{
                    
                    var model = DiscussionModel(dic: dic as! NSDictionary)
                    
                    self.dataArray.append(model)
                    //                TAOverlay.hideOverlay()
                    var str = dic["withtags"] as? String
                    
                    //wrap the html with font and color
                    let finalString = String(format: "<html><head><style type=\"text/css\">\nbody {font-family: \"%@\"; font-size: %@; color:#%@;}\n</style></head><body>%@</body></html>",
                        "Open Sans", "14", "000000", str!);
                    
                    let attributString = finalString.html2AttributedString as NSAttributedString
                    self.attributStrings.addObject(attributString)
                    
                    
                }
                
//                TAOverlay.hideOverlay()
                MediumProgressViewManager.sharedInstance.hideProgressView(self)
                
                self.tablview.reloadData()
            }) { (error) -> Void in
                MediumProgressViewManager.sharedInstance.hideProgressView(self)
                println(error)
                TAOverlay.hideOverlay()
                
        }
    }
    /**
    Removing observers listion when keyboard hides and appears, removing footerView
    */
    override func viewWillDisappear(animated: Bool) {
        if(fromDeclinePage == true){
            //            self.navigationController?.popViewControllerAnimated(false)
            super.viewWillDisappear(animated)
            
            self.navigationController?.popToRootViewControllerAnimated(true)
            
            return;
        }
        
        
        super.viewWillDisappear(animated)
        
        /* No longer listen for keyboard */
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
        
        
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    
    // MARK: - Actions
    func onComment(message:String) {
        
        let parameters = [
            "token": token,
            "answer_id":questionModel.accept["answerid"] as! String,
            "Appeal":message
        ]
        
        //println(self.tutorModel?.answer_id)
        MediumProgressViewManager.sharedInstance.showProgressOnView(self)
        NetworkUI.sharedInstance.postComment(parameters, success: { (response) -> Void in
            MediumProgressViewManager.sharedInstance.hideProgressView(self)
            
            let parameters = [
                "token": token,
                "answer_id":self.questionModel.accept["answerid"] as! String
            ]
            

            
            
            MediumProgressViewManager.sharedInstance.showProgressOnView(self)
            NetworkUI.sharedInstance.getDiscussions(parameters,
                success: { (response) -> Void in
                    MediumProgressViewManager.sharedInstance.hideProgressView(self)
                    self.dataArray.removeAll(keepCapacity: true)
                    
                    let arrayJSON = response as! NSArray
                    
                    let arrayTemp = NSMutableArray()
                    for dic in arrayJSON{
                        var model = DiscussionModel(dic: dic as! NSDictionary)
                        self.dataArray.append(model)
                        
                        var str = dic["withtags"] as? String
                        
                        //wrap the html with font and color
                        let finalString = String(format: "<html><head><style type=\"text/css\">\nbody {font-family: \"%@\"; font-size: %@; color:#%@;}\n</style></head><body>%@</body></html>",
                            "Open Sans", "14", "000000", str!);
                        
                        let attributString = finalString.html2AttributedString as NSAttributedString
                        arrayTemp.addObject(attributString)
                        TAOverlay.hideOverlay()
                        
                    }
                    
                    self.attributStrings.addObjectsFromArray(arrayTemp as [AnyObject])
                    
                    self.tablview.reloadData()
                    self.tableViewScrollToBottom()
                }) { (error) -> Void in
                    MediumProgressViewManager.sharedInstance.hideProgressView(self)
            }
            
            }) { (error) -> Void in
                MediumProgressViewManager.sharedInstance.hideProgressView(self)
                
                
        }
        
    }
    
    @IBAction func submitAction(sender: AnyObject) {
        
        //        TAOverlay.showOverlayWithLabel("Please wait...", options: TAOverlayOptions.OverlaySizeRoundedRect|TAOverlayOptions.OverlayTypeActivityBlur)
        MediumProgressViewManager.sharedInstance.showProgressOnView(self)
        
        var addOnValue = 0.00
        if (qUrgent == true)
        {
            addOnValue += 2.85
        }
        if (qPrivate == true)
        {
            addOnValue += 2.85
        }
        
        //        var finalValue = (self.questionModel.price as NSString).floatValue / 10.0 + Float(addOnValue)
        var finalValue = Float(addOnValue)
        
        let checkparamters = [
            "token": token,
            "price": self.questionModel.price
        ]
        MediumProgressViewManager.sharedInstance.showProgressOnView(self)
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
                    MediumProgressViewManager.sharedInstance.hideProgressView(self)
                    TAOverlay.showOverlayWithLabel("We can't verify your payment, Please add your payment method", options: TAOverlayOptions.OverlaySizeRoundedRect|TAOverlayOptions.OverlayTypeInfo|TAOverlayOptions.AutoHide)
                    
                    self.gotopayment(finalValue)
                }
            }
            
            
            
            
            }) { (error) -> Void in
                MediumProgressViewManager.sharedInstance.hideProgressView(self)
                println(error)
                
                
        }
        
        
        
        
    }
    
    
    func gotopayment(price: Float){
        
        var paymentStoryboard = UIStoryboard(name: "Payment", bundle: nil)
        let paymentPayViewController = paymentStoryboard.instantiateViewControllerWithIdentifier("PaymentPayViewController") as! PaymentPayViewController
        paymentPayViewController.paymentprice = price
        paymentPayViewController.isFromWithdraw = true
        
        var paymentNav = UINavigationController(rootViewController: paymentPayViewController);
        answerid = questionModel.accept["answerid"] as! String
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        var slidemenu = appDelegate.window?.rootViewController as! SlideMenuController
        slidemenu.changeMainViewController(paymentNav, close: true)
    }
    
    func actpayment(type: String, finalprice:Float){
        
        let finalparameters = [
            "token": token,
            "answer_id":questionModel.accept["answerid"] as! String,
            "Pay[Money]":finalprice.description,
            "review_special":"18",
            "Transaction[0][money]":((self.questionModel.price as NSString).floatValue).description,
            "tip":finalprice.description,
            "Pay[type_id]":type,
            "Creditcard[card_num]":"",
            "Billing":"",
            "stripe" : stripetoken,
            "paypal" : paypaltoken
            
        ]
        
        
        MediumProgressViewManager.sharedInstance.showProgressOnView(self)
        NetworkUI.sharedInstance.releaseFinalPayment(finalparameters, success: { (response) -> Void in
            MediumProgressViewManager.sharedInstance.hideProgressView(self)
            TAOverlay.showOverlayWithLabel("Success", options: TAOverlayOptions.OverlaySizeRoundedRect|TAOverlayOptions.OverlayTypeSuccess|TAOverlayOptions.AutoHide)
            
            var qdSB:UIStoryboard = UIStoryboard(name: "Question_detail", bundle: nil)
            
            let applicationDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            
            if let questionDetailController = qdSB.instantiateViewControllerWithIdentifier("QuestionDetailViewController") as? QuestionDetailViewController {
                questionDetailController.questionId = self.questionModel.question_id.toInt()
                questionDetailController.questionModel = self.questionModel
                questionDetailController.studentName = applicationDelegate.userlogin.username
                questionDetailController.studentImageUrl = self.questionModel.avatar
                self.questionModel.withdrawed = "0"
                self.questionModel.paid = "1"
                
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
                println("------------------")
                println(qUrgent)
                println(qPrivate)
                
                if(self.questionModel.accept["status"] as! NSNumber == 1){
                    
                    questionDetailController.answerId = (self.questionModel.accept["answerid"] as! NSString).integerValue
                    
                }
                
                let vcArray = self.navigationController?.viewControllers
                var newVcArray = NSMutableArray()
                newVcArray.addObject(vcArray![0])
                newVcArray.addObject(questionDetailController)
                self.navigationController?.setViewControllers(newVcArray as [AnyObject], animated: true)
                
            }
            
            }, failure: { (error) -> Void in
                
        })
        
        
    }
    
    
    //MARK: BHDiscussBarDelegate
    func enteredMessage(message: String) {
        
        onComment(message)
        
    }
    
    // MARK: - Keyboard functions
    func keyboardWillShow(notification:NSNotification){
        if let userInfo = notification.userInfo {
            if let keyboardSize = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.CGRectValue() {
                self.keyboardSize = keyboardSize
            } else {
                // no UIKeyboardFrameBeginUserInfoKey entry in userInfo
            }
        } else {
            // no userInfo dictionary in notification
        }
        
        
        
        self.view.layoutIfNeeded()
        UIView.animateWithDuration(0.5, animations: {
            self.textviewMarginConstraint?.constant = self.keyboardSize.height - 70
            self.tablview.layoutIfNeeded()
            self.messageView.layoutIfNeeded()
            self.tableViewScrollToBottom()
        })
        
    }
    
    func keyboardWillHide(notification:NSNotification){
        self.view.layoutIfNeeded()
        UIView.animateWithDuration(0.5, animations: {
            self.textviewMarginConstraint?.constant = 0
            self.tablview.layoutIfNeeded()
            self.messageView.layoutIfNeeded()
        })
        
    }
    // MARK: - tableView Functions
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        //NSLog("%d",dataArray.count)
        return dataArray.count
        
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        var str = self.dataArray[indexPath.row].withtags
        
        let finalString = String(format: "<html><head><style type=\"text/css\">\nbody {font-family: \"%@\"; font-size: %@; color:#%@;}\n</style></head><body>%@</body></html>",
            "Open Sans", "14", "000000", str);
        
        mTextView?.frame = CGRectMake(0, 0, UIScreen.mainScreen().bounds.width-18, 30)
        mTextView?.attributedText = attributStrings[indexPath.row] as! NSAttributedString
        mTextView?.sizeToFit()
        
        
        var profileHeight = mTextView!.frame.height
        
        if(indexPath.row > 0){
            if(dataArray[indexPath.row].sender == dataArray[indexPath.row-1].sender){
                profileHeight = profileHeight - 70
            }else{
                
            }
        }
        
        let photoarray = dataArray[indexPath.row].attachment_img as NSArray
        let linkarray = dataArray[indexPath.row].attachment_link as NSArray
        if (photoarray.count > 0 || linkarray.count > 0){
            
            return 76 + profileHeight + 75
        }else{
            return 76 + profileHeight + 10
        }
        
    }
    
    func respondToTapAvatarGesture(gesture: UITapGestureRecognizer){
        var storyboard = UIStoryboard(name: "Feed", bundle: nil)
        let profileViewController = storyboard.instantiateViewControllerWithIdentifier("Profile") as! ProfileViewController
        
        if(gesture.view?.tag == 1){
            profileViewController.selectedUserID = String(user_id) //student
        }else{
            profileViewController.selectedUserID = tutorID // tutor
        }
        self.navigationController?.pushViewController(profileViewController, animated: true)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("QuestionDetailWithImageCell", forIndexPath: indexPath) as! QuestionDetailWithImageCell
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        if (indexPath.row % 2 == 0) {
            cell.backgroundColor = UIColor(red: 240/255.0, green: 240/255.0, blue: 240/255.0, alpha: 1.0)
        } else {
            cell.backgroundColor = UIColor.whiteColor()
        }
        
        cell.viewcontroller = self
        
        
        var tap = UITapGestureRecognizer(target: self, action: "respondToTapAvatarGesture:")
        
        cell.ivAvatar.addGestureRecognizer(tap)
        cell.ivAvatar.userInteractionEnabled = true
        
        
        var sender = dataArray[indexPath.row].sender
        if (sender as NSString).integerValue != user_id {
            cell.lbName.text = dataArray[indexPath.row].username
            if let url = NSURL(string: dataArray[indexPath.row].avatar) {
                cell.ivAvatar.hnk_setImageFromURL(url)
            }
            tutorID = sender
            cell.ivAvatar.tag = 2 // tutor
            cell.lbName.tag = 2
            cell.backgroundColor = UIColor(red: 245/255.0, green: 245/255.0, blue: 243/255.0, alpha: 1.0)
            
        } else {
            cell.lbName.text = self.studentName
            cell.lbCount.text = ""
            if let url = NSURL(string: questionModel.avatar) {
                cell.ivAvatar.hnk_setImageFromURL(url)
            }
            cell.ivAvatar.tag = 1 // student
            cell.lbName.tag = 1
            cell.backgroundColor = UIColor(red: 231/255.0, green: 231/255.0, blue: 226/255.0, alpha: 1.0)
        }
        
        var strTime = dataArray[indexPath.row].created_time
        var date = NSDate(timeIntervalSince1970: (strTime as NSString).doubleValue)
        cell.lbTimestamp.text = date.relativeTime
        
        var str = dataArray[indexPath.row]._description
        
        
        //wrap the html with font and color
        cell.lbDesc.attributedText = attributStrings[indexPath.row] as! NSAttributedString
        
        if(indexPath.row > 0){
            
            if((dataArray[indexPath.row].sender as String) == (dataArray[indexPath.row-1].sender as String)){
                cell.profileview.hidden = true
                cell.topMarginConstraint?.constant = 15
                
            }else{
                
                
                cell.profileview.hidden = false
                cell.topMarginConstraint?.constant = 73
                
            }
            
        }else{
            
            cell.topMarginConstraint?.constant = 73
            cell.profileview.hidden = false
        }
        
        let photoarray = dataArray[indexPath.row].attachment_img as NSArray
        let linkarray = dataArray[indexPath.row].attachment_link as NSArray
        if (photoarray.count > 0 || linkarray.count > 0){
            cell.photoArray = photoarray
            cell.linkArray = linkarray
            cell.imvCamera.hidden =  true
            cell.imageCollection.hidden = false
            cell.imageCollection.reloadData()
            cell.constraintImageHeight.constant = 65
            
            //                    cell.imageCollection.transform = CGAffineTransformMakeTranslation(0, 30)
        }else{
            cell.imvCamera.hidden =  true
            cell.imageCollection.hidden = true
            cell.constraintImageHeight.constant = 0
        }
        
//        cell.lbDetail.loadHTMLString(finalString, baseURL: nil)
        
        
        return cell;
    }
    
    
    
    
    func tableViewScrollToUp() {
        let offset = CGPoint(x: 0, y: 0)
        tablview.setContentOffset(offset, animated: true)
    }
    
    func tableViewScrollToBottom() {
        
        if tablview.contentSize.height > tablview.frame.size.height
        {
            let offset = CGPoint(x: 0, y: tablview.contentSize.height - tablview.frame.size.height)
            tablview.setContentOffset(offset, animated: true)
        }
    }
    
    
}
