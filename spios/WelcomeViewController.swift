//
//  WelcomeViewController.swift
//  spios
//
//  Created by MobileGenius on 6/16/15.
//  Copyright (c) 2015 Studypool. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController {
    
    @IBOutlet weak var welcomeview: WelcomeView!

    override func viewDidLoad() {
        super.viewDidLoad()
        welcomeview.controller = self

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        welcomeview.viewwillappear()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        welcomeview.viewdidappear()
    }
    
    @IBAction func clickMain(sender:UIButton){
        self.enterFeed()
    }
    
    func enterFeed(){

        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        token = appDelegate.userlogin.token
        appDelegate.createMenuView()
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
