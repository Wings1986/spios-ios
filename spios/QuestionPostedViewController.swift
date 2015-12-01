//
//  QuestionPostedViewController.swift
//  spios
//
//  Created by Wilson Wang on 7/2/15.
//  Copyright (c) 2015 Studypool. All rights reserved.
//

import Foundation
import UIKit
import Analytics

/// Question Posted Animation Page (Roket Animation)
class QuestionPostedViewController: UIViewController
{
    
    @IBOutlet weak var questionpostedview: QuestionPostedView!
    
    var questionModel: QuestionModel?
    
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)

        
        self.navigationController?.navigationBarHidden = true

        UIApplication.sharedApplication().setStatusBarHidden(true, withAnimation:UIStatusBarAnimation.None)

        questionpostedview.rocketView.clipsToBounds = true
     
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        questionpostedview.controller = self
        
        questionpostedview.viewdidload()
    }
    
    override func viewDidAppear(animated: Bool) {
        
        super.viewDidAppear(animated)
        
        
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

