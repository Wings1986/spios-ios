//
//  PhoneVerificationView.swift
//  spios
//
//  Created by MobileGenius on 10/2/15.
//  Copyright (c) 2015 Studypool. All rights reserved.
//

import UIKit

class PhoneVerificationView: UIView {

    ///phonenumber edittext
    
    @IBOutlet var phoneNumber: UITextField!
    @IBOutlet weak var countryCode: UITextField!
    @IBOutlet weak var btnSendNumber: UIButton!
    
    /// array to get phone code information from country.json
    var countryPickerDataSourceShort : NSArray!
    
    /// array for country name
    var countryArray: [String] = []
    /// country phone code
    var countryCodeString: String = "+1"
    
    /// selected country index default = 224(US)
    var nCountry = 224 as Int
    
    var controller:PhoneVerificationViewController!

    
    func initviews(){
        
        self.countryCode.text = "United States"
        
        addDoneButtonToKeyboard(phoneNumber)
        
        var swipe:UISwipeGestureRecognizer = UISwipeGestureRecognizer(target:self.controller, action:"dismissKeyboard")
        
        swipe.direction = UISwipeGestureRecognizerDirection.Down
        
        let kForegroudColor = UIColor(red: 255, green: 255, blue: 255, alpha: 0.7)
        self.phoneNumber.attributedPlaceholder = NSAttributedString(string: self.phoneNumber.placeholder!,
            attributes:[NSForegroundColorAttributeName: kForegroudColor])
        
        self.phoneNumber.tintColor = UIColor(white: 1, alpha: 0.87)
        
        self.countryCode.attributedPlaceholder = NSAttributedString(string: self.countryCode.placeholder!,
            attributes:[NSForegroundColorAttributeName: kForegroudColor])
        
        self.countryCode.tintColor = UIColor(white: 1, alpha: 0.87)
        
        self.controller.view.addGestureRecognizer(swipe)
        
        
        /// get country phone code information fron country.json
        if let path = NSBundle.mainBundle().pathForResource("country", ofType: "json")
        {
            if let jsonData = NSData(contentsOfFile: path, options: .DataReadingMappedIfSafe, error: nil)
            {
                if let jsonResult: NSDictionary = NSJSONSerialization.JSONObjectWithData(jsonData, options: NSJSONReadingOptions.MutableContainers, error: nil) as? NSDictionary
                {
                    
                    countryPickerDataSourceShort = jsonResult["countries"] as! NSArray
                    
                }
            }
        }
        
        for dic in countryPickerDataSourceShort{
            countryArray.append(dic["name"] as! String)
        }
        
        
        // sort country
        countryArray = countryArray.sorted { $0.localizedCaseInsensitiveCompare($1) == NSComparisonResult.OrderedAscending }

    }
    
    /**
    add done button
    */
    func addDoneButtonToKeyboard(textView: AnyObject)
    {
        var toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: controller.view.bounds.width, height: 44))
        var leftSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        var doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Done, target: self.controller, action: Selector("dismissKeyboard"))
        toolbar.setItems([leftSpace, doneButton], animated: false)
        if textView.isKindOfClass(UITextField)
        {
            (textView as! UITextField).inputAccessoryView = toolbar
            return
        }
        (textView as! UITextView).inputAccessoryView = toolbar
    }

}
