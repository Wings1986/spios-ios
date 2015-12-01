//
//  SettingsViewController.swift
//  spios
//
//  Created by Nhon Nguyen Van on 6/28/15.
//  Modified by Samarth Sandeep on 6/29/15
//  Copyright (c) 2015 Studypool. All rights reserved.
//

import UIKit
import Analytics


/// Setting screen for New Post
class SettingsViewController: UIViewController{
    
    @IBOutlet weak var settingsview: SettingsView!
    
    /// post parameters at previous pages
    var parameters : Dictionary<String, AnyObject> = [:]
    /// Array for post images
    var arrImages = [UIImage]()
    
    var segueHappened = false
    
    /// Get QuestionModel after posting
    var questionModel: QuestionModel?
    
    /// bool value for Urgent
    var isUrgent = false
    /// bool value for Private
    var isPrivate = false
    
    /// String value for Urgent
    var finalUrgent: String = "0"
    
    /// String value for Private
    var finalPrivate: String = "0"
    
    /// Total Price
    var price = 1 as Float
    
    /// Deadline Type (Hour = 0 or Day = 1)
    var nType = 1 as Int
    
    /// Deadline Value
    var nDayHour = 0 as Int
    
    /// Budget Value
    var nBudget = 0 as Int
    
    // MARK: - View Setup
    override func viewDidLoad() {
        super.viewDidLoad()

        settingsview.controller = self
        
        SEGAnalytics.sharedAnalytics().screen("Settings", properties: [:])
        settingsview.viewdidload()
        
        self.view.userInteractionEnabled = true
    }

    
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
        refreshSubmitButton()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    var bottomPopViewConstant: CGFloat! // Saving constants to restore the view when keyboard hides
    var topPopViewConstant: CGFloat! // Saving constants to restore the view when keyboard hides
    var normalFrame: CGRect! // Saving View frame to restore it on keyboard hide
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        let qpvc:QuestionPostedViewController = segue.destinationViewController as! QuestionPostedViewController
        
        qpvc.questionModel = self.questionModel
    }
    
    func dateformatterDate(date: NSDate) -> NSString
    {
        var dateFormatter: NSDateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MMM d hh:mm a"
//        dateFormatter.timeZone = NSTimeZone(abbreviation: "UTC")
        
        return dateFormatter.stringFromDate(date)
        
        
    }
    
    func refreshSubmitButton() {
        let submitEnabled = (self.nBudget > 0 && self.nDayHour > 0)
        self.settingsview.btnSubmit.enabled = submitEnabled
        self.settingsview.btnSubmitBottom.enabled = submitEnabled
    }
    
    // MARK: - Actions
    
    @IBAction func onSubmit(sender: AnyObject){
        
        if (segueHappened == false)
        {
            self.view.userInteractionEnabled = false
            userInputQuestionDescription = ""
            userInputQuestionTitle = ""
            postQuestion()
        }
        segueHappened = true
    }
    
    
    @IBAction func urgentQuestionClicked(sender: UIButton) {
        isUrgent = !isUrgent
        stUrgentQues = isUrgent
        if(isUrgent == false){
            settingsview.btnCheckMarkUrgentQues.hidden = true
            sender.layer.borderWidth = 0
            
            sender.layer.borderColor = nil
        } else {
            settingsview.btnCheckMarkUrgentQues.hidden = false
            settingsview.changeButtonTapped(sender)
        }
    }
    
    @IBAction func privateQuestionClicked(sender: UIButton) {
        isPrivate = !isPrivate
        stPrivateQues = isPrivate
        if(isPrivate == false){
            settingsview.btnCheckMarkPrivateQues.hidden = true
            sender.layer.borderWidth = 0
            
            sender.layer.borderColor = nil
            
        } else {
            settingsview.btnCheckMarkPrivateQues.hidden = false
            settingsview.changeButtonTapped(sender)
        }
    }
    
    @IBAction func backPressed(sender: AnyObject) {
        
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func valChanged(sender: CustomSlider) {
        //updateSliderText()
        
        if(sender.value > 1 && sender.value <= 5){
            sender.setValue(1, animated: true)
        }else if(sender.value > 5 && sender.value <= 10){
            sender.setValue(10.5, animated: true)
        }else if(sender.value > 10 && sender.value <= 15){
            sender.setValue(10.5, animated: true)
        }else if(sender.value > 15 && sender.value <= 20){
            sender.setValue(20, animated: true)
        }
    }
    
    /**
    Final Post Question function with Images, text, category, Settings
    */
    
    func postQuestion(){
        
        
        
        if(isUrgent == true){
            //price += 2.85
            finalUrgent = "1"
        }
        if(isPrivate == true){
            finalPrivate = "1"
        }
        
        var type = "1"
        if(settingsview.btnTimely.titleLabel?.text == "Hour(s)"){
            type = "2"
        }else{
            type = "1"
        }
        
        // Update variable for API changes - 6 Aug 2015
        price = 0

        // Tier value (1, 2 or 3)
        var tierValue = String(Int(settingsview.sliderTier.value))
        
        //escape title
        //var escapedString = (self.parameters["title"] as! NSString).stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())
        var escapedString = self.parameters["title"] as! NSString
        var budget = settingsview.arrayBudget[nBudget] as NSString
        
        let version = NSBundle.mainBundle().infoDictionary?["CFBundleShortVersionString"] as! String
        
        let realparameters = [
            
            "token": token,
            "Questions[name]": escapedString,
            "Questions[money]":budget,
            "Questions[high]":budget,
            "Questions[description]":self.parameters["description"] as! String,
            "Questions[tier]":tierValue,
            // Offset 1 for index-0
            "Questions[days]":String(self.nDayHour + 1),
            "Questions[type]":String(self.nType),
            "Questions[urgent]":finalUrgent,
            "Questions[private]":finalPrivate,
            "primary":self.parameters["category"] as! String,
            "imagecount":String(self.arrImages.count),
            "isPic":self.parameters["isPic"] as! String,
            "version":version
        ]
        
        
        settingsview.stepsView.hidden = true
        
        
        // call PostQuestion api with image posting
        if(self.arrImages.count == 0){
            MediumProgressViewManager.sharedInstance.showProgressOnView(self)
            
            settingsview.btnBack.enabled = false
            settingsview.btnSubmit.enabled = false
            settingsview.btnSubmitBottom.enabled = false
            
            NetworkUI.sharedInstance.postQuestion(realparameters, success: { (response) -> Void in
                TAOverlay.hideOverlay()
                
                //get the questionModel
                //let dicJSON = response as! NSDictionary
                
                self.questionModel = QuestionModel(dic: response as! NSDictionary)
                
                self.performSegueWithIdentifier("showAnimation", sender: self)
                MediumProgressViewManager.sharedInstance.hideProgressView(self)
                
                self.settingsview.btnBack.enabled = true
                self.settingsview.btnSubmit.enabled = true
                self.settingsview.btnSubmitBottom.enabled = true
                
                // SEGMENT -
                
                }) { (error) -> Void in
                    MediumProgressViewManager.sharedInstance.hideProgressView(self)
                    TAOverlay.showOverlayWithLabel("Please try again", options: TAOverlayOptions.OverlaySizeRoundedRect|TAOverlayOptions.OverlayTypeWarning|TAOverlayOptions.AutoHide)
                    println(error)
                    
                    self.settingsview.btnBack.enabled = true
                    self.settingsview.btnSubmit.enabled = true
                    self.settingsview.btnSubmitBottom.enabled = true
                    
                    self.navigationController?.popToRootViewControllerAnimated(true)
            }
        }
            // call PostQuestion api without image posting
        else{
            
            MediumProgressViewManager.sharedInstance.showProgressOnView(self)
            
            settingsview.btnBack.enabled = false
            settingsview.btnSubmit.enabled = false
            settingsview.btnSubmitBottom.enabled = false
            
            NetworkUI.sharedInstance.postQuestion(realparameters, images:self.arrImages, success: { (response) -> Void in
                
                MediumProgressViewManager.sharedInstance.hideProgressView(self)
                
                TAOverlay.hideOverlay()
                
                self.questionModel = QuestionModel(dic: response as! NSDictionary)
                
                self.settingsview.btnBack.enabled = true
                self.settingsview.btnSubmit.enabled = true
                self.settingsview.btnSubmitBottom.enabled = true
                
                self.performSegueWithIdentifier("showAnimation", sender: self)
                
                }) { (error) -> Void in
                    TAOverlay.showOverlayWithLabel("Please try again", options: TAOverlayOptions.OverlaySizeRoundedRect|TAOverlayOptions.OverlayTypeWarning|TAOverlayOptions.AutoHide)
                    MediumProgressViewManager.sharedInstance.hideProgressView(self)
                    
                    self.settingsview.btnBack.enabled = true
                    self.settingsview.btnSubmit.enabled = true
                    self.settingsview.btnSubmitBottom.enabled = true
            }
        }
    }
    
    
    @IBAction func budgetPicked(sender: AnyObject) {
        var picker = ActionSheetStringPicker(title: "Select Budget Amount", rows: settingsview.arrayBudget, initialSelection: self.nBudget, doneBlock: { (picker, index, object) -> Void in
            
            self.nBudget = index
            self.refreshSubmitButton()
            
            if (index > 0) {
                sender.setTitle(String(format:"$ %@", self.settingsview.arrayBudget[index]), forState: UIControlState.Normal)
            }
            else {
                sender.setTitle(self.settingsview.arrayBudget[index], forState: UIControlState.Normal)
            }
            
        }, cancelBlock: { (picker) -> Void in
                
        }, origin: sender.superview!!.superview)
        
        picker.showActionSheetPicker()
        
    }
    
    @IBAction func typePicked(sender: UIButton) {
        var picker = ActionSheetStringPicker(title: "Select Deadline type", rows: settingsview.arrayType, initialSelection: nType, doneBlock: { (picker, index, object) -> Void in
            
            self.nType = index
            sender.setTitle(self.settingsview.arrayType[index], forState: UIControlState.Normal)
            
        }, cancelBlock: { (picker) -> Void in
                
        }, origin: sender.superview!.superview)
        
        picker.showActionSheetPicker()
    }
    
    @IBAction func valuePicked(sender: UIButton) {
        
        var picker = ActionSheetStringPicker(title: "Select Deadline Date", rows: (self.nType == 0 ? settingsview.arrayhours : settingsview.arrayDays), initialSelection:nDayHour, doneBlock: { (picker, index, object) -> Void in
            
            self.nDayHour = index
            self.refreshSubmitButton()
            
            var strValue = (self.nType == 0 ? self.settingsview.arrayhours[index] : self.settingsview.arrayDays[index]) as String
            sender.setTitle(strValue, forState: UIControlState.Normal)
            
        }, cancelBlock: { (picker) -> Void in
                
        }, origin: sender.superview!.superview)
        
        picker.showActionSheetPicker()
    }
    
    func sliderThumbCenter(slider: CustomSlider, forValue value:Float)-> CGFloat{
        let trackRect :CGRect = slider.trackRectForBounds(slider.bounds) as CGRect!
        let thumbRect :CGRect = slider.thumbRectForBounds(slider.bounds, trackRect: trackRect, value: value) as CGRect!
        let centerThumb: CGFloat = CGRectGetMidX(thumbRect)
        return centerThumb;
    }
}
