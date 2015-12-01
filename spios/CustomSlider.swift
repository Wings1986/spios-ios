//
//  CustomSlider.swift
//  spios
//
//  Created by Wilson Wang on 8/3/15.
//  Copyright (c) 2015 Studypool. All rights reserved.
//

import Foundation

class CustomSlider : UISlider
{
    /*
    override func trackRectForBounds(bounds: CGRect) -> CGRect {
        //keeps original origin and width, changes height, you get the idea
        //let customBounds = CGRect(origin: CGPoint(x: bounds.origin.x, y: bounds.origin.y), size: CGSize(width: bounds.size.width, height: 25.0))
        let customBounds = super.trackRectForBounds(bounds)
        let finalBounds = CGRectMake(customBounds.origin.x, customBounds.origin.y - 12.5, customBounds.width, 50)
       // super.trackRectForBounds(customBounds)
        return finalBounds
    }
    
    
    override func thumbRectForBounds(bounds: CGRect, trackRect rect: CGRect, value: Float) -> CGRect {
        let customRect = super.thumbRectForBounds(bounds, trackRect: rect, value: value)
        let finalRect = CGRectMake(customRect.origin.x, customRect.origin.y - 12.5, customRect.width, customRect.height)
        return finalRect
    }
*/

}