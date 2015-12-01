//
//  CountryCodePickerDelegate.swift
//  spios
//
//  Created by Stanley Chiang on 8/15/15.
//  Copyright (c) 2015 Studypool. All rights reserved.
//

import Foundation
import UIKit

protocol CountryCodePickerViewDelegate: NSObjectProtocol {
    func countryUpdatedValue(object: AnyObject)
}

class CountryCodePickerDelegate: NSObject, UIPickerViewDelegate, UIPickerViewDataSource {
    var countryPickerDataSource = [
        "Argentina",
        "United States",
        "New Zealand"
    ]
    
    weak var delegate: CountryCodePickerViewDelegate!
 
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1;
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return countryPickerDataSource.count;
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        return countryPickerDataSource[row];
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        delegate.countryUpdatedValue(countryPickerDataSource[row]);
    }
    
}
