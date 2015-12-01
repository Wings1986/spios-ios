//
//  QuestionBidFooterView.swift
//  spios
//
//  Created by MobileGenius on 10/13/15.
//  Copyright (c) 2015 Studypool. All rights reserved.
//

import UIKit

class QuestionBidFooterView: UIView, UITableViewDataSource, UITableViewDelegate {
    
    var controller: QuestionBidFooterController!

    @IBOutlet weak var toolView: UIView!
    @IBOutlet weak var btnExpand: UIButton!
    @IBOutlet weak var mTableView: UITableView!
    @IBOutlet weak var lbTutorTitle: UILabel!
    @IBOutlet weak var lbStandardTier: UILabel!
    @IBOutlet weak var lbBidTitle: UILabel!
    @IBOutlet weak var imgExpand: UIImageView!
    @IBOutlet weak var btnHowTowork: UIButton!
    
    func viewdidload(){
        
        toolView.layer.shadowOpacity = 0.3
        toolView.layer.shadowColor = UIColor.blackColor().CGColor
        toolView.layer.shadowOffset = CGSizeMake(0.0,3.0)
        toolView.layer.masksToBounds = false
        toolView.layer.shadowRadius = 2.5
        self.bringSubviewToFront(toolView)
        
        //make sure you can scroll to the bottom of the bid list.
        self.mTableView.contentInset = UIEdgeInsetsMake(0, 0, 124, 0)
        
        //by default the view is hidden, so no scroll
        self.mTableView.scrollEnabled = false
        self.mTableView.tableFooterView = UIView()
        
        self.setUpGestures()
        
    }
    
    private func setUpGestures() {
        // Set up gestures
        var swipeUp = UISwipeGestureRecognizer(target: self, action: "respondToSwipeGesture:")
        swipeUp.direction = UISwipeGestureRecognizerDirection.Up
        self.toolView.addGestureRecognizer(swipeUp)
        
        var swipeDown = UISwipeGestureRecognizer(target: self, action: "respondToSwipeGesture:")
        swipeDown.direction = UISwipeGestureRecognizerDirection.Down
        self.toolView.addGestureRecognizer(swipeDown)
        
        var tap = UITapGestureRecognizer(target: self, action: "respondToTapGesture:")
        self.toolView.addGestureRecognizer(tap)
    }
    
    func respondToSwipeGesture(gesture: UISwipeGestureRecognizer) {
        if gesture.direction == UISwipeGestureRecognizerDirection.Up {
            openView()
        } else {
            closeView()
        }
    }
    
    func openView() {
        self.imgExpand.image = UIImage(named: "drop_down")
        controller.delegate?.openBidView()
        controller.bExpand = true
        
        mTableView.delegate = self
        mTableView.dataSource = self
        mTableView.reloadData()
    }
    
    func closeView() {
        self.imgExpand.image = UIImage(named: "drop_up")
        controller.delegate?.closeBidView()
        controller.bExpand = false
    }
    
    func respondToTapGesture(gesture: UITapGestureRecognizer){
        controller.onClickExpand(gesture)
    }

    // MARK: - tableView Functions
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return controller.dataTutor.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("QuestionBidCell", forIndexPath: indexPath) as! QuestionBidCell
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        
        let bidModel = controller.dataTutor[indexPath.row] as! BidModel
        
        // Dynamic tier pricing updated via backend
        self.lbStandardTier.text = String(format: "%@", bidModel.tier_name)

        // TODO: Should move this out of here. Oh well.
        cell.btnDetail.tag = indexPath.row
        cell.btnDetail.addTarget(controller, action: "actDetail:", forControlEvents: UIControlEvents.TouchUpInside)
        
        cell.loadBid(bidModel);
        
        return cell;
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.controller.delegate?.showBidProfile(indexPath.row)
    }
}
