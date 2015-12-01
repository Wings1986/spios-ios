//
//  FeedViewController.swift
//  spios
//
//  Created by Stanley Chiang on 3/7/15.
//  Copyright (c) 2015 Stanley Chiang. All rights reserved.
//

import UIKit
import FRDLivelyButton
import Analytics


/// Question List Page
class FeedViewController: UIViewController, UITextFieldDelegate, OverlayviewDelegate, AnsweredQuestionPopoverViewDelegate, WelcomeUserPopoverViewDelegate {
    
//    @IBOutlet weak var tableViewFooter: MyFooter!
    
    /// avatar image
    var avatarImage: UIImage!
    var test:NSDictionary!
    var newthing = [NSDictionary]()
    
    //loading sign for scrolling
    /// current page index
    var nPage:Int!
    //checks if "search mode" has been activated
	var searchModeOn = false
    
    
    var showedPop:Bool = false
    
    /// async task Id for search typing
    var currentTaskId:Int!

    let LOADMORE_HEIGHT:CGFloat = 60
    
    /// AppDelegate
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    /// last query item counts
    var lastCounts:Int = 0
    

    /// Question model array
    var dataArray :[QuestionModel] = [QuestionModel]()
    
    /// question model filtered array
    var questionArray:[QuestionModel] = [QuestionModel]()
    
    //check if the person has scrolled to the bottom and is loading 
	var isOnLoadForSure = false
    
    var backIsTouched = false
    /// keyboard size
    var keyboardSize : CGRect!
    var x = 0
    
    let blueColor = UIColor(netHex: 0x2ABFFF)
    let greyColor = UIColor(netHex: 0xBBBBBB)
    
    var isKeyboardShown = false
    
    
    /// close button
    @IBOutlet weak var feedview: FeedView!
    
    //MARK: View Setup
    override func viewDidLoad() {
        super.viewDidLoad()
        
        feedview.controller = self

        nPage = 1
        
        var nav = self.navigationController?.navigationBar
        nav?.tintColor = blueColor
        nav?.titleTextAttributes = [NSFontAttributeName : UIFont(name: "Armonioso", size: 20)!,NSForegroundColorAttributeName: blueColor]
        
        //SHADOW
        nav?.layer.shadowOpacity = 0.3
        nav?.layer.shadowColor = UIColor.blackColor().CGColor
        nav?.layer.shadowOffset = CGSizeMake(0.0,3.0)
        nav?.layer.masksToBounds = false
        nav?.layer.shadowRadius = 2.5

        self.currentTaskId = 1;
        
        
        
        let params = ["token": token]
        // Identify user
        NetworkUI.sharedInstance.getIdentifyUser(params, success: { (result) -> Void in
            
            //            var response:NSMutableDictionary = result! as! NSMutableDictionary
            
            
            }, failure: { (error) -> Void in
                
        })
        
        feedview.initview()
       
    }

    override func viewWillDisappear(animated: Bool) {
        NSNotificationCenter.defaultCenter().removeObserver(self)
//        tfSearch.resignFirstResponder()
    }
    
    func onShowPopup(popuptype:Int, popupdetail:String) {
        
        if(popuptype == 2){
            return;
        }
        
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        if(popuptype == 1){
            let popView = WelcomeBackPopoverView.loadFromNibNamed("WelcomeBackPopoverView", bundle: nil) as! WelcomeBackPopoverView
            
            popView.frame = CGRectMake(0, 0, screenSize.width - 70, 430)
            
            self.lew_presentPopupView(popView, animation: LewPopupViewAnimationDrop.alloc())
        }else{
            
            let popView = ReferralBonusPopoverView.loadFromNibNamed("HowTobidPopOverView", bundle: nil) as! HowTobidPopOverView
            
            popView.frame = CGRectMake(0, 0, screenSize.width - 70, 430)
//            popView.signupTitle.text = popupdetail
//            popView.signupTitle.hidden = false
            self.lew_presentPopupView(popView, animation: LewPopupViewAnimationDrop.alloc())
        }
        
    }
    func openWelcomePopup() {
        let popView = WelcomeUserPopoverView.loadFromNibNamed("WelcomeUserPopoverView", bundle: nil) as! WelcomeUserPopoverView
        
        popView.delegate = self
        
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        popView.frame = CGRectMake(0, 0, screenSize.width - 70, 430)
        
        self.lew_presentPopupView(popView, animation: LewPopupViewAnimationDrop.alloc())
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if (appDelegate.bFirstSign) {
            appDelegate.bFirstSign = false;
            self.openWelcomePopup()
        }
//        self.onShowPopup(0, popupdetail: "test")
        
       self.setNavigationBarItem()
        
        if (feedview.searchView.hidden == true)
        {
            refreshQuestions()
            
        }
        
        else
        {
            processSearchType(feedview.tfSearch.text)
        }
        
        
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
        

    }
    
    
    
    //MARK: Actions
    func backTapped(){
        
        backIsTouched = true
        
        refreshQuestions()
        feedview.tableView.reloadData()
        UIView.animateWithDuration(0.5, animations: {
            self.feedview.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
            self.feedview.tableView.layoutIfNeeded()
        })
        
        searchModeOn = false
        
        feedview.hideSearchBar()
    }
    
    
    /**
    handle refresh for tableview
    */
    func handleRefresh(refreshControl: UIRefreshControl) {
        
        if (feedview.searchView.hidden == true)
        {
            // self.tfSearch.text = ""
            let version = NSBundle.mainBundle().infoDictionary?["CFBundleShortVersionString"] as! String
            let parameters = [
                "token": token,
                "refresh_all":String(format:"%d",nPage),
                "version":version
            ]
            
            //activity spinner activated
            UIApplication.sharedApplication().networkActivityIndicatorVisible = true
            MediumProgressViewManager.sharedInstance.showProgressOnView(self)
            NetworkUI.sharedInstance .getMyQuestions(parameters, success: { (response) -> Void in
                
                self.questionArray.removeAll(keepCapacity: true)
                self.dataArray.removeAll(keepCapacity: true)
                
                
                let arrayJSON = response as! NSArray
                for dic in arrayJSON{
                    var model = QuestionModel(dic: dic as! NSDictionary)
                    self.dataArray.append(model)
                    self.feedview.noQs.hidden = true
                    self.feedview.lookDownToStart.hidden = true
                }
                self.questionArray = self.dataArray
                
                self.feedview.tableView.reloadData()
                //activity spinner deactivated
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                MediumProgressViewManager.sharedInstance.hideProgressView(self)
                refreshControl.endRefreshing()
                
                
                
                }) { (error) -> Void in
                    
                    MediumProgressViewManager.sharedInstance.hideProgressView(self)
                    refreshControl.endRefreshing()
                    TAOverlay.showOverlayWithLabel("Please try again", options: TAOverlayOptions.OverlaySizeRoundedRect|TAOverlayOptions.OverlayTypeWarning|TAOverlayOptions.AutoHide)
            }
            
        }else{
            processSearchType(feedview.tfSearch.text)
            
        }
        
    }
    
    /**
    call GetmyQuestions api to refresh
    */
    func refreshQuestions(){
        
        let version = NSBundle.mainBundle().infoDictionary?["CFBundleShortVersionString"] as! String
        
        let parameters = [
            "token": token,
            "refresh_all":String(format:"%d",nPage),
            "version":version
        ]
        
        //activity spinner activated
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        
        MediumProgressViewManager.sharedInstance.showProgressOnView(self)
        
        NetworkUI.sharedInstance .getMyQuestions(parameters, success: { (response) -> Void in
            
            self.questionArray.removeAll(keepCapacity: true)
            self.dataArray.removeAll(keepCapacity: true)
            
            let arrayJSON = response as! NSArray
            
            for dic in arrayJSON{
                
                var model = QuestionModel(dic: dic as! NSDictionary)
                
                //now, if the question is overdue, go directly to that question.
                
                var nowDouble = NSDate().timeIntervalSince1970
                
                if (nowDouble > model.deadline.doubleValue && model.paid == "0" && model.withdrawed == "0" && model.accept["status"] as! NSNumber == 1) {
                    
                    //if not kowai's account
                    if (model.owner_id != "156226" && model.deadline.doubleValue <= (-86400 * 2))
                    {
                        
                        self.questionArray.removeAll(keepCapacity: true)
                        self.dataArray.removeAll(keepCapacity: true)
                        self.enterQuestionDetail(model, isWithdrawn: false)
                        return
                        
                    }
                    
                }
                
                
                self.dataArray.append(model)
            }
            
            self.questionArray = self.dataArray
            
            if (self.questionArray.count == 0)
            {
                self.feedview.noQs.hidden = false
                self.feedview.lookDownToStart.hidden = false
                self.feedview.noQs.image = UIImage(named: "img_noQs")
                self.feedview.lookDownToStart.image = UIImage(named: "img_dropForNoQs")
                
            }
            else {
                self.feedview.noQs.hidden = true
                self.feedview.lookDownToStart.hidden = true
                
            }
            
            self.lastCounts = self.dataArray.count
            
            self.feedview.tableView.reloadData()
            
            //activity spinner deactivated
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            
            MediumProgressViewManager.sharedInstance.hideProgressView(self)
            
            
            
            }) { (error) -> Void in
                
                MediumProgressViewManager.sharedInstance.hideProgressView(self)
                TAOverlay.showOverlayWithLabel("Please try again", options: TAOverlayOptions.OverlaySizeRoundedRect|TAOverlayOptions.OverlayTypeWarning|TAOverlayOptions.AutoHide)
        }
    }
    
    /**
    check there is reminder in Question array
    */
    func checkReminder(question: QuestionModel)
    {
        
        
        var nowDouble = NSDate().timeIntervalSince1970
        
        
        if ( nowDouble > question.deadline.doubleValue && question.paid == "0" && question.withdrawed == "0" && question.accept["status"] as! NSNumber == 1) {
            println ("DEADLINE: ")
            println (question.deadline.doubleValue)
            if (question.deadline as Double) <= (-86400 * 2){
                println (" inside!")
                self.openPopoverView(question);
            }
            
            
            return;
        }
        
    }
    
    
    
    /**
    Load more( call GetmyQuestions with pageindex++
    */
    
    func loadMore()
    {
        
        MediumProgressViewManager.sharedInstance.showProgressOnView(self)
        if(self.lastCounts < 10){
            return
        }
        
        isOnLoadForSure = true
        nPage = nPage + 1
        getMyQuestions()
        isOnLoadForSure = false
    }
    
    
    
    
    
    /**
    open left menu
    */
    @IBAction func menuButtonTouched(sender: AnyObject) {
        self.findHamburguerViewController()?.showMenuViewController()
        
    }
    
    /**
    Get Question list with page index
    */
    
    func getMyQuestions(){
        
        let version = NSBundle.mainBundle().infoDictionary?["CFBundleShortVersionString"] as! String
        
        let parameters = [
            "token": token,
            "page":String(format:"%d",nPage),
            "version":version
        ]
        
        //activity spinner activated
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        if(isOnLoadForSure == false){
            MediumProgressViewManager.sharedInstance.hideProgressView(self)
        }
        NetworkUI.sharedInstance .getMyQuestions(parameters, success: { (response) -> Void in
            let arrayJSON = response as! NSArray
            for dic in arrayJSON{
                var model = QuestionModel(dic: dic as! NSDictionary)
                self.dataArray.append(model)
                //                TAOverlay.hideOverlay()
                self.x = 1
                self.lastCounts++
                
            }
            
            self.lastCounts = self.dataArray.count
            println("LASTCOUNTS:\(self.lastCounts)")
            self.questionArray = self.dataArray
            //            self.dataArray = self.dataArrayWithFilter(self.tfSearch.text, originArray: self.questionArray)
            self.feedview.tableView.reloadData()

            //activity spinner deactivated
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            MediumProgressViewManager.sharedInstance.hideProgressView(self)
            
            
            
            }) { (error) -> Void in
                MediumProgressViewManager.sharedInstance.hideProgressView(self)
                TAOverlay.showOverlayWithLabel("Please try again", options: TAOverlayOptions.OverlaySizeRoundedRect|TAOverlayOptions.OverlayTypeWarning|TAOverlayOptions.AutoHide)
        }
    }
    
    
    
    /**
    Enter Create question screen
    */
    
    func enterQuestion(){
        
        var feedSB:UIStoryboard = UIStoryboard(name: "Question", bundle: nil)
        if let questionController = feedSB.instantiateViewControllerWithIdentifier("Question") as? QuestionsViewController{
            navigationController!.showViewController(questionController, sender: self)
        }
        
    }
    
    /**
    Enter question detail screen
    */
    
    func enterQuestionDetail(question:QuestionModel, isWithdrawn:Bool){
        
        var qdSB:UIStoryboard = UIStoryboard(name: "Question_detail", bundle: nil)
        
        let applicationDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        if let questionDetailController = qdSB.instantiateViewControllerWithIdentifier("QuestionDetailViewController") as? QuestionDetailViewController {
            questionDetailController.questionId = question.question_id.toInt()
            questionDetailController.questionModel = question
            questionDetailController.studentName = applicationDelegate.userlogin.username
            questionDetailController.studentImageUrl = question.avatar
            questionDetailController.isWithdrwan = isWithdrawn
            
            if (question.isUrgent == 0)
            {
                qUrgent = false
            }
            else if (question.isUrgent == 1)
            {
                qUrgent = true
                
            }
            
            if (question.isPrivate == 0)
            {
                qPrivate = false
            }
            else if (question.isPrivate == 1)
            {
                qPrivate = true
                
            }
            println("------------------")
            println(qUrgent)
            println(qPrivate)
            
            if(question.accept["status"] as! NSNumber == 1){
                
                questionDetailController.answerId = (question.accept["answerid"] as! NSString).integerValue
                
            }
            
            navigationController?.showViewController(questionDetailController, sender:self)
            
            self.checkReminder(question)
        }
        
    }
    
    /**
    Post question action
    */
    
    @IBAction func postQuestion(sender: UIButton) {
        
        enterQuestion()
        
        
        
    }
    
    
    func onDismiss() {
        self.lew_dismissPopupViewWithanimation(LewPopupViewAnimationDrop.alloc())
        
    }
    
    func onAnswer() {
        var storyboard = UIStoryboard(name: "Answer", bundle: nil)
        let myAnswerViewController = storyboard.instantiateViewControllerWithIdentifier("MyAnswer") as! MyAnswerViewController
        let nav = UINavigationController(rootViewController: myAnswerViewController) as UINavigationController
        
        self.lew_dismissPopupViewWithanimation(LewPopupViewAnimationDrop.alloc())
        let slidermenu =  self.appDelegate.window?.rootViewController as! SlideMenuController
        slidermenu.changeMainViewController(nav, close: true)
    }
    
    @IBAction func viewQuestion(sender: UIButton) {
        
    }
    
    @IBAction func unwindSegueToFeedVC(segue: UIStoryboardSegue)
    {}
    
    // MARK SearchBar
    
    
    
    /**
    Search text changed
    */
    
    @IBAction func searchKeyChanged(sender: UITextField) {
        var searchText = sender.text
        processSearchType(searchText)
        
        
        let yCoordinateFromSearchBar = feedview.searchView.frame.height
        feedview.tableView.setContentOffset(CGPoint(x: 0,y: -1.0 * yCoordinateFromSearchBar), animated: false)
        
    }
    
    
    /**
    call sesarch api
    */
    
    func processSearchType(keyword: String){
        MediumProgressViewManager.sharedInstance.showProgressOnView(self)
        
        self.currentTaskId = self.currentTaskId + 1;
        //        NSInteger taskId = self.currentTaskId;
        let taskId = self.currentTaskId
        let queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(1 * NSEC_PER_SEC)), queue) { // 2
            
            // Do search
            if (taskId == self.currentTaskId) // this is still current task
            {
                // your query
                
                if (taskId == self.currentTaskId) // sill current after query? update visual elements
                {
                    // Ensure that search doesn't occur after user pressed back button
                    if (self.searchModeOn == false) { return }
                    
                    let parameters = [
                        "token": token,
                        "query":keyword
                    ]
                    
                    //activity spinner activated
                    MediumProgressViewManager.sharedInstance.showProgressOnView(self)
                    UIApplication.sharedApplication().networkActivityIndicatorVisible = true
                    NetworkUI.sharedInstance .getSearchQuery(parameters, success: { (response) -> Void in
                        let arrayJSON = response as! NSArray
                        
                        self.questionArray.removeAll(keepCapacity: true)
                        for dic in arrayJSON{
                            var model = QuestionModel(dic: dic as! NSDictionary)
                            //                            for curModel in self.dataArray{
                            //                                if(model.question_id == curModel.question_id){
                            self.questionArray.append(model);
                            //                                }
                            //                            }
                            
                            
                            
                        }
                        if(self.searchModeOn == true){
                            var hamberbutton = self.navigationItem.leftBarButtonItem?.customView as! FRDLivelyButton
                            hamberbutton.addTarget(self, action: "backTapped", forControlEvents: .TouchUpInside)
                            hamberbutton.setStyle(kFRDLivelyButtonStyleCaretLeft, animated: true)
                            self.searchModeOn = true
                        }
                        self.feedview.tableView.reloadData()
                        MediumProgressViewManager.sharedInstance.hideProgressView(self)
                        
                        //activity spinner deactivated
                        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                        self.feedview.refreshControl.endRefreshing()
                        }) { (error) -> Void in
                            MediumProgressViewManager.sharedInstance.hideProgressView(self)
                            TAOverlay.showOverlayWithLabel("Please try again", options: TAOverlayOptions.OverlaySizeRoundedRect|TAOverlayOptions.OverlayTypeWarning|TAOverlayOptions.AutoHide)
                    }
                }
            }
        }
    }
    
    
    /**
    action when user click search key
    */
    @IBAction func onSearch(sender: AnyObject) {
        
        
        feedview.hideSearchBar()
        //		refreshQuestions()
        //		self.tableView.reloadData()
        //		refreshQuestions()
        //		println("Search: BWAH")
        
        
    }
    
    /**
    action when user click close button
    */
    @IBAction func onClose(sender: AnyObject) {
        
        feedview.tfSearch.text = ""
        feedview.tfSearch.resignFirstResponder()
        refreshQuestions()
    }
    
    
    
    // MARK popup
    func openPopoverView(question:QuestionModel) {
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        let popView = AnsweredQuestionPopoverView.loadFromNibNamed("AnsweredQuestionPopoverView", bundle: nil) as! AnsweredQuestionPopoverView
        
        popView.delegate = self
        popView.question = question
        
        popView.frame = CGRectMake(0, 0, screenSize.width - 70, 430)
        
        self.lew_presentPopupView(popView, animation: LewPopupViewAnimationDrop.alloc())
    }
    
    
    /**
    Enter detail screen
    */
    func onGotoDetail(question: QuestionModel) {
        
        self.lew_dismissPopupViewWithanimation(LewPopupViewAnimationDrop.alloc())
        
        self.enterQuestionDetail(question, isWithdrawn: false)
        
    }
    
    
    //MARK: Keyboard Functions
    
    @IBAction func titleAction(sender: UIButton) {
        feedview.hideSearchBar()
        var top:NSIndexPath = NSIndexPath(forRow: NSNotFound, inSection: 0)
        feedview.tableView.scrollToRowAtIndexPath(top, atScrollPosition: UITableViewScrollPosition.Top, animated: true)
    }
    
    // func ltzOffset() -> Int { return NSTimeZone.localTimeZone().secondsFromGMT }
    
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
        
        
        
        let app = UIApplication.sharedApplication()
        app.keyWindow?.endEditing(true)
        searchModeOn = false
        
        if(count(feedview.tfSearch.text) > 0){
            searchModeOn = true
            return
        }
        
        var hamberbutton = self.navigationItem.leftBarButtonItem?.customView as! FRDLivelyButton
        
        
        //        hamberbutton.addTarget(self, action: "backTapped", forControlEvents: .TouchUpInside)
        hamberbutton.setStyle(kFRDLivelyButtonStyleHamburger, animated: true)
    }
    
    /**
    keyboard will show notification
    */
    func moveDownWithoutKeyboard(){
        feedview.topMarginConstraint?.constant = 64
        feedview.tableView.contentInset = UIEdgeInsetsMake(68, 0, 0, 0)
        feedview.bottomMarginConstraint?.constant = self.keyboardSize.height
        feedview.tableView.layoutIfNeeded()
        
    }
    func keyboardWillShow(notification: NSNotification) {
        
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
            self.feedview.topMarginConstraint?.constant = 64
            self.feedview.tableView.contentInset = UIEdgeInsetsMake(68, 0, 0, 0)
            self.feedview.bottomMarginConstraint?.constant = self.keyboardSize.height
            self.feedview.tableView.layoutIfNeeded()
        })
        self.feedview.btnSearch.hidden = true;
        
        //if(searchModeOn == true ){
        searchModeOn = true
        var hamberbutton = self.navigationItem.leftBarButtonItem?.customView as! FRDLivelyButton
        
        hamberbutton.addTarget(self, action: "backTapped", forControlEvents: .TouchUpInside)
        hamberbutton.setStyle(kFRDLivelyButtonStyleCaretLeft, animated: true)
        
        isKeyboardShown = true
        
        
    }
    /**
    keyboard will hide notification
    */
    func keyboardWillHide(notification: NSNotification) {
        
        self.view.layoutIfNeeded()
        feedview.topMarginConstraint?.constant = 64
        feedview.bottomMarginConstraint?.constant = 43
        if(feedview.tfSearch.hidden == true){
            UIView.animateWithDuration(0.5, animations: {
                self.feedview.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
                self.feedview.tableView.layoutIfNeeded()
				        })
            
        }
        
        feedview.btnSearch.hidden = false;
        feedview.btnClose.hidden = true;
        self.dataArray.removeAll(keepCapacity: true)
        
        
        isKeyboardShown = false
        
    }
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        return true;
    }
    
    
}
