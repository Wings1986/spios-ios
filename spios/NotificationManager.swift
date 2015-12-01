//
//  NotificationManager.swift
//  spios
//
//  Created by Samarth Sandeep on 6/17/15.
//  Copyright (c) 2015 Studypool. All rights reserved.
//

import Foundation
import Alamofire

class NotificationManager: NSObject {
    var deviceToken:NSString = ""
    var userToken:NSString = ""
	
    
    func setDeviceIOSToken(string:NSString){
        deviceToken = string
		devToken = string as String
        
    }
    func setUserOfNotifToken(string:NSString){
        userToken = string
        
        println("posting")
        
        let params = [
            "token": userToken,
            "device":"ios",
            "push_token":deviceToken
            
        ]
        
        NetworkUI.sharedInstance.postDeviceToken(params, success: { (response) -> Void in
            println("good\(response)")
            }) { (error) -> Void in
        }
    
    
}
func http(request: NSURLRequest!, callback: (NSDictionary, String?) -> Void) {
    //    func http(request: NSURLRequest!, callback: (String, String?) -> Void) {
    var session = NSURLSession.sharedSession()
    var task = session.dataTaskWithRequest(request){
        (data, response, error) -> Void in
        if error != nil {
            //                callback("", error.localizedDescription)
        } else {
            var result = NSString(data: data, encoding:
                NSASCIIStringEncoding)!
            var jsonResult: AnyObject? = NSJSONSerialization.JSONObjectWithData(data, options:NSJSONReadingOptions.AllowFragments, error: nil)
            println(jsonResult)
            //callback(jsonResult as! NSDictionary, nil)
            //callback(jsonResult as! String, nil)
        }
    }
    task.resume()
}
}
