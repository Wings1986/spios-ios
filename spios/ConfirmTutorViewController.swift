//
//  ConfirmTutorViewController.swift
//  spios
//
//  Created by MobileGenius on 6/29/15.
//  Copyright (c) 2015 Studypool. All rights reserved.
//

import UIKit
import Analytics



/// Bid discussion page
class ConfirmTutorViewController: UIViewController {
    
    
    @IBOutlet weak var confirmtutorview: ConfirmTutorView!
    
  	var IsPaymentClicked:Bool = false
    
    
    /// Array of discussion
    var dataArray :[DiscussionModel] = [DiscussionModel]()
    
    
    
    var studentAvatar: UIImage!

    
    
    // current student name
    var studentName : String?
    
    // current student image url
    var studentImageUrl : String?
    
    // current Tutor image url
    var tutorImageUrl : String?
    
    // current Tutor model
    var tutorModel : BidModel?
    
    // current Question Model
    var questionModel : QuestionModel?
    
    // array of Attribute String of discussion contents
    var attributStrings = NSMutableArray()
    
    var temptablebottom: CGFloat!
    var tempfooterbottom: CGFloat!
    
    
    
    
    
    //for testing, directly go to the segue
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        confirmtutorview.controller = self;
        confirmtutorview.viewdidload()
        
        
    }
    
    
    
    
    
	
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)
        
        confirmtutorview.viewwillappear()
    }
    /**
    Removing observers listion when keyboard hides and appears, removing footerView
    */
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        confirmtutorview.viewwilldisappear()
    }
    
    
    //MARK: Actions
    func actAccept(paytype:String){
        let paramters = [
            "token": token,
            "answer_id":self.tutorModel?.answer_id,
            "Mile[type_id]":paytype,
            "Creditcard[card_num]":cardnumber,
            "Billing":"",
            "stripe" : stripetoken,
            "paypal" : paypaltoken
        ]
        
        
        MediumProgressViewManager.sharedInstance.showProgressOnView(self)
        
        NetworkUI.sharedInstance.acceptTutor(paramters, success: { (response) -> Void in
            
            MediumProgressViewManager.sharedInstance.hideProgressView(self)
            
            let JSON = response as! NSDictionary
            
            
            if((JSON["error"]) != nil){
                self.gotopayment()
            }else{
                
                self.performSegueWithIdentifier("animation", sender: self)
                
                
            }
            
            }) { (error) -> Void in
                
                MediumProgressViewManager.sharedInstance.hideProgressView(self)
                
                println(error)
                TAOverlay.showOverlayWithLabel("We can not verify your payment", options: TAOverlayOptions.OverlaySizeRoundedRect|TAOverlayOptions.OverlayTypeError|TAOverlayOptions.AutoHide)
                self.gotopayment()
                
        }
        
        
    }
    
    func gotopayment(){
        self.view.userInteractionEnabled = true
        var paymentStoryboard = UIStoryboard(name: "Payment", bundle: nil)
        let paymentPayViewController = paymentStoryboard.instantiateViewControllerWithIdentifier("PaymentPayViewController") as! PaymentPayViewController
        paymentPayViewController.paymentprice = (globalPaymentPrice as NSString).floatValue
        paymentPayViewController.isFromQuestion = true
        self.navigationController?.pushViewController(paymentPayViewController, animated: true)
        answerid = tutorModel?.answer_id
    }
    
    
    
    /**
    Get discussion history from getDiscussions api and refresh tableview
    */
    
    func refreshDiscuss(){
        
        let parameters = [
            "token": token,
            "answer_id":self.tutorModel?.answer_id
        ]
        
        MediumProgressViewManager.sharedInstance.showProgressOnView(self)
        
        NetworkUI.sharedInstance.getDiscussions(parameters,
            success: { (response) -> Void in
                
                MediumProgressViewManager.sharedInstance.hideProgressView(self)
                
                self.dataArray.removeAll(keepCapacity: true)
                
                
                let arrayTemp = NSMutableArray()
                let arrayJSON = response as! NSArray
                for dic in arrayJSON{
                    var model = DiscussionModel(dic: dic as! NSDictionary)
                    self.dataArray.append(model)
                    
                    var str = String(format: "%@", (dic["withtags"] as? String)!)
                    
                    //wrap the html with font and color and make AttributeString array
                    
                    var attrString = DDHTMLAttribute.attributedStringFromHTML(str, normalFont: UIFont(name: "Open Sans", size: 14)!, boldFont: UIFont(name: "Open Sans", size: 14)!, italicFont: UIFont(name: "Open Sans", size: 14)!) as NSAttributedString
                    
                    let attributString = attrString
                    
                    arrayTemp.addObject(attributString)
                    TAOverlay.hideOverlay()
                    
                }
                
                self.attributStrings.removeAllObjects()
                self.attributStrings.addObjectsFromArray(arrayTemp as [AnyObject])
                
                self.confirmtutorview.tablview.reloadData()
                self.confirmtutorview.tableViewScrollToBottom()
                
            }) { (error) -> Void in
                MediumProgressViewManager.sharedInstance.hideProgressView(self)
                TAOverlay.showOverlayWithLabel("Please try again", options: TAOverlayOptions.OverlaySizeRoundedRect|TAOverlayOptions.OverlayTypeWarning|TAOverlayOptions.AutoHide)
        }
        
    }
    
    @IBAction func gotoProfile(sender: UIButton){
        var storyboard = UIStoryboard(name: "Feed", bundle: nil)
        let profileViewController = storyboard.instantiateViewControllerWithIdentifier("Profile") as! ProfileViewController
        
        profileViewController.selectedUserID = self.tutorModel?.owner_id // tutor
        self.navigationController?.pushViewController(profileViewController, animated: true)
        
        
    }
    
    @IBAction func onAccept(sender: UIButton){
        
        
        let paramters = [
            "token": token,
            "price": self.tutorModel?.price
        ]
        
        
        MediumProgressViewManager.sharedInstance.showProgressOnView(self)
        // Disable buttons
        self.view.userInteractionEnabled = false
        NetworkUI.sharedInstance.checkPaymentToken(paramters, success: { (response) -> Void in
            self.navigationController?.view.userInteractionEnabled = false
            
            MediumProgressViewManager.sharedInstance.hideProgressView(self)
            
            println(response)
            let JSON = response as! NSDictionary
            let returntype = JSON["type"] as! Int
            
            if(returntype == 1){
                self.actAccept("1")
            }else if(returntype == 2){
                self.actAccept("2")
            }else{
                if(stripetoken != ""){
                    self.actAccept("1")
                }else if(paypaltoken != ""){
                    self.actAccept("2")
                }else{
                    
                    
                    
                    TAOverlay.showOverlayWithLabel("Please add your payment method", options: TAOverlayOptions.OverlaySizeRoundedRect|TAOverlayOptions.OverlayTypeInfo|TAOverlayOptions.AutoHide)
                    
                    self.gotopayment()
                    
                }
            }
            
            
            }) { (error) -> Void in
                println(error)
                // Enable buttons
                self.view.userInteractionEnabled = true
                TAOverlay.showOverlayWithLabel("Please try again", options: TAOverlayOptions.OverlaySizeRoundedRect|TAOverlayOptions.OverlayTypeWarning|TAOverlayOptions.AutoHide)
        }
        
    }
    
    

        //MARK: BHDiscussBarDelegate, be called when user click send button
    func enteredMessage(message: String) {
        
        onComment(message)
        
        
    }
    
    /**
    1. add local message ( grey message )
    2. Call Post comment api
    3. call refreshDiscuss function
    */
    func onComment(message:String) {
        
        // add local grey message to the last of current discuss array
        var commentString = NSMutableAttributedString(string: message, attributes: [NSFontAttributeName: UIFont(name: "Open Sans", size: 14)!])
        commentString.addAttribute(NSForegroundColorAttributeName, value: UIColor.grayColor(), range: NSMakeRange(0, commentString.length))
        self.attributStrings.addObject(commentString)
        
        var myObject = NSDate()
        let timeSinceNow = myObject.timeIntervalSince1970
        
        let addedlocalmessage = [
            "create_time":String(format: "%f",timeSinceNow),
            "withtags":message,
            "sender":questionModel!.owner_id,
            "receiver":tutorModel!.owner_id,
            "discuss_id":"1",
            "description":message,
            "username":tutorModel!.tutorname,
            "avatar":"",
            "attachment_img":[],
            "attachment_link":[]
        ]
        
        var model = DiscussionModel(dic: addedlocalmessage as NSDictionary)
        dataArray.append(model)
        
        self.confirmtutorview.tablview.reloadData()
        self.confirmtutorview.tableViewScrollToBottom()
        
        // call postcomment api
        let parameters =  [
            "token": token,
            "answer_id":self.tutorModel?.answer_id,
            "message":message
        ]
        MediumProgressViewManager.sharedInstance.showProgressOnView(self)
        NetworkUI.sharedInstance.postComment(parameters, success: { (response) -> Void in
            
            MediumProgressViewManager.sharedInstance.hideProgressView(self)
            
            self.refreshDiscuss()
            
            
            
            }) { (error) -> Void in
                MediumProgressViewManager.sharedInstance.hideProgressView(self)
                TAOverlay.showOverlayWithLabel("Please try again", options: TAOverlayOptions.OverlaySizeRoundedRect|TAOverlayOptions.OverlayTypeWarning|TAOverlayOptions.AutoHide)
        }
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "animation") {
            // pass data to next view
            
            let animationController : ConfirmTutorAnimationViewController = segue.destinationViewController as! ConfirmTutorAnimationViewController
            animationController.left = self.studentAvatar
            animationController.right = confirmtutorview.avatar.image
            animationController.answer_id = self.tutorModel?.answer_id
            animationController.questionModel = self.questionModel
            animationController.tutorImageUrl = self.tutorImageUrl
            animationController.tutorName = self.tutorModel?.tutorname
            
        }
    }
    
}
