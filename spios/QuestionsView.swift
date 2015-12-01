//
//  QuestionsView.swift
//  spios
//
//  Created by MobileGenius on 10/6/15.
//  Copyright (c) 2015 Studypool. All rights reserved.
//

import UIKit
import AVFoundation
import MobileCoreServices


class QuestionsView: UIView, UIImagePickerControllerDelegate, UIAlertViewDelegate, UINavigationControllerDelegate, UITextViewDelegate, UITextFieldDelegate,UICollectionViewDataSource,UICollectionViewDelegate {

    @IBOutlet weak var clvImageUpload: UICollectionView!
    @IBOutlet weak var collectionImages: UICollectionView!
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var descField: SAMTextView!
    @IBOutlet weak var textlength: UILabel!
    @IBOutlet weak var stepimageview: UIImageView!
    
    @IBOutlet weak var capturedImage: UIImageView!
    @IBOutlet weak var progressHeaderHeight: NSLayoutConstraint!
    
    @IBOutlet weak var topheight: NSLayoutConstraint?
    
    @IBOutlet weak var tempImage: UIImageView!
    
    @IBOutlet weak var btnNext: UIBarButtonItem!
    @IBOutlet weak var btnNextBottom: UIButton!
    
    
    var tapback : UITapGestureRecognizer!
    
    var controller:QuestionsViewController!
    
    let staticDescFieldText = "Stuck on an academic question? Get help now!"
    
    
    func viewdidload(){
        
        refreshNextButton()

        //SHADOWS
        titleField.delegate = self
        titleField.addTarget(self, action: "textFieldDidChange:", forControlEvents: UIControlEvents.EditingChanged)
        //titleField.layer.shadowOpacity = 0.3
        //titleField.layer.shadowColor = UIColor.blackColor().CGColor
        //titleField.layer.shadowOffset = CGSizeMake(0.0,1.0)
        //titleField.layer.masksToBounds = false
        titleField.layer.cornerRadius = 0.5
        //titleField.layer.shadowRadius = 2.5
        titleField.layer.sublayerTransform = CATransform3DMakeTranslation(5, 0, 0)
        
        descField.placeholder = staticDescFieldText;
        descField.delegate = self
        
        //descField.layer.shadowOpacity = 0.3
        //descField.layer.shadowColor = UIColor.blackColor().CGColor
        //descField.layer.shadowOffset = CGSizeMake(0.0,1.0)
        //descField.layer.masksToBounds = true
        //descField.layer.shadowRadius = 2.5
        descField.layer.cornerRadius = 0.5
        descField.layer.sublayerTransform = CATransform3DMakeTranslation(2, 0, 0)
        descField.clipsToBounds = true
        
        self.layoutIfNeeded()
        
        tapback = UITapGestureRecognizer(target: self, action: "tapBackground:")
        var swipe:UISwipeGestureRecognizer = UISwipeGestureRecognizer(target:self, action:"dismissKeyboard")
        
        swipe.direction = UISwipeGestureRecognizerDirection.Down
        
        self.addGestureRecognizer(swipe)
        
        addDoneButtonToKeyboard(titleField)
        addDoneButtonToKeyboard(descField)
    }
    
    func viewdidappear(){
        // Restore user previously written text.
        if (!userInputQuestionTitle.isEmpty) {
            self.titleField.text = userInputQuestionTitle
        }
        if (!userInputQuestionDescription.isEmpty) {
            self.descField.text = userInputQuestionDescription
        }
        
        refreshNextButton()
    }
    
    /**
    
    Add Done button bar at buttom of toolbar
    :param: textView: the textView activates the keyboard
    
    :returns: None
    */
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
    
    /**
    
    Dismisses the keyboard
    
    :param: notification: the notification that causes the keyboard to be hidden
    
    :returns: None
    */
    func hideKeyboard(notification: AnyObject)
    {
        
        if titleField.isFirstResponder(){
            titleField.resignFirstResponder()
            return
        }
        if descField.isFirstResponder(){
            descField.resignFirstResponder()
            return
        }
    }
    
    /**
    
    Dismisses the keyboard for title and description text fields.
    
    :param: None
    
    :returns: None
    */
    func dismissKeyboard(){
        self.titleField.resignFirstResponder()
        self.descField.resignFirstResponder()
    }
    
    func refreshNextButton() {
        var enabled = true
        // Enabled = title + either description or image(s)
        if (count(self.titleField.text) <= 5) {
            enabled = false
        }
        else if (self.descField.text.isEmpty && self.controller.arrImages.count == 0) {
            enabled = false
        }
        self.btnNext.enabled = enabled
        self.btnNextBottom.enabled = enabled
    }
    
    /**
    Dismisses the keyboard when background is tapped
    
    :param: gesture: The tap-background gesture that is detected
    
    :returns: None
    */
    func tapBackground(gesture: UITapGestureRecognizer){
        self.titleField.resignFirstResponder()
        self.descField.resignFirstResponder()
    }
    
    // Title
    func textFieldDidChange(textField: UITextField) {
        // Red color for <= 5 chars, black otherwise
        self.titleField.textColor = count(self.titleField.text) <= 5 ? UIColor.redColor() : UIColor.blackColor()
        
        // Limit to 80 chars
        if (count(self.titleField.text) > 80) {
            self.titleField.text = self.titleField.text.substringToIndex(advance(self.titleField.text.startIndex, 80))
        }
        
        userInputQuestionTitle = self.titleField.text
        refreshNextButton()
    }
    
    // Description
    func textViewDidChange(textView: UITextView) {
        userInputQuestionDescription = self.descField.text
        refreshNextButton()
    }
    
    // MARK: UICollectionViewDatasource
    
    /**
    
    Get the number of Items in the collectionView
    :param: collectionView: The collection view with the images
    :param: section: The section of the collection view that we want to know about (here there is only 1 section)
    
    :returns: the number of images in the section of the collectionview
    */
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return controller.arrImages.count + 1;
    }
    
    /**
    Load each cell of the collection View
    
    :param: collectionView: The collection view with the images
    :param: indexPath: The indexPath of the collection view that we want to know about
    :returns: UICollectionViewCell
    */
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell{
        
        if (indexPath.row == controller.arrImages.count) {
            return collectionView.dequeueReusableCellWithReuseIdentifier("add_cell", forIndexPath: indexPath) as! UICollectionViewCell
        }
        else {
            let cell: ImageCollectionCell = collectionView.dequeueReusableCellWithReuseIdentifier("image_cell", forIndexPath: indexPath) as! ImageCollectionCell
            cell.imvUpload.image = controller.arrImages[indexPath.row]
            cell.btnDeleteImgae.tag = indexPath.row
            cell.btnDeleteImgae.addTarget(self, action: "deleteImage:", forControlEvents: UIControlEvents.TouchUpInside)
            return cell
        }
    }
    
    /**
    
    Get the minimum Line spacing for a given section in the collection view
    
    :param: collectionView: The collection view with the images
    :param: section: The section of the collection view that we want to know about (here there is only 1 section)
    :param: collectionViewLayout: The default layout is used here
    
    :returns: the minimum line spacing
    */
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat{
        return 3
    }
    
    /**
    
    Get the minimum inter-item Line spacing for a given section in the collection view
    
    :param: collectionView: The collection view with the images
    :param: section: The section of the collection view that we want to know about (here there is only 1 section)
    :param: collectionViewLayout: The default layout is used here
    
    :returns: the minimum inter-item line spacing
    */
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat{
        return 1
    }
    
    /**
    
    This method is used when an item in the collection view is tapped
    :param: collectionView: The collection view with the images
    :param: indexPath: The indexPath of the collection view that we want to know about
    :returns: None
    */
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath){
        if (indexPath.row == controller.arrImages.count) {
            self.choosePhoto()
        }
        else {
            self.tapImage(index: indexPath.row)
        }
    }
    
    /**
    
    I am not exactly sure what this does. I think that it selects the image when you tap it.
    
    :param: index: Index of the image that was tapped
    
    :returns: None
    */
    func tapImage(index imageIndex: Int){
        PhotoBroswerVC.show(controller, type: PhotoBroswerVCTypeZoom, index: 0) { () -> [AnyObject]! in
            var myArray : NSMutableArray = []
            let model = PhotoModel()
            model.mid = 1;
            model.image = self.controller.arrImages[imageIndex]
            
            let cell: ImageCollectionCell = self.clvImageUpload.cellForItemAtIndexPath(NSIndexPath(forRow: imageIndex, inSection: 0)) as! ImageCollectionCell
            model.sourceImageView = cell.imvUpload
            
            myArray.addObject(model)
            return myArray as [AnyObject]
            
        }
    }
    
    /**
    Remove image from collection view
    :param: sender: The delete button is pressed
    :returns: None
    */
    func deleteImage(sender: UIButton){
        
        controller.arrImages.removeAtIndex(sender.tag)
        if (controller.arrImages.count == 0) {
            controller.isImage = false
        }
        self.clvImageUpload.reloadData()
        
        refreshNextButton()
    }
    
    // MARK: Actions
    ////////////////////////////////
    //capture photo code starts
    
    var captureSession: AVCaptureSession?
    var stillImageOutput: AVCaptureStillImageOutput!
    var previewLayer: AVCaptureVideoPreviewLayer!
    
    /**
    
    Choose UIAlertAction when the user presses the take photo button.
    :returns: None
    */
    func choosePhoto() {
        
        var alert:UIAlertController=UIAlertController(title: "Choose Image", message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        var cameraAction = UIAlertAction(title: "Camera", style: UIAlertActionStyle.Default)
            {
                UIAlertAction in
                self.presentCamera()
                
        }
        var galleryAction = UIAlertAction(title: "Gallery", style: UIAlertActionStyle.Default)
            {
                UIAlertAction in
                self.presentGallery()
        }
        var cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel)
            {
                UIAlertAction in
                
        }
        // Add the actions
        alert.addAction(cameraAction)
        alert.addAction(galleryAction)
        alert.addAction(cancelAction)
        // Present the actionsheet
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone
        {
            controller.presentViewController(alert, animated: true, completion: nil)
        }
        
    }
    
    var cameraUI: UIImagePickerController = UIImagePickerController()
    
    /**
    
    Presents image picker from camera images
    
    :param: None
    
    :returns: None
    */
    func presentCamera()
    {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        {
            cameraUI = UIImagePickerController()
            cameraUI.delegate = self
            cameraUI.sourceType = UIImagePickerControllerSourceType.Camera
            cameraUI.mediaTypes = [kUTTypeImage]
            cameraUI.allowsEditing = false
            
            controller.presentViewController(cameraUI, animated: true, completion: nil)
        }
    }
    
    /**
    
    Presents the image gallery
    
    :param: None
    
    :returns: None
    */
    func presentGallery()
    {
        cameraUI = UIImagePickerController()
        cameraUI.delegate = self
        cameraUI.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        cameraUI.mediaTypes = [kUTTypeImage]
        cameraUI.allowsEditing = false
        
        controller.presentViewController(cameraUI, animated: true, completion: nil)
    }
    
    /**
    
    Callback for when the imagePicker is cancelled
    :param: picker: the picker that was cancelled
    :returns: None
    */
    func imagePickerControllerDidCancel(picker:UIImagePickerController)
    {
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
    
    /**
    
    Callback for when the imagePicker is finished picking images
    
    :param: picker: the picker that is finished
    :param: info: dummy parameter
    
    :returns: None
    */
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        
        let image = info[UIImagePickerControllerOriginalImage] as? UIImage
        controller.arrImages.append(image!)
        self.clvImageUpload.reloadData()
        controller.isImage = true
        
        refreshNextButton()
        
        controller.dismissViewControllerAnimated(true, completion:nil)
    }

}
