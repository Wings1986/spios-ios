//
//  ConfirmTutorAnimationViewController.swift
//  spios
//
//  Created by Wilson Wang on 6/30/15.
//  Copyright (c) 2015 Studypool. All rights reserved.
//

import Foundation
import UIKit


/// Connecting With Tutor animation page
class ConfirmTutorAnimationViewController: UIViewController
{
    
    @IBOutlet weak var animationview: ConfirmTutorAnimationView!
    
    
    
    var right: UIImage?
    var left: UIImage?
    var questionModel: QuestionModel!
    var answer_id: String!
    var studentImageUrl: String?
    var tutorImageUrl : String?
    var tutorName : String?
    
    
    

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        UIApplication.sharedApplication().setStatusBarHidden(true, withAnimation:UIStatusBarAnimation.None)
        
        self.navigationController?.navigationBar.hidden = true
        
        // Load student image (Left) if it's nil
        if (self.left == nil && self.studentImageUrl != nil) {
            ImageLoader.sharedLoader.imageForUrl(self.studentImageUrl!, imageview: self.animationview!.leftImage, completionHandler: { (image: UIImage?, url: String) -> () in
                self.left = image
            })
        }
        // Load tutor image (Left) if it's nil
        if (self.right == nil && self.tutorImageUrl != nil) {
            ImageLoader.sharedLoader.imageForUrl(self.tutorImageUrl!, imageview: self.animationview!.rightImage, completionHandler: { (image: UIImage?, url: String) -> () in
                self.right = image
            })
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        animationview.controller = self
        animationview.viewdidload()
    }
    
    override func viewDidAppear(animated: Bool) {
        
        super.viewDidAppear(animated)
        
        animationview.viewdidappear()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        UIApplication.sharedApplication().setStatusBarHidden(false, withAnimation:UIStatusBarAnimation.None)
    }
    
    
}
