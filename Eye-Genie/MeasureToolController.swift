//
//  MeasureToolController.swift
//  EyeGenie
//
//  Created by Ryan Maxwell on 2016-04-26.
//  Copyright © 2016 Bceen Ventures. All rights reserved.
//

import UIKit

class MeasureToolController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {


    
    @IBOutlet weak var selectedImageName: UILabel!
    @IBOutlet weak var selectedImage: UIImageView!
    @IBOutlet weak var mainView: UIView!
    
    
    
    //Rotate Section
    var selectedImageTransform = Double(0) // Default is zero.
    @IBAction func btnRotateCounter(sender: UIButton) {
        
       selectedImageTransform = selectedImageTransform + (M_PI / 90)
       selectedImage.transform = CGAffineTransformMakeRotation(CGFloat(selectedImageTransform))
       
    }
    @IBAction func btnRotateClockwise(sender: UIButton) {
        
        selectedImageTransform = selectedImageTransform - (M_PI / 90)
        selectedImage.transform = CGAffineTransformMakeRotation(CGFloat(selectedImageTransform))
        
    }
    
    
    @IBOutlet weak var btnRefA: UIButton!
    @IBOutlet weak var btnRefB: UIButton!
    
    var btnAPosition = CGPointZero
    var btnBPosition = CGPointZero
    
    @IBAction func btnRefADrag(sender: UIButton) {
        
        btnAPosition = sender.frame.origin
        
        
    }
       //Toolbox Section
    @IBOutlet weak var toolboxView: UIView!
    
    
    @IBOutlet weak var moveView: UIImageView!
    
    override func viewDidAppear(animated: Bool)
    {

        var faceparams = CGRect()
        var lefteye = CGPointZero
        var righteye = CGPointZero
        
        
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
                }
                
                if face.hasRightEyePosition {
                    print("Found right eye at \(face.rightEyePosition)")
                    righteye = face.rightEyePosition
                }
            }
            
        }
        
        let helper = FunctionsHelper()
        
    
        
        
        
      
        let mt = MeasureTool.init(drawIn: mainView.layer, fillColor: UIColor.blackColor(), borderWidth: 1.0, borderColor: UIColor.redColor(), radius: 10, opacity: 1.0)
        mt.draw(faceparams,lefteye: lefteye, righteye: righteye)
    
        let topLine = mt.drawTopLine()
        let topLineView = UIImageView()
        topLineView.image = topLine
        topLineView.backgroundColor = UIColor.blackColor()
        
      
        
        if referencePointLeft == nil && referencePointRight == nil {
           
          referencePointLeft = helper.createDragButton("AppIcon-76", buttonTitle: "left", selector: Selector("imageDrag:withEvent:"), bounds: CGRectMake(0,0,150,150), frame: CGRectMake(100,500,150,150))
       
          referencePointRight = helper.createDragButton("AppIcon-76", buttonTitle: "right", selector: Selector("imageDrag:withEvent:"), bounds: CGRectMake(0,0,150,150), frame: CGRectMake(250,500,150,150))
        
            mainView.addSubview(referencePointLeft)
            mainView.addSubview(referencePointRight)
        }
        mainView.addSubview(topLineView)

    }
    
    var referencePointLeft = UIButton!()
    var referencePointRight = UIButton!()
    
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
    }

    
    override func viewDidLoad(){
        
        super.viewDidLoad()
    
        //Create Reference Points and add to our interface.
     
            }


    
    func grabItFromDirectory(findimage: String)->String{
    
        print(findimage);
        var imagePath = ""
        let fm = NSFileManager.defaultManager()
        let path = getSupportPath("images")  // applicationSupportdirectory + images
        let items = try! fm.contentsOfDirectoryAtPath(path)
        for item in items {
                if item.hasPrefix(findimage) {
                  imagePath = path + "/" + item + ".jpg"
                }
        }
    
        return imagePath
    }

    
}