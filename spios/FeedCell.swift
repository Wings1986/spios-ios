//
//  self.swift
//  spios
//
//  Created by Nhon Nguyen Van on 6/1/15.
//  Copyright (c) 2015 Studypool. All rights reserved.
//

import UIKit

class FeedCell: UITableViewCell {

    @IBOutlet weak var imvLogoCircle2: UIImageView!
    @IBOutlet weak var imvLogoCircle1: UIImageView!
    @IBOutlet weak var imvLogo: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblSubTitle: UILabel!
    @IBOutlet weak var lblNumOfAnswers: UILabel!
    @IBOutlet weak var lblTimesAgo: UILabel!
    @IBOutlet weak var imvReadMark: UIImageView!
    @IBOutlet weak var lblUnread: UILabel!
    @IBOutlet weak var imvLogoMask: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var lblStatusLabel: UILabel!
    @IBOutlet weak var lblDeadline: UILabel!
	@IBOutlet weak var loading: UIActivityIndicatorView!
    
    let pickerData : NSMutableArray = [
        ["id":1,"name":"Accounting"],
        ["id":2,"name":"Art & Design"],
        ["id":3,"name":"Biology"],
        ["id":4,"name":"Business & Finance"],
        ["id":5,"name":"Calculus"],
        ["id":6,"name":"Chemistry"],
        ["id":7,"name":"Economics"],
        ["id":9,"name":"Engineering"],
        ["id":10,"name":"English"],
        ["id":11,"name":"Environmental Science"],
        ["id":12,"name":"Foreign Languages"],
        ["id":14,"name":"Geology"],
        ["id":15,"name":"Health & Medical"],
        ["id":16,"name":"History"],
        ["id":17,"name":"Law"],
        ["id":18,"name":"Marketing"],
        ["id":19,"name":"Mathematics"],
        ["id":20,"name":"Philosophy"],
        ["id":21,"name":"Physics"],
        ["id":23,"name":"Political Science"],
        ["id":24,"name":"Computer Science"],
        ["id":25,"name":"Psychology"],
        ["id":26,"name":"Science"],
        ["id":27,"name":"Social Science"],
        ["id":28,"name":"Sociology"],
        ["id":29,"name":"Statistics"],
        ["id":30,"name":"Writing"],
        ["id":31,"name":"Other"],
        ["id":32,"name":"Algebra"],
        ["id":33,"name":"Programming"],
        ["id":34,"name":"Communications"],
        ["id":35,"name":"Film"],
        ["id":36,"name":"Management"],
        ["id":37,"name":"SAT"]
    ]
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.imvLogo.layer.borderWidth = 0.5
        self.imvLogo.layer.borderColor = UIColor.clearColor().CGColor
        self.imvLogo.layer.cornerRadius = self.imvLogo.frame.width/2.0
        self.imvLogo.clipsToBounds = true
        self.imvReadMark.hidden = true
        self.imvLogoMask.layer.cornerRadius = self.imvLogoMask.frame.width/2.0
        self.imvLogoMask.clipsToBounds = true
        
        self.imvLogoCircle1.clipsToBounds = true
        self.imvLogoCircle2.clipsToBounds = true
        
        self.priceLabel.textColor = UIColor.whiteColor()
        self.priceLabel.text = "$30"
        self.priceLabel.textAlignment = NSTextAlignment.Center
        
        self.timeLabel.textColor = UIColor.whiteColor()
        self.timeLabel.text = "2h"
        self.timeLabel.textAlignment = NSTextAlignment.Center
	
        
    }
    
    func setData(questionModel:QuestionModel){
        var date = NSDate(timeIntervalSince1970:questionModel.create_time as Double)
        
        self.lblTitle?.text = questionModel.title
        
        self.lblSubTitle?.text = questionModel._description
        self.lblTimesAgo?.text = date.relativeTime
        
        
        //set price
        self.priceLabel.text = "$" + (questionModel.price as NSString).substringToIndex(count(questionModel.price) - 3)
        
        //set time left
        let timeToDeadline = questionModel.deadline
        let currentTime = NSDate().timeIntervalSince1970
        
        
        let deadlineTime = NSDate(timeIntervalSince1970: NSTimeInterval(timeToDeadline.doubleValue + currentTime))
        
        let dateFormatter = NSDateFormatter()
        //the "M/d/yy, H:mm" is put together from the Symbol Table
        dateFormatter.dateFormat = "MMM d hh:mm a"
        
        // Show only when it's in progress
        if ( ( (questionModel.deadline as Double) > 0)
            && (questionModel.accept["status"] as! NSNumber == 1)
            && (questionModel.withdrawed != "1")
            && (questionModel.paid == "0") ) {
                self.lblDeadline.text = String(format: "Due: %@", dateFormatter.stringFromDate(deadlineTime))
        } else {
            self.lblDeadline.text = ""
        }
        
        
        let difference = timeToDeadline.doubleValue
        let days = Int(difference) / (3600*24)
        let hours = Int(difference) / (3600)
        let minutes = Int(difference) / (60)
        
        if (minutes <= 0)
        {
            self.timeLabel.text = "0m"
        }
        else
        {
            if (minutes <= 60)
            {
                self.timeLabel.text = String(minutes) + "m"
            }
            else if (hours <= 24)
            {
                self.timeLabel.text = String(hours) + "h"
            }
            else
            {
                self.timeLabel.text = String(days) + "d"
            }
        }
        
        
        
        if (questionModel.unread == 0) {//if read
            self.imvReadMark.hidden = true
            if (questionModel.real_answers.toInt() == 1)
            {
                self.lblNumOfAnswers.text = "\(questionModel.real_answers) bid"
            }
            else{
                self.lblNumOfAnswers.text = "\(questionModel.real_answers) bids"
            }
        }
        else{
            self.imvReadMark.hidden = false
            
            self.lblNumOfAnswers.text = "\(questionModel.unread) Unread bids"
        }
        
        if(questionModel.question_notifications > 0){
            
            self.imvLogoCircle1.layer.shadowColor = UIColor.blackColor().CGColor
            self.imvReadMark.hidden = false
            self.lblUnread.hidden = false
            self.lblUnread.text = String(questionModel.question_notifications)
            
        }else{
            self.imvReadMark.hidden = true
            self.lblUnread.hidden = true
        }
        
        self.imvLogoCircle1.layer.cornerRadius = self.imvLogoCircle1.frame.width / 2
        self.imvLogoCircle1.layer.borderWidth = 2
        self.imvLogoCircle1.layer.borderColor = UIColor.whiteColor().CGColor
        
        self.imvLogoCircle1.layer.shadowOpacity = 0.3
        
        self.imvLogoCircle1.layer.shadowOffset = CGSizeMake(0.0,1.0)
        self.imvLogoCircle1.layer.masksToBounds = false
        self.imvLogoCircle1.layer.shadowRadius = 2.5
        
        self.imvLogoCircle2.layer.cornerRadius = self.imvLogoCircle1.frame.width / 2
        self.imvLogoCircle2.layer.borderWidth = 2
        self.imvLogoCircle2.layer.borderColor = UIColor.whiteColor().CGColor
        
        self.imvLogoCircle2.layer.shadowOpacity = 0.3
        self.imvLogoCircle2.layer.shadowColor = UIColor.blackColor().CGColor
        self.imvLogoCircle2.layer.shadowOffset = CGSizeMake(0.0,1.0)
        self.imvLogoCircle2.layer.masksToBounds = false
        self.imvLogoCircle2.layer.shadowRadius = 2.5
        
        
        //check if paid
        if (questionModel.paid == "1" )
        {
            self.lblStatusLabel.text = "Completed"
            self.lblStatusLabel.textColor = self.lblTitle.textColor
            self.imvLogoCircle1.backgroundColor = UIColor(red: 134.0/255, green: 131.0/255, blue: 135.0/255, alpha: 1.0)
            self.imvLogoCircle2.backgroundColor = UIColor(red: 134.0/255, green: 131.0/255, blue: 135.0/255, alpha: 1.0)
        
        }else if (questionModel.withdrawed != "0" && questionModel.resolutionSolved == 1 && questionModel.resolutionRefunded == 1){
            
            self.lblStatusLabel.text = "Question Refunded"
            self.lblStatusLabel.textColor = UIColor(red: 255/255, green: 42.0/255, blue: 91.0/255, alpha: 1.0)
            self.imvLogoCircle1.backgroundColor = UIColor(red: 255/255, green: 42.0/255, blue: 91.0/255, alpha: 1.0)
            self.imvLogoCircle2.backgroundColor = UIColor(red: 255/255, green: 42.0/255, blue: 91.0/255, alpha: 1.0)
            
        }
        else if (questionModel.withdrawed != "0" && questionModel.resolutionSolved == 1 && questionModel.resolutionRefunded == 0){
            
            self.lblStatusLabel.text = "Withdraw Declined"
            self.lblStatusLabel.textColor = UIColor(red: 255/255, green: 42.0/255, blue: 91.0/255, alpha: 1.0)
            self.imvLogoCircle1.backgroundColor = UIColor(red: 255/255, green: 42.0/255, blue: 91.0/255, alpha: 1.0)
            self.imvLogoCircle2.backgroundColor = UIColor(red: 255/255, green: 42.0/255, blue: 91.0/255, alpha: 1.0)
            
        }
            
        else if (questionModel.paid == "0")
        {
            if(questionModel.numBids == 0){
                self.lblStatusLabel.text = "Bids Pending"
            }
            if(questionModel.numBids != 0){
                self.lblStatusLabel.text = "\(questionModel.numBids) Bids"
            }
            
            self.lblStatusLabel.textColor = UIColor.grayColor()//self.lblTitle.textColor
            self.imvLogoCircle1.backgroundColor = UIColor(red: 0.0/255, green: 193.0/255, blue: 248.0/255, alpha: 1.0)
            self.imvLogoCircle2.backgroundColor = UIColor(red: 0.0/255, green: 193.0/255, blue: 248.0/255, alpha: 1.0)
            
            if(questionModel.accept["status"] as! NSNumber == 1 && questionModel.withdrawed != "1"){
                self.lblStatusLabel.textColor = self.lblTitle.textColor
                if ( (questionModel.deadline as Double) > 0) {
                    self.lblStatusLabel.text = "In Progress"
                } else {
                    self.lblStatusLabel.text = "Overdue"
                }
            }
        }
        else if (questionModel.real_answers == ""){
            self.lblStatusLabel.text = "No bids yet"
            self.lblStatusLabel.textColor = UIColor.grayColor()//self.lblTitle.textColor
        }
        
        //check if withdrawn
        if (questionModel.withdrawed != "0" && questionModel.resolutionSolved == 0)
        {
            self.lblStatusLabel.text = "Withdrawn"
            self.lblStatusLabel.textColor = UIColor(red: 255/255, green: 42.0/255, blue: 91.0/255, alpha: 1.0)
            self.imvLogoCircle1.backgroundColor = UIColor(red: 255/255, green: 42.0/255, blue: 91.0/255, alpha: 1.0)
            self.imvLogoCircle2.backgroundColor = UIColor(red: 255/255, green: 42.0/255, blue: 91.0/255, alpha: 1.0)
            
        }
        
        questionModel.lastToTalk = questionModel.lastToTalk.stringByReplacingOccurrencesOfString(" ", withString: "%20", options: NSStringCompareOptions.RegularExpressionSearch, range: nil)
        questionModel.avatar = questionModel.avatar.stringByReplacingOccurrencesOfString(" ", withString: "%20", options: NSStringCompareOptions.RegularExpressionSearch, range: nil)
        
        // Image of feed cell
        if (questionModel.showCategory == 1) {
            // Put question category
            let categoryIndex = questionModel.category.toInt()
            for eachInput in pickerData {
                if (eachInput["id"] as! Int) == categoryIndex {
                    ImageLoader.sharedLoader.imageFromAssets(eachInput["name"] as! String, imageview: self.imvLogo)
                }
            }
            
        } else {
            // Put last to talk
            ImageLoader.sharedLoader.imageForUrl(questionModel.lastToTalk, imageview: self.imvLogo, completionHandler:{(image: UIImage?, url: String) in
                
            })
        }
        
        
        
        
    }
    
}
