//
//  AnimatedCustomSplashViewController.swift
//  spios
//
//  Created by Артем Труханов on 29.05.15.
//  Copyright (c) 2015 Studypool. All rights reserved.
//

import UIKit
import CoreData



class AnimatedCustomSplashViewController: UIViewController {
    
    ///core data for loing object
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext

    
    @IBOutlet weak var animateview: AnimatedCustomSplashView!
    
    
    
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)


    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.animateview.initviews()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        //animation
        
        self.animateview.viewdidappear()
        
        NSTimer.scheduledTimerWithTimeInterval(5.4, target: self, selector: Selector("showLoginPage"), userInfo: nil, repeats: false)
        
    }
    
    /**
    Check Phone Verified
    **/
    
    func isCheckPhoneVerified(success: (response: Bool) -> Void) {
        
        let version = NSBundle.mainBundle().infoDictionary?["CFBundleShortVersionString"] as! String
        
        let parameters = [
            "token": token,
            "version" : version
        ]
        
        NetworkUI.sharedInstance.isCheckPhoneVerification(parameters, success: { (response) -> Void in
            var status = response["status"] as! String
            if(status == "out_of_date"){
                isUptodate = false
                
                if(isUptodate == false){
                    var refreshAlert = UIAlertController(title: "Studypool", message: "Your app is out of date, Please update your app", preferredStyle: UIAlertControllerStyle.Alert)
                    
                    refreshAlert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { (action: UIAlertAction!) in
                        
                        UIApplication.sharedApplication().openURL(NSURL(string: "https://itunes.apple.com/us/app/studypool/id1033410225?mt=8")!)
                    }))
                    
                    refreshAlert.addAction(UIAlertAction(title: "Not, for now", style: .Default, handler: { (action: UIAlertAction!) in
                        
                    }))
                    
                    self.presentViewController(refreshAlert, animated: true, completion: nil)
                }
                
                
            }else if status == "verified" {
                isUptodate = true
                success(response: true)
            }
            else {
                isUptodate = true
                success(response: false)
                
            }
            
            
            
            }) { (error) -> Void in
                
                return false
        }
        
    }

    /**
    Enter feedscreen
    */
    func enterFeed(){
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        token = appDelegate.userlogin.token
        
        self.isCheckPhoneVerified { (response) -> Void in
            if (response) {
                // create viewController code...
                let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                token = appDelegate.userlogin.token
                appDelegate.createMenuView()
            }
            else {
                TAOverlay.showOverlayWithLabel("Please verify with your phone number", options: TAOverlayOptions.OverlaySizeRoundedRect|TAOverlayOptions.OverlayTypeWarning|TAOverlayOptions.AutoHide)
                
                var storyboard = UIStoryboard(name: "Auth", bundle: nil)
                
                let phoneverify = storyboard.instantiateViewControllerWithIdentifier("PhoneVerVC") as! PhoneVerificationViewController
                
                self.presentViewController(phoneverify, animated: true, completion: nil)
                
            }
        }
    }

    
    
    func showLoginPage()
    {
        // Login or PhoneVerification
        // Execute the fetch request, and cast the results to an array of LogItem objects
        let fetchRequest = NSFetchRequest(entityName: "UserLogin")
        if let fetchResults = managedObjectContext!.executeFetchRequest(fetchRequest, error: nil) as? [UserLogin] {
            
            if (fetchResults.count > 0){
                let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                appDelegate.userlogin = fetchResults[fetchResults.count-1]
                NSLog("%@", appDelegate.userlogin.id)
                enterFeed()
            }
        }
        self.performSegueWithIdentifier("showlogin", sender: self)
    }
    
}
