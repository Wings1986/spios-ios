//
//  HowItWorksViewController.swift
//  spios
//
//  Created by Wilson Wang on 7/31/15.
//  Copyright (c) 2015 Studypool. All rights reserved.
//

import Foundation
import UIKit

class HowItWorksViewController : UIViewController
{
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNavigationBarItem()
        
        self.title = "How It Works";
        
        //Navigation Shadow
        var nav = self.navigationController?.navigationBar
        nav?.layer.shadowOpacity = 0.3
        nav?.layer.shadowColor = UIColor.blackColor().CGColor
        nav?.layer.shadowOffset = CGSizeMake(0.0,3.0)
        nav?.layer.masksToBounds = false
        nav?.layer.shadowRadius = 2.5
    }
}
