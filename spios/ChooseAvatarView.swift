//
//  ChooseAvatarView.swift
//  spios
//
//  Created by MobileGenius on 6/15/15.
//  Copyright (c) 2015 Studypool. All rights reserved.
//

import UIKit

// Choose Avatar view
class ChooseAvatarView: UIView {
    
    
    /// current selected index
    var nIndex : Int!
    
    /// parent view
    var parentview : ConfirmPhoneNumberViewController!
    
    /// array of avatar images
    var arrayimages : NSArray!
    
    /// complete button
    @IBOutlet weak var btnComplete: UIButton!
    
    class func loadFromNibNamed(nibNamed: String, bundle : NSBundle? = nil) -> UIView? {
        return UINib(
            nibName: nibNamed,
            bundle: bundle
            ).instantiateWithOwner(nil, options: nil)[0] as? UIView
    }
    
    
    /**
        inite layout the avatar images
    */
    func initviews(images:NSArray){
        
        self.btnComplete.layer.cornerRadius = self.btnComplete.bounds.size.height / 2
        arrayimages = images;
        
        let nWidth = self.frame.width - 50
        var y = 70 as Int
        
        

        for i : Int in 1...6{
            var x : Int = 25
            for j : Int in 1...4{
                let imageview = UIImageView()
                let left = 25 + (j-1) * Int(nWidth) / 4
                imageview.frame = CGRectMake(CGFloat(0 + left), CGFloat(y), nWidth/4, nWidth/4)
                
                NSLog("%@", images[(i-1)*4+j-1] as! String)
                imageview.tag = (i-1)*4+j-1
                self.addSubview(imageview)
                
//                imageview.loadImage(NSURL(fileURLWithPath: images[i*j-1] as! String)!, autoCache: true)
                ImageLoader.sharedLoader.imageForUrl(images[(i-1)*4+j-1] as! String, imageview: imageview, completionHandler:{(image: UIImage?, url: String) in
//                self.imageView.image = image
                })
                
                let aSelector : Selector = "tapimage:"
                
                let tapgesture = UITapGestureRecognizer(target: self, action: aSelector)
                imageview.addGestureRecognizer(tapgesture)
                imageview.userInteractionEnabled = true
            }
            y = y + Int(nWidth) / 4
        }
    }
    
    /**
        tap one avatar image
    */
    
    func tapimage(gesture: UITapGestureRecognizer){
        nIndex = gesture.view?.tag
        
        for view in self.subviews{
            view.layer.borderWidth = 0
        }
        
        self.bringSubviewToFront(gesture.view!)
        gesture.view?.layer.borderColor = UIColor(red: 0, green: 196.0/255, blue: 252.0/255, alpha: 1.0).CGColor
        gesture.view?.layer.borderWidth = 3
        
    }
    /**
        select avatar image
    */
    @IBAction func complete(sender: UIButton){
        
        if nIndex != nil {
            self.parentview.addAvataImage(nIndex, strURL: self.arrayimages[nIndex] as! String)
        }
        
    }
    
    

}
