//
//  TermsViewController.swift
//  spios
//
//  Created by user on 6/24/15.
//  Copyright (c) 2015 Studypool. All rights reserved.
//

import UIKit

/// TermsViewController
class TermsViewController: UIViewController {

//    @IBOutlet weak var mWebView: UIWebView!
    
    
    
    @IBOutlet weak var termsview: TermsView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //hide the default back button
         self.navigationItem.setHidesBackButton(true, animated: false)
        
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
    
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if let url = NSBundle.mainBundle().URLForResource("TermsOfServices", withExtension: "rtf") {
            println("URL: \(url)")
            termsview.textView.attributedText = NSAttributedString(fileURL: url, options: nil, documentAttributes: nil, error: nil)
        } else {
            println("Resource not found. ")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onBack(sender: AnyObject) {
        
        self.navigationController?.popViewControllerAnimated(true)
        println(self.navigationController)
        
    }

}
