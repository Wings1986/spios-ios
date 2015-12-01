//
//  QuestionDetailWithImageCell.swift
//  spios
//
//  Created by Administrator on 6/9/15.
//  Copyright (c) 2015 Studypool. All rights reserved.
//

import UIKit


// Discussion Cell with Image Collection and Profile View
class QuestionDetailWithImageCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource{

    
    @IBOutlet weak var ivAvatar: UIImageView!
    @IBOutlet weak var ivMask: UIImageView!
    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var lbCount: UILabel!
    @IBOutlet weak var lbTimestamp: UILabel!
    @IBOutlet weak var lbMainTimestamp: UILabel!
    @IBOutlet weak var lblRating: UILabel!
    

    @IBOutlet weak var lbDesc: UITextView!
    
    @IBOutlet weak var imvCamera: UIImageView!
    @IBOutlet weak var ivImage: UIImageView!
    

    @IBOutlet weak var timestampContraint: NSLayoutConstraint!
    @IBOutlet weak var timestampTopContraint: NSLayoutConstraint!
    @IBOutlet weak var textviewRightContraint: NSLayoutConstraint!
    @IBOutlet weak var constraintImageHeight: NSLayoutConstraint!
    @IBOutlet weak var imageEmboss: UIImageView!
    @IBOutlet weak var imageCollection: UICollectionView!
    @IBOutlet weak var profileview: UIView!
    
    @IBOutlet weak var topMarginConstraint: NSLayoutConstraint?
    @IBOutlet weak var bottomMarginConstraint: NSLayoutConstraint?
    
    var nTotalCount : Int!
    var nColumnCount : Int!
    
    var viewcontroller : UIViewController!
    
    var photoArray:NSArray!
    var linkArray:NSArray!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        lbName.text = ""
        ivAvatar.image = nil
        lbCount.text = ""
        lbTimestamp.text = ""
        
        imvCamera.hidden = false
        
        ivAvatar.layer.cornerRadius = ivAvatar.frame.size.width/2.0
        ivAvatar.layer.borderWidth = 0.5;
        ivAvatar.layer.borderColor = UIColor.clearColor().CGColor
        ivAvatar.clipsToBounds = true
        ivAvatar.userInteractionEnabled = true
        
        imageCollection.delegate = self
        imageCollection.dataSource = self
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    // MARK: - Collection View functions
    //1
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        
        if(photoArray == nil){
            nTotalCount = 0
        }
        else if (linkArray == nil)
        {
            nTotalCount = photoArray.count
        }
        else {
            
            nTotalCount = photoArray.count + linkArray.count
        }
        nColumnCount = Int(collectionView.frame.width / 70)
        
        var rowCount  = nTotalCount / nColumnCount
        
        if(nTotalCount % nColumnCount != 0){
            rowCount = rowCount + 1
        }
        return rowCount
    }
    
    //2
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        let nColumnCount = Int(collectionView.frame.width / 70)
        
        if(nColumnCount * (section+1) < nTotalCount){
            return nColumnCount
        }else{
            return nTotalCount - nColumnCount * (section)
        }

    }
    
    //3
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        if(indexPath.section*nColumnCount+indexPath.row+1 <= photoArray.count){
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("image_cell", forIndexPath: indexPath) as! ImageQuestionCell
            cell.backgroundColor = UIColor.clearColor()
            let imageurl = photoArray[indexPath.section*nColumnCount+indexPath.row] as! String
            
            if let url = NSURL(string: imageurl) {
                
                cell.IMG.hnk_setImageFromURL(url)
                
                //                self.studentAvatar = cell.ivAvatar.image
                return cell
                
                
            }
        }else{
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("image_cell1", forIndexPath: indexPath) as! ImageQuestionCell

            cell.IMG.image = UIImage(named: "textimage")
            cell.IMG.layer.borderWidth = 0
            return cell

            
        }
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("image_cell", forIndexPath: indexPath) as! ImageQuestionCell
        return cell
        // Configure the cell
        
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as! ImageQuestionCell
        
        if(indexPath.section*nColumnCount+indexPath.row+1  <= photoArray.count){
            if let photoarray = self.photoArray{
                PhotoBroswerVC.show(viewcontroller, type: PhotoBroswerVCTypeZoom, index: UInt(indexPath.section*nColumnCount+indexPath.row)) { () -> [AnyObject]! in
                    var myArray : NSMutableArray = []
                    for i in photoarray {
                        let model = PhotoModel()
                        model.mid = UInt(self.photoArray.count)
                        
                        model.image_HD_U = i as! String
                        model.sourceImageView = cell.IMG
                        
                        myArray.addObject(model)
                    }
                    return myArray as [AnyObject]
                    
                }
            }
        }else{
            
            UIApplication.sharedApplication().openURL(NSURL(string: self.linkArray[indexPath.section*nColumnCount+indexPath.row-photoArray.count] as! String)!)
            
        }
    }
    

}
