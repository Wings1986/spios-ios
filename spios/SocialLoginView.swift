//
//  SocialLoginView.swift
//  spios
//
//  Created by MobileGenius on 6/16/15.
//  Copyright (c) 2015 Studypool. All rights reserved.
//

import UIKit
import CoreData

class SocialLoginView: UIView, UIWebViewDelegate {

    @IBOutlet weak var webview: UIWebView!
    var socialURL : String!
    var parentview : LoginViewController!
    var signupview : SignupViewController!
    
    class func loadFromNibNamed(nibNamed: String, bundle : NSBundle? = nil) -> UIView? {
        return UINib(
            nibName: nibNamed,
            bundle: bundle
            ).instantiateWithOwner(nil, options: nil)[0] as? UIView
    }
    
    func loadwebview(){
        let requestURL = NSURL(string:self.socialURL)
        let request = NSURLRequest(URL: requestURL!)
        self.webview.loadRequest(request)
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        let response = webView.stringByEvaluatingJavaScriptFromString("document.body.innerHTML")
        NSLog("%@", response!)
        
        if response!.rangeOfString("user_id") != nil{
            var range = response!.rangeOfString("{")?.startIndex
            var range2 = response!.rangeOfString("}")?.startIndex
            
            let res = response!.substringWithRange(Range<String.Index>(start: range!, end: range2!)) //"llo, playgroun"
            let ret = res.stringByAppendingString("}")
            NSLog("%@", ret)
            
            
            var data: NSData = ret.dataUsingEncoding(NSUTF8StringEncoding)!
            var error: NSError?
            
            // convert NSData to 'AnyObject'
            let anyObj: AnyObject? = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions(0),
                error: &error)
            let json = anyObj as! NSDictionary
            if(signupview != nil){
            
                let newItem = NSEntityDescription.insertNewObjectForEntityForName("UserLogin", inManagedObjectContext: parentview.managedObjectContext!) as! UserLogin
                newItem.id = json["user_id"] as! String
                newItem.token = json["token"] as! String
                newItem.username = json["username"]as! String
                
                
                parentview.managedObjectContext?.save(nil)
                let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                appDelegate.userlogin = newItem
                println("good\(data)")
                parentview.loginview.enterFeed()
            }else{
                let newItem = NSEntityDescription.insertNewObjectForEntityForName("UserLogin", inManagedObjectContext: signupview.managedObjectContext!) as! UserLogin
                newItem.id = json["user_id"] as! String
                newItem.token = json["token"] as! String
                newItem.username = json["username"]as! String
                
                
                signupview.managedObjectContext?.save(nil)
                let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                appDelegate.userlogin = newItem
                println("good\(data)")
                signupview.enterFeed()
            }
            
        }
    
    
    }
}
