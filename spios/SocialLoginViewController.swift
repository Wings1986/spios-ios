//
//  SocialLoginViewController.swift
//  spios
//
//  Created by user on 6/24/15.
//  Copyright (c) 2015 Studypool. All rights reserved.
//

import UIKit
import CoreData
import Analytics

class SocialLoginViewController: UIViewController, UIWebViewDelegate {
    var black: Bool!

    /// back button
    @IBOutlet weak var backButton: UIButton!
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        
        if (self.black == true)
        {
            self.backButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
            self.backButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Selected)
            self.backButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Highlighted)

        }

        
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.loadwebview()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var webview: UIWebView!
    var socialURL : String!
    var socialType : String!
    var parentview : LoginViewController!
    var signupview : SignupViewController!
    
    func loadwebview(){
        
        MediumProgressViewManager.sharedInstance.showProgressOnView(self)
        let requestURL = NSURL(string:socialURL)
        let request = NSURLRequest(URL: requestURL!)
        self.webview.loadRequest(request)

    }
    /**
        comoplete login and enter main feed screen
    */
    func webViewDidFinishLoad(webView: UIWebView) {
        
        MediumProgressViewManager.sharedInstance.hideProgressView(self)
        

        let response = webView.stringByEvaluatingJavaScriptFromString("document.body.innerHTML")
        NSLog("%@", response!)
        
        if response!.rangeOfString("user_id") != nil{
            webView.removeFromSuperview()
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
            
            if(signupview == nil){
                let newItem = NSEntityDescription.insertNewObjectForEntityForName("UserLogin", inManagedObjectContext: parentview.managedObjectContext!) as! UserLogin
                newItem.id = json["user_id"] as! String
                newItem.token = json["token"] as! String
                newItem.username = json["username"]as! String
                
                
                parentview.managedObjectContext?.save(nil)
                let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                appDelegate.userlogin = newItem
                self.navigationController?.popViewControllerAnimated(false)
                println("good\(data)")
                parentview.loginview.enterFeed()
                SEGAnalytics.sharedAnalytics().track(String(format: "Logged in with %@", socialType), properties: [:])
                
            }else{
                let newItem = NSEntityDescription.insertNewObjectForEntityForName("UserLogin", inManagedObjectContext: signupview.managedObjectContext!) as! UserLogin
                newItem.id = json["user_id"] as! String
                newItem.token = json["token"] as! String
                newItem.username = json["username"]as! String
                
                
                signupview.managedObjectContext?.save(nil)
                let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                appDelegate.userlogin = newItem
                println("good\(data)")
                self.navigationController?.popViewControllerAnimated(false)
                signupview.enterFeed()
                SEGAnalytics.sharedAnalytics().track(String(format: "Signed up with %@", socialType), properties: [:])
            }
        }
    }

    /**
        back to login page
    */
    @IBAction func onBack(sender: AnyObject) {
        self.webview.stopLoading()
        self.navigationController?.popViewControllerAnimated(true)
    }

}
