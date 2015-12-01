//
//  MediumProgressViewManager.swift
//  MediumProgressView
//
//  Created by pixyzehn on 2/9/15.
//  Copyright (c) 2015 pixyzehn. All rights reserved.
//

import UIKit

public let MEDIUM_PROGRESS_COLOR = UIColor(red:0.33, green:0.83, blue:0.44, alpha:1)

public class MediumProgressViewManager {
    
    public enum Position {
        case Top
        case Bottom
    }
        
    public var position: Position?
    public var color: UIColor?
    public var height: CGFloat?
    public var isLeft: Bool             = true
    public var duration: CFTimeInterval = 1.2
    public var navigationheight : CGFloat?
    
    public var progressView: MediumProgressView?
    
    public init() {
       initialize()
    }
    
    public func initialize() {
        self.position = .Top
        self.color    = MEDIUM_PROGRESS_COLOR
        self.height   = 4.0
    }
    
    public class var sharedInstance: MediumProgressViewManager {
        struct Static {
            static let instance: MediumProgressViewManager = MediumProgressViewManager()
        }
        
        Static.instance.position = .Top // Default is top.
        Static.instance.color    = UIColor(red:42.0/255, green:191.0/255, blue:225.0/255, alpha:1) // Default is UIColor(red:0.33, green:0.83, blue:0.44, alpha:1).
        Static.instance.height   = 4.0 // Default is 4.0.
        Static.instance.isLeft   = true // Default is true.
        Static.instance.duration = 1.0  // Default is 1.2.

        
        return Static.instance
    }

    // Internal function
    
    public func showProgressOnView(controller: UIViewController) {
        
        for view in controller.view.subviews {
            if(view.tag == 1000){
                view.removeFromSuperview()
            }
        }
        if(controller.navigationController == nil){
            return
        }
        if let controllerHeight = controller.navigationController!.navigationBar.frame.height as CGFloat? {
            if let statusBarHeight = UIApplication.sharedApplication().statusBarFrame.size.height as CGFloat? {
                navigationheight = controllerHeight + statusBarHeight
                progressView = initializeProgressViewWithFrame(controller.view.frame)
                progressView?.tag = 1000
                controller.view.addSubview(progressView!)
                controller.view.bringSubviewToFront(progressView!)
            }
        }

    }
    
    public func hideProgressView(controller: UIViewController) {
        progressView?.removeFromSuperview()
        for view in controller.view.subviews {
            if(view.tag == 1000){
                view.removeFromSuperview()
            }
        }
    }
    
    // Helpers
    
    func initializeProgressViewWithFrame(aFrame: CGRect) -> MediumProgressView {
        let aWidth = aFrame.size.width
        let aHeight = aFrame.size.height
        var frame: CGRect = CGRectMake(0, navigationheight!, aWidth, height!)
        if position == .Bottom {
            frame = CGRectMake(0, navigationheight! + aHeight - height!, aWidth, height!)
        }
        var progressView = MediumProgressView(frame: frame, isLeft: isLeft, duration: duration)
        progressView.backgroundColor = color
        return progressView
    }

}
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com