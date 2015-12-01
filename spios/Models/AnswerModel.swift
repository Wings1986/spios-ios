//
//  AnswerModel.swift
//  spios
//
//  Created by MobileGenius on 6/17/15.
//  Copyright (c) 2015 Studypool. All rights reserved.
//

import UIKit

/// Model for Answer pages

public class AnswerModel: NSObject {
    
    /// answer id
    public var answer_id       : String
    /// question id
    public  var question_id     : String
    /// created time
    public  var created_time    : NSNumber
    /// answer title
    public var title           : String
    /// answer detail
    public var _description    : String
    /// student id
    public var owner_id        : String
    /// avatar url
    public var avatar          : String
    
    init(dic : NSDictionary){
        
        self.answer_id = dic["answer_id"] as! String
        self.question_id = dic["question_id"] as! String
        self.created_time = dic["create_time"] as! NSNumber
        self.title = dic["title"] as! String
        self._description = dic["description"] as! String
        self.owner_id = dic["owner_id"] as! String
        self.avatar = String(format: "https://www.studypool.com/uploads/avatar/%@/profile photo.jpg",self.owner_id)
    }

}
