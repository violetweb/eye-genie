//
//  MeasureToolController.swift
//  EyeGenie
//
//  Created by Ryan Maxwell on 2016-04-26.
//  Copyright © 2016 Bceen Ventures. All rights reserved.
//

import UIKit

class MeasureToolController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {


    @IBAction func txtReferenceDistance(sender: UITextField) {
        referenceDistance = Float(sender.text!)
    }
    
    @IBOutlet weak var selectedImageName: UILabel!
    @IBOutlet weak var selectedImage: UIImageView!
    @IBOutlet weak var mainView: UIView!
    
   
    @IBOutlet weak var lblBridge: UILabel!
    @IBOutlet weak var lblrightBoxWidth: UILabel!
    @IBOutlet weak var lblleftBoxWidth: UILabel!
    @IBOutlet weak var lblleftBoxHeight: UILabel!
    @IBOutlet weak var lblrightBoxHeight: UILabel!
    
  
    var referenceDistance: Float!
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
    
    var lastScale = CGFloat(0)
    
    @IBAction func pinchGesture(sender: UIPinchGestureRecognizer) {
        
      
        if sender.state == .Changed || sender.state == .Began {
            
            let translate = CATransform3DMakeTranslation(0, 0, 0);
            let scale = CATransform3DMakeScale(sender.scale, sender.scale, 1);
            let selectedImageTransform = CATransform3DConcat(translate, scale);
            selectedImage.layer.transform = selectedImageTransform
            
        
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
    
    
    @IBOutlet weak var moveView: UIImageView!
    
    
    
    var referencePointLeftPosition: Float = 0.0
    var referencePointRightPosition: Float = 0.0
    
    func calcAll(){
    
     //draw a line from reference point left to reference point right on the screen
    // our user entered referenceDistance value = our line length.
    
      leftboxWidth = Float(leftInnerLine.frame.origin.x -  leftOuterLine.frame.origin.x)
      rightBoxWidth = Float(rightOuterLine.frame.origin.x - rightInnerLine.frame.origin.x)
      lblleftBoxWidth.text = String(leftboxWidth)
      lblrightBoxWidth.text = String(rightBoxWidth)
        
      leftBoxHeight = Float(bottomLine.frame.origin.y - topLine.frame.origin.y)
      rightBoxHeight = Float(bottomLine.frame.origin.y - topLine.frame.origin.y)
      lblrightBoxHeight.text = String(rightBoxHeight)
      lblleftBoxHeight.text = String(leftBoxHeight)
        
      bridge = Float(rightInnerLine.frame.origin.x - leftInnerLine.frame.origin.x)
      lblBridge.text = String(bridge)
        
        
        
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
        
        //TODO:  Catch an image of this "point" radius on the screen zoomed in! 
        //increase its size by 2X.
        //Add it to a sublayer of the UIButton image??? is that possible.
        //probably not.  this may need to be a UIView.
        
    
       //control.addSubview(imageView)
                
       /*
        let context = UIGraphicsGetCurrentContext();
        CGContextTranslateCTM(context,1*(control.frame.size.width*0.5),1*(control.frame.size.height*0.5));
        CGContextScaleCTM(context, 1.5, 1.5);
        CGContextTranslateCTM(context,-1*(p.x),-1*(p.y));
        control.layer.renderInContext(context!)
  */
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
    
    
    override func viewDidLoad(){
        
        super.viewDidLoad()
        //Create Reference Points and add to our interface.
        
        toolboxView.layer.zPosition = 20
        selectedImage.layer.bounds = mainView.frame
        selectedImage.layer.masksToBounds = true
        print(selectedImage.layer.bounds)
        var faceparams = CGRect()
        var lefteye = CGPointZero
        var righteye = CGPointZero
        
        let mt = MeasureTool.init()
        if let inputImage = selectedImage.image {
            
            
            let ciImage = CIImage(CGImage: inputImage.CGImage!)
            
            let options = [CIDetectorAccuracy: CIDetectorAccuracyHigh]
            let faceDetector = CIDetector(ofType: CIDetectorTypeFace, context: nil, options: options)
            
            let faces = faceDetector.featuresInImage(ciImage)
            
            if let face = faces.first as? CIFaceFeature {
                print("Found face at \(face.bounds)")
                faceparams = face.bounds
                
                if face.hasLeftEyePosition {
                    print("Found left eye at \(face.leftEyePosition)")
                    lefteye = face.leftEyePosition
                    leftPupil = mt.drawPupil(CGFloat(10.0),eyePosition: lefteye)
                }
                
                if face.hasRightEyePosition {
                    print("Found right eye at \(face.rightEyePosition)")
                    righteye = face.rightEyePosition
                    rightPupil = mt.drawPupil(CGFloat(10.0),eyePosition: righteye)
                }
            }else{
                leftPupil = mt.drawPupil(CGFloat(10.0),eyePosition: CGPoint(x: mainView.bounds.width/CGFloat(4.0),y:150))
                rightPupil = mt.drawPupil(CGFloat(10.0),eyePosition: CGPoint(x: mainView.bounds.width - (mainView.bounds.width/CGFloat(4.0)),y:150))
            }
            
        }else{
            leftPupil = mt.drawPupil(CGFloat(10.0),eyePosition: CGPoint(x: mainView.bounds.width/CGFloat(4.0),y:150))
            rightPupil = mt.drawPupil(CGFloat(10.0),eyePosition: CGPoint(x: mainView.bounds.width - (mainView.bounds.width/CGFloat(4.0)),y:150))
        }
        
        let helper = FunctionsHelper()
        
        topLine = mt.drawTopLine()
        bottomLine = mt.drawBottomLine()
        leftOuterLine = mt.drawOuterLeftLine()
        rightOuterLine = mt.drawOuterRightLine()
        leftInnerLine = mt.drawInnerLeftLine()
        rightInnerLine = mt.drawInnerRightLine()
        centerLine = mt.drawCenterLine()
        
        
        //TODO:  HAVE A DEFAULT : FIRST-choice should be our default until the user overrides it.
        referencePointLeft = MeasureTool().drawReferencePoint("first-choice")
        referencePointRight = MeasureTool().drawReferencePoint("first-choice")
     
        mainView.addSubview(referencePointLeft)
        mainView.addSubview(referencePointRight)
        
        mainView.addSubview(topLine)
        mainView.addSubview(bottomLine)
        mainView.addSubview(leftOuterLine)
        mainView.addSubview(rightOuterLine)
        mainView.addSubview(leftInnerLine)
        mainView.addSubview(rightInnerLine)
        mainView.addSubview(centerLine)
        mainView.addSubview(leftPupil)
        mainView.addSubview(rightPupil)
        
        calcAll()

   }


    
  }