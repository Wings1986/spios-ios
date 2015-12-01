//
//  FeedViewController.swift
//  spios
//
//  Created by Stanley Chiang on 3/7/15.
//  Copyright (c) 2015 Stanley Chiang. All rights reserved.
//

import UIKit



class MyAnswerViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var tableViewFooter: MyFooter!
    
    
    
    var test:NSDictionary!
    var newthing = [NSDictionary]()
    var nPage:Int!
    
    var currentTaskId:Int!

    let LOADMORE_HEIGHT:CGFloat = 60
    
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    var lastCounts:Int!
    
    var postCount:Int!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var headerbar: UIView!
    @IBOutlet weak var topMarginConstraint: NSLayoutConstraint?
    @IBOutlet weak var bottomMarginConstraint: NSLayoutConstraint?

    
    var dataArray :[AnswerModel] = [AnswerModel]()
    
    var questionArray:[AnswerModel] = [AnswerModel]()
    
    var keyboardSize : CGRect!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.currentTaskId = 1;
//        user_id = test["id"]?.description.toInt()
//        token = test["token"] as? String
//        username = test["username"] as? String
        
        println(test)
//        for (index,item) in enumerate(test){
//            println(item)
////            newthing.append(newElement: item)
//        }
        
        self.tableViewFooter.hidden = true
        tableView.addSubview(self.refreshControl)
        tableView.delegate = self
        tableView.dataSource = self
        //add effect
        tfSearch.layer.shadowColor = UIColor.darkGrayColor().CGColor
        tfSearch.layer.shadowOffset = CGSizeMake(0, 1)
        tfSearch.layer.shadowOpacity = 1
        tfSearch.layer.shadowRadius = 2
        tfSearch.layer.cornerRadius = 2
        tfSearch.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0)
        
        btnSearch.layer.shadowColor = UIColor.darkGrayColor().CGColor
        btnSearch.layer.shadowOffset = CGSizeMake(0, 1)
        btnSearch.layer.shadowOpacity = 1
        btnSearch.layer.shadowRadius = 1

        headerbar.layer.shadowColor = UIColor.darkGrayColor().CGColor
        headerbar.layer.shadowOffset = CGSizeMake(0, 1)
        headerbar.layer.shadowOpacity = 1
        headerbar.layer.shadowRadius = 2
        
        nPage = 1
        
        
        

    }
    
    @IBAction func goToProfile(sender:UIButton){
        var storyboard = UIStoryboard(name: "Feed", bundle: nil)
        let profileViewController = storyboard.instantiateViewControllerWithIdentifier("Profile") as! ProfileViewController
        self.navigationController?.pushViewController(profileViewController, animated: true)
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
            self.topMarginConstraint?.constant = 120
            self.bottomMarginConstraint?.constant = self.keyboardSize.height
            self.tableView.layoutIfNeeded()
        })
        self.btnSearch.hidden = true;
        self.btnClose.hidden = false;
    }
    
    func keyboardWillHide(notification: NSNotification) {
        
        self.view.layoutIfNeeded()
        UIView.animateWithDuration(0.5, animations: {
            self.topMarginConstraint?.constant = 64
            self.bottomMarginConstraint?.constant = 60
            self.tableView.layoutIfNeeded()
        })
        self.btnSearch.hidden = false;
        self.btnClose.hidden = true;
        getMyAnswers()
        //
    }
    
    override func viewWillDisappear(animated: Bool) {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.setNavigationBarItem()
        
        getMyAnswers()
//        getMyProfile()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
//  ////////////////////////
//  start handle top refresh
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "handleRefresh:", forControlEvents: UIControlEvents.ValueChanged)
        
        return refreshControl
        }()
    
    func handleRefresh(refreshControl: UIRefreshControl) {
        
        self.tfSearch.text = ""
        
        let parameters = [
            "token": token,
            "refresh_all":String(format:"%d",nPage)
        ]
        questionArray.removeAll(keepCapacity: true)
        dataArray.removeAll(keepCapacity: true)
        
        MediumProgressViewManager.sharedInstance.showProgressOnView(self)
        
        NetworkUI.sharedInstance .getMyAnswer(parameters, success: { (response) -> Void in
            MediumProgressViewManager.sharedInstance.hideProgressView(self)
            
            let arrayJSON = response as! NSArray
            for dic in arrayJSON{
                var model = AnswerModel(dic: dic as! NSDictionary)
                self.dataArray.append(model)
                
            }
            self.questionArray = self.dataArray

            self.tableView.reloadData()
            refreshControl.endRefreshing()
            
            }) { (error) -> Void in
                MediumProgressViewManager.sharedInstance.hideProgressView(self)
                TAOverlay.showOverlayWithLabel("Please try again", options: TAOverlayOptions.OverlaySizeRoundedRect|TAOverlayOptions.OverlayTypeWarning|TAOverlayOptions.AutoHide)
        }

        
        
    }
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
//        var yVelocity : CGFloat = scrollView.panGestureRecognizer.velocityInView(scrollView).y;
//        var needShowFooter:Bool = (scrollView.contentOffset.y > 0) && (scrollView.contentSize.height < scrollView.frame.size.height || scrollView.contentOffset.y + scrollView.frame.size.height > scrollView.contentSize.height)
//        if (yVelocity <= 0 && needShowFooter) {
//            self.tableViewFooter.hidden = false
//        }
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        var yVelocity : CGFloat = scrollView.panGestureRecognizer.velocityInView(scrollView).y;
        var needShowFooter:Bool = (scrollView.contentOffset.y > LOADMORE_HEIGHT) && (scrollView.contentSize.height < scrollView.frame.size.height || scrollView.contentOffset.y + scrollView.frame.size.height - LOADMORE_HEIGHT > scrollView.contentSize.height)
        if (yVelocity <= 0 && needShowFooter) {
            self.tableViewFooter.hidden = false
        }else{
            self.tableViewFooter.hidden = true
        }
        
        if (yVelocity > 0 && searchView.hidden == false)
        {
            self.hideSearchBar()
        } else if (yVelocity < 0 && searchView.hidden == true) {
            self.showSearchBar()
        }
    }
    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        var needShowFooter:Bool = (scrollView.contentOffset.y > LOADMORE_HEIGHT) && (scrollView.contentSize.height < scrollView.frame.size.height || scrollView.contentOffset.y + scrollView.frame.size.height - LOADMORE_HEIGHT > scrollView.contentSize.height)
        if (!self.tableViewFooter.hidden && needShowFooter){
                //simulate delay
                self.loadMore()
        }
    }
    
    func loadMore()
    {
        if(self.lastCounts < 10){
            return
        }
        
        nPage = nPage + 1
        getMyAnswers()
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return questionArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//        if (indexPath.row % 2 == 0)
//        {
            let feedCell = tableView.dequeueReusableCellWithIdentifier("FeedCell_1", forIndexPath: indexPath) as! FeedCell
            
            let questionModel = questionArray[indexPath.row] as AnswerModel
        
            var date = NSDate(timeIntervalSince1970:questionModel.created_time as Double)
            
            feedCell.lblTitle?.text = questionModel.title
            feedCell.lblSubTitle?.text = questionModel._description
            feedCell.lblTimesAgo?.text = date.relativeTime
        
            questionModel.avatar = questionModel.avatar.stringByReplacingOccurrencesOfString(" ", withString: "%20", options: NSStringCompareOptions.RegularExpressionSearch, range: nil)
            
            ImageLoader.sharedLoader.imageForUrl(questionModel.avatar, imageview: feedCell.imvLogo, completionHandler:{(image: UIImage?, url: String) in
                //                self.imageView.image = image
            })
        
            
            if(indexPath.row % 2 == 1){
                feedCell.contentView.backgroundColor = UIColor(red: 231.0/255, green: 231.0/255, blue: 226.0/255, alpha: 1.0)
            }else{
                feedCell.contentView.backgroundColor = UIColor(red: 245.0/255, green: 245.0/255, blue: 243.0/255, alpha: 1.0)
            }
                
            return feedCell

//        }
        /*else{
            let feedCell = tableView.dequeueReusableCellWithIdentifier("FeedCell_2", forIndexPath: indexPath) as! FeedCell
            
            let	 questionModel = questionArray[indexPath.row]
            
            feedCell.lblTitle?.text = questionModel.title
            feedCell.lblSubTitle?.text = questionModel._description
            
            if (questionModel.unread == 0) {//if read
                feedCell.imvReadMark.hidden = true
                feedCell.lblNumOfAnswers.text = "\(questionModel.real_answers) Answers"
            }else{
                feedCell.imvReadMark.hidden = false
                feedCell.lblNumOfAnswers.text = "\(questionModel.unread) Unread Answer"
            }
            return feedCell
        }*/
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        var movie:Movie = dataArray.objectAtIndex(indexPath.row) as! Movie
//        switch (movie.status as QuestionStatus) {
//        case .decides:
//            break;
//        case .new:
//            break;
//        case .working:
//            break;
//        default:
//            break;
//        }
        
//        enterQuestionDetail(questionArray[indexPath.row] as QuestionModel)
        
        let answerModel = questionArray[indexPath.row] as AnswerModel
        
        var qdSB:UIStoryboard = UIStoryboard(name: "Question_detail", bundle: nil)
        if let answerDetailController = qdSB.instantiateViewControllerWithIdentifier("QuestionDetailViewController") as? QuestionDetailViewController {
            
            answerDetailController.questionId = answerModel.question_id.toInt()
            answerDetailController.mIsTutor = true
            answerDetailController.answerId = answerModel.answer_id.toInt()
            
            let navController = UINavigationController(rootViewController: answerDetailController)
            
            navigationController?.showViewController(navController, sender:self)
        }
    }
//    end handle top refresh
//    /////////////////////
    
    @IBAction func menuButtonTouched(sender: AnyObject) {
        self.findHamburguerViewController()?.showMenuViewController()
    }
    
    func getMyProfile(){
        let parameters = [
            "token": token
        ]
        
        MediumProgressViewManager.sharedInstance.showProgressOnView(self)
        
        NetworkUI.sharedInstance.getStudentsProfile(parameters, success: { (response) -> Void in
            MediumProgressViewManager.sharedInstance.hideProgressView(self)
            let model = response as! ProfileModel
            self.postCount = model.total_questions.toInt()
        }) { (error) -> Void in
            MediumProgressViewManager.sharedInstance.hideProgressView(self)
            TAOverlay.showOverlayWithLabel("Please try again", options: TAOverlayOptions.OverlaySizeRoundedRect|TAOverlayOptions.OverlayTypeWarning|TAOverlayOptions.AutoHide)
        }
    }
    
    func getMyAnswers(){

        MediumProgressViewManager.sharedInstance.showProgressOnView(self)
        
        let parameters = [
            "token": token,
            "page":String(format:"%d",nPage)
        ]
        self.dataArray.removeAll(keepCapacity: true)
        NetworkUI.sharedInstance .getMyAnswer(parameters, success: { (response) -> Void in
            MediumProgressViewManager.sharedInstance.hideProgressView(self)
            
            let arrayJSON = response as! NSArray
            for dic in arrayJSON{
                var model = AnswerModel(dic: dic as! NSDictionary)
                self.dataArray.append(model)

                
            }
            self.lastCounts = self.dataArray.count
            
            self.questionArray = self.dataArray
//            self.dataArray = self.dataArrayWithFilter(self.tfSearch.text, originArray: self.questionArray)
            self.tableView.reloadData()
            
        }) { (error) -> Void in
           MediumProgressViewManager.sharedInstance.hideProgressView(self)
            TAOverlay.showOverlayWithLabel("Please try again", options: TAOverlayOptions.OverlaySizeRoundedRect|TAOverlayOptions.OverlayTypeWarning|TAOverlayOptions.AutoHide)
        }
    }

    func httpParseArr(request: NSURLRequest!, callback: ([NSDictionary], String?) -> Void) {
        //    func http(request: NSURLRequest!, callback: (String, String?) -> Void) {
        var session = NSURLSession.sharedSession()
        var task = session.dataTaskWithRequest(request){
            (data, response, error) -> Void in
            if error != nil {
                //                callback("", error.localizedDescription)
            } else {
                var result = NSString(data: data, encoding:
                    NSASCIIStringEncoding)!
                var jsonResult: AnyObject? = NSJSONSerialization.JSONObjectWithData(data, options:NSJSONReadingOptions.AllowFragments, error: nil)
                //                println("first look \(result)")
                if let returnVal: AnyObject = jsonResult {
                    println("\(jsonResult!)")
                    callback(jsonResult! as! [NSDictionary], nil)
                } else{
                    println("try again \(result)")
                }
            }
        }
        task.resume()
    }
    
    func enterQuestion(){
        var feedSB:UIStoryboard = UIStoryboard(name: "Question", bundle: nil)
        if let questionController = feedSB.instantiateViewControllerWithIdentifier("Question") as? QuestionsViewController{
            navigationController!.showViewController(questionController, sender: self)
        }
    }
    
    func enterQuestionDetail(question:QuestionModel){
        
        var qdSB:UIStoryboard = UIStoryboard(name: "Question_detail", bundle: nil)
        if let questionDetailController = qdSB.instantiateViewControllerWithIdentifier("QuestionDetailViewController") as? QuestionDetailViewController {
            questionDetailController.questionId = question.question_id.toInt()
            
            let navController = UINavigationController(rootViewController: questionDetailController)
            
            navigationController?.showViewController(navController, sender:self)
        }
//        if let questionDetailNavigation = qdSB.instantiateViewControllerWithIdentifier("QuestionDetail_Nav") as? UINavigationController {
//            navigationController?.showViewController(questionDetailNavigation, sender: self)
//        }
    }
    
    @IBAction func postQuestion(sender: UIButton) {
        if(self.postCount<4){
            enterQuestion()
        }else{
        
            let overlay = OverlayView.loadFromNibNamed("Overlayview") as! OverlayView
            
//            overlay.parentview = self
            overlay.frame = CGRectMake(0, 0, self.view.frame.width - 70, self.view.frame.height - 130)
            
            self.lew_presentPopupView(overlay, animation: LewPopupViewAnimationDrop.alloc())
        
        }
    }
    
    @IBAction func viewQuestion(sender: UIButton) {

    }
    
    @IBAction func unwindSegueToFeedVC(segue: UIStoryboardSegue)
    {}
    
    // MARK SearchBar
    @IBOutlet weak var tfSearch: UITextField!
    @IBOutlet weak var btnSearch: UIButton!
    @IBOutlet weak var btnClose: UIButton!
    @IBOutlet weak var searchView: UIVisualEffectView!
    
    func showSearchBar() {
        if (!searchView.hidden){
            return;
        }
        
        searchView.alpha = 0
        searchView.hidden = false
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.searchView.alpha = 1
        })
    }
    
    func hideSearchBar() {
        self.tfSearch.resignFirstResponder()
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.searchView.alpha = 0
        }) { (success) -> Void in
            self.searchView.hidden = true
        }
    }
    
    @IBAction func searchKeyChanged(sender: UITextField) {
        var searchText = sender.text
        if(count(searchText) == 0){
            questionArray = self.dataArray
            self.tableView.reloadData()
            
            
        }else{
//            dataArray = self.dataArrayWithFilter(searchText, originArray: movies)
//            processSearchType(searchText)
            
            
            
        }
        
    }
    
//    func processSearchType(keyword: String){
//        self.currentTaskId = self.currentTaskId + 1;
////        NSInteger taskId = self.currentTaskId;
//        let taskId = self.currentTaskId
//        let queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
//        
//
//        
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(1 * NSEC_PER_SEC)), queue) { // 2
//            if (taskId == self.currentTaskId) // this is still current task
//            {
//                // your query
//                
//                if (taskId == self.currentTaskId) // sill current after query? update visual elements
//                {
//                    let parameters = [
//                        "token": token,
//                        "query":keyword
//                    ]
//                    
//                    NetworkUI.sharedInstance .getSearchQuery(parameters, success: { (response) -> Void in
//                        let arrayJSON = response as! NSArray
//                        
//                        self.questionArray.removeAll(keepCapacity: true)
//                        for dic in arrayJSON{
//                            var model = QuestionModel(dic: dic as! NSDictionary)
//                            for curModel in self.dataArray{
//                                if(model.question_id == curModel.question_id){
//                                    self.questionArray.append(model);
//                                }
//                            }
//                            
//                            
//                        }
//                        
//                       
//                        self.tableView.reloadData()
//                        
//                        }) { (error) -> Void in
//                            
//                    }
//                }
//            }
//        }
//    }
    
    func dataArrayWithFilter(filterkey:String, originArray:NSArray)->NSArray
    {
        if (filterkey == "") {
            return originArray
        }
        
        
        var lowerString = filterkey.lowercaseString

        var results = self.questionArray.filter { (model:AnswerModel) -> Bool in
            if ((model.title.lowercaseString.rangeOfString(lowerString) != nil) || (model.description.lowercaseString.rangeOfString(lowerString) != nil)) {
                return true
            }else{
                return false
            }
        }
        return results
    }
    
    @IBAction func onSearch(sender: AnyObject) {
        self.hideSearchBar()
    }
    
    @IBAction func onClose(sender: AnyObject) {
        self.tfSearch.text = ""
//        getMyQuestions()
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        return true;
    }
    
    
}
