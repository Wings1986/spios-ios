//
//  QuestionModel.swift
//  spios
//
//  Created by MobileGenius on 6/9/15.
//  Copyright (c) 2015 Studypool. All rights reserved.
//

import UIKit

public class QuestionModel: NSObject {
    
    /// created time
    var create_time : NSNumber
    /// question detail
    var _description : String
    ///
    var due : NSNumber
    /// is free
    var free : String
    /// is paid
    var paid : String
    /// question id
    var question_id : String
    /// answers count
    var real_answers : String
    /// question title
    var title : String
    ///
    var today : String
    /// is unread
    var unread : NSNumber
    /// is withdrawed
    var withdrawed : String
    /// student id
    var owner_id : String
    /// student avatar url
    var avatar : String
    /// price range
    var price : String
    /// Amount withdrawn from PayPal
    var paypalWithdrawal: String?
    /// Amount withdrawn from Credit Card
    var creditCardWithdrawal: String?
    /// Amount withdrawn from Balance
    var balanceWithdrawal: String?
    /// deadline
    var deadline : NSNumber
    /// accept info
    var accept : NSDictionary
    /// is urgent
    var isUrgent : Int
    var chargeForUrgent : Int
    /// is private
    var isPrivate : Int
	//bids
	var numBids : Int
//    var withtags : String
    /// unread discuss message count
    var question_notifications : Int
    
    // Last to send message
    var lastToTalk: String
    
    // Whether to show category
    var showCategory: Int
    
    var category: String
    
    // Resolutions
    var resolutionRefunded: Int
    var resolutionSolved: Int
    
    init(dic : NSDictionary){
        
        self.create_time = dic["create_time"] as! NSNumber
        self._description = dic["description"] as! String
        self.due = 0//dic["due"] as! NSNumber
        self.free = ""//dic["free"] as! String
        self.paid = dic["paid"] as! String
        self.question_id = dic["question_id"] as! String
        self.real_answers = dic["real_answers"] as! String
        self.title = dic["title"] as! String
        self.today = ""//dic["today"] as! String
        self.unread = dic["unread"] as! NSNumber
        self.withdrawed = dic["withdrawed"] as! String
        self.owner_id = dic["owner_id"] as! String
        self.avatar = dic["avatar"] as! String
        self.lastToTalk = dic["lastToTalk"] as! String
        self.deadline = dic["deadline"] as! NSNumber
        self.price = dic["price"] as! String
        self.accept = dic["accept"] as! NSDictionary
        self.isUrgent = dic["isurgent"] as! Int
        self.chargeForUrgent = dic["chargeForUrgent"] as! Int
        self.isPrivate = dic["isprivate"] as! Int
        self.question_notifications = dic["question_notifications"] as! Int
        if(dic["bidcount"] != nil){
            self.numBids = dic["bidcount"] as! Int
        }else{
            self.numBids = 0
        }
        
        self.showCategory = dic["showCategory"] as! Int
        self.category = dic["category"] as! String
//        self.withtags = dic["withtags"] as! String
        self.resolutionRefunded = dic["resolution_refunded"] as! Int
        self.resolutionSolved = dic["resolution_solved"] as! Int
        
        //FIXME: uncomment the following to get info from server
//        self.creditCardWithdrawal = dic["stripe"] as? String
//        self.paypalWithdrawal = dic["paypal"] as? String
//        self.balanceWithdrawal = dic["cash"] as? String
        
        self.creditCardWithdrawal = "5"
//        self.balanceWithdrawal = "100"
    }
}
