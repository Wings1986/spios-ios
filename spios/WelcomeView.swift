//
//  WelcomeView.swift
//  spios
//
//  Created by MobileGenius on 10/2/15.
//  Copyright (c) 2015 Studypool. All rights reserved.
//

import UIKit

class WelcomeView: UIView {

    @IBOutlet weak var view1: UIView!
    @IBOutlet weak var view2: UIView!
    @IBOutlet weak var view3: UIView!
    
    @IBOutlet weak var view1contstraint: NSLayoutConstraint?
    @IBOutlet weak var view2contstraint: NSLayoutConstraint?
    @IBOutlet weak var view3contstraint: NSLayoutConstraint?
    
    var controller: WelcomeViewController!
    
    func viewdidappear(){
        controller.view.layoutIfNeeded()
        UIView.animateWithDuration(1, animations: {
            self.view1contstraint?.constant = -16
            self.view2contstraint?.constant = -16
            self.view3contstraint?.constant = -16
            
            self.view1.layoutIfNeeded()
            self.view2.layoutIfNeeded()
            self.view3.layoutIfNeeded()
        })
    }
    func viewwillappear(){
        view1contstraint?.constant = controller.view.frame.width
        view2contstraint?.constant = -controller.view.frame.width
        view3contstraint?.constant = controller.view.frame.width
    }

}
