//
//  ConfirmTutorAnimationView.swift
//  spios
//
//  Created by MobileGenius on 10/12/15.
//  Copyright (c) 2015 Studypool. All rights reserved.
//

import UIKit

class ConfirmTutorAnimationView: UIView {
    
    var controller:ConfirmTutorAnimationViewController!

    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var rightImage: UIImageView!
    @IBOutlet weak var leftImage: UIImageView!
    @IBOutlet weak var chatIcon: UIImageView!
    @IBOutlet weak var secondImage: UIImageView!
    @IBOutlet weak var ellipsis: UIImageView!
    @IBOutlet weak var leftConstraint: NSLayoutConstraint!
    @IBOutlet weak var rightConstraint: NSLayoutConstraint!
    
    class func colorizeImage(image: UIImage, color: UIColor) -> UIImage
    {
        UIGraphicsBeginImageContext(image.size);
        let context = UIGraphicsGetCurrentContext();
        let area = CGRectMake(0, 0, image.size.width, image.size.height);
        CGContextScaleCTM(context, 1, -1);
        CGContextTranslateCTM(context, 0, -area.size.height);
        CGContextSaveGState(context);
        CGContextClipToMask(context, area, image.CGImage);
        color.set()
        CGContextFillRect(context, area);
        CGContextRestoreGState(context);
        CGContextSetBlendMode(context, kCGBlendModeMultiply);
        CGContextDrawImage(context, area, image.CGImage);
        var colorizedImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return colorizedImage;
    }
    
    func viewdidload(){
        setUpViews()
    }
    
    func viewwillappear(){
        //set the beginning alphas
        self.secondImage.alpha = 0
        self.backgroundImage.alpha = 0.5
        
        //animate ellipsis
        var gifImages: [AnyObject]? = [UIImage(named: "image1.png")!, UIImage(named: "image2.png")!, UIImage(named: "image3.png")!, UIImage(named: "image4.png")!, UIImage(named: "image5.png")!, UIImage(named: "image6.png")!, UIImage(named: "image7.png")!, UIImage(named: "image8.png")!, UIImage(named: "image9.png")!, UIImage(named: "image10.png")!]
        self.ellipsis.animationImages = gifImages
        self.ellipsis.animationDuration = 0.75
        self.ellipsis.startAnimating()
        
        println(gifImages)
    }
    
    func viewdidappear(){
        // Enable buttons
        controller.navigationController?.view.userInteractionEnabled = true
        
        //make sure the image is centered
        self.backgroundImage.center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2)
        self.secondImage.center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2)
        self.leftConstraint.constant = self.bounds.width / 2 - 157
        self.rightConstraint.constant = self.bounds.width / 2 - 157
        
        //animation
        UIView.animateWithDuration(2.5, delay: 0, options: .CurveEaseOut, animations: {//1.4
            
            self.layoutIfNeeded()
            
            //move 2 circles
            //the end alphas
            self.backgroundImage.alpha = 0
            self.secondImage.alpha = 1
            
            
            }, completion: { finished in
                //push to x and heart view
                var qdSB:UIStoryboard = UIStoryboard(name: "Question_detail", bundle: nil)
                
                let applicationDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                
                //setup question detail vc with the question information
                if let questionDetailController = qdSB.instantiateViewControllerWithIdentifier("QuestionDetailViewController") as? QuestionDetailViewController {
                    
                    //set status of questionModel to 1, accepted
                    var newDict = self.controller.questionModel.accept.mutableCopy() as! NSDictionary
                    newDict.setValue(1, forKey: "status")
                    newDict.setValue(self.controller.answer_id, forKey: "answerid")
                    newDict.setValue(self.controller.tutorImageUrl, forKey: "tutoravatar")
                    newDict.setValue(self.controller.tutorName, forKey: "tutorusername")
                    self.controller.questionModel.accept = newDict
                    questionDetailController.questionId = self.controller.questionModel.question_id.toInt()
                    questionDetailController.questionModel = self.controller.questionModel
                    questionDetailController.studentName = applicationDelegate.userlogin.username
                    questionDetailController.studentImageUrl = self.controller.questionModel.avatar
                    
                    // Check urgent / private4
                    if (self.controller.questionModel.isUrgent == 0) {
                        qUrgent = false
                    } else if (self.controller.questionModel.isUrgent == 1) {
                        qUrgent = true
                    }
                    
                    if (self.controller.questionModel.isPrivate == 0) {
                        qPrivate = false
                    } else if (self.controller.questionModel.isPrivate == 1) {
                        qPrivate = true
                    }
                    questionDetailController.answerId = self.controller.answer_id.toInt()
                    
                    // Navigation to question detail view controller
                    let vcArray = self.controller.navigationController?.viewControllers
                    var newVcArray = NSMutableArray()
                    newVcArray.addObject(vcArray![0])
                    newVcArray.addObject(questionDetailController)
                    self.controller.navigationController?.navigationBar.hidden = false
                    self.controller.navigationController?.setViewControllers(newVcArray as [AnyObject], animated: true)
                    
                }
        })
    }
    
    private func setUpViews() {
        //first, make the round profile pictures with a white border (using college_student.png)
        self.backgroundImage.image = UIImage(named: "animation_bg")
        
        //prepare the second image. First, darken it
        self.secondImage.image = ConfirmTutorAnimationView.colorizeImage(UIImage(named: "animation_bg_blur")!, color: UIColor.grayColor())
        
        //set rightImage to the right of the screen
        self.rightImage.image = controller.right
        self.rightImage.layer.cornerRadius = self.rightImage.layer.frame.size.width/2
        self.rightImage.clipsToBounds = true
        self.rightImage.layer.borderColor = UIColor.whiteColor().CGColor
        self.rightImage.layer.borderWidth = 5
        
        //set leftImage to the left of the screen
        self.leftImage.image = controller.left
        self.leftImage.layer.cornerRadius = self.leftImage.layer.frame.size.width/2
        self.leftImage.clipsToBounds = true
        self.leftImage.layer.borderColor = UIColor.whiteColor().CGColor
        self.leftImage.layer.borderWidth = 5
    }

}
