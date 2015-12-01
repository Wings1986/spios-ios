
//
//  Global.swift
//  spios
//
//  Created by Stanley Chiang on 4/15/15.
//  Copyright (c) 2015 Studypool. All rights reserved.
//

import Foundation
import MBProgressHUD

/// current user ID
var user_id:Int = 0
/// current User Token
var token:String!
/// phonenumber
var phoneNum:String!
/// current Post count
var postCount:Int!
/// current username
var username:String!
///
var questionCase:Int = 0
///
var numChecked:Bool = false
///
var numVerified:Bool = false
/// price when user purchase
var currentprice:Float!
/// paypal token
var paypaltoken:String = ""
/// stripe token
var stripetoken:String = ""
/// card number
var cardnumber:String = ""
/// current balance
var balance:String = "0.0"
/// tutor bid price
var globalPaymentPrice: String = "0.0"
/// current avatar url
var studentImage: UIImage!
/// selected tutor avatar url
var tutorImage: UIImage!
/// check Urgent at Posting setting
var qUrgent: Bool = false
/// check Private at Posting setting
var qPrivate: Bool = false
/// selected answer ID
var answerid:String!
/// remain balance
var remainingAmt: String!
/// post question parameter dictinoary
var postQuestionParameters:NSDictionary!
//device token for notifications
var devToken:String!
var qdEntered:Bool!
var responseFromQuestion:String!
var notificationIsReceived:Bool!
var questionIDFromNotifications:String!
//Category Selected Index
var ctSelectedIndex:Int! = 6
//Settings Question
var stBudget:Int! = 1
var stTime:Int! = 1
var stTimeType:String! = "Hours"
var stPrivateQues:Bool! = false
var stUrgentQues:Bool! = false
var counter:Int!
var userInputQuestionTitle:String! = ""
var userInputQuestionDescription:String! = ""
var reviewRating:Int! = 1
var isPaymentPopup:Bool! = false

var linkToReferral:String!
var isUptodate:Bool! = false

/**
Turn a string into a json string
:param: value: The object (probably a string) to turn into json format
:param: prettyPrinted: Specifies if the json should be pretty Printed
:returns: the json string
*/
func JSONStringify(value: AnyObject, prettyPrinted: Bool = false) -> String {
    var options = prettyPrinted ? NSJSONWritingOptions.PrettyPrinted : nil
    if NSJSONSerialization.isValidJSONObject(value) {
        if let data = NSJSONSerialization.dataWithJSONObject(value, options: options, error: nil) {
            if let string = NSString(data: data, encoding: NSUTF8StringEncoding) {
                return string as String
            }
        }
    }
    return ""
}
