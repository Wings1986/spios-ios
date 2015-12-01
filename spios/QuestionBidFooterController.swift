//
//  QuestionDetailFooterController.swift
//  spios
//
//  Created by Administrator on 6/9/15.
//  Copyright (c) 2015 Studypool. All rights reserved.
//

import UIKit
import Haneke

protocol QuestionBidFooterControllerDelegate
{
    func openBidView()
    func closeBidView()
    func selectBid(row:Int)
    func showBidProfile(row:Int)
}

/// Question Bid Tutor List ViewController
class QuestionBidFooterController: UIViewController, HowTobidPopOverDelegate{

    
    @IBOutlet weak var footerview: QuestionBidFooterView!
    
    var delegate:QuestionBidFooterControllerDelegate?
    
    var dataTutor = []
    
    var tutorCell = NSMutableDictionary()
    
    var bExpand:Bool = false

    var category:String? = "MATH"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        footerview.controller = self
        footerview.viewdidload()
        // Do any additional setup after loading the view.

        // Set up toolview
        
    }
    
    

    @IBAction func leftButtonPressed(sender: UIButton) {
        let buttonPosition = sender.convertPoint(CGPointZero, toView: footerview.mTableView)
        let indexPath = footerview.mTableView.indexPathForRowAtPoint(buttonPosition)
        self.delegate?.showBidProfile(indexPath!.row)
    }
    
    @IBAction func rightButtonPressed(sender: UIButton) {
        let buttonPosition = sender.convertPoint(CGPointZero, toView: footerview.mTableView)
        let indexPath = footerview.mTableView.indexPathForRowAtPoint(buttonPosition)
        let cellSelected = footerview.mTableView.cellForRowAtIndexPath(indexPath!) as! QuestionBidCell
        self.delegate?.selectBid(indexPath!.row)
    }

    func reloadBidList(){
        if(dataTutor.count == 0){
            footerview.btnHowTowork.hidden = true
        }
        footerview.mTableView.reloadData()
        footerview.lbBidTitle.text = String(format: "Bids (%d)", self.dataTutor.count)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func onClickExpand(sender: AnyObject) {
        if (bExpand == true) {
            footerview.closeView()
        } else {
            footerview.openView()
        }
    }
    
    
    
    @IBAction func showBidGuidPopupview(sender: AnyObject) {
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        let popView = HowTobidPopOverView.loadFromNibNamed("HowTobidPopOverView", bundle: nil) as! HowTobidPopOverView
        popView.delegate = self
        popView.frame = CGRectMake(0, 0, screenSize.width - 70, 430)
        
        self.lew_presentPopupView(popView, animation: LewPopupViewAnimationDrop.alloc())
    }
    
    func onDismiss() {
        self.lew_dismissPopupViewWithanimation(LewPopupViewAnimationDrop.alloc())
    }
    
    func actDetail(sender:UIButton){
        //self.delegate?.selectBid(sender.tag)
        let bidModel = self.dataTutor[sender.tag] as! BidModel
        //change to access bidarray
        globalPaymentPrice = bidModel.price
    }
   
}
