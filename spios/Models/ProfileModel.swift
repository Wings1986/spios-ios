//
//  ProfileModel.swift
//  spios
//
//  Created by MobileGenius on 6/15/15.
//  Copyright (c) 2015 Studypool. All rights reserved.
//

import UIKit

public class ProfileModel: NSObject {
    
    /// user id
    var user_id         : String
    /// user name
    var username        : String
    /// created time
    var create_time     : String
    /// last action time
    var last_action     : String
    /// profile url
    var profile_pic     : String
    /// totla questions count
    var total_questions : String
    /// completed questions count
    var complete_questions : String
    /// is gold member
    var gold            : String
    /// current balance
    var balance         : String
    
    init(dic : NSDictionary){
        self.user_id = dic["user_id"] as! String
        self.username = dic["username"] as! String
        self.create_time = dic["create_time"] as! String
        self.last_action = dic["last_action"] as! String
        self.profile_pic = dic["profile_pic"] as! String
        self.total_questions = dic["total_questions"] as! String
        //self.complete_questions = dic["complete_questions"] as! String
        self.complete_questions = ""
        self.gold = dic["gold"] as! String
        self.balance = dic["balance"] as! String
        
    }
}
