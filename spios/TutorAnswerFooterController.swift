//
//  TutorAnswerFooterController.swift
//  spios
//
//  Created by Administrator on 6/18/15.
//  Copyright (c) 2015 Studypool. All rights reserved.
//

import UIKit


protocol TutorAnswerFooterControllerDelegate:BHExpandingTextViewDelegate
{
    func onSubmit(message:String)
    func onAnswer()
    
    func changeTutorFooterHeight(height:CGFloat)
}


class TutorAnswerFooterController: UIViewController {

    
    @IBOutlet weak var footerview: TutorAnswerFooterView!
    
    
    var delegate:TutorAnswerFooterControllerDelegate?
    
    var bAnswered:Bool? = false
    var isResize:Bool? = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        footerview.controller = self
        
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//        
//        if bAnswered == true {
//            if isResize == true {
//                messageBox.resizeToolbar()
//                isResize = false
//            }
//        }
//    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    
    
    @IBAction func onClickMessage(sender: AnyObject) {
        
        if bAnswered == true {
            if !((footerview.messageBox.textView.text as String).isEmpty) {

                delegate?.onSubmit(footerview.messageBox.textView.text)
                
            }
            
        }
        else {
            delegate?.onAnswer()
        }
    }
    
    
    
}
