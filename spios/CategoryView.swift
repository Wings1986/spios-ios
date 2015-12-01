//
//  CategoryView.swift
//  spios
//
//  Created by MobileGenius on 10/6/15.
//  Copyright (c) 2015 Studypool. All rights reserved.
//

import UIKit

class CategoryView: UIView, UIPickerViewDataSource,UIPickerViewDelegate, UITextFieldDelegate {
    
    var controller:CategoryViewController!

    //UI links
    @IBOutlet weak var tfSearch: UITextField!
    @IBOutlet weak var btSearch: UIButton!
    @IBOutlet weak var picker: UIPickerView!
    
    @IBOutlet weak var btPopular1: UIButton!
    @IBOutlet weak var btPopular2: UIButton!
    @IBOutlet weak var btPopular3: UIButton!
    @IBOutlet weak var btPopular4: UIButton!
    @IBOutlet weak var progressHeaderHeight: NSLayoutConstraint!
    
    @IBOutlet weak var viewContent: UIView!
    
    @IBOutlet weak var navigation: UINavigationItem!
    
    // Array of Category id and name
    let pickerData : NSMutableArray = [
        ["id":1,"name":"Accounting"],
        ["id":2,"name":"Art & Design"],
        ["id":3,"name":"Biology"],
        ["id":4,"name":"Business & Finance"],
        ["id":5,"name":"Calculus"],
        ["id":6,"name":"Chemistry"],
        ["id":7,"name":"Economics"],
        ["id":9,"name":"Engineering"],
        ["id":10,"name":"English"],
        ["id":11,"name":"Environmental Science"],
        ["id":12,"name":"Foreign Languages"],
        ["id":14,"name":"Geology"],
        ["id":15,"name":"Health & Medical"],
        ["id":16,"name":"History"],
        ["id":17,"name":"Law"],
        ["id":18,"name":"Marketing"],
        ["id":19,"name":"Mathematics"],
        ["id":20,"name":"Philosophy"],
        ["id":21,"name":"Physics"],
        ["id":23,"name":"Political Science"],
        ["id":24,"name":"Computer Science"],
        ["id":25,"name":"Psychology"],
        ["id":26,"name":"Science"],
        ["id":27,"name":"Social Science"],
        ["id":28,"name":"Sociology"],
        ["id":29,"name":"Statistics"],
        ["id":30,"name":"Writing"],
        ["id":31,"name":"Other"],
        ["id":32,"name":"Algebra"],
        ["id":33,"name":"Programming"],
        ["id":34,"name":"Communications"],
        ["id":35,"name":"Film"],
        ["id":36,"name":"Management"],
        ["id":37,"name":"SAT"]
    ]
    
    var btPopular1Title: String!
    var btPopular2Title: String!
    var btPopular3Title: String!
    var btPopular4Title: String!
    var image : UIImage!
    
    
    
    
    
    var isRowOnLoad = false
    
    //to check if one Popular Button is tapped
    var buttonTapped : UIButton?
    let blueColor = UIColor(netHex: 0x2ABFFF)
    let strongblueColor = UIColor(netHex: 0x2ABFFF)
    let greyColor = UIColor(netHex: 0x000000)
    
    func viewdidload(){
        
        picker.selectRow(controller.selectedIndex, inComponent: 0, animated: true)
        
        //search button
        self.btSearch.layer.cornerRadius = self.btSearch.frame.width / 2
                
        //SHADOWS
        tfSearch.layer.shadowOpacity = 0.3
        tfSearch.layer.shadowColor = UIColor.blackColor().CGColor
        tfSearch.layer.shadowOffset = CGSizeMake(0.0,3.0)
        tfSearch.layer.masksToBounds = false
        tfSearch.layer.shadowRadius = 2.5
        
        picker.layer.shadowOpacity = 0.4
        picker.layer.shadowColor = UIColor.blackColor().CGColor
        picker.layer.shadowOffset = CGSizeMake(0.0,1.0)
        picker.layer.masksToBounds = false
        picker.layer.shadowRadius = 1.0
        
        tfSearch.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0)
        
        backgroundColor = UIColor(netHex: 0xF0F0ED)
        
        //SET Popular Button Subject
        btPopular1.layer.cornerRadius = 34
        btPopular1Title = pickerData[16]["name"] as? String
        btPopular2.layer.cornerRadius = 34
        btPopular2Title = pickerData[3]["name"] as? String
        btPopular3.layer.cornerRadius = 34
        btPopular3Title = pickerData[26]["name"] as? String
        btPopular4.layer.cornerRadius = 34
        btPopular4Title = pickerData[29]["name"] as? String
        
        tfSearch.addTarget(self, action: "textFieldDidChange:", forControlEvents: UIControlEvents.EditingChanged)
        
        //SET navigation bar color and Font
        var nav = controller.navigationController?.navigationBar
        nav?.tintColor = blueColor
        nav?.titleTextAttributes = [NSFontAttributeName : UIFont(name: "Armonioso", size: 20)!,NSForegroundColorAttributeName: UIColor(netHex: 0x2ABFFF)]
        
        //SHADOW
        nav?.layer.shadowOpacity = 0.3
        nav?.layer.shadowColor = UIColor.blackColor().CGColor
        nav?.layer.shadowOffset = CGSizeMake(0.0,3.0)
        nav?.layer.masksToBounds = false
        nav?.layer.shadowRadius = 2.5
        
        var swipe:UISwipeGestureRecognizer = UISwipeGestureRecognizer(target:self, action:"dismissKeyboard")
        
        swipe.direction = UISwipeGestureRecognizerDirection.Down
        addDoneButtonToKeyboard(tfSearch)
        self.addGestureRecognizer(swipe)
    }
    
    func viewdiddisappear(){
        ctSelectedIndex = controller.selectedIndex
    }
    
    func dismissKeyboard(){
        self.tfSearch.resignFirstResponder()
        
    }
    
    func addDoneButtonToKeyboard(textView: AnyObject)
    {
        var toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.bounds.width, height: 44))
        var leftSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        var doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Done, target: self, action: Selector("hideKeyboard:"))
        toolbar.setItems([leftSpace, doneButton], animated: false)
        if textView.isKindOfClass(UITextField)
        {
            (textView as! UITextField).inputAccessoryView = toolbar
            return
        }
        (textView as! UITextView).inputAccessoryView = toolbar
    }
    func hideKeyboard(notification: AnyObject)
    {
        
        if tfSearch.isFirstResponder(){
            tfSearch.resignFirstResponder()
            return
        }
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        
        return 1
    }
    
    
    //first index for ID, second for index of subject in array
    //For every subject, it checks if subjectName is in
    func findSubject(subjectName : String) -> [Int]{
        var response = [-1,-1]
        for index  in 0...pickerData.count-1{
            let subject: AnyObject = pickerData[index]
            if (subject["name"]as! String).lowercaseString.contains(subjectName.lowercaseString) {
                response = [subject["id"] as! Int,index]
                return response
            }
        }
        return response
    }
    
    
    
    
    
    
    
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        let touch = touches.first as! UITouch
        let location = touch.locationInView(self)
        if buttonTapped != nil {
            changeButtonInicialTapped(buttonTapped!)
        }
        self.endEditing(true)
    }
    
    
    
    
    // MARK: Keyboard Functions
    
    func textFieldShouldReturn(userText: UITextField) -> Bool {
        userText.resignFirstResponder()
        return true;
    }
    
    
    
    
    //Check if TextField was changed, to searh every char typed
    func textFieldDidChange(textField: UITextField) {
        changePickerRow(tfSearch.text)
    }
    
    
    // MARK: Picker Views
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        controller.selectedIndex = row;
        pickerView .reloadAllComponents()
        //        selectedIndex = -1;
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        return pickerData[row]["name"] as! String
    }
    
    func pickerView(pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        
        if(controller.selectedIndex == row){
            
            return NSAttributedString(string: pickerData[row]["name"] as! String, attributes: [NSForegroundColorAttributeName : strongblueColor])
            
        }
        else{
            return NSAttributedString(string: pickerData[row]["name"] as! String, attributes: [NSForegroundColorAttributeName : greyColor])
        }
        
    }
    
    // MARK: Actions
    
    @IBAction func backPressed(sender: UIButton){
        controller.navigationController?.popViewControllerAnimated(true)
    }
    
    //Search button Action
    @IBAction func searchButtonTapped(sender: UIButton) {
        tfSearch.resignFirstResponder()
        self.endEditing(true)
        
        changePickerRow(tfSearch.text)
    }
    
    //ALL Popular Buttons Action
    @IBAction func btPopular1Tapped(sender: UIButton) {
        changePickerRow(btPopular1Title!)
        changeButtonTapped(sender)
    }
    @IBAction func btPopular2Tapped(sender: UIButton) {
        changePickerRow(btPopular2Title!)
        changeButtonTapped(sender)
    }
    @IBAction func btPopular3Tapped(sender: UIButton) {
        changePickerRow(btPopular3Title)
        changeButtonTapped(sender)
    }
    
    @IBAction func btPopular4Tapped(sender: UIButton) {
        changePickerRow(btPopular4Title!)
        changeButtonTapped(sender)
    }
    
    @IBAction func btComplete(sender: UIButton){
        
        //        postQuestion()
        
    }
    
    //Change the button tapped, border OFF in previous button tapped, border ON in current Button tapped
    func changeButtonTapped(button : UIButton){
        buttonTapped?.layer.borderWidth = 0
        buttonTapped?.layer.borderColor = nil
        button.layer.borderWidth = 3
        button.layer.borderColor = blueColor.CGColor
        buttonTapped = button
    }
    func changeButtonInicialTapped(button : UIButton){
        buttonTapped?.layer.borderWidth = 0
        buttonTapped?.layer.borderColor = nil
        buttonTapped = button
    }
    
    //change the selected row in Picker with one Subject if it is finded
    func changePickerRow(subject: String){
        let response = findSubject(subject)
        if response[0] != -1 {
            picker.selectRow(response[1], inComponent: 0, animated: true)
            controller.selectedIndex = response[1];
            picker.reloadAllComponents()
        }
    }

}
