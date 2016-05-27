//
//  MeasurementController.swift
//  EyeGenie
//
//  Created by Valerie Trotter on 2016-04-21.
//  Copyright © 2016 Bceen Ventures. All rights reserved.
//


import UIKit

    
class MeasurementController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    
    @IBOutlet weak var imgInstructions: UIImageView!
    @IBOutlet weak var imgLongPress: UIImageView!
    @IBOutlet weak var imgSingleTap: UIImageView!
    
    let path = getSupportPath("images")
    let picker = UIImagePickerController();
    var pickedImage = UIImage();
    var imageViewName = UIImageView();
    
    @IBAction func launchCamera(sender: UIButton) {
       
        takePhoto()
    }
    
    func takePhoto(){
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
    
    var imageview: UIImageView!
    
    var lefteye = CGPointZero
    var righteye = CGPointZero
    let scale = CGFloat(2.18) // thinking bout leaving it large!
    
    
    func processImage(image: UIImage){
        
        
        var cropparams = CGRectZero
        
        let ciImage = CIImage(CGImage: image.CGImage!)
        let options = [CIDetectorAccuracy: CIDetectorAccuracyHigh, CIDetectorImageOrientation: 1]
        let faceDetector = CIDetector(ofType: CIDetectorTypeFace, context: nil, options: options as? [String : AnyObject])
        
        
        let faces = faceDetector.featuresInImage(ciImage)
        
        let ciContext = CIContext(options: nil)
        
        if let face = faces.first as? CIFaceFeature {
            
            let faceparams = face.bounds
          
            var mouth = CGPointZero
            var mouthheight = CGFloat(0)
            
            if face.hasLeftEyePosition {
                lefteye = CGPointMake(face.leftEyePosition.x/scale, face.leftEyePosition.y/scale)
                
            }
            
            if face.hasRightEyePosition {
                righteye = CGPointMake(face.rightEyePosition.x/scale, face.rightEyePosition.y/scale)
            }
            
            if face.hasMouthPosition {
                mouth = CGPointMake(face.mouthPosition.x, face.mouthPosition.y)
                mouthheight = face.mouthPosition.y - faceparams.origin.y
            }

            if (lefteye.x > 0 && righteye.x > 0){
                if (mouth.x>0){
                    cropparams = CGRectMake(faceparams.origin.x-200, faceparams.origin.y+mouthheight-200, faceparams.width+200, faceparams.height - mouthheight+200)
                }else{
                    cropparams = CGRectMake(faceparams.origin.x-100,faceparams.origin.y-100,faceparams.width+100,faceparams.height+100)
                }
            }
            let croppedimage = ciContext.createCGImage(ciImage, fromRect: cropparams)
            
            let finalimage = UIImage(CGImage: croppedimage)
      
            let originalsize = image.size
            
            
            UIGraphicsBeginImageContextWithOptions(CGSize(width: originalsize.width/scale, height:originalsize.height/scale), false, finalimage.scale)
            finalimage.drawInRect(CGRectMake(0,0,originalsize.width/scale, originalsize.height/scale))
            let thefinalimage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            
            imageview.image = thefinalimage
            imageview.alpha = 1.0


        }else{
            imageview.image = image
            imageview.alpha = 1.0
        }
        
        
    }
    
    func FlipForBottomOrigin(point: CGPoint, height: CGFloat)->CGPoint{
        return CGPointMake(point.x, height - point.y);
    }
    
    
    @IBOutlet weak var MainView: UIView!
    @IBOutlet weak var imgA: UIImageView!
    @IBOutlet weak var imgB: UIImageView!
    @IBOutlet weak var imgC: UIImageView!
    @IBOutlet weak var imgD: UIImageView!
    
  
    
    func dblADetected() {
        
        imageview = imgA
        takePhoto()
    }
    
    func dblBDetected() {
        
        imageview = imgB
        takePhoto()
        
    }
    
    
    func dblCDetected() {
        
        imageview = imgC
        takePhoto()
        
    }
    
    
    func dblDDetected() {
        
        imageview = imgD
        takePhoto()
        
    }
    
    
    
    //AS OF RIGHT NOW, SINGLE = DOUBLE, AND VICE VERSA (NAMING CONVENTION-WISE) SUCKS WHEN YOU SWITCH.
    
    
    
    func sglADetected(){
       
        imageview = imgA
        
        let basealpha = imgA.image != nil ? CGFloat(1.0) : CGFloat(0.5)
        
        
            if (imageview.frame.size == self.MainView.frame.size){
            
            UIView.animateWithDuration(1.0, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
                
                self.imageview.alpha = basealpha
                self.imgA.frame = self.ABounds
                self.imgB.frame = self.BBounds
                self.imgC.frame = self.CBounds
                self.imgD.frame = self.DBounds
                }, completion: nil)
            
            } else {
                
                if (imgA.image != nil){
                    

                    UIView.animateWithDuration(1.0, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
            
                self.imageview.alpha = 1.0
                self.imageview.frame = CGRect(x: self.imageview.frame.origin.x, y: self.imageview.frame.origin.y, width: self.MainView.frame.size.width, height: self.MainView.frame.size.height)
                self.imageview.bounds = self.MainView.bounds
                self.imgB.frame = self.BBounds
                self.imgC.frame = self.CBounds
                self.imgD.frame = self.DBounds
                self.imgA.layer.zPosition = 2
                self.imgB.layer.zPosition = 1
                self.imgC.layer.zPosition = 1
                self.imgD.layer.zPosition = 1
                }, completion:nil)
                }
        }
    }
    
    func sglBDetected(){
        
        imageview = imgB
       
        let basealpha = imgB.image != nil ? CGFloat(1.0) : CGFloat(0.5)
        
        
            
       
            if (imageview.frame.size == self.MainView.frame.size){
            
            UIView.animateWithDuration(1.0, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
                
                self.imageview.alpha = basealpha
                self.imgA.frame = self.ABounds
                self.imgB.frame = self.BBounds
                self.imgC.frame = self.CBounds
                self.imgD.frame = self.DBounds
                }, completion: nil)
            
            }else {
                if (imgB.image != nil){
                    UIView.animateWithDuration(1.0, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
                
                self.imageview.alpha = 1.0
                self.imageview.frame = CGRect(x: self.imageview.frame.origin.x-self.MainView.frame.size.width/2, y: self.imageview.frame.origin.y, width: self.MainView.frame.size.width, height: self.MainView.frame.size.height)
                
                self.imgA.frame = self.ABounds
                self.imgC.frame = self.CBounds
                self.imgD.frame = self.DBounds
                
                self.imgB.layer.zPosition = 2
                self.imgA.layer.zPosition = 1
                self.imgC.layer.zPosition = 1
                self.imgD.layer.zPosition = 1
                
                }, completion: nil)
                }        }
        
    }
    func sglCDetected(){
        
        imageview = imgC
        let basealpha = imgC.image != nil ? CGFloat(1.0) : CGFloat(0.5)
        MainView.bringSubviewToFront(imgC)
        
        
        if (imageview.frame.size == self.MainView.frame.size){
            
            UIView.animateWithDuration(1.0, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
                
                self.imageview.alpha = basealpha
                self.imgA.frame = self.ABounds
                self.imgB.frame = self.BBounds
                self.imgC.frame = self.CBounds
                self.imgD.frame = self.DBounds
                }, completion: nil)
            
        }else {
            if (imgC.image != nil){

                UIView.animateWithDuration(1.0, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
                
                    self.imageview.alpha = 1.0
                    self.imageview.frame = CGRect(x: self.imgC.frame.origin.x, y: self.imgC.frame.origin.y-self.MainView.frame.size.height/2, width: self.MainView.frame.size.width, height: self.MainView.frame.size.height)
                
                        self.imgA.frame = self.ABounds
                    self.imgB.frame = self.BBounds
                    self.imgD.frame = self.DBounds
                    self.imgA.layer.zPosition = 1
                    self.imgB.layer.zPosition = 1
                    self.imgC.layer.zPosition = 2
                    self.imgD.layer.zPosition = 1
                    }, completion: nil)
           
            }
        }
        
    }
    func sglDDetected(){
        
        imageview = imgD
     
        let basealpha = imgD.image != nil ? CGFloat(1.0) : CGFloat(0.5)
        
        
            if (imageview.frame.size == self.MainView.frame.size){
            
                UIView.animateWithDuration(1.0, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
                
                self.imageview.alpha = basealpha
                self.imgA.frame = self.ABounds
                self.imgB.frame = self.BBounds
                self.imgC.frame = self.CBounds
                self.imgD.frame = self.DBounds
                }, completion: nil)
            
            }else {
              
                if (imgD.image != nil){

                    UIView.animateWithDuration(1.0, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
                
                        self.imageview.alpha = 1.0
                        self.imageview.frame = CGRect(x: self.imgD.frame.origin.x-self.MainView.frame.size.width/2, y: self.imgD.frame.origin.y-self.MainView.frame.size.height/2, width: self.MainView.frame.size.width, height: self.MainView.frame.size.height)
                
                        self.imgA.frame = self.ABounds
                        self.imgB.frame = self.BBounds
                        self.imgC.frame = self.CBounds
                        self.imgA.layer.zPosition = 1
                        self.imgB.layer.zPosition = 1
                        self.imgC.layer.zPosition = 1
                        self.imgD.layer.zPosition = 2
                }, completion: nil)
                    
                }        }
        
    }
       
    func saveData(data: Order)->Bool{
        
        var success = false
        
        let documentsURL = NSFileManager.defaultManager().URLsForDirectory(.ApplicationSupportDirectory, inDomains: .UserDomainMask)[0]
        let databasePath = documentsURL.URLByAppendingPathComponent("genie.db").path!
        let genieDB = FMDatabase(path: String(databasePath))
        
        if genieDB.open() {
                
                let insertSQL = "INSERT INTO ORDERS (CLIENTID, SELECTEDGLASSES) VALUES ("+data.clientID+", "+data.selectedGlasses+")"
                let result = genieDB.executeUpdate(insertSQL,
                    withArgumentsInArray: nil)
                
                if !result {
                    print("Error: \(genieDB.lastErrorMessage())")
                }else{
                    print("inserted order")
                    success = true
                }
                genieDB.close()
         } else {
            print("Error: \(genieDB.lastErrorMessage())")
         }
        
        return success
        
    }
    
    var selectedGlasses = "";
    
    func lngADetected(){
        
        //Save the image to directory / save to variable / save to DB.
        pickedImage = imgA.image!
        
        if !CGSizeEqualToSize(pickedImage.size, CGSizeZero){
            selectedGlasses = "first-option"
            saveImage(pickedImage, path: path, filename: "first-option") //save image to our application directory.
            self.tabBarController?.selectedIndex = 1
            let measureViewController = self.tabBarController!.viewControllers![1] as! MeasureToolController // or whatever tab index you're trying to access
            measureViewController.selectedImage.image = UIImage(named: path + "/" + selectedGlasses)
            measureViewController.selectedImageName.text = selectedGlasses
            measureViewController.leftEyePosition = lefteye
            measureViewController.rightEyePosition = righteye
        }else{
            showTakePhotoAlert()
        
        }

        
    }
    
    func showTakePhotoAlert(){
        
        let alert = UIAlertController(title: "Take a photo?", message: "Long press detected on a panel with no image.  Tap once to take a photo.  Tap twice to Use the photo for Measurements.", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: { action in
            switch action.style{
            case .Default:
                print("default")
                
            case .Cancel:
                print("cancel")
                
            case .Destructive:
                print("destructive")
            }
        }))
    }
    
    func lngBDetected(){
        
        //Whatever image is here.. this one needs to be used for the measurement.
        
        if imgB.image != nil {
            pickedImage = imgB.image!
          //  print(pickedImage);
            if !CGSizeEqualToSize(pickedImage.size, CGSizeZero){
                selectedGlasses = "second-option"
                saveImage(pickedImage, path: path, filename: "second-option") //save image to our application directory.
                self.tabBarController?.selectedIndex = 1
                let measureViewController = self.tabBarController!.viewControllers![1] as! MeasureToolController // or whatever tab index you're trying to  access
                measureViewController.selectedImage.image = UIImage(named: path + "/" + selectedGlasses)
                measureViewController.selectedImageName.text = selectedGlasses
                measureViewController.leftEyePosition = lefteye
                measureViewController.rightEyePosition = righteye
            }
        } else{
                showTakePhotoAlert()
            
         
        }
        
    }
    
    func lngCDetected(){
        
        //Whatever image is here.. this one needs to be used for the measurement.
        
        if imgC.image != nil {
            pickedImage = imgC.image!
        
            if !CGSizeEqualToSize(pickedImage.size, CGSizeZero){
                selectedGlasses = "third-option"
                saveImage(pickedImage, path: path, filename: "third-option") //save image to our application directory.
                self.tabBarController?.selectedIndex = 1
                let measureViewController = self.tabBarController!.viewControllers![1] as! MeasureToolController // or whatever tab index you're trying to access
                    measureViewController.selectedImage.image = UIImage(named: path + "/" + selectedGlasses)
                measureViewController.selectedImageName.text = selectedGlasses
                measureViewController.leftEyePosition = lefteye
                measureViewController.rightEyePosition = righteye
            }
        } else{
          showTakePhotoAlert()
                
        }
        
    }
    
      
    func lngDDetected(){
        
        //Whatever image is here.. this one needs to be used for the measurement.
        
        if (imgD.image != nil){
            pickedImage = imgD.image!
        
            if !CGSizeEqualToSize(pickedImage.size, CGSizeZero){
                selectedGlasses = "fourth-option"
                saveImage(pickedImage, path: path, filename: "fourth-option") //save image to our application directory.
                self.tabBarController?.selectedIndex = 1
                let measureViewController = self.tabBarController!.viewControllers![1] as! MeasureToolController // or whatever tab index you're trying to access
                measureViewController.selectedImage.image = UIImage(named: path + "/" + selectedGlasses)
                measureViewController.selectedImageName.text = selectedGlasses
                measureViewController.leftEyePosition = lefteye
                measureViewController.rightEyePosition = righteye
            }
        }else{
            showTakePhotoAlert()
            
        }
        

        
        
        
    }
    
    func resizeImage(image: UIImage, convertToSize: CGSize)->UIImage {
    
        UIGraphicsBeginImageContext(convertToSize)
        image.drawInRect(CGRectMake(0,0, convertToSize.width, convertToSize.height))
        return UIGraphicsGetImageFromCurrentImageContext()
        
    }
    
    func cropImage(image: UIImage, cropCoords: CGRect, convertToSize: CGSize)->UIImage{
        
        
     //   CGRect biggerRectangle = CGRectInset(faceFeature.bounds, someNegativeCGFloatToIncreaseSizeForXAxis, someNegativeCGFloatToIncreaseSizeForYAxis);
     //   CGImageRef imageRef = CGImageCreateWithImageInRect([staticBG.image CGImage], biggerRectangle);
        
        UIGraphicsBeginImageContextWithOptions(CGSize(width:1024,height:768), false, image.scale)
        image.drawInRect(CGRectMake(0,0,1024,768))
        
      
        //image.drawAtPoint(CGPointMake(-cropCoords.origin.x, -cropCoords.origin.y))
        let croppedimage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return croppedimage
        
    
    }
        
    var ABounds = CGRect(), BBounds = CGRect(), CBounds = CGRect(), DBounds = CGRect()
    
    //Grab the last set of first - fourth choice images (we're only going to hold onto them until next set is taken)
    let firstoption = grabFromDirectory("first-option", ext: ".jpg")
    let secondoption = grabFromDirectory("second-option", ext: ".jpg")
    let thirdoption = grabFromDirectory("third-option", ext: ".jpg")
    let fourthoption = grabFromDirectory("fourth-option", ext: ".jpg")
  
    
    
    override func viewDidAppear(animated: Bool) {
        
       }
    
    @IBOutlet weak var instructionView: UIView!
    
    
    override func viewDidLoad(){
        
        super.viewDidLoad()
        
        let view = UIView.appearance()
        view.tintColor = UIColor(red:0.80, green:0.00, blue:0.20, alpha:1.0)
        
        instructionView.hidden = false
        instructionView.layer.zPosition = 3
        
        picker.delegate = self;
        
        
        
        //Save frame initial sizing ( used by animation to return to its original size)
        ABounds = imgA.frame
        BBounds = imgB.frame
        CBounds = imgC.frame
        DBounds = imgD.frame

        
         //set up tap events.
        let sglImgATap = UITapGestureRecognizer(target: self, action: Selector("sglADetected"))
        let dblPressATap = UITapGestureRecognizer(target: self, action: Selector("dblADetected"))
        let lngPressATap = UILongPressGestureRecognizer(target: self, action: Selector("lngADetected"))
        lngPressATap.minimumPressDuration = 0.40
        dblPressATap.numberOfTapsRequired = 1
        sglImgATap.numberOfTapsRequired = 2
        dblPressATap.requireGestureRecognizerToFail(sglImgATap)
        
        
        
        imgA.userInteractionEnabled = true
        imgA.alpha = 0.5
        imgA.contentMode = .ScaleAspectFill
        imgA.bounds = CGRectMake(0,0,490,310)
        imgA.layer.masksToBounds = true
        
        imgA.addGestureRecognizer(sglImgATap)
        imgA.addGestureRecognizer(dblPressATap)
        imgA.addGestureRecognizer(lngPressATap)

        
        if firstoption != "" {
            imgA.image = UIImage(named: firstoption)
            
        }else {
            imgA.image = UIImage(named: "snapshot-default")
        }
        
        
            imgB.image = UIImage(named: secondoption)
            let sglImgBTap = UITapGestureRecognizer(target: self, action: Selector("sglBDetected"))
            let dblPressBTap = UITapGestureRecognizer(target: self, action: Selector("dblBDetected"))
            let lngPressBTap = UILongPressGestureRecognizer(target: self, action: Selector("lngBDetected"))
            lngPressBTap.minimumPressDuration = 0.40
            
            sglImgBTap.numberOfTapsRequired = 2
            dblPressBTap.numberOfTapsRequired = 1
            dblPressBTap.requireGestureRecognizerToFail(sglImgBTap)
            
            imgB.userInteractionEnabled = true
            imgB.alpha = 0.5
            imgB.contentMode = .ScaleAspectFill
            imgB.bounds = CGRectMake(0,0,490,310)
            imgB.layer.masksToBounds = true

            imgB.addGestureRecognizer(sglImgBTap)
            imgB.addGestureRecognizer(dblPressBTap)
            imgB.addGestureRecognizer(lngPressBTap)
            BBounds = imgB.frame
            
       
            imgC.image = UIImage(named: thirdoption)
            let sglImgCTap = UITapGestureRecognizer(target: self, action: Selector("sglCDetected"))
            let dblPressCTap = UITapGestureRecognizer(target: self, action: Selector("dblCDetected"))
            let lngPressCTap = UILongPressGestureRecognizer(target: self, action: Selector("lngCDetected"))
            lngPressCTap.minimumPressDuration = 0.40
            
            sglImgCTap.numberOfTapsRequired = 2
            dblPressCTap.numberOfTapsRequired = 1
            dblPressCTap.requireGestureRecognizerToFail(sglImgCTap)
            
            imgC.userInteractionEnabled = true
            imgC.alpha = 0.5
            imgC.contentMode = .ScaleAspectFill
            imgC.bounds = CGRectMake(0,0,490,310)
            imgC.layer.masksToBounds = true

            imgC.addGestureRecognizer(sglImgCTap)
            imgC.addGestureRecognizer(dblPressCTap)
            imgC.addGestureRecognizer(lngPressCTap)
            
            CBounds = imgC.frame
            
    
            
            imgD.image = UIImage(named: fourthoption)
            
            let sglImgDTap = UITapGestureRecognizer(target: self, action: Selector("sglDDetected"))
            let dblPressDTap = UITapGestureRecognizer(target: self, action: Selector("dblDDetected"))
            let lngPressDTap = UILongPressGestureRecognizer(target: self, action: Selector("lngDDetected"))
            lngPressDTap.minimumPressDuration = 0.40
            
            sglImgDTap.numberOfTapsRequired = 2
            dblPressDTap.numberOfTapsRequired = 1
            dblPressDTap.requireGestureRecognizerToFail(sglImgDTap)
            
            
            imgD.userInteractionEnabled = true
            imgD.alpha = 0.5
            imgD.contentMode = .ScaleAspectFill
            imgD.bounds = CGRectMake(0,0,490,310)
            imgD.layer.masksToBounds = true

            imgD.addGestureRecognizer(sglImgDTap)
            imgD.addGestureRecognizer(dblPressDTap)
            imgD.addGestureRecognizer(lngPressDTap)
            DBounds = imgD.frame
            
    
        

        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
        
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return [UIInterfaceOrientationMask.LandscapeLeft,UIInterfaceOrientationMask.LandscapeRight]
    }
    

    
}