//
//  SettingsView.swift
//  spios
//
//  Created by MobileGenius on 10/6/15.
//  Copyright (c) 2015 Studypool. All rights reserved.
//

import UIKit

class SettingsView: UIView {

    @IBOutlet weak var btnBack: UIBarButtonItem!
    
    @IBOutlet weak var btnSubmit: UIBarButtonItem!
    @IBOutlet weak var btnSubmitBottom: UIButton!
    
    /// step imageview
    @IBOutlet weak var stepsView: UIImageView!
    
    @IBOutlet weak var sliderTier: UISlider!
    @IBOutlet weak var sliderTrack: UIView!
    
    /// Urgent Button
    @IBOutlet weak var bgUrgentQuestion: UIButton!
    /// Private Button
    @IBOutlet weak var bgPrivateQuestion: UIButton!
    
    /// Button to select Hour or Day value
    @IBOutlet weak var btnTimely: UIButton!
    
    /// Button to select Hour or Day type
    @IBOutlet weak var btnHoursDays: UIButton!
    
    /// Deadline Textivew
    @IBOutlet weak var txtDeadLine: UITextField!
    
    /// Cost TextView
    @IBOutlet weak var txtCost: UITextField!
    
    /// Poster View
    @IBOutlet weak var posterView: UIView!
    
    /// PrivateQuestion Check Mark Button
    @IBOutlet weak var btnCheckMarkPrivateQues: UIButton!
    /// UrgentQuestion Check Mark Button
    @IBOutlet weak var btnCheckMarkUrgentQues: UIButton!
    
    /// Scroll View
    @IBOutlet weak var scrollview: UIScrollView!
    
    /// Tier Label
    @IBOutlet weak var lblTier: UILabel!
    
    /// Step bar height Constraint
    @IBOutlet weak var progressHeaderHeight: NSLayoutConstraint!
    
    /// Step ImageView
    @IBOutlet weak var stepimageview: UIImageView!
    
    /// Tier Description Label
    @IBOutlet weak var tierDescription: UILabel!
    
    /// Budget Button
    @IBOutlet weak var btnBudget: UIButton!
    
    
    /// String array for Deadline Type
    var arrayType: [String] = ["Hour(s)", "Day(s)"]
    
    /// String array for Days
    var arrayDays: [String] = ["Choose one", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23", "24", "25", "26", "27", "28", "29", "30", "31"]
    /// String array for Hours
    var arrayhours: [String] = ["Choose one", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23", "24"]
    /// String array for Budget
    var arrayBudget: [String] = ["Choose one", "1", "3", "5", "10", "15", "20", "35", "50", "75", "100", "150", "200", "250", "300", "400", "500", "600", "700", "800", "900", "1000"]
    
    
    let blueColor = UIColor(netHex: 0x2ABFFF)
    
    var segueHappened = false
    
    var controller:SettingsViewController!
    
    
    func viewdidload(){
        //setup posterview
        self.posterView.layer.borderWidth = 3
        self.posterView.layer.borderColor = UIColor(red: 42.0/255.0, green: 191.0/255.0, blue: 255.0/255.0, alpha: 1).CGColor
        
        makeRoundView(self.btnTimely)
        makeRoundView(self.bgUrgentQuestion)
        makeRoundView(self.bgPrivateQuestion)
        makeRoundView(self.btnHoursDays)
        makeRoundView(self.btnBudget)
        
        self.btnCheckMarkPrivateQues.hidden = true
        self.btnCheckMarkUrgentQues.hidden = true
        
        controller.isUrgent = stUrgentQues
        if(controller.isUrgent == false){
            self.btnCheckMarkUrgentQues.hidden = true
            bgUrgentQuestion.layer.borderWidth = 0
            
            bgUrgentQuestion.layer.borderColor = nil
        } else {
            self.btnCheckMarkUrgentQues.hidden = false
            changeButtonTapped(bgUrgentQuestion)
        }
        
        controller.isPrivate = stPrivateQues
        if(controller.isPrivate == false){
            self.btnCheckMarkPrivateQues.hidden = true
            bgPrivateQuestion.layer.borderWidth = 0
            
            bgPrivateQuestion.layer.borderColor = nil
            
        } else {
            self.btnCheckMarkPrivateQues.hidden = false
            changeButtonTapped(bgPrivateQuestion)
        }
        
        
        self.layoutIfNeeded()
        
        self.btnHoursDays.setTitle(self.arrayDays[0], forState: UIControlState.Normal)
        self.btnTimely.setTitle("Day(s)", forState: UIControlState.Normal)
        
        // Set slider thumb
        self.sliderTier.setThumbImage(UIImage(named: "newSlideDrop"), forState: .Normal);
        // Hide slider track
        self.sliderTier.setMinimumTrackImage(UIImage(), forState: .Normal);
        self.sliderTier.setMaximumTrackImage(UIImage(), forState: .Normal);
        // Set slider track view's background
        self.sliderTrack.backgroundColor = UIColor(patternImage: UIImage(named: "tutor-tier-slider-track")!);
        
        // Gesture recognizers for the slider
        var tapGesture = UITapGestureRecognizer(target: self, action: Selector("tierSliderTapped:"));
        self.sliderTier.addGestureRecognizer(tapGesture);
        
        self.updateTierInfo();
    }
    
    func makeRoundView(view:UIView)
    {
        view.layer.cornerRadius = 2
        view.layer.shadowColor = UIColor.darkGrayColor().CGColor
        view.layer.shadowRadius = 2
        view.layer.shadowOffset = CGSizeMake(1, 1)
        view.layer.shadowOpacity = 0.5
    }
    
    func changeButtonTapped(button : UIButton){
        
        button.layer.borderWidth = 3
        button.layer.borderColor = blueColor.CGColor
        
    }
    
    @IBAction func tierSliderValueChanged(slider:UISlider) {
        // Round to the next integer value
        let roundedValue = Int(slider.value + 0.5);
        slider.setValue(Float(roundedValue), animated: false);
        
        self.updateTierInfo();
    }
    
    func tierSliderTapped(gesture: UITapGestureRecognizer) {
        if (self.sliderTier.highlighted) {
            // Tapped on the knob
            return;
        }
        
        let point = gesture.locationInView(self.sliderTier);
        let percentage = Float(point.x / self.sliderTier.frame.width);
        let rawValue = 0.5 + (percentage * (self.sliderTier.maximumValue - self.sliderTier.minimumValue));
        
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.sliderTier.setValue(self.sliderTier.minimumValue + Float(Int(rawValue)), animated: true);
        }) { (completed:Bool) -> Void in
            self.updateTierInfo();
        }
    }
    
    func updateTierInfo() {
        let tier = Int(self.sliderTier.value);
        switch tier {
        case 1:
            self.lblTier.text = "Standard Tier"
            self.tierDescription.text = "Get quality answers from verified tutors. Ideal for smaller questions."
            
        case 2:
            self.lblTier.text = "Premium"
            self.tierDescription.text = "High quality answers from Top Studypool Tutors. Great for bigger questions."
            
        case 3:
            self.lblTier.text = "Ivy League"
            self.tierDescription.text = "Want to crush it? Get help from only the highest quality tutors educated at top universities."
            
        default:
            break;
        }
    }

}
