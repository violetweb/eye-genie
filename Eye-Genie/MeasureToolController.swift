//
//  MeasureToolController.swift
//  EyeGenie
//
//  Created by Ryan Maxwell on 2016-04-26.
//  Copyright © 2016 Bceen Ventures. All rights reserved.
//

import UIKit

class MeasureToolController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIScrollViewDelegate, UIAlertViewDelegate, UIPopoverPresentationControllerDelegate {

    @IBOutlet weak var lblPupilDistance: UILabel!

    @IBOutlet weak var txtReferenceDistance: UITextField!
    @IBAction func txtReferenceDistance_Changed(sender: UITextField) {
        if (sender.text != nil){
            let numbers = NSCharacterSet.decimalDigitCharacterSet();
            let value = sender.text!.rangeOfCharacterFromSet(numbers);
            if let result = value {
                referenceDistance = Float(sender.text!)!
                calcAll()
            }
        }
    }
    
    @IBOutlet weak var selectedImageName: UILabel!
    @IBOutlet weak var lblFittingHeightLeft: UILabel!
    @IBOutlet weak var lblFittingHeightRight: UILabel!
    
    
    
    @IBAction func btnShowCalculations(sender: UIButton) {
        
        
        
        let calculationsPopover = UIStoryboard(name:"Main",bundle:nil);

        let controller = calculationsPopover.instantiateViewControllerWithIdentifier("Order") as! OrderController
        
        controller.modalPresentationStyle = .Popover
        self.presentViewController(controller, animated: true, completion: nil)
       
        // configure the Popover presentation controller
        let popController = controller.popoverPresentationController
        popController!.permittedArrowDirections = .Down
        popController!.sourceView = view
        popController!.sourceRect = CGRectMake(0,620,500,500)
        popController!.delegate = self;
        
        
        
        controller.txtFittingHeight.text = String(fittingHeight)
        controller.txtBoxWidth.text =  String(leftboxWidth)
        controller.txtBoxHeight.text = String(leftBoxHeight)
        controller.txtBridge.text = String(bridge*scale) // also known as DBL.
        controller.txtPD.text = String(pd)
        
        
    }
    
     
    func copyToOrder(alertView: UIAlertAction!){
        print("We will add this part later.");
    }
    
    @IBOutlet weak var selectedImage: UIImageView!
    
   
    @IBOutlet weak var lblBridge: UILabel!
    @IBOutlet weak var lblrightBoxWidth: UILabel!
    @IBOutlet weak var lblleftBoxWidth: UILabel!
    @IBOutlet weak var lblleftBoxHeight: UILabel!
    @IBOutlet weak var lblrightBoxHeight: UILabel!
    
    var leftEyePosition = CGPointZero
    var rightEyePosition = CGPointZero
    
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    let path = getSupportPath("images")
    let picker = UIImagePickerController();
    var pickedImage = UIImage();
    
    var referenceDistance = Float(0.0)
    var pdLeft: Float!
    var pdRight: Float!
    var bridge: Float!
    var leftboxWidth: Float!
    var rightBoxWidth: Float!
    var leftBoxHeight: Float!
    var rightBoxHeight: Float!
    var pdHeight: Float!
    
    
    //Rotate Section
    var selectedImageTransform = Double(0) // Default is zero.
    
    
    @IBAction func btnRotateCounter(sender: UIButton) {
        
       selectedImageTransform = selectedImageTransform + (M_PI / 180)
       selectedImage.transform = CGAffineTransformMakeRotation(CGFloat(selectedImageTransform))
       
    }
    @IBAction func btnRotateClockwise(sender: UIButton) {
        
        selectedImageTransform = selectedImageTransform - (M_PI / 180)
        selectedImage.transform = CGAffineTransformMakeRotation(CGFloat(selectedImageTransform))
        
    }
    
    var lastScale = Float(0)
    
    
    @IBAction func btnReset(sender: UIButton) {
      
        
        //reference points are 100x100
        referencePointLeft.frame.origin.x = lefteye.x != 0 ? lefteye.x - 50 : 125
        referencePointRight.frame.origin.x = righteye.x != 0 ? righteye.x - 50 : referencePointLeft.frame.origin.x + 575
        referencePointLeft.frame.origin.y = lefteye.y != 0 ? lefteye.y - 30 : 30
        referencePointRight.frame.origin.y = lefteye.y != 0 ? righteye.y - 30 : 30

        
        
        bottomLine.frame.origin.y = referencePointLeft.frame.origin.y + 175
        topLine.frame.origin.y = referencePointLeft.frame.origin.y
        
        leftOuterLine.frame.origin.x = referencePointLeft.frame.origin.x + 65
        rightOuterLine.frame.origin.x = referencePointRight.frame.origin.x - 15
        
        leftInnerLine.frame.origin.x =  referencePointLeft.frame.origin.x + 250
        rightInnerLine.frame.origin.x = referencePointRight.frame.origin.x - 250
        
        leftPupil.frame.origin.x = lefteye.x != 0 ? lefteye.x : referencePointLeft.frame.origin.x + 150
        rightPupil.frame.origin.x = righteye.x != 0 ? righteye.x : referencePointRight.frame.origin.x - 150
        leftPupil.frame.origin.y = lefteye.y != 0 ? lefteye.y : 100
        rightPupil.frame.origin.y = righteye.y != 0 ? righteye.y : 100

       
    }
    
    @IBAction func btnNudgeLeft(sender: UIButton, event: UIEvent) {
        
        
        let currentpos = selectedImage.frame.origin.x
        selectedImage.frame.origin.x = currentpos - 5
        
    }
    
    
    @IBAction func btnNudgeUp(sender: UIButton, event: UIEvent) {
        let currentpos = selectedImage.frame.origin.y
        selectedImage.frame.origin.y = currentpos - 5
    }
    
    
    @IBAction func btnNudgeDown(sender: UIButton, event: UIEvent) {
        let currentpos = selectedImage.frame.origin.y
        selectedImage.frame.origin.y = currentpos + 5
    }
    
    @IBAction func btnNudgeRight(sender: UIButton, event: UIEvent) {
        let currentpos = selectedImage.frame.origin.x
        selectedImage.frame.origin.x = currentpos + 5
    }
    
    @IBAction func pinchGesture(sender: UIPinchGestureRecognizer) {
       
       
        if sender.state == .Changed || sender.state == .Began {
            
            let translate = CATransform3DMakeTranslation(0, 0, 0);
            
            let scale = CATransform3DMakeScale(sender.scale, sender.scale, 1);
            let selectedImageTransform = CATransform3DConcat(translate, scale);
            selectedImage.layer.transform = selectedImageTransform
            
            
        }else{
            print("hello")
        }
        

    }
    
    @IBOutlet weak var lblPupilSlider: UILabel!
    
    @IBAction func slidePupilDiameter(sender: UISlider) {
        
        let radius = CGFloat(sender.value)
        leftPupil.bounds = CGRectMake(0,0,radius*8,radius*8)
        rightPupil.bounds = CGRectMake(0,0,radius*8,radius*8)
        lblPupilSlider.text = String(radius)
        
    }
    
    
    var btnAPosition = CGPointZero
    var btnBPosition = CGPointZero
    
        //Toolbox Section
    @IBOutlet weak var toolboxView: UIView!
    
    
    
    var referencePointLeftPosition: Float = 0.0
    var referencePointRightPosition: Float = 0.0
    
    var scale = Float(0.0);
    var pd = Float(0.0)
    var fittingHeight = Float(0.0);
    
    func calcAll(){
    
     
      let refWidth =  Float(referencePointRight.frame.origin.x - referencePointLeft.frame.origin.x)
      scale = referenceDistance / refWidth
     
        //BOX WIDTH
      leftboxWidth = Float(leftInnerLine.frame.origin.x -  leftOuterLine.frame.origin.x)*scale
      rightBoxWidth = Float(rightOuterLine.frame.origin.x - rightInnerLine.frame.origin.x)*scale
      lblleftBoxWidth.text = String(format: "%.02f",leftboxWidth)
      lblrightBoxWidth.text = String(format: "%.02f", rightBoxWidth)
        
        //BOX HEIGHT
      leftBoxHeight = Float(bottomLine.frame.origin.y - topLine.frame.origin.y)*scale
      rightBoxHeight = Float(bottomLine.frame.origin.y - topLine.frame.origin.y)*scale
      lblrightBoxHeight.text = String(format: "%.02f", rightBoxHeight)
      lblleftBoxHeight.text = String(format: "%.02f", leftBoxHeight)
        
        //BRIDGE
      bridge = Float(rightInnerLine.frame.origin.x - leftInnerLine.frame.origin.x)
      let bridgecenter = CGFloat(bridge/2.0)
      lblBridge.text = String(format: "%.02f", bridge*scale)
    
        //PD
       pd = Float(rightPupil.frame.origin.x - leftPupil.frame.origin.x)*scale
       lblPupilDistance.text = String(pd);
        
        //FITTING HEIGHT
        fittingHeight = Float(bottomLine.frame.origin.y - leftPupil.frame.origin.y)*scale
        lblFittingHeightLeft.text = String(format: "%.02f",fittingHeight)
     
        lblFittingHeightRight.text = String(format: "%.02f",(Float(bottomLine.frame.origin.y - rightPupil.frame.origin.y)*scale))
        
       //Move the centercline based on where center of bridge is.
       centerLine.frame.origin.x = leftInnerLine.frame.origin.x + CGFloat(bridge/2.0)

        //Default positioning of labels
        lblBridge.frame.origin.x = leftInnerLine.frame.origin.x + CGFloat(bridge/2.0) //allow for the size of the label.
        
        lblleftBoxWidth.frame.origin.x = leftInnerLine.frame.origin.x - leftOuterLine.frame.origin.x/2.0
        lblrightBoxWidth.frame.origin.x = rightInnerLine.frame.origin.x + ((rightOuterLine.frame.origin.x - rightInnerLine.frame.origin.x) / 2.0)
        
        lblleftBoxHeight.frame.origin.x = leftOuterLine.frame.origin.x - 50;
        lblleftBoxHeight.frame.origin.y = bottomLine.frame.origin.y
        
        lblrightBoxHeight.frame.origin.x = rightOuterLine.frame.origin.x + 50;
        lblrightBoxHeight.frame.origin.y = bottomLine.frame.origin.y
        
        lblFittingHeightLeft.frame.origin.y = bottomLine.frame.origin.y - 80
        lblFittingHeightRight.frame.origin.y = bottomLine.frame.origin.y - 80
        

        
    }
    
    func toolPositioningBasedOnReferencePoints(){
        
        
        //Base everything off reference points.
        let baseRef = Float(referencePointLeft.frame.origin.x - referencePointRight.frame.origin.x)
        
        
        //User Set the reference points.
        topLine.frame.origin.y = referencePointLeft.frame.origin.y + 25
        bottomLine.frame.origin.y = topLine.frame.origin.y + 150
        
        leftOuterLine.frame.origin.x = referencePointLeft.frame.origin.x + 65
        rightOuterLine.frame.origin.x = referencePointRight.frame.origin.x - 15
        
        leftInnerLine.frame.origin.x =  referencePointLeft.frame.origin.x + 300
        rightInnerLine.frame.origin.x = referencePointRight.frame.origin.x - 250
        
        leftPupil.frame.origin.x = lefteye.x != 0 ? lefteye.x : referencePointLeft.frame.origin.x + 150
        rightPupil.frame.origin.x = righteye.x != 0 ? righteye.x : referencePointRight.frame.origin.x - 150
        leftPupil.frame.origin.y = lefteye.y != 0 ? lefteye.y : 100
        rightPupil.frame.origin.y = righteye.y != 0 ? righteye.y : 100
        

        
    }
    
    
    func imageDrag(sender: AnyObject, event: UIEvent) {
        
        guard let control = sender as? UIControl else { return }
        guard let touches = event.allTouches() else { return }
        guard let touch = touches.first else { return }
        
        let prev = touch.previousLocationInView(control)
        let p = touch.locationInView(control)
        var center = control.center
        center.x += p.x - prev.x
        center.y += p.y - prev.y
        control.center = center
        
        
         //After either reference is dragged... update the reference point data.
        calcAll()
        
    }
    
    
    
    func referenceDrag(sender: AnyObject, event: UIEvent) {
        
        guard let control = sender as? UIControl else { return }
        guard let touches = event.allTouches() else { return }
        guard let touch = touches.first else { return }
        
        let prev = touch.previousLocationInView(control)
        let p = touch.locationInView(control)
        var center = control.center
        
        center.x += p.x - prev.x
        center.y += p.y - prev.y
        control.center = center
        
        
        //After either reference is dragged... update the reference point data.
        calcAll()
        
    }

    
    
    
    func buttonDragVertical(sender: AnyObject, event: UIEvent) {
        
        guard let control = sender as? UIControl else { return }
        guard let touches = event.allTouches() else { return }
        guard let touch = touches.first else { return }
        
        let prev = touch.previousLocationInView(control)
        let p = touch.locationInView(control)
        var center = control.center
        center.x += p.x - prev.x
        control.center = center
        calcAll()
       
    }
    
    func buttonDragHorizontal(sender: AnyObject, event: UIEvent) {
        
        //determine which object
        
        guard let control = sender as? UIControl else { return }
        guard let touches = event.allTouches() else { return }
        guard let touch = touches.first else { return }
        
        let prev = touch.previousLocationInView(control)
        let p = touch.locationInView(control)
        var center = control.center
        center.y += p.y - prev.y
        control.center = center
        
        calcAll()
    }
    

    
    var leftOuterLine = UIButton()
    var leftInnerLine = UIButton()
    var bottomLine = UIButton()
    var rightOuterLine = UIButton()
    var rightInnerLine = UIButton()
    var centerLine = UIButton()
    var topLine = UIButton()
    var leftPupil = UIButton()
    var rightPupil = UIButton()
    var referencePointLeft = UIButton!()
    var referencePointRight = UIButton!()
    var faceparams = CGRect()
    var lefteye = CGPointZero
    var righteye = CGPointZero
    var hasPupil = false

    
    @IBAction func btnSnapToEyes(sender: UIButton) {
        
        hasEyes() // re-run it, if it set the global haspupil to true, deal w/it.
        
        if hasPupil == true {
            //Snap to the eyes
            leftPupil.layer.position = lefteye
            rightPupil.layer.position = righteye
            
        }else{
            let alert = UIAlertController(title: "Facial Detection", message: "Unable to Detect Facial Features automatically.  You may continue by using manual control features.  Optionally, you may retake the photo.", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Close", style: UIAlertActionStyle.Default, handler: { action in
                switch action.style{
                case .Default:
                    print("default")
                    
                case .Cancel:
                    print("cancel")
                    
                case .Destructive:
                    print("destructive")
                }
            }))
            alert.addAction(UIAlertAction(title: "Retake Photo", style: UIAlertActionStyle.Default, handler: retakePhoto ))
            self.presentViewController(alert, animated: true, completion: nil)
        }
     
        toolPositioningBasedOnReferencePoints()
    }
    
    @IBOutlet weak var mainView: UIView!
    
    
   
    
    func retakePhoto(alertView: UIAlertAction!){
        
        picker.allowsEditing = true
        picker.sourceType = .Camera
        self.presentViewController(picker, animated: true, completion: nil)

    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage{
            processImage(pickedImage)
        }
        dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    
    func processImage(image: UIImage){
        
        
        var cropparams = CGRectZero
        
        let ciImage = CIImage(CGImage: image.CGImage!)
        let options = [CIDetectorAccuracy: CIDetectorAccuracyHigh, CIDetectorImageOrientation: 1]
        let faceDetector = CIDetector(ofType: CIDetectorTypeFace, context: nil, options: options as! [String : AnyObject])
        
        
        let faces = faceDetector.featuresInImage(ciImage)
        
        let ciContext = CIContext(options: nil)
        
        if let face = faces.first as? CIFaceFeature {
            
            let faceparams = face.bounds
            var lefteye = CGPointZero
            var righteye = CGPointZero
            var mouth = CGPointZero
            var mouthheight = CGFloat(0)
            
            if face.hasLeftEyePosition {
                lefteye = CGPointMake(face.leftEyePosition.x, face.leftEyePosition.y)
            }
            
            if face.hasRightEyePosition {
                righteye = CGPointMake(face.rightEyePosition.x, face.rightEyePosition.y)
            }
            
            if face.hasMouthPosition {
                mouth = CGPointMake(face.mouthPosition.x, face.mouthPosition.y)
                mouthheight = face.mouthPosition.y - faceparams.origin.y
            }
            
            
            if (lefteye.x > 0 && righteye.x > 0){
                if (mouth.x>0){
                    cropparams = CGRectMake(faceparams.origin.x, faceparams.origin.y+mouthheight, faceparams.width, faceparams.height - mouthheight)
                }else{
                    cropparams = faceparams
                }
            }
            let croppedimage = ciContext.createCGImage(ciImage, fromRect: cropparams)
            
            let finalimage = UIImage(CGImage: croppedimage)
            
            let originalsize = image.size
            let scale = CGFloat(2.18) // thinking bout leaving it large!
            
            
            UIGraphicsBeginImageContextWithOptions(CGSize(width: originalsize.width/scale, height:originalsize.height/scale), false, finalimage.scale)
            finalimage.drawInRect(CGRectMake(0,0,originalsize.width/scale, originalsize.height/scale))
            let thefinalimage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            
            selectedImage.image = thefinalimage
            
            
        }else{
            selectedImage.image = image
        }
        
        
    }

    
    override func viewDidAppear(animated: Bool) {
       
        
       
        let mt = MeasureTool.init()
      
        //Initialize Face Detection
        hasEyes()
        
        let hasImage = leftPupil.imageForState(.Normal);
        
        if (hasImage == nil){
            //If detected, draw pupils / assign appropriately.
            if (hasPupil == true){
                leftPupil = mt.drawPupil(CGFloat(10.0),eyePosition: lefteye)
                rightPupil = mt.drawPupil(CGFloat(10.0), eyePosition: righteye)
                
            }else{
                leftPupil = mt.drawPupil(CGFloat(10.0),eyePosition: CGPoint(x: selectedImage.frame.width/CGFloat(4.0),y:100))
                rightPupil = mt.drawPupil(CGFloat(10.0),eyePosition: CGPoint(x: selectedImage.frame.width - (selectedImage.frame.width/CGFloat(4.0)),y:100))
            }
            
            toolView.addSubview(leftPupil)
            toolView.addSubview(rightPupil)

        }
        
       
            
   }

   
   
    
    func hasEyes() {
        
        if let inputImage = selectedImage.image {
            
            let ciImage = CIImage(CGImage: inputImage.CGImage!)
            let options = [CIDetectorAccuracy: CIDetectorAccuracyHigh, CIDetectorImageOrientation: 1]
            let faceDetector = CIDetector(ofType: CIDetectorTypeFace, context: nil, options: options as! [String : AnyObject])
            
            let faces = faceDetector.featuresInImage(ciImage)
            
            if let face = faces.first as? CIFaceFeature {
                
                faceparams = face.bounds
                
                 if face.hasLeftEyePosition {
                    lefteye = CGPointMake(face.leftEyePosition.x, face.leftEyePosition.y)
                    hasPupil = true
                 }
                if face.hasRightEyePosition {
                    hasPupil = true
                    righteye = CGPointMake(face.rightEyePosition.x, face.rightEyePosition.y)
                }
            
            }
        }
        
     }
    
    @IBOutlet weak var toolView: UIView!

    
      override func viewDidLoad(){
        
        super.viewDidLoad()
        
        toolboxView.layer.zPosition = 20
        
        let mt = MeasureTool.init()
        
        topLine = mt.drawTopLine()
        bottomLine = mt.drawBottomLine()
        leftOuterLine = mt.drawOuterLeftLine()
        rightOuterLine = mt.drawOuterRightLine()
        leftInnerLine = mt.drawInnerLeftLine()
        rightInnerLine = mt.drawInnerRightLine()
        centerLine = mt.drawCenterLine()
        
        
        //TODO:  HAVE A DEFAULT : FIRST-choice should be our default until the user overrides it.
        referencePointLeft = MeasureTool().drawReferencePoint((selectedImage.bounds.width/6))
        referencePointRight = MeasureTool().drawReferencePoint(selectedImage.bounds.width - (selectedImage.bounds.width/6))
     
        
        toolView.addSubview(referencePointLeft)
        toolView.addSubview(referencePointRight)
        
        toolView.addSubview(topLine)
        toolView.addSubview(bottomLine)
        toolView.addSubview(leftOuterLine)
        toolView.addSubview(rightOuterLine)
        toolView.addSubview(leftInnerLine)
        toolView.addSubview(rightInnerLine)
        toolView.addSubview(centerLine)
        
       
        self.scrollView.contentSize=CGSizeMake(970,550);
        self.scrollView.delegate = self;
        
        picker.delegate = self;
        calcAll()
        
        toolPositioningBasedOnReferencePoints()

        
   }

    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        
        return selectedImage
        //eturn toolView
    
    }

    
    func scrollViewDidZoom(scrollView: UIScrollView) {
        
        var oldFrame = toolView.frame;
        oldFrame.origin = scrollView.contentOffset;
        toolView.frame = oldFrame;
    }
    
}