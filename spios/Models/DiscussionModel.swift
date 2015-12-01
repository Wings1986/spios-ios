//
//  AnswerModel.swift
//  spios
//
//  Created by MobileGenius on 6/17/15.
//  Copyright (c) 2015 Studypool. All rights reserved.
//

import UIKit

/// Model for discussion pages

public class DiscussionModel: NSObject {
    
    /// message sender id
    var sender          : String
    /// created time
    var created_time    : String
    /// message receiver id
    var receiver        : String
    /// discuss id
    var discuss_id      : String
    /// description
    var _description    : String
    /// username
    var username        : String
    /// avatar url
    var avatar          : String
    /// attach (images)
    var attachment_img  : NSArray
    /// attach (links)
    var attachment_link  : NSArray
    /// tags
    var withtags          : String
    
    init(dic : NSDictionary){
        
        self.created_time = dic["create_time"] as! String
        self.sender = dic["sender"] as! String
        self.receiver = dic["receiver"] as! String
        self.discuss_id = dic["discuss_id"] as! String
        self._description = dic["description"] as! String
        self.username = dic["username"] as! String
        self.avatar = dic["avatar"] as! String
        self.avatar = self.avatar.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
        self.attachment_img = dic["attachment_img"] as! NSArray
        self.attachment_link = dic["attachment_link"] as! NSArray
        self.withtags = dic["withtags"] as! String

    }

}
