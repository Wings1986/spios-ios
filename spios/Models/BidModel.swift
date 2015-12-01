//
//  AnswerModel.swift
//  spios
//
//  Created by MobileGenius on 6/17/15.
//  Copyright (c) 2015 Studypool. All rights reserved.
//

import UIKit

/// Model for Bid list and detail pages
public class BidModel: NSObject {
    
    /// bid price
    var price           : String
    /// created time
    var created_time    : NSNumber
    /// student id
    var owner_id        : String
    /// tutor avatar
    var avatar          : String
    /// tutor name
    var tutorname       : String
    /// tutor deadline
    var deadline        : String
    /// answer id
    var answer_id       : String
    /// unread discuss message count
    var bid_notifications : Int
    
    var recommended     : Bool
    
    var university      : String
    
    var major           : String
    
    var rating          : String
    
    var tier_name       : String
    
    var tier_price      : String
    
    var calc_price      : Float
    
    var deliverin       : String
    
    var est_time        : String
    
    var timetype        : String
    
    init(dic : NSDictionary){
        
        self.created_time = dic["create_time"] as! NSNumber
        self.price = dic["price"] as! String
        self.owner_id = dic["owner_id"] as! String
        self.answer_id = dic["answer_id"] as! String
        
        self.avatar = dic["avatar"] as! String
        self.avatar = self.avatar.stringByReplacingOccurrencesOfString(" ", withString: "%20", options: NSStringCompareOptions.RegularExpressionSearch, range: nil)
        
        self.timetype = dic["time_type"] as! String
        self.tutorname = dic["tutorusername"] as! String
        self.deadline = dic["deliverin"] as! String
        self.bid_notifications = dic["bid_notifications"] as! Int
        
        self.recommended = (dic["recommended"] as? String) == "1"
        
        self.university = dic["university"] as! String
        self.major = dic["major"] as! String
        
        // Making sure rating exists, as per Fabric.io crash report.
        if dic["rating"] != nil {
            self.rating = dic["rating"] as! String
        }
        else {
            // Default to zero
            self.rating = "4.0"
        }
        
        self.tier_name = dic["tier_name"] as! String
        self.tier_price = dic["tier_price"] as! String
        self.calc_price = dic["calc_price"] as! Float
        self.deliverin = dic["deliverin"] as! String
        self.est_time = dic["est_time"] as! String
    }

    
}
extension String {
    
    subscript (i: Int) -> Character {
        return self[advance(self.startIndex, i)]
    }
    
    subscript (i: Int) -> String {
        return String(self[i] as Character)
    }
    
    subscript (r: Range<Int>) -> String {
        return substringWithRange(Range(start: advance(startIndex, r.startIndex), end: advance(startIndex, r.endIndex)))
    }
}
