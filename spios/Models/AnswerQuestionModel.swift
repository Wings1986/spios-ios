//
//  AnswerModel.swift
//  spios
//
//  Created by MobileGenius on 6/17/15.
//  Copyright (c) 2015 Studypool. All rights reserved.
//

import UIKit

public class AnswerQuestionModel: NSObject {
    
    /// question id
    var question_id     : String
    /// created time
    var created_time    : NSNumber
    /// answer title
    var title           : String
    /// answer detail
    var _description    : String
    /// student id
    var owner_id        : String
    /// avatar url
    var avatar          : String
    
    init(dic : NSDictionary){
        
        self.question_id = dic["question_id"] as! String
        self.created_time = dic["create_time"] as! NSNumber
        self.title = dic["title"] as! String
        self._description = dic["description"] as! String
        self.owner_id = dic["owner_id"] as! String
        self.avatar = String(format: "https://www.studypool.com/uploads/avatar/%@/profile photo.jpg",self.owner_id)
    }

}
