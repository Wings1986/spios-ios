//
//  QuestionDetailAnsweredFooterController.swift
//  spios
//
//  Created by Administrator on 6/9/15.
//  Copyright (c) 2015 Studypool. All rights reserved.
//

import UIKit

// MARK: QuestionDetailAnsweredDelegate
protocol QuestionDetailAnsweredFooterControllerDelegate:BHExpandingTextViewDelegate
{
    func onComment(message:String)
    func onDecline()
    func onInfo()
    func onAccept()
    
    func changeFrameHeight(height:Float)
}



class QuestionDetailAnsweredFooterController: UIViewController {

//    @IBOutlet weak var tfComment: UITextField!
    
    @IBOutlet weak var footerview: QuestionDetailAnsweredFooterView!
    
    
    
    
    var delegate:QuestionDetailAnsweredFooterControllerDelegate?
    
    var overdue: Bool = false
    // MARK: - View setup
    override func viewDidLoad() {
        super.viewDidLoad()
        
        footerview.controller = self
        footerview.viewdidload()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Actions
    // MARK
    func attachButtonPressed(inputText: NSAttributedString!) {
        
    }
    
    func onComment(comment:String) {
        self.delegate?.onComment(comment)
    }
    
    @IBAction func onClickDecline(sender: AnyObject) {
        
        // Check if overdue
        if (self.overdue == true) {
            self.delegate?.onDecline()
        } else {
            TAOverlay.showOverlayWithLabel("Failed to Withdraw.\nYou cannot withdraw a pending question.", options: TAOverlayOptions.OverlaySizeRoundedRect|TAOverlayOptions.OverlayTypeError|TAOverlayOptions.AutoHide)
        }
        
    }
    
    @IBAction func onClickInfo(sender: AnyObject) {
        
        self.delegate?.onInfo()
        
    }
    
    @IBAction func onClickAccept(sender: AnyObject) {
        
        self.delegate?.onAccept()
        
    }
}
