//
//  FeedView.swift
//  spios
//
//  Created by MobileGenius on 9/24/15.
//  Copyright (c) 2015 Studypool. All rights reserved.
//

import UIKit
import FRDLivelyButton

class FeedView: UIView, UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate, UITextFieldDelegate {

    @IBOutlet weak var noQs: UIImageView!
    
    @IBOutlet weak var lookDownToStart: UIImageView!
    @IBOutlet weak var textForFin: UITextField!
    
    @IBOutlet weak var tableView: UITableView!
    
    /// top layoutcontraint of tableview
    @IBOutlet weak var topMarginConstraint: NSLayoutConstraint?
    
    /// bottom layoutcontraint of tableview
    @IBOutlet weak var bottomMarginConstraint: NSLayoutConstraint?
    
    /// search textfield
    @IBOutlet weak var tfSearch: UITextField!
    
    /// search button
    @IBOutlet weak var btnSearch: UIButton!
    
    /// close button
    @IBOutlet weak var btnClose: UIButton!
    
    /// search back view
    @IBOutlet weak var searchView: UIView!
    
    /// Question model array
    var dataArray :[QuestionModel] = [QuestionModel]()
    
    /// question model filtered array
    var questionArray:[QuestionModel] = [QuestionModel]()
    
    var controller:FeedViewController!
    
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        
        
    }
    
    /// refresh control
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self.controller, action: "handleRefresh:", forControlEvents: UIControlEvents.ValueChanged)
        
        return refreshControl
        }()
    
    func initview(){
        
        noQs.hidden = true
        lookDownToStart.hidden = true
        textForFin.hidden = true
        
        
        controller.addDoneButtonToKeyboard(tfSearch)
        tableView.addSubview(self.refreshControl)
        tableView.delegate = self
        tableView.dataSource = self
        //add effect
        tfSearch.layer.shadowColor = UIColor.darkGrayColor().CGColor
        tfSearch.layer.shadowOffset = CGSizeMake(0, 1)
        tfSearch.layer.shadowOpacity = 1
        tfSearch.layer.shadowRadius = 2
        tfSearch.layer.cornerRadius = 2
        
        tfSearch.attributedPlaceholder = NSAttributedString(string:"Search...",
            attributes:[NSForegroundColorAttributeName: UIColor.grayColor()])
        
        controller.searchModeOn = false
        btnSearch.layer.shadowColor = UIColor.darkGrayColor().CGColor
        btnSearch.layer.shadowOffset = CGSizeMake(0, 1)
        btnSearch.layer.shadowOpacity = 1
        btnSearch.layer.shadowRadius = 1
        //        self.hideSearchBar()
        
        
        //adjust because we used an image for the uitextfield
        let spacerView = UIView(frame: CGRectMake(0, 0, 10, 10))
        self.tfSearch.leftViewMode = UITextFieldViewMode.Always
        self.tfSearch.leftView = spacerView
        
        //Navigation Shadow
        
        
        
        
        if !UIAccessibilityIsReduceTransparencyEnabled() {
            
            //alpha instead of blur
            
            self.searchView.backgroundColor = UIColor(white: 1, alpha: 0.75)
            
            
            //let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.Light)
            //let blurEffectView = UIVisualEffectView(effect: blurEffect)
            //  blurEffectView.frame = self.searchView.bounds
            //self.searchView.insertSubview(blurEffectView, atIndex: 0)
            
            //add auto layout constraints so that the blur fills the screen upon rotating device
            // blurEffectView.setTranslatesAutoresizingMaskIntoConstraints(false)
        } else {
            self.searchView.backgroundColor = UIColor.clearColor()
        }
    }
    
    
    //MARK: Tableview Functions
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return controller.questionArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let feedCell = tableView.dequeueReusableCellWithIdentifier("FeedCell_1", forIndexPath: indexPath) as! FeedCell
        
        if(controller.isOnLoadForSure == true){
            feedCell.loading.hidden = false
            feedCell.loading.startAnimating()
            
        }else{
            feedCell.loading.hidden = true
            feedCell.loading.stopAnimating()
            
        }
        let questionModel = controller.questionArray[indexPath.row] as QuestionModel
        feedCell.setData(questionModel)
        
        
        if(feedCell.lblTitle?.text != ""){
            self.noQs.hidden = true
            self.lookDownToStart.hidden = true
        }
        
        controller.lastCounts++
        
        return feedCell
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        //check if withdrawn
        let questionModel = controller.questionArray[indexPath.row] as QuestionModel
        
        let cellSelected = tableView.cellForRowAtIndexPath(indexPath) as! FeedCell
        
        //if withdrawn, go to withdrawlpending view controller
        if (questionModel.withdrawed == "1")
        {
            controller.enterQuestionDetail(questionModel, isWithdrawn: true)
        }
            
            //else go to question detail controller
        else {
            controller.enterQuestionDetail(questionModel, isWithdrawn:false)
        }
        
    }
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        
    }
    
    /**
    scrollview delegate (show/hide search bar)
    */
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        var yVelocity : CGFloat = scrollView.panGestureRecognizer.velocityInView(scrollView).y;
        var needShowFooter:Bool = (scrollView.contentOffset.y > controller.LOADMORE_HEIGHT) && (scrollView.contentSize.height < scrollView.frame.size.height || scrollView.contentOffset.y + scrollView.frame.size.height - controller.LOADMORE_HEIGHT > scrollView.contentSize.height)
        if (yVelocity <= 0 && needShowFooter) {
        }else{
        }
        
        if (yVelocity > 0 && searchView.hidden == false && !tfSearch.isFirstResponder())
        {
            //only dismiss search on left arrow pressed
            
            self.hideSearchBar()
            
        } else if (yVelocity < 0 && searchView.hidden == true) {
            self.showSearchBar()
            
        }
        
    }
    
    
    /**
    scrollview delegate (load more)
    */
    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        var needShowFooter:Bool = (scrollView.contentOffset.y > controller.LOADMORE_HEIGHT) && (scrollView.contentSize.height < scrollView.frame.size.height || scrollView.contentOffset.y + scrollView.frame.size.height - controller.LOADMORE_HEIGHT > scrollView.contentSize.height)
        if (needShowFooter){
            MediumProgressViewManager.sharedInstance.showProgressOnView(controller)
            //dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            //simulate delay
            //load only if not in search
            if (searchView.hidden == false) {
                controller.loadMore()
            }
            //}
        }
    }

    /**
    Show search view
    */
    func showSearchBar() {
        if (!searchView.hidden){
            
            return;
        }
        
        searchView.alpha = 0
        searchView.hidden = false
        btnSearch.hidden = false
        btnClose.hidden = false
        tfSearch.text = ""
        //        searchModeOn = true
        
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.searchView.alpha = 1
        })
        
        
    }
    
    /**
    Hide search bar
    */
    
    func hideSearchBar() {
        UIView.animateWithDuration(0.5, animations: {
            self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
            self.tableView.layoutIfNeeded()
        })
        self.tfSearch.resignFirstResponder()
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.searchView.alpha = 0
            }) { (success) -> Void in
                self.searchView.hidden = true
                self.btnSearch.hidden = true
                self.btnClose.hidden = true
        }
        controller.searchModeOn = false
        var hamberbutton = controller.navigationItem.leftBarButtonItem?.customView as! FRDLivelyButton
        
        hamberbutton.setStyle(kFRDLivelyButtonStyleHamburger, animated: true)
        
        //        refreshQuestions()
    }
}
