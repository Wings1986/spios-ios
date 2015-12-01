//
//  QuestionsViewController.swift
//  spios
//
//  Created by Stanley Chiang on 4/15/15.
//  Copyright (c) 2015 Studypool. All rights reserved.
//


/*
Variables:
    UIView descriptionview: Holds instructions to user
    UICollectionView clvImageUpload: CollectionView for the images
    UITextField titleField: Textfield for user to enter title of question
    UITextView descField: Where user enters description of question
    UILabel textlength: label showing how many characters user has left
    UIBarButtonItem btnNext: next button
    String qTitle: Intermediate variable that holds question title (probably unnecessary)
    String qDesc: Intermediate variable that holds question description (probably unnecessary)
    Int qCat: Not Used
    String qid: Not Used
    Bool isImage: Indicates if the user attached an image?
    [UIImage] arrImages: Holds the images that user uploads
    UIColor greyColor: not Used
    UIColor blueColor: not Used
    UITapGestureRecognizer tapBack: detects when the user taps the background
*/
import UIKit
import AVFoundation
import MobileCoreServices
import Analytics


class QuestionsViewController: UIViewController, UIAlertViewDelegate, UINavigationControllerDelegate  {
    
    var qTitle:String!
    var qDesc:String!
    
    var isImage:Bool!
    
    var arrImages = [UIImage]()
    
    
    @IBOutlet weak var questionview:QuestionsView!
    
    
    
    // MARK: View Setup
    
    /**
    Disable the next button
    Set up UI of titleField
    Set up UI of descField
    Setup Gesture Recognizers for background tap and keyboard dismissal
    Add Done button bar at buttom of toolbar
    
    :param: None
    
    :returns: None
    */
    override func viewDidLoad() {
        
        //        capturedImage.userInteractionEnabled = true
        
//        SEGAnalytics.sharedAnalytics().screen("New Question", properties: [:])
        
		ctSelectedIndex = 6
        stBudget = 1
        stTime = 1
        stTimeType = "Hours"
        stPrivateQues = false
        stUrgentQues = false

        isImage = false
        
        //SET navigation bar color and Font
        
        
        
        
        questionview.controller = self
		
        questionview.viewdidload()
        
        SEGAnalytics.sharedAnalytics().screen("Ask a Question", properties: [:])
        
    }
    
    
	
    //setup keyboard functionality
    override func viewWillAppear(animated: Bool) {
        addNotificationsObservers()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        questionview.viewdidappear()
    }
	
    //remove keyboard functionality
    override func viewWillDisappear(animated: Bool)
    {
        removeNotificationsObservers()
    }
    
    
    
    
    
    /**
    
    Helper method to do JSON parsing
    
    :param: request: the request to execute and get the json back from
    :param: callback: the callback to execute after the request completes
    
    :returns: None
    */
    func httpParse(request: NSURLRequest!, callback: (NSDictionary, String?) -> Void) {
        var session = NSURLSession.sharedSession()
        var task = session.dataTaskWithRequest(request){
            (data, response, error) -> Void in
            if error != nil {
            } else {
                var result = NSString(data: data, encoding:
                    NSASCIIStringEncoding)!
                var jsonResult: AnyObject? = NSJSONSerialization.JSONObjectWithData(data, options:NSJSONReadingOptions.AllowFragments, error: nil)
                if let returnVal: AnyObject = jsonResult {
                    callback(jsonResult! as! NSDictionary, nil)
                } else{
                    println("try again \(result)")
                }
            }
        }
        task.resume()
    }
    
    
    override func shouldPerformSegueWithIdentifier(identifier: String?, sender: AnyObject?) -> Bool {
        if (count(questionview.titleField.text) <= 5 && identifier == "showCategory"){
           
            return false
        }
        else if (count(questionview.titleField.text) >= 80 && identifier == "showCategory"){
            
            return false
        }

        else{
            return true
        }
    }
    /**
    
    Prepare for segue to category view controller
    
    :param: segue: The segue to execute
    :param: sender: The object that sent the segue
    
    :returns: None
    */
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "showCategory" {
            // Restore user previously written text.
            if (!questionview.titleField.text.isEmpty) {
                userInputQuestionTitle = questionview.titleField.text
                println ("Question Title saved!")
            }
            if(!questionview.descField.text.isEmpty) {
                userInputQuestionDescription = questionview.descField.text
                println ("Question Description saved!")
            }
            
            
            qTitle = questionview.titleField.text
            
            qDesc = "<p>" + questionview.descField.text.stringByReplacingOccurrencesOfString("\n", withString:"</p><p>") + "</p>"
            
            println(questionview.descField.text)
            
            var isPic:String
            if(isImage == true){
                isPic = "1"
            }
            else{
                isPic = "0"
            }
            
            let parameters = [
                "token": token,
                "title": qTitle,
                "description":qDesc,
                "imagecount":String(self.arrImages.count),
                "isPic":isPic
            ]
            
            let categoryVC:CategoryViewController = segue.destinationViewController as! CategoryViewController
            categoryVC.selectedIndex = ctSelectedIndex
            if let id: AnyObject = sender{
                categoryVC.parameters = parameters
                categoryVC.arrImages = self.arrImages
               
            }else{
                println("no question id to pass")
            }
        } else if segue.destinationViewController is FeedViewController {
            // Restore user previously written text.
            if (!questionview.titleField.text.isEmpty) {
                userInputQuestionTitle = questionview.titleField.text
                println ("Question Title saved!")
            }
            if(!questionview.descField.text.isEmpty) {
                userInputQuestionDescription = questionview.descField.text
                println ("Question Description saved!")
            }
            
            //SEGMENT_CODE: TRACKER
//            SEGAnalytics.sharedAnalytics().track("Cancelled Creating New Question")
        }
    }
    
    
    
    
    let overlayTransitioningDelegate = OverlayTransitioningDelegate()
    
    
    /**
    
    Helper method to present a popup
    :param: overlayVC: The View controller in which to present the popup.
    :returns: None
    */
    private func prepareOverlayVC(overlayVC: UIViewController) {
        overlayVC.transitioningDelegate = overlayTransitioningDelegate
        overlayVC.modalPresentationStyle = .Custom
    }
    
    
    // MARK: Keyboard Functions
    
    /**
    Update the number of characters left label
    :param: textView: the textView with the characters that changed
    :returns: None
    */
    func textViewDidChange(textView: UITextView) {
        questionview.textlength.text = String(format: "%d/500", count(textView.text))
    }
    
    
    
    
    
    
    
    /**
    
    Function executed when the keyboard is about to hide
    
    :param: notification: The notification that causes the keyboard to be hidden
    
    :returns: None
    */
    func keyboardWillHide(notification: NSNotification)
    {
        self.questionview.removeGestureRecognizer(questionview.tapback)
        self.questionview.userInteractionEnabled = true
    }
    
    /**
    
    Function executed when the keyboard is about to show
    
    :param: notification: The notification that causes the keyboard to be shown
    
    :returns: None
    */
    func keyboardWillShow(notification: NSNotification)
    {
        self.questionview.addGestureRecognizer(questionview.tapback)
        self.questionview.userInteractionEnabled = true
    }
    
    /**
    
    Setup Keyboard Functionality by using NSnotification
    
    :param: None
    
    :returns: None
    */
    func addNotificationsObservers()
    {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    /**
    
    Remove Keyboard Functionality by using NSnotification
    
    :param: None
    
    :returns: None
    */
    func removeNotificationsObservers()
    {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    
    
    
    
    
}

extension NSMutableData {
    func appendString(string: String) {
        let data = string.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
        appendData(data!)
    }
}
// capture photo ends