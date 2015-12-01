//
//  ConfirmTutorView.swift
//  spios
//
//  Created by MobileGenius on 10/12/15.
//  Copyright (c) 2015 Studypool. All rights reserved.
//

import UIKit

class ConfirmTutorView: UIView, UIGestureRecognizerDelegate, UITableViewDataSource,UITableViewDelegate, BHInputbarDelegate {
    
    var controller:ConfirmTutorViewController!

    @IBOutlet weak var titleView: UIView!
    @IBOutlet weak var messageView: UIView!
    @IBOutlet weak var buttonView: UIView!
    @IBOutlet weak var tablview: UITableView!
    
    @IBOutlet weak var lbUniversity: UILabel!
    @IBOutlet weak var lbMajor: UILabel!
    @IBOutlet weak var lbRating: UILabel!
    @IBOutlet weak var lblRating: UILabel!
    
    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var lbPrice: UILabel!
    @IBOutlet weak var lbHours: UILabel!
    @IBOutlet weak var lbTime: UILabel!
    @IBOutlet weak var avatar: UIImageView!
    
    @IBOutlet weak var textviewMarginConstraint: NSLayoutConstraint?
    
    var startLocation : CGPoint!
    
    var keyboardIsVisible :Bool = false
    
    var keyboardSize : CGRect!
    
    var tutorID : String?
    
    // Hidden Textview to calculate the each cell height
    var mTextView:UITextView?
    

    func viewdidload(){
        
        titleView.layer.shadowOpacity = 0.3
        titleView.layer.shadowColor = UIColor.blackColor().CGColor
        titleView.layer.shadowOffset = CGSizeMake(0.0,2.0)
        titleView.layer.masksToBounds = false
        titleView.layer.shadowRadius = 1.5
        
        mTextView = UITextView(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.width-18, 30))
        
        var strRating  = NSString(format: "%@", controller.tutorModel!.rating)
        var rating = strRating.floatValue as Float
        lblRating.text = String(format: "%.01f", rating)
        
        controller.automaticallyAdjustsScrollViewInsets = false
        
        
        var swipe:UISwipeGestureRecognizer = UISwipeGestureRecognizer(target:self, action:"dismissKeyboard")
        
        swipe.direction = UISwipeGestureRecognizerDirection.Down
        
        self.addGestureRecognizer(swipe)
        
        // add swipe down up to show/hide keyboard
        self.keyboardTriggerOffset = 57
        
        
        self.addKeyboardPanningWithFrameBasedActionHandler({ (keyboardFrameInView, opening, closing) -> Void in
            
            if(self.keyboardIsVisible == true){
                
                var different = keyboardFrameInView.origin.y - (self.frame.height - self.keyboardSize.height)
                if(self.keyboardSize.height - different < 70){
                    
                    self.textviewMarginConstraint?.constant = 70
                }else{
                    self.textviewMarginConstraint?.constant = self.keyboardSize.height - different
                }
                
                
            }
            
            }, constraintBasedActionHandler: nil)
        
        // add pan gesture to show detail date at right of tableview
        let panRecognizer = UIPanGestureRecognizer(target: self, action: "panDetected:")
        panRecognizer.delegate = self
        
        self.tablview.addGestureRecognizer(panRecognizer)
    }
    
    func viewwillappear(){
        
        // Show tutor information at top of tableview
        var date = NSDate(timeIntervalSince1970:controller.tutorModel!.created_time as Double)
        
        ImageLoader.sharedLoader.imageForUrl(controller.tutorModel!.avatar, imageview: avatar, completionHandler:{(image: UIImage?, url: String) in
            
        })
        avatar.layer.cornerRadius = avatar.frame.width / 2
        avatar.layer.masksToBounds = true
        
        lbName.text = controller.tutorModel!.tutorname
        
        
        
        lbPrice.text = String(format: "$%@", String((controller.tutorModel!.price as NSString)))
        lbTime.text = String(format: "%@ %@", controller.tutorModel!.deliverin, controller.tutorModel!.timetype)
        
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector :"keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
        
        MediumProgressViewManager.sharedInstance.showProgressOnView(controller)
        controller.refreshDiscuss()
        
    }
    
    func viewwilldisappear(){
        /* No longer listen for keyboard */
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func panDetected(gesture: UIPanGestureRecognizer){
        
        if gesture.state == UIGestureRecognizerState.Began{
            
            startLocation = gesture.locationInView(self.tablview)
            
            
        }
            // show date label at tableview
        else if gesture.state == UIGestureRecognizerState.Changed{
            
            let currentLocation = gesture.locationInView(self.tablview)
            let dx = abs(startLocation.x - currentLocation.x)
            let dy = abs(currentLocation.y - startLocation.y)
            
            let distance = sqrt(dx*dx + dy*dy)
            
            let realvalue = (distance / (((self.tablview.frame.width / 2) * 1.0) / 111)) / 6 * 4
            
            for cell in self.tablview.visibleCells(){
                
                if(cell.isKindOfClass(QuestionDetailWithImageCell)){
                    let visibleCell = cell as! QuestionDetailWithImageCell
                    visibleCell.timestampContraint.constant = realvalue - 111
                    //                    visibleCell.textviewRightContraint.constant = 8 + realvalue + 101
                    visibleCell.lbTimestamp.hidden = false
                }
                
            }
            
        }
            // hide date label when pan gesture is ended.
        else if gesture.state == UIGestureRecognizerState.Ended{
            for cell in self.tablview.visibleCells(){
                
                UIView.animateWithDuration(0.7, delay: 0.0, options: .CurveEaseOut, animations: {
                    
                    if(cell.isKindOfClass(QuestionDetailWithImageCell)){
                        
                        let visibleCell = cell as! QuestionDetailWithImageCell
                        visibleCell.timestampContraint.constant = -111
                        
                    }
                    }, completion: { finished in
                        
                })
                
            }
        }
        
    }
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    /**
    add done button to keyboard
    */
    func addDoneButtonToKeyboard(textView: AnyObject)
    {
        var toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: bounds.width, height: 44))
        var leftSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        var doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Done, target:self, action: Selector("hideKeyboard:"))
        toolbar.setItems([leftSpace, doneButton], animated: false)
        if textView.isKindOfClass(UITextField)
        {
            (textView as! UITextField).inputAccessoryView = toolbar
            return
        }
        (textView as! UITextView).inputAccessoryView = toolbar
    }
    
    func keyboardWillShow(notification:NSNotification){
        if let userInfo = notification.userInfo {
            if let keyboardSize = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.CGRectValue() {
                self.keyboardSize = keyboardSize
                self.keyboardIsVisible = true
            } else {
                // no UIKeyboardFrameBeginUserInfoKey entry in userInfo
            }
        } else {
            // no userInfo dictionary in notification
        }
        
        
        
        self.layoutIfNeeded()
        UIView.animateWithDuration(0.5, animations: {
            self.textviewMarginConstraint?.constant = self.keyboardSize.height
            self.tablview.layoutIfNeeded()
            self.tableViewScrollToBottom()
            
        })
        
    }
    
    func keyboardWillHide(notification:NSNotification){
        self.layoutIfNeeded()
        UIView.animateWithDuration(0.5, animations: {
            self.textviewMarginConstraint?.constant = 70
            self.tablview.layoutIfNeeded()
        })
        
        self.keyboardIsVisible = false
        
    }
    
    func expandingTextView(expandingTextView: BHExpandingTextView!, didChangeHeight height: Float) {
        self.tableViewScrollToBottom()
    }
    
    /**
    1. add local message ( grey message )
    2. Call Post comment api
    3. call refreshDiscuss function
    */
    func onComment(message:String) {
        
        controller.onComment(message)
        
    }
    
    //MARK: TableView Functions
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        //NSLog("%d",dataArray.count)
        return controller.dataArray.count + 1
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        //empty cell height for footer
        if(indexPath.row == controller.dataArray.count){
            return 60
        }
        
        
        //calculate the height of discussion cell
        mTextView?.frame = CGRectMake(47, 0, UIScreen.mainScreen().bounds.width-47, 30)
        mTextView?.attributedText = controller.attributStrings[indexPath.row] as! NSAttributedString
        let maxHeight : CGFloat = 10000
        
        let rect = mTextView?.sizeThatFits(CGSizeMake(UIScreen.mainScreen().bounds.width-100, maxHeight))
        
        var profileHeight = rect!.height - 10
        
        
        var strTime = controller.dataArray[indexPath.row].created_time as String
        var date = NSDate(timeIntervalSince1970: (strTime as NSString).doubleValue)
        
        if(indexPath.row > 0 && (controller.dataArray[indexPath.row].sender) == (controller.dataArray[indexPath.row-1].sender)){
            var prevTime = controller.dataArray[indexPath.row-1].created_time as String
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
        
        let photoarray = controller.dataArray[indexPath.row].attachment_img as NSArray
        let linkarray = controller.dataArray[indexPath.row].attachment_link as NSArray
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
            
            return profileHeight + CGFloat(75*rowCount) + 5
        }else{
            if(linkarray.count > 0){
                if(profileHeight < 0){
                    profileHeight = 20
                }
                return profileHeight + CGFloat(75*rowCount) + 5
            }else{
                if(profileHeight < 0){
                    profileHeight = 20
                }
                return profileHeight + 5
            }
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
        controller.navigationController?.pushViewController(profileViewController, animated: true)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        if(indexPath.row == controller.dataArray.count){
            
            var myObject: AnyObject = UITableViewCell()
            myObject.contentView.backgroundColor = UIColor(red: 247/255.0, green: 247/255.0, blue: 247/255.0, alpha: 1.0)
            
            return myObject as! UITableViewCell
        }
        let cell = tableView.dequeueReusableCellWithIdentifier("QuestionDetailWithImageCell", forIndexPath: indexPath) as! QuestionDetailWithImageCell
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        
        cell.viewcontroller = controller
        
        
        var tap = UITapGestureRecognizer(target: self, action: "respondToTapAvatarGesture:")
        var nameTap = UITapGestureRecognizer(target: self, action: "respondToTapAvatarGesture:")
        
        
        
        var sender = controller.dataArray[indexPath.row].sender
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        
        if (sender as NSString) != controller.questionModel?.owner_id {
            
            cell.ivAvatar.addGestureRecognizer(tap)
            cell.ivAvatar.userInteractionEnabled = true
            
            cell.lbName.addGestureRecognizer(nameTap)
            cell.lbName.userInteractionEnabled = true
            
            
            cell.lbName.text = controller.dataArray[indexPath.row].username
            if let url = NSURL(string: controller.dataArray[indexPath.row].avatar) {
                cell.ivAvatar.hnk_setImageFromURL(url)
            }
            tutorID = sender
            cell.ivAvatar.tag = 2 // tutor
            cell.lbName.tag = 2
            cell.backgroundColor = UIColor(red: 247/255.0, green: 247/255.0, blue: 247/255.0, alpha: 1.0)
            cell.ivMask.image = UIImage(named: "mask_light_rating")
            var strRating  = NSString(format: "%@", controller.tutorModel!.rating)
            var rating = strRating.floatValue as Float
            
            cell.lblRating.text = String(format: "%.01f", rating)
            cell.lblRating.hidden = true
            cell.ivMask.hidden = true
            
        } else {
            cell.lblRating.hidden = true
            cell.lbName.text = controller.studentName
            cell.lbCount.text = ""
            if let url = NSURL(string: controller.studentImageUrl!) {
                cell.ivAvatar.hnk_setImageFromURL(url)
            }
            cell.ivAvatar.tag = 1 // student
            cell.lbName.tag = 1
            cell.backgroundColor = UIColor(red: 247/255.0, green: 247/255.0, blue: 247/255.0, alpha: 1.0)
            cell.ivMask.hidden = true
        }
        
        
        var strTime = controller.dataArray[indexPath.row].created_time as String
        var date = NSDate(timeIntervalSince1970:
            (strTime as NSString).doubleValue)
        
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "hh:mm a" //format style. Browse online to get a format that fits your needs.
        var dateString = dateFormatter.stringFromDate(date)
        cell.lbTimestamp.text = dateString
        
        
        dateFormatter.dateFormat = "EEE MMM d hh:mm a" //format style. Browse online to get a format that fits your needs.
        dateString = dateFormatter.stringFromDate(date)
        
        if date.relativeTime.rangeOfString("ago") != nil{
            cell.lbMainTimestamp.text = dateString
        }else{
            cell.lbMainTimestamp.text = date.relativeTime
        }
        
        
        
        
        if(indexPath.row > 0){
            
            if((controller.dataArray[indexPath.row].sender as String) == (controller.dataArray[indexPath.row-1].sender as String)){
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
        
        if(indexPath.row > 0 && (controller.dataArray[indexPath.row].sender) == (controller.dataArray[indexPath.row-1].sender)){
            var prevTime = controller.dataArray[indexPath.row-1].created_time as String
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
        
        let photoarray = controller.dataArray[indexPath.row].attachment_img as NSArray
        let linkarray = controller.dataArray[indexPath.row].attachment_link as NSArray
        
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
            cell.bottomMarginConstraint?.constant = -10
            
        }
        
        cell.lbDesc.attributedText = controller.attributStrings[indexPath.row] as! NSAttributedString
        cell.lbDesc.textContainer.lineBreakMode = NSLineBreakMode.ByWordWrapping
        return cell;
    }
    
    func tableViewScrollToUp() {
        let offset = CGPoint(x: 0, y: 0)
        tablview.setContentOffset(offset, animated: true)
    }
    
    func tableViewScrollToBottom() {
        
        tableViewScrollToBottom(true)
    }
    
    func tableViewScrollToBottom(animated: Bool) {
        
        let delay = 0.1 * Double(NSEC_PER_SEC)
        let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
        
        dispatch_after(time, dispatch_get_main_queue(), {
            
            let numberOfSections = self.tablview.numberOfSections()
            let numberOfRows = self.tablview.numberOfRowsInSection(numberOfSections-1)
            
            if numberOfRows > 0 {
                let indexPath = NSIndexPath(forRow: numberOfRows-1, inSection: (numberOfSections-1))
                self.tablview.scrollToRowAtIndexPath(indexPath, atScrollPosition: UITableViewScrollPosition.Bottom, animated: animated)
            }
            
        })
    }

    
}
