
//
//  AppDelegate.swift
//  spios
//
//  Created by Stanley Chiang on 4/15/15.
//  Copyright (c) 2015 Studypool. All rights reserved.
//

import UIKit
import CoreData
import Analytics
import Fabric
import Crashlytics
import FBSDKCoreKit

/// SEGAnalytics APIKEY
let kSegWriteKey = "WzqcP7ZNRf761quDaRnYd07fbSwSGdyW"

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, WelcomeBackPopoverViewDelegate, ReferralBonusPopoverViewDelegate {
    
    var window: UIWindow?
    /// UserModel
    var userlogin : UserLogin!
    /// notification manager
    var notifications:NotificationManager? = NotificationManager()
    /// left slide menu viewcontroller
    var leftViewController : DLSlideMenuViewController!
    /// Loading animation Manager object
    var mediumProgressViewManager : MediumProgressViewManager!

    var bFirstSign:Bool = false
    
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        var type = UIUserNotificationType.Badge | UIUserNotificationType.Alert | UIUserNotificationType.Sound;
        var setting = UIUserNotificationSettings(forTypes: type, categories: nil);
        UIApplication.sharedApplication().registerUserNotificationSettings(setting);
        UIApplication.sharedApplication().registerForRemoteNotifications();
        
        
        //NavigationBar appearance settings
        UINavigationBar.appearance().tintColor = UIColor(red: 42/255.0, green: 191/255.0, blue: 255/255.0, alpha: 1.0)
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName: UIColor(red: 42/255.0, green: 191/255.0, blue: 255/255.0, alpha: 1.0)]
        
        //MediumProgressView setting
        mediumProgressViewManager = MediumProgressViewManager.sharedInstance
        mediumProgressViewManager.position = .Top // Default is top.
        mediumProgressViewManager.color    = UIColor(red:42.0/255, green:191.0/255, blue:223.0/255, alpha:1) // Default is UIColor(red:0.33, green:0.83, blue:0.44, alpha:1).
        mediumProgressViewManager.height   = 4.0 // Default is 4.0.
        mediumProgressViewManager.isLeft   = true // Default is true.
        mediumProgressViewManager.duration = 1.0  // Default is 1.2.
        
        application.applicationIconBadgeNumber = 0;
        
        //SEGMENT_CODE: INITIAL SETUP
        let configuration = SEGAnalyticsConfiguration(writeKey:kSegWriteKey)
        SEGAnalytics.setupWithConfiguration(configuration)
        
        Fabric.with([Crashlytics.self()])
        
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions);
        
        return true
    }
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject?) -> Bool {
        return FBSDKApplicationDelegate.sharedInstance().application(application, openURL: url, sourceApplication: sourceApplication, annotation: annotation);
    }
    
    /**
    Get Device token for push notification.
    
    */
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        
        NSLog("My token is: %@", deviceToken)
        var tokenString = ""
        let tokenChars = UnsafePointer<CChar>(deviceToken.bytes)
        
        for var i = 0; i < deviceToken.length; i++ {
            tokenString += String(format: "%02.2hhx", arguments: [tokenChars[i]])
        }
        println("tokenString: \(tokenString)")
        notifications?.setDeviceIOSToken(tokenString)
    }
    
    /**
    Fail to get deviceToken
    
    */
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        NSLog("Failed to get token, error: %@", error);
    }
    
    
	/**
	Handle Notifications being received
	
	*/
	func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject])
	{
        
        if(application.applicationState == UIApplicationState.Active){
            
            if let aps = userInfo["aps"] as? NSDictionary {
                
                var alert = aps["content"] as! NSDictionary
                
                ///show popup from notification
                if((alert.objectForKey("referrer")) != nil){
                    
                    //"referrer":notification type
                    //"message":popup message
                    //"money":added bonus amount
                    onShowPopup((alert.objectForKey("referrer") as! String).toInt()!, popupdetail: alert["message"] as! String, promoMoney: alert["money"] as! String)
                    
                }
                ///for Incomming messages and accept/decline question. refresh current pages(e.g discussion pages, feedpage)
                else{
                    refreshPages(alert)
                }
                
                
            }
        }
	}
    /**
    Refresh current page when push notification is comming.
    (e.g, student sent message, question is approved or declined)
    */
    func refreshPages(content: NSDictionary){
        if !(window?.rootViewController is SlideMenuController)  {
            return
        }
        

        var slidemenu = window?.rootViewController as! SlideMenuController
        
        var arraycontrollers = (leftViewController.feedViewController as! UINavigationController).viewControllers
        
        
        //if push notification is from approved/declined and refresh
        if((content.objectForKey("reso")) != nil){
            if(arraycontrollers[arraycontrollers.count-1].isKindOfClass(QuestionDetailViewController)){
                let questionDetail = arraycontrollers[arraycontrollers.count-1] as! QuestionDetailViewController
                if(((content.objectForKey("reso")) as! String) == "approved"){
                    
                    questionDetail.detailview.withdrawFooter.hidden = true
                    questionDetail.detailview.mCompletedFooter.hidden = false
                    questionDetail.detailview.contraintTableBottom.constant = 62
                    
                    questionDetail.questionModel.resolutionRefunded = 1
                    
                }else if(((content.objectForKey("reso")) as! String) == "declined"){
                    
                    questionDetail.detailview.withdrawFooter.hidden = true
                    questionDetail.detailview.mCompletedFooter.hidden = false
                    questionDetail.detailview.contraintTableBottom.constant = 62
                    
                    questionDetail.questionModel.resolutionRefunded = 1
                    
                }
            }else{
                
            }
        }
        // push notification is for Discuss pages
        else{
            if(arraycontrollers[arraycontrollers.count-1].isKindOfClass(QuestionDetailViewController)){
                
                let questionDetail = arraycontrollers[arraycontrollers.count-1] as! QuestionDetailViewController
                if(questionDetail.detailview.mFooterBidController.view.hidden == true && questionDetail.detailview.mHowtoworks.hidden == true){
                    questionDetail.refreshDiscuss()
                }else{
                    questionDetail.refreshquestion()
                }
                
            }else if(arraycontrollers[arraycontrollers.count-1].isKindOfClass(ConfirmTutorViewController)){
                let confirmTutor = arraycontrollers[arraycontrollers.count-1] as! ConfirmTutorViewController
                confirmTutor.refreshDiscuss()
            }else if(arraycontrollers[arraycontrollers.count-1].isKindOfClass(FeedViewController)){
                let feed = arraycontrollers[arraycontrollers.count-1] as! FeedViewController
                feed.refreshQuestions()
                //                        confirmTutor.refreshDiscuss()
            }
        }
    }
    /**
    create notification badge
    */
    func clearNotifications() {
        // clear push budge
        UIApplication.sharedApplication().applicationIconBadgeNumber = 0
        UIApplication.sharedApplication().cancelAllLocalNotifications()
    }
    
    /**
    show popup screens from push notification
    (e.g Welcomeback, Promotion Popupview)
    */
    func onShowPopup(popuptype:Int, popupdetail:String, promoMoney:String) {
        
        if(popuptype == 2){
            return;
        }
        
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        //popuptype == 1, show Welcomeback page.
        if(popuptype == 1){
            
            let popView = WelcomeBackPopoverView.loadFromNibNamed("WelcomeBackPopoverView", bundle: nil) as! WelcomeBackPopoverView
            
            popView.frame = CGRectMake(0, 0, screenSize.width - 70, 430)
            
            window?.rootViewController!.lew_presentPopupView(popView, animation: LewPopupViewAnimationDrop.alloc())
            
        }
        // popuptype == 2, show Prmopo popupview
        else{

            let popView = ReferralBonusPopoverView.loadFromNibNamed("PromoMoneyPopoverView", bundle: nil) as! ReferralBonusPopoverView
            let amountAdded:String = promoMoney// API CALL
            popView.promoMoneyAmount.text = "+ $" + amountAdded
            popView.frame = CGRectMake(0, 0, screenSize.width - 70, 430)
            popView.signupTitle.text = popupdetail
            popView.signupTitle.hidden = false
            window?.rootViewController!.lew_presentPopupView(popView, animation: LewPopupViewAnimationDrop.alloc())
        }
        
    }
	

    func onDismiss() {
        window?.rootViewController!.lew_dismissPopupViewWithanimation(LewPopupViewAnimationDrop.alloc())
    }
    
    /**
    Get My Profile
    this function is called after user logged in
    
    */
    func getMyProfile(){
        let parameters = [
            "token": token
        ]
	
			notifications?.setUserOfNotifToken(token)

        NetworkUI.sharedInstance.getStudentsProfile(parameters, success: { (response) -> Void in
            let model = response as! ProfileModel
            user_id = model.user_id.toInt()!
            postCount = model.total_questions.toInt()
            }) { (error) -> Void in
                TAOverlay.showOverlayWithLabel("Please try again", options: TAOverlayOptions.OverlaySizeRoundedRect|TAOverlayOptions.OverlayTypeWarning|TAOverlayOptions.AutoHide)
                
        }
    }
    
    /**
    Create left slide menu
    */
    
    func createMenuView() {
        
        // create viewController code...
        var storyboard = UIStoryboard(name: "Feed", bundle: nil)
        
        let mainViewController = storyboard.instantiateViewControllerWithIdentifier("Feed") as! FeedViewController
        
        self.leftViewController = storyboard.instantiateViewControllerWithIdentifier("DLSlideMenuViewController") as! DLSlideMenuViewController
        
        let nvc: UINavigationController = UINavigationController(rootViewController: mainViewController)
        
        
        self.leftViewController.feedViewController = nvc
        
        let slideMenuController = SlideMenuController(mainViewController:nvc, leftMenuViewController: self.leftViewController)
        
        self.window?.rootViewController = slideMenuController
        
        self.window?.makeKeyAndVisible()
        
        self.getMyProfile()
        
    }
    
    
    /**
    Logout
    */
    func logout(){
        
        var request = NSFetchRequest(entityName: "UserLogin")
        request.returnsObjectsAsFaults = false
        var dowjones = self.managedObjectContext!.executeFetchRequest(request, error: nil)!
        
        if dowjones.count > 0 {
            
            for result: AnyObject in dowjones{
                self.managedObjectContext!.deleteObject(result as! UserLogin)
                println("NSManagedObject has been Deleted")
            }
            self.managedObjectContext!.save(nil)
        }
        
        var storyboard = UIStoryboard(name: "Auth", bundle: nil)
        let loginViewcontroller = storyboard.instantiateViewControllerWithIdentifier("LoginViewController") as! LoginViewController
        
        let nav: UINavigationController = UINavigationController(rootViewController: loginViewcontroller)
        nav.navigationBarHidden = true
        
        self.window?.rootViewController = nav
        self.window?.makeKeyAndVisible()
        
        //SEGMENT_CODE: TRACKER
        SEGAnalytics.sharedAnalytics().track("Logged Out", properties: [:])
        
    }
    
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
        refreshPages(["":""])
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        FBSDKAppEvents.activateApp()
        
        // Clear notification badge
        UIApplication.sharedApplication().applicationIconBadgeNumber = 0
        if let tokenString = token {
            if (!tokenString.isEmpty) {
                NetworkUI.sharedInstance.clearNotificationBadge(tokenString)
            }
        }
    }
    
    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }
    
    // MARK: - Core Data stack
    
    lazy var applicationDocumentsDirectory: NSURL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "com.studypool.spios" in the application's documents Application Support directory.
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls[urls.count-1] as! NSURL
        }()
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = NSBundle.mainBundle().URLForResource("spios", withExtension: "momd")!
        return NSManagedObjectModel(contentsOfURL: modelURL)!
        }()
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator? = {
        // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        var coordinator: NSPersistentStoreCoordinator? = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.URLByAppendingPathComponent("spios.sqlite")
        var error: NSError? = nil
        var failureReason = "There was an error creating or loading the application's saved data."
        if coordinator!.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: nil, error: &error) == nil {
            coordinator = nil
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
            dict[NSLocalizedFailureReasonErrorKey] = failureReason
            dict[NSUnderlyingErrorKey] = error
            error = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(error), \(error!.userInfo)")
            abort()
        }
        
        return coordinator
        }()
    
    lazy var managedObjectContext: NSManagedObjectContext? = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        if coordinator == nil {
            return nil
        }
        var managedObjectContext = NSManagedObjectContext()
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
        }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        if let moc = self.managedObjectContext {
            var error: NSError? = nil
            if moc.hasChanges && !moc.save(&error) {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                NSLog("Unresolved error \(error), \(error!.userInfo)")
                abort()
            }
        }
    }
    
}

