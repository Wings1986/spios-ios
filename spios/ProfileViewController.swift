	//
//  ProfileViewController.swift
//
//  Created by Dom Bryan on 27/05/2015.
//  Modified by Andrew Mikhailov on 2015.06.16.
//
//  Copyright (c) 2015 Dom Bryan. All rights reserved.
//

import UIKit
import Alamofire
import Analytics

class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var labelsCollectionView: UICollectionView!
    @IBOutlet weak var questionsCountLabel: UILabel!
    @IBOutlet weak var answersCountLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var profileBackgroundImageView: UIImageView!
    @IBOutlet weak var profileRatingLabel: UILabel!
    @IBOutlet weak var noReviewsView: UIView!
    
    @IBOutlet weak var noReviewImage: UIImageView!
    @IBOutlet weak var noReviewLabel: UILabel!
    
    var selectedUserID: String!
    
    var nextReviewsPage: Int = 0

    // A set of user profile reviews
    var reviews: Array<Dictionary<String,String>> = Array<Dictionary<String,String>>()

    // MARK: Variable which tells us if a swipe has been performed
    var swiped = 1
    var labelArray:NSMutableArray!
    
    override func viewWillAppear(animated: Bool) {
        //unhide top bar
        
        //UIApplication.sharedApplication().setStatusBarHidden(false, withAnimation:UIStatusBarAnimation.None)
        
        //MARK: Allows this swift file to delegeate (control) the table view
        self.tableView.registerClass(ProfileTableViewCell.self, forCellReuseIdentifier: "cell1")
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        // MARK: Below images and label (Name) can be edited to take items from an array, eg. the array of users infromation from their facebook profile. Currently they are set values, this is because no user infromation is downloaded as of 27/05/2015
        self.profileImageView.layer.masksToBounds = false
        self.profileImageView.layer.cornerRadius = self.profileImageView.frame.height / 2
        self.profileImageView.clipsToBounds = true
        
        // MARK: Blur effected added as the view will appear
//        addBlur()
        
        
        // TODO: Properly define whether to load tutor or student profile
        self.loadProfile(1)
        self.loadProfilePicture()
        self.reviews.removeAll(keepCapacity: true)
        self.loadReviews(page: 1)
        
        //0.5 black opacity done by putting a black view behind and setting front view to alpha = 0.5
    }
    
    // MARK: This Blurs the background image. Other sytles can be .Dark or .ExtraLight

    override func viewDidLoad() {
        //
        super.viewDidLoad()
        
        self.noReviewsView.hidden = true
        
        
        if let hamburguerViewController = self.findHamburguerViewController() {
            hamburguerViewController.gestureEnabled = false
        }
        
        //MARK: Swipe down declaration
        let swipeDown:UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: Selector("swipedDown:"))
        swipeDown.direction = .Down
        swipeDown.delegate = self
        self.view.addGestureRecognizer(swipeDown)
        
        let swipeUp:UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: Selector("swipedUp:"))
        swipeUp.direction = .Up
        swipeUp.delegate = self
        self.view.addGestureRecognizer(swipeUp)
        swipeDown.enabled = false
        swipeUp.enabled = false

        updateProfileLabels(0)
        
        
        // SEGMENT
        let params = ["Tutor" as NSObject :selectedUserID.toInt() as! AnyObject] as [NSObject : AnyObject]
        SEGAnalytics.sharedAnalytics().screen("Tutor Profile", properties: params)

    }
    
    func updateProfileLabels(recommended: Boolean) {
        var items:NSMutableArray = []
        if (1 == recommended) {
            items.addObject(["title": "Recommended by Studypool", "color":UIColor(red: 0.16, green: 0.75, blue: 1, alpha: 1), "textcolor": UIColor(red: 1, green: 1, blue: 1, alpha: 1)])
        }
        
        items.addObject(["title": "Verified Tutor", "color": UIColor(red: 0, green: 0, blue: 0, alpha: 1), "textcolor": UIColor(red: 1, green: 1, blue: 1, alpha: 1)])
        labelArray = items
        labelsCollectionView.reloadData()
    }
    
    override func viewWillDisappear(animated: Bool) {
        if let hamburguerViewController = self.findHamburguerViewController() {
            hamburguerViewController.gestureEnabled = true
        }

        super.viewWillDisappear(animated);
    }
    
    // TODO: That is similar to a method for loading profile in the "MenuViewController" class. Need to be re-factored.
    func loadProfile(tutor: Boolean) {
        
        // User data to communicate with the server
        let applicationDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let userToken: String? = applicationDelegate.userlogin.token
        let userIdentifier: String? = applicationDelegate.userlogin.id

        // Load user profile data
        if (nil != userToken) {
            if (nil != userIdentifier) {

                // Load student profile data
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
                var studentProfileUri: NSString? = "https://www.studypool.com/questions/Apistudentprofile?token=\(userToken!)&user_id=\(selectedUserID!)"
                request(.GET, "\(studentProfileUri!)").responseJSON() {
                    (_, _, result, error) in
                    if (nil == error) {
                        
                    }
                }
                
                let parameters = [
                    "token": token,
                    "user_id":selectedUserID!
                    
                ]
                
                NetworkUI.sharedInstance.getStudentsProfile(parameters, success: { (response) -> Void in
                    let model = response as! ProfileModel
                    
                    // Display questions count
                    //                        self.questionsCountLabel.text = response["total_questions"] as! String?
                    //                        self.questionsCountLabel.hidden = false
                    
                    // Display answers count
                    //                        self.answersCountLabel.text = response["complete_questions"] as! String?
                    self.answersCountLabel.hidden = false
                    
                    // Display user name
                    self.userNameLabel.text = model.username.uppercaseString
                    self.userNameLabel.hidden = false
                    
                    }) { (error) -> Void in
                        
                }
                
                // Load tutor profile data
                let params = ["token": userToken, "user_id":selectedUserID]
                
                NetworkUI.sharedInstance.getTutorProfile(params,
                    success: { (result) -> Void in
                        
                        MediumProgressViewManager.sharedInstance.hideProgressView(self)
                        
                        if result != nil {
                            
                            let response = result! as! Dictionary<String, AnyObject>
                            
                            // Display user rating
                            var rating: String = response["rating"] as! String
                            self.profileRatingLabel.text = String(format: "%.01f", (rating as NSString).doubleValue)
                            self.profileRatingLabel.hidden = false
                            self.answersCountLabel.text = response["answers"] as? String
                            // Display profile labels
                            var recommended: Int = response["recommended"] as! Int
                            // TODO: Remove this after fully testing
                            // recommended = 1
                            //
                            if (0 != recommended) {
                                self.updateProfileLabels(1)
                            } else {
                                self.updateProfileLabels(0)
                            }
                            
                        }
                        
                    }) { (error) -> Void in
                        TAOverlay.showOverlayWithLabel("Please try again", options: TAOverlayOptions.OverlaySizeRoundedRect|TAOverlayOptions.OverlayTypeWarning|TAOverlayOptions.AutoHide)
                        
                }

            }
        }
    }
    
    // TODO: This method redundantly acquires data which may be also available through the "profile" method
    func loadProfilePicture() {
        
        // User data to communicate with the server
        let applicationDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let userToken: String? = applicationDelegate.userlogin.token
        let userIdentifier: String? = applicationDelegate.userlogin.id
        
        // Load user profile picture address
        if (nil != userToken) {
            if (nil != userIdentifier) {
                let pictureApiUri = "https://www.studypool.com/questions/ApipicStan?token=\(userToken!)&user_id=\(selectedUserID!)"
                request(.GET, pictureApiUri).responseJSON() {
                    (_, _, result, error) in
                    if (nil == error) {
                        
                        var pictureUri = result! as! String
                        
                        pictureUri = pictureUri.stringByReplacingOccurrencesOfString(" ", withString: "%20", options: NSStringCompareOptions.RegularExpressionSearch, range: nil)
                        ImageLoader.sharedLoader.imageForUrl(pictureUri, imageview: self.profileImageView, completionHandler:{(image: UIImage?, url: String) in
                            self.profileBackgroundImageView.image = image?.blurredImage(0.2)
                        })

                    }
                }
            }
        }
    }
    
    func loadReviews(page: Int = 1) {

        // User data to communicate with the server
        let applicationDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let userToken: String? = applicationDelegate.userlogin.token
        let userIdentifier: String? = applicationDelegate.userlogin.id

        // Load user's reviews
        if (nil != userToken) {
            if (nil != userIdentifier) {
                
                // Reviews data API URI
                /**
                * Returns an array in the following format:
                * [
                *  ["comment": "vc",
                *   "create_time": "1433871626",
                *   "avatar": "https://www.studypool.com/uploads/systemavatars/ava_kakashi4.jpg",
                *   "username": "rety"
                *  ]
                * ]
                **/
                
                /*
                var uri: NSString? = "https://www.studypool.com/questions/apireviewstan?token=\(userToken!)&tutor=\(self.selectedUserID!)&page=\(page)"
    */
                var uri = "https://www.studypool.com/questions/apireviewstan?token=\(userToken!)&tutor=\(self.selectedUserID!)&page=\(page)"
                // TODO: Remove this after all testing is done
                //var uri = "https://studypool.com/questions/apireviewstan?token=82ab4d396d8de3338e4412334ab6a880&tutor=27448&page=1"
                
            
                println(uri)
                request(.GET, "\(uri)").responseJSON() {
                    (_, _, result, error) in
                    
                    println(error)
                    if (nil == error) {
                        
                        let items = result as? Array<Dictionary<String,String>>
                        
                        //every time you go through this, you should get a completely new set of items
                        self.reviews += items!
                        self.nextReviewsPage = page + 1
                        if (0 < self.reviews.count) {
                            
                            
                            dispatch_async(dispatch_get_main_queue(), {() -> Void in
                                
                        self.tableView.reloadData()
                
                            })
                            
                            self.tableView.hidden = false
                            self.noReviewsView.hidden = false
                            
                        } else {
                            
                            //executes if there are no reviews
                            self.tableView.hidden = true
                            self.noReviewsView.hidden = false
                            self.noReviewImage.hidden = false
                            self.noReviewLabel.hidden = false
                        }
                        
                    }
                    else
                    {
                        //executes if is an error
                        self.tableView.hidden = true
                        self.noReviewsView.hidden = false
                        self.noReviewImage.hidden = false
                        self.noReviewLabel.hidden = false
                    }
                }
            }
        }
    }
    
    // TODO: There is the same method in the "MenuViewController" class
    func downloadImageAsynchronously(imageView: UIImageView, uri: String) {
        
        var pictureUri = uri.stringByReplacingOccurrencesOfString(" ", withString: "%20", options: NSStringCompareOptions.RegularExpressionSearch, range: nil)
        
        request(.GET, "\(pictureUri)").response() {
            (_, _, data, _) in
            let image = UIImage(data: data! as! NSData)
            imageView.image = image
        }
    }
    
    // MARK: Table data source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.reviews.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {

        var textView = UITextView()
        textView.text = reviews[indexPath.row]["comment"]!
        let fixedWidth = self.view.frame.size.width - 73
        textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.max))
        let newSize = textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.max))
        var newFrame = textView.frame
        newFrame.size = CGSize(width: max(newSize.width, fixedWidth), height: newSize.height)
        
        return newFrame.size.height + 50
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        // A cell instance requested
//        var cell: ProfileTableViewCell
//        if (indexPath.row % 2 == 0) {
//            cell = tableView.dequeueReusableCellWithIdentifier("Cell1", forIndexPath: indexPath) as! ProfileTableViewCell
//        } else {
//            cell = tableView.dequeueReusableCellWithIdentifier("Cell2", forIndexPath: indexPath) as! ProfileTableViewCell
//        }

        let cell = tableView.dequeueReusableCellWithIdentifier("Cell1", forIndexPath: indexPath) as! ProfileTableViewCell
        
        if(indexPath.row % 2 == 1){
            cell.contentView.backgroundColor = UIColor(red: 231.0/255, green: 231.0/255, blue: 226.0/255, alpha: 1.0)
        }else{
            cell.contentView.backgroundColor = UIColor(red: 245.0/255, green: 245.0/255, blue: 243.0/255, alpha: 1.0)
        }

        
        
        // A review to be displayed
        var review: Dictionary<String,String> = self.reviews[indexPath.row]
        
        // Bind values
        cell.cellLabel1.text = review["username"]?.uppercaseString
        cell.reviewView.text = review["comment"]
        cell.reviewView.textContainerInset = UIEdgeInsetsMake(5, 0, 0, 0)
        self.downloadImageAsynchronously(cell.cellImage, uri: review["avatar"]!)
        var date = NSDate(timeIntervalSince1970: Double((review["create_time"]!).toInt()!))
        cell.timeLabel.text = date.relativeTime
        var mark: String? = review["rating"] as String?
        var strRating  = NSString(format: "%@", mark!)
        var rating = strRating.floatValue as Float
        
        cell.startMark.text = String(format: "%.01f★", rating)

       
        if (self.reviews.count - 1 == indexPath.row) {
            self.loadReviews(page: self.nextReviewsPage)
        }
    
        println("-----")
        println("Textview Frame:")
        println(cell.reviewView.frame)
        println("Cell Frame:")
        println(cell.contentView.frame)
        println("-----")

        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // MARK: Un-highlights a row when it is pressed
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
    }
    
    // MARK: CollectionView delegate and datesource
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if (labelArray != nil) {
            return labelArray.count
        } else {
            return 0
        }
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        var kCellHeight:CGFloat = 24.0
        var width = Float(collectionView.bounds.size.width) / Float(labelArray.count)
        var size:CGSize = CGSizeMake(CGFloat(width), kCellHeight)
        return size
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        var cell:UICollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier("label_cell", forIndexPath: indexPath) as! UICollectionViewCell
        var label:UILabel? = cell.viewWithTag(1) as? UILabel
        label?.text = labelArray.objectAtIndex(indexPath.row)["title"] as! NSString as String
        label?.textColor = labelArray.objectAtIndex(indexPath.row)["textcolor"] as? UIColor
        cell.backgroundColor = labelArray.objectAtIndex(indexPath.row)["color"] as? UIColor
        label?.frame = cell.bounds
        return cell
    }
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRequireFailureOfGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return false
    }
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if otherGestureRecognizer.isMemberOfClass(UIPanGestureRecognizer) {
            return true
        }
        
        return false
    }
    
    // MARK: Swipe Down Gesture Recognizer
    // MARK: By changing the value of the global variable swiped, I can see what direction the user has swiped across the program. This allows for editing depending on what the user has done, in different sections of the code.
    
    func swipedDown(sender:UISwipeGestureRecognizer){
        if swiped == 1 {
            swiped++
        } else {
            swiped == swiped
        }
        
        // MARK: Reloading the data so that depending on the swipe, the data can be altered automatically
        tableView.reloadData()
        self.profileImageView.hidden = true
        self.profileRatingLabel.hidden = true
        
        // MARK: This removes any subview (ie. blur effect) from the background image view
        let subViews = self.profileBackgroundImageView.subviews
        for subview in subViews{
            subview.removeFromSuperview()
        }
    }
    
    func swipedUp(sender:UISwipeGestureRecognizer){
        if swiped != 1 {
            swiped--
        } else {
            swiped == swiped
        }
        
        tableView.reloadData()
        self.profileImageView.hidden = false
        self.profileRatingLabel.hidden = false
    }

    @IBAction func answerQuestions(sender: UIButton) {
        self.navigationController?.popViewControllerAnimated(true)
    }
}