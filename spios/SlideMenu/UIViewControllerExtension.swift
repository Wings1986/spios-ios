//
//  UIViewControllerExtension.swift
//
//  Created by Yuji Hato on 1/19/15.
//  Modified by Andrew Mikhailov on 2015.06.18.
//  Copyright (c) 2015 Yuji Hato. All rights reserved.
//

import UIKit
import Alamofire
import FRDLivelyButton

var g_hamburgerNotificationsCountLabel: UILabel? = nil

extension UIViewController {
    
    func setNavigationBarItem() {
        
        // Create a "hamburger" button and a notifications count label on this button
        let buttonBack: UIButton = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
        buttonBack.frame = CGRectMake(0, 0, 20, 20)
        buttonBack.setImage(UIImage(named: "top_menu"), forState: UIControlState.Normal)
        buttonBack.addTarget(self, action: "toggleLeft", forControlEvents: UIControlEvents.TouchUpInside)
        
//        var hamburgerButton = LBHamburgerButton(frame: CGRectMake(0, 0, 40, 50), type: LBHamburgerButtonType.BackButton, lineWidth: 20, lineHeight: 20/6, lineSpacing: 2, lineCenter: CGPointMake(10, 25), color: UIColor(red: 0, green: 192.0/255, blue: 251.0/255, alpha: 1.0))
//
//        hamburgerButton.backgroundColor = UIColor.clearColor()
        
        

        var hamburgerButton = FRDLivelyButton(frame: CGRectMake(0, 0, 20, 20))
//        hamburgerButton.setLayerLineLength(50)
        hamburgerButton.setStyle(kFRDLivelyButtonStyleHamburger, animated: false)
        hamburgerButton.options = [kFRDLivelyButtonLineWidth: 3.0,
            kFRDLivelyButtonHighlightedColor: UIColor(red: 0, green: 193.0/255, blue: 248.0/255, alpha: 1.0),
            kFRDLivelyButtonColor: UIColor(red: 0, green: 193.0/255, blue: 248.0/255, alpha: 1.0)
        ]
        hamburgerButton.addTarget(self, action: "toggleLeft", forControlEvents: UIControlEvents.TouchUpInside)
        
        /*
        var badgeLabel: SwiftBadge = SwiftBadge(frame: CGRect(x: 13, y: 0, width: 19, height: 13))
        badgeLabel.text = ""
        badgeLabel.font = UIFont(name: "Exo-ExtraBold", size: 11.0)
        badgeLabel.textAlignment = NSTextAlignment.Center
        badgeLabel.hidden = true
        g_hamburgerNotificationsCountLabel = badgeLabel
        hamburgerButton.addSubview(badgeLabel)

*/
        var leftBarButtonItem: UIBarButtonItem = UIBarButtonItem(customView: hamburgerButton)
        navigationItem.leftBarButtonItem = leftBarButtonItem


        
        // Load notifications count
        /*
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
            
            // TODO: This code is similar to code available in the menu view controller class
            
            // User data to communicate with the server
            let applicationDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            let userToken: String? = applicationDelegate.userlogin.token
            
            // Load student and tutor notifications count
            var studentNotificationsCountUri: String = "https://www.studypool.com/questions/ApiStudentNoti?token=\(userToken!)"
            var tutorNotificationsCountUri: String = "https://www.studypool.com/questions/ApitutorNoti?token=\(userToken!)"
            self.loadJSONNumber(studentNotificationsCountUri, callback: {
                (studentNotificationsCount: Int) -> Void in
                self.loadJSONNumber(tutorNotificationsCountUri, callback: {
                    (tutorNotificationsCount: Int) -> Void in
                    var totalNotificationsCount = studentNotificationsCount + tutorNotificationsCount
                    if (0 == totalNotificationsCount) {
                        badgeLabel.hidden = true
                    } else {
                        badgeLabel.hidden = false
                    }
                    
                    badgeLabel.text = "\(totalNotificationsCount)"
                    
                    badgeLabel.frame = CGRect(x: 13, y: 0, width: 19, height: 13)
                })
            })
        })
*/
        
        self.slideMenuController()?.removeLeftGestures()
        self.slideMenuController()?.addLeftGestures()
    }
    
    func removeNavigationBarItem() {
        self.navigationItem.leftBarButtonItem = nil
        self.navigationItem.rightBarButtonItem = nil
        self.slideMenuController()?.removeLeftGestures()
        self.slideMenuController()?.removeRightGestures()
    }
    
    // TODO: This code is similar to code available in the menu view controller class
    func loadJSONNumber(uri: String, callback: (Int) -> Void) {
        request(.GET, uri).responseJSON() {
            (_, _, result, error) in
            if (nil == error) {
                var value = result! as! NSString
                callback(value.integerValue)
            }
        }
    }
}