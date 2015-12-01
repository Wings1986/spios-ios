//
//  CategoryViewController.swift
//  spios
//
//  Created by Stanley Chiang on 4/25/15.
//  Copyright (c) 2015 Studypool. All rights reserved.
//

import UIKit
import MBProgressHUD
import Analytics

protocol CategoryViewProtocal{
    
}

/// Select Post Category View Page
class CategoryViewController: UIViewController {
    
    @IBOutlet weak var categoryview: CategoryView!
    var arrImages = [UIImage]()
    
    var selectedIndex: Int = 6
    
    var parameters : Dictionary<String, AnyObject> = [:]

    
    // MARK: View Setup
    override func viewDidLoad() {
        super.viewDidLoad()
        
        categoryview.controller = self
        categoryview.viewdidload()
        
        SEGAnalytics.sharedAnalytics().screen("Category", properties: [:])
        
    }
    
    override func  viewDidDisappear(animated: Bool) {
        categoryview.viewdiddisappear()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "showSettings" {
            
            let selected = categoryview.picker.selectedRowInComponent(0)
            let nID = categoryview.pickerData[selected]["id"] as! Int
            
            parameters["category"] = String(nID)
            
            let settingVC:SettingsViewController = segue.destinationViewController as! SettingsViewController
            if let id: AnyObject = sender{
                settingVC.parameters = parameters
                settingVC.arrImages = arrImages
            }else{
                println("no question id to pass")
            }
        }
    }
    
}

//extension to check if Strings contains Another
extension String {
    
    func contains(find: String) -> Bool{
        return self.rangeOfString(find) != nil
    }
}

//extensiono to make Color with Hexadecimal
extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(netHex:Int) {
        self.init(red:(netHex >> 16) & 0xff, green:(netHex >> 8) & 0xff, blue:netHex & 0xff)
    }
}