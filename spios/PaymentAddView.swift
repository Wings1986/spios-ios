//
//  PaymentAddView.swift
//  spios
//
//  Created by MobileGenius on 9/30/15.
//  Copyright (c) 2015 Studypool. All rights reserved.
//

import UIKit

class PaymentAddView: UIView, UIPickerViewDataSource, UIPickerViewDelegate {

    @IBOutlet weak var cardNumberButton: UIButton!
    @IBOutlet weak var cardCodeButton: UIButton!
    @IBOutlet weak var yearButton: UIButton!
    @IBOutlet weak var monthButton: UIButton!
    @IBOutlet weak var tfCardNumber: UITextField!
    @IBOutlet weak var tfCVC: UITextField!
    @IBOutlet weak var tvHiddenField: UITextField!
    @IBOutlet weak var lbPrice: UILabel!
    
    
    var currentPickupView:UIButton!
    
    @IBOutlet weak var controller: PaymentAddViewController!
    
    @IBOutlet weak var topPopContraint: NSLayoutConstraint!
    
    let pickerView = UIPickerView(frame: CGRect(x: 0, y: 0, width: 0, height: 0)) // Init UIPicker
    
    
    func initviews(){
        self.makeRoundView(self.cardNumberButton)
        self.makeRoundView(self.cardCodeButton)
        self.makeRoundView(self.yearButton)
        self.makeRoundView(self.monthButton)
        self.addDoneButtonToKeyboard(self.tfCardNumber)
        self.addDoneButtonToKeyboard(self.tfCVC)
    }
    
    func makeRoundView(view:UIView)
    {
        view.layer.cornerRadius = 2
        view.layer.shadowColor = UIColor.darkGrayColor().CGColor
        view.layer.shadowRadius = 2
        view.layer.shadowOffset = CGSizeMake(1, 1)
        view.layer.shadowOpacity = 0.5
    }
    
    /**
    Creates toolbar for storing Done Button and adds it to keyboard
    */
    func addDoneButtonToKeyboard(textView: AnyObject)
    {
        var toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: controller.view.bounds.width, height: 44))
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
    
    func instantiatePickerTextField()
    {
        pickerView.showsSelectionIndicator = true;
        pickerView.dataSource = self;
        pickerView.delegate = self;
        self.tvHiddenField.inputView = pickerView;
        addDoneButtonToKeyboard(self.tvHiddenField)
    }
    
    var topPopViewConstant: CGFloat! // Saving constants to restore the view when keyboard hides
    var bottomPopViewConstant: CGFloat! // Saving constants to restore the view when keyboard hides
    /**
    Hides keyboard or the picker. If hides picker, than takes current value and sets it as the buttons title
    */
    func hideKeyboard(notification: AnyObject)
    {
        self.tfCVC.resignFirstResponder()
        self.tfCardNumber.resignFirstResponder()
        self.tvHiddenField.resignFirstResponder()
    }
    
    let monthDataSource = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12"]
    let yearDataSource = ["2012", "2013", "2014", "2015", "2016", "2017","2018","2019","2020","2021","2022","2023","2024","2025","2026","2027","2028","2029","2030"]
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if (currentPickupView == monthButton)
        {
            return monthDataSource.count
        }else{
            return yearDataSource.count
        }
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        if (currentPickupView == monthButton)
        {
            return monthDataSource[row]
        }else{
            return yearDataSource[row]
        }
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if (currentPickupView == monthButton)
        {
            currentPickupView.setTitle(monthDataSource[row], forState: .Normal)
        }else{
            currentPickupView.setTitle(yearDataSource[row], forState: .Normal)
        }
    }
    
    func goWithdrawRelease(){
        
        var arraycontrollers = controller.navigationController!.viewControllers
        
        if(arraycontrollers[arraycontrollers.count-3].isKindOfClass(WithdrawPendingViewcontroller)){
            
            let withdraw = arraycontrollers[arraycontrollers.count-3] as! WithdrawPendingViewcontroller
            
            withdraw.actpayment("1",finalprice: currentprice)
            
        }
        
    }
    
    
    func goFinalRelease(){
        
        var arraycontrollers = controller.navigationController!.viewControllers
        
        if(arraycontrollers[arraycontrollers.count-3].isKindOfClass(AcceptQuestionViewController)){
            
            let accept = arraycontrollers[arraycontrollers.count-3] as! AcceptQuestionViewController
            
            accept.actpayment("1",finalprice: currentprice)
            
        }
        
    }
    
    
    
    
    func gobacktodetail(){
        
        var arraycontrollers = controller.navigationController!.viewControllers
        
        if(arraycontrollers[arraycontrollers.count-3].isKindOfClass(FeedViewController)){
            
            let feed = arraycontrollers[arraycontrollers.count-3] as! FeedViewController
            
        }else{
            
            let confirm = arraycontrollers[arraycontrollers.count-3] as! ConfirmTutorViewController
            confirm.performSegueWithIdentifier("animation", sender: confirm)
        }
        
    }

}
