//
//  DLSlideMenuViewController
//  DLHamburguerMenu
//
//  Created by Nacho on 5/3/15.
//  Modified by Andrew Mikhailov on 2015.06.12.
//
//  Copyright (c) 2015 Ignacio Nieto Carvajal. All rights reserved.
//

import UIKit
import Alamofire
import MessageUI
import FRDLivelyButton
import Analytics

///Left slide menu controller

class DLSlideMenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, OverlayviewDelegate, MFMailComposeViewControllerDelegate {
    
    /// Menu table view
    @IBOutlet weak var tableView: UITableView!
    
    /// Profile image
    @IBOutlet weak var profileImageView: UIImageView!
    
    /// profile background blur image
    @IBOutlet weak var profileBackgroundImageView: UIImageView!
    
    /// balance label
    @IBOutlet weak var profileBalanceLabel: UILabel!
    
    /// user name label
    @IBOutlet weak var profileUserNameLabel: UILabel!
    
    /// notification count label
    weak var notificationsCountLabel: UILabel?
    
    // Indexes for navigation actions related to specific menu items
    enum NavigationIndex: Int {
        case Questions = 0, AskQuestion , Invite, HowItWorks, Website, ContactUs, Logout
    }
    
    /// menu items
    let segues = ["My Questions","Ask a Question", "Free Help", "How It Works", "Website", "Contact Us", "Logout"]
    
    /// menu items icon
    let icons = ["question","plus3", "dollar", "book", "network", "mail", "lock"]
    
    /// feed viewcontroller
    var feedViewController: UIViewController!
    
    /// add payment viewcontroller
    var paymentPayViewController: UIViewController!
    
    /// my Answer viewcontroller
    var myanswerViewController: UIViewController!
    
    ///
    var tutorViewController: UIViewController!
    
    /// promition viewcontroller
    var promoViewController: UIViewController!
    
    //how it works view controller
    var howItWorksController: UIViewController!
    
    var tutorApplicationFirstViewController: UIViewController!
    
    var picker: MFMailComposeViewController!
    
    
    /// App delegate
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var storyboard = UIStoryboard(name: "Feed", bundle: nil)
        
//        let feedViewController = storyboard.instantiateViewControllerWithIdentifier("Feed") as! FeedViewController
//        self.feedViewController = UINavigationController(rootViewController: feedViewController)
        //self.feedViewController.navigationController?.navigationBar.backgroundImageForBarMetrics(UIImage(named: "UINavigationBarBackground.png"), forBarMetrics: .Default)
        
        var paymentStoryboard = UIStoryboard(name: "Payment", bundle: nil)
        let paymentPayViewController = paymentStoryboard.instantiateViewControllerWithIdentifier("PaymentPayViewController") as! PaymentPayViewController
        self.paymentPayViewController = UINavigationController(rootViewController: paymentPayViewController);
        
        var storyboard1 = UIStoryboard(name: "Answer", bundle: nil)
        
        let myanswerViewController = storyboard1.instantiateViewControllerWithIdentifier("MyAnswer") as! MyAnswerViewController
        self.myanswerViewController = UINavigationController(rootViewController: myanswerViewController);
        
        var storyboard3 = UIStoryboard(name: "Promotion", bundle: nil)
        
        let promoViewController = storyboard3.instantiateViewControllerWithIdentifier("PromotionViewController") as! PromotionViewController
        self.promoViewController = UINavigationController(rootViewController: promoViewController);
        
        var storyboard4 = UIStoryboard(name: "HowItWorks", bundle: nil)
        
        let howItWorksController = storyboard4.instantiateViewControllerWithIdentifier("HowItWorksViewController") as! HowItWorksViewController
        self.howItWorksController = UINavigationController(rootViewController: howItWorksController);
        
       
        // Make the profile image round shaped
        self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.width / 2
        self.profileImageView.clipsToBounds = true
        
        loadProfilePicture()
        
        //load the email sender 
        //self.picker = MFMailComposeViewController()
        //self.picker.mailComposeDelegate = self

    }
    
    override func viewDidAppear(animated: Bool) {
        
        super.viewDidAppear(animated)
        
        // Load user profile picture
        
        
        // Display user profile name
        let applicationDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        self.profileUserNameLabel.text = applicationDelegate.userlogin.username.uppercaseString
        
        // Load user profile and display profile balance
        self.loadProfile()
        
        // Load and display data for the notifications badge
        // TODO: Properly pass user type (student or tutor)
//        self.loadNotifications(0)
    }
    
    /**
        add blur effect on background image
    */
    func addBlur() {
        var blurEffect = UIVisualEffectView(effect: UIBlurEffect(style: .Light)) as UIVisualEffectView
        blurEffect.frame = self.profileBackgroundImageView.bounds
        self.profileBackgroundImageView.addSubview(blurEffect)

    }
    
    /**
        set image from URL
    */
    func downloadImageAsynchronously(imageView: UIImageView, uri: NSString) {
        request(.GET, "\(uri)").response() {
            (_, _, data, _) in
            let image = UIImage(data: data! as! NSData)
            imageView.image = image
        }
    }
    
    /**
        Load profile image from URL
    */
    func loadProfilePicture() {
        
        // User data to communicate with the server
        let applicationDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let userToken: String? = applicationDelegate.userlogin.token
        let userIdentifier: String? = applicationDelegate.userlogin.id
        
        // Load user profile picture address
        if (nil != userToken) {
            if (nil != userIdentifier) {
                let pictureApiUri = "https://www.studypool.com/questions/ApipicStan?token=\(userToken!)&user_id=\(userIdentifier!)"
                request(.GET, pictureApiUri).responseJSON() {
                    (_, _, result, error) in
                    if (nil == error && result != nil) {
                        
                        var pictureUri: String = result! as! String
                        
                        // Load user profile picture
//                        pictureUri = pictureUri.stringByReplacingOccurrencesOfString(" ", withString: "%20", options: NSStringCompareOptions.RegularExpressionSearch, range: nil)
                        pictureUri = pictureUri.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
                        ImageLoader.sharedLoader.imageForUrl(pictureUri, imageview: self.profileImageView, completionHandler:{(image: UIImage?, url: String) in
                            self.profileBackgroundImageView.image = image?.blurredImage(0.2)
                            UIView(frame: CGRectMake(0, 0, 0, 0))
                            
                            var width:CGFloat = self.profileBackgroundImageView.frame.size.width
                            var height:CGFloat = self.profileBackgroundImageView.frame.size.height
                            let darkLayer = UIView(frame:CGRectMake(0, 0, width, height+20.0))
                            darkLayer.frame.origin = CGPoint(x: 0.0, y: -20.0)
                            darkLayer.backgroundColor = UIColor.darkGrayColor()
                            darkLayer.alpha = 0.66
                            self.profileBackgroundImageView.addSubview(darkLayer)
                        })
                    }
                }
            }
        }
    }
    
    /**
        Load current profile info
    */
    
    func loadProfile() {
        
        // User data to communicate with the server
        let applicationDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let userToken: String? = applicationDelegate.userlogin.token
        let userIdentifier: String? = applicationDelegate.userlogin.id
        
        // Load user profile data
        if (nil != userToken) {
            if (nil != userIdentifier) {
                /**
                * Returns the object with the following structure:
                *
                * {
                *  balance = "0.00";
                *  "complete_questions" = 3;
                *  "create_time" = 1433742409;
                *  gold = 0;
                *  "last_action" = 1434430395;
                *  "profile_pic" = "https://www.studypool.com/pictures/unknown.jpg";
                *  "total_questions" = 4;
                *  "user_id" = 156226;
                *  username = kowaiwoon;
                * }
                *
                **/
                
                
                
                let params = ["token": token]
                NetworkUI.sharedInstance.getBalance(params, success: { (response) -> Void in
                    if let result = response as? NSMutableDictionary {
                        balance = result["balance"] as! String
                        self.profileBalanceLabel.text = "$" + balance
                    }
                    }) { (error) -> Void in
                        TAOverlay.showOverlayWithLabel("Please try again", options: TAOverlayOptions.OverlaySizeRoundedRect|TAOverlayOptions.OverlayTypeWarning|TAOverlayOptions.AutoHide)
                }

//                let studentProfileApiUri = "https://www.studypool.com/questions/apistudentprofile?token=\(userToken!)&user_id=\(userIdentifier!)"
//                request(.GET, studentProfileApiUri).responseJSON() {
//                    (_, _, result, error) in
//                    if (nil == error && result != nil) {
//                        
//                        
//                        
//                        
//                        
//                    }
//                }
            }
        }
    }
    
    /**
        Load user's notification
    */
    func loadNotifications(tutor: Boolean) {
        
        // User data to communicate with the server
        let applicationDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let userToken: String? = applicationDelegate.userlogin.token
        
        // Load student / tutor notifications count
        var notificationCountUri: NSString? = nil
        if (0 == tutor) {
            notificationCountUri = "https://www.studypool.com/questions/ApiStudentNoti?token=\(userToken!)"
        } else {
            notificationCountUri = "https://www.studypool.com/questions/ApitutorNoti?token=\(userToken!)"
        }
        
        if (nil != notificationCountUri) {
            request(.GET, "\(notificationCountUri!)").responseJSON() {
                (_, _, result, error) in
                if (nil == error) {
                    var notificationCount = result! as! NSString
                    // TODO: Remove that after fully testing everything
                    // notificationCount = "11"
                    self.notificationsCountLabel?.text = notificationCount as String
                    if (notificationCount == "0") {
                        self.notificationsCountLabel?.hidden = true
                    } else {
                        self.notificationsCountLabel?.hidden = false
                    }
                }
            }
        }
    }
    
    /**
        Clear user's notification
    */
    
    func clearNotifications(tutor:Boolean) {
        
        // User data to communicate with the server
        let applicationDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let userToken: String? = applicationDelegate.userlogin.token
        
        // Load student / tutor notifications count
        var notificationCountResetUri: NSString? = nil
        if (0 == tutor) {
            notificationCountResetUri = "https://www.studypool.com/questions/ApiClearStudentNoti?token=\(userToken!)"
        } else {
            notificationCountResetUri = "https://www.studypool.com/questions/ApiClearTutorNoti?token=\(userToken!)"
        }
        
        if (nil != notificationCountResetUri) {
            request(.GET, "\(notificationCountResetUri!)").responseJSON() {
                (_, _, result, error) in
                if (nil == error) {
                    let notificationCount = result! as! NSString
                    self.notificationsCountLabel?.text = "0"
                    self.notificationsCountLabel?.hidden = true
                }
            }
        }
    }
    
    
    // MARK: UITableViewDelegate, UITableViewDataSource methods
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return segues.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        // Get proper menu item data
        let index = indexPath.row
        let itemTitle = segues[index]
        let itemImageName = icons[index]
        
        // Build a menu cell
        let cell = tableView.dequeueReusableCellWithIdentifier("MenuCell", forIndexPath: indexPath) as! MenuCell
        cell.itemLabel?.text = itemTitle
        cell.iconView?.image = UIImage(named: itemImageName)
        if(indexPath.row % 2 == 1){
            cell.contentView.backgroundColor = UIColor(red: 240.0/255, green: 240.0/255, blue: 237.0/255, alpha: 1.0)
        }
        else{
            cell.contentView.backgroundColor = UIColor(red: 231.0/255, green: 231.0/255, blue: 226.0/255, alpha: 1.0)
        }
        
        
        // Remember a label used for displaying notifications count
        if (NavigationIndex.Questions.rawValue == index) {
            notificationsCountLabel = cell.badgeView
        }
        
        cell.badgeView.hidden = true
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var index = NavigationIndex(rawValue: indexPath.item)!
        
        switch index {
        case NavigationIndex.AskQuestion:
                self.slideMenuController()?.changeMainViewController(self.feedViewController, close: true)
                ((self.feedViewController as! UINavigationController).viewControllers[0] as! FeedViewController).enterQuestion()
                self.tableView.deselectRowAtIndexPath(indexPath, animated: false)
            break;
        case NavigationIndex.Questions:
            self.slideMenuController()?.changeMainViewController(self.feedViewController, close: true)
            let feed = (self.feedViewController as! UINavigationController).viewControllers[0] as! FeedViewController
            feed.feedview.hideSearchBar()
            feed.refreshQuestions()
            // Clear notifications count
            // TODO: Properly pass user type (student or tutor)
            self.clearNotifications(0)
            break;
        case NavigationIndex.Invite:
            self.slideMenuController()?.changeMainViewController(self.promoViewController, close: true)
            
//            SEGAnalytics.sharedAnalytics().screen("Invite Friends", properties: [:])
            break;
        case NavigationIndex.Logout:
            appDelegate.logout()
            break;
        case NavigationIndex.Website:
            UIApplication.sharedApplication().openURL(NSURL(string: "http://www.studypool.com")!)
        case NavigationIndex.HowItWorks:
            self.slideMenuController()?.changeMainViewController(self.howItWorksController, close: true)
            break;
        case NavigationIndex.ContactUs:
            if MFMailComposeViewController.canSendMail() {
                self.picker = MFMailComposeViewController()
                self.picker.mailComposeDelegate = self
                
                var emailTitle = "Feedback"
                var messageBody = ""
                var toRecipents = ["contact@studypool.com"]
                var mc: MFMailComposeViewController = MFMailComposeViewController()
                mc.mailComposeDelegate = self
                mc.setSubject(emailTitle)
                mc.setMessageBody(messageBody, isHTML: false)
                mc.setToRecipients(toRecipents)
                
                self.presentViewController(mc, animated: true, completion: {
                    // Dismiss slide menu controller upon 'ContactUs' action: (sent / delete draft)
                    self.slideMenuController()?.closeLeft()
                    self.tableView.deselectRowAtIndexPath(indexPath, animated: false)
                })

                   // self.presentViewController(self.picker, animated: false, completion: {});
//                self.picker.setToRecipients(["contact@studypool.com"])
//                self.picker.setSubject("Mobile Issue")
//                self.presentViewController(self.picker, animated: true, completion: nil)
//                self.slideMenuController()?.changeMainViewController(self.picker, close: true)
               

            } else {
                self.showSendMailErrorAlert()
            }
            //break;
        }
        
    }

	
    
    func onDismiss() {
        self.lew_dismissPopupViewWithanimation(LewPopupViewAnimationDrop.alloc())
    }
    
    func onAnswer() {
        var storyboard = UIStoryboard(name: "Answer", bundle: nil)
        let myAnswerViewController = storyboard.instantiateViewControllerWithIdentifier("MyAnswer") as! MyAnswerViewController
        let nav = UINavigationController(rootViewController: myAnswerViewController) as UINavigationController
        
        self.lew_dismissPopupViewWithanimation(LewPopupViewAnimationDrop.alloc())
        let slidermenu =  self.appDelegate.window?.rootViewController as! SlideMenuController
        slidermenu.changeMainViewController(nav, close: true)
    }
    
    func mailComposeController(controller: MFMailComposeViewController!, didFinishWithResult result: MFMailComposeResult, error: NSError!) {
        
        dismissViewControllerAnimated(true, completion: nil)
     
        
    }
    
    func showSendMailErrorAlert() {
        let sendMailErrorAlert = UIAlertView(title: "Could Not Send Email", message: "Your device could not send e-mail.  Please check e-mail configuration and try again.", delegate: nil, cancelButtonTitle: "OK")
        sendMailErrorAlert.show()
    }
    
}