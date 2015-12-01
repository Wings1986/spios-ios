//
//  TutorAnsweredFooterView.swift
//  spios
//
//  Created by MobileGenius on 10/13/15.
//  Copyright (c) 2015 Studypool. All rights reserved.
//

import UIKit

class TutorAnswerFooterView: UIView, UITextFieldDelegate, BHInputbarDelegate {

    
    var controller:TutorAnswerFooterController!
    
    @IBOutlet weak var messageBox: BHInputbar!
    @IBOutlet weak var constraintMessageHeight: NSLayoutConstraint!
    
    @IBOutlet weak var btnAnswer: UIButton!
    
    func viewdidload(){
        // Do any additional setup after loading the view.
        
        messageBox?.inputDelegate = self; // making this class delegate to know what actions are happening with toolbar
        messageBox?.textView.placeholder = "Comment";
        messageBox?.textView.maximumNumberOfLines = 5 // li
        var swipe:UISwipeGestureRecognizer = UISwipeGestureRecognizer(target:self, action:"dismissKeyboard")
        
        swipe.direction = UISwipeGestureRecognizerDirection.Down
        
        self.addGestureRecognizer(swipe)
    }
    
    func dismissKeyboard(){
        messageBox!.textView.resignFirstResponder()
        
    }
    
    func clearComment() {
        messageBox!.textView.clearText()
    }
    
    func setAnswered(answered: Bool) {
        controller.bAnswered = answered
        
        var height:CGFloat = 0
        if answered == true {
            
            btnAnswer.setTitle("SUBMIT", forState: UIControlState.Normal)
            
            constraintMessageHeight.constant = 66
            height = 125
            
            messageBox.frame = CGRectMake(13, 9, messageBox.frame.size.width, 38)
            messageBox.resizeToolbar()
        }
        else {
            btnAnswer.setTitle("ANSWER", forState: UIControlState.Normal)
            
            constraintMessageHeight.constant = 0
            height = 59
        }
        
        if controller.delegate != nil {
            controller.delegate?.changeTutorFooterHeight(height)
        }
    }
    
    // MARK expanding TextView
    
    func expandingTextView(expandingTextView: BHExpandingTextView!, didChangeHeight height: Float) {
        
        if controller.bAnswered == true {
            constraintMessageHeight.constant = 9 + CGFloat(height) + 9;
            
            controller.delegate?.changeTutorFooterHeight( constraintMessageHeight.constant + 59 )
        }
    }

}
