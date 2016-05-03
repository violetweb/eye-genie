//
//  MeasurementController.swift
//  EyeGenie
//
//  Created by Valerie Trotter on 2016-04-21.
//  Copyright © 2016 Bceen Ventures. All rights reserved.
//


import UIKit

    
class MeasurementController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    
    let path = getSupportPath("images")
    let picker = UIImagePickerController();
    var pickedImage = UIImage();
    var imageViewName = UIImageView();
 
    @IBAction func launchCamera(sender: UIButton) {
       
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
    
    func processImage(image: UIImage){
        imageview.image = image;
        imageview.alpha = 1.0
        
    }
    
    
    @IBOutlet weak var MainView: UIView!
    @IBOutlet weak var imgA: UIImageView!
    @IBOutlet weak var imgB: UIImageView!
    @IBOutlet weak var imgC: UIImageView!
    @IBOutlet weak var imgD: UIImageView!
    
  
    
    func dblADetected() {
        
        imageview = imgA
        imgA.layer.borderWidth = 4.0
        imgA.layer.borderColor =  UIColor.blackColor().CGColor
        picker.allowsEditing = true
        picker.sourceType = .Camera
        self.presentViewController(picker, animated: true, completion: nil)

    }
    
    func dblBDetected() {
        
        imageview = imgB
        imgB.layer.borderWidth = 4.0
        imgB.layer.borderColor =  UIColor.blackColor().CGColor
        picker.allowsEditing = true
        picker.sourceType = .Camera
        self.presentViewController(picker, animated: true, completion: nil)
        
    }
    
    
    func dblCDetected() {
        
        imageview = imgC
        imgC.layer.borderWidth = 4.0
        imgC.layer.borderColor =  UIColor.blackColor().CGColor
        picker.allowsEditing = true
        picker.sourceType = .Camera
        self.presentViewController(picker, animated: true, completion: nil)
        
    }
    
    
    func dblDDetected() {
        
        imageview = imgD
        imgD.layer.borderWidth = 4.0
        imgD.layer.borderColor =  UIColor.blackColor().CGColor
        picker.allowsEditing = true
        picker.sourceType = .Camera
        self.presentViewController(picker, animated: true, completion: nil)
        
    }
    
    
    
    
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
            
        }else {
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
                    }
        
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
            
        }
        
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
            //measureViewController.selectedImageName.text = selectedGlasses
            measureViewController.selectedImageName.text = selectedGlasses
        }

        
    }
    
    func lngBDetected(){
        
        //Whatever image is here.. this one needs to be used for the measurement.
        pickedImage = imgB.image!
        
        if !CGSizeEqualToSize(pickedImage.size, CGSizeZero){
            selectedGlasses = "second-option"
            saveImage(pickedImage, path: path, filename: "second-option") //save image to our application directory.
            self.tabBarController?.selectedIndex = 1
            let measureViewController = self.tabBarController!.viewControllers![1] as! MeasureToolController // or whatever tab index you're trying to access
            measureViewController.selectedImage.image = UIImage(named: path + "/" + selectedGlasses)
            measureViewController.selectedImageName.text = selectedGlasses
        }
        
    }
    
    func lngCDetected(){
        
        //Whatever image is here.. this one needs to be used for the measurement.
        pickedImage = imgC.image!
        
        if !CGSizeEqualToSize(pickedImage.size, CGSizeZero){
            selectedGlasses = "third-option"
            saveImage(pickedImage, path: path, filename: "third-option") //save image to our application directory.
            self.tabBarController?.selectedIndex = 1
            let measureViewController = self.tabBarController!.viewControllers![1] as! MeasureToolController // or whatever tab index you're trying to access
            measureViewController.selectedImage.image = UIImage(named: path + "/" + selectedGlasses)
            measureViewController.selectedImageName.text = selectedGlasses
        }
        
    }
    
      
    func lngDDetected(){
        
        //Whatever image is here.. this one needs to be used for the measurement.
        pickedImage = imgD.image!
        let path = getSupportPath("images")
        
        if !CGSizeEqualToSize(pickedImage.size, CGSizeZero){
            selectedGlasses = "fourth-option"
            saveImage(pickedImage, path: path, filename: "fourth-option") //save image to our application directory.
            self.tabBarController?.selectedIndex = 1
            let measureViewController = self.tabBarController!.viewControllers![1] as! MeasureToolController // or whatever tab index you're trying to access
            measureViewController.selectedImage.image = UIImage(named: path + "/" + selectedGlasses)
            measureViewController.selectedImageName.text = selectedGlasses
        
        }
        
        
        
    }
    
        
    var ABounds = CGRect(), BBounds = CGRect(), CBounds = CGRect(), DBounds = CGRect()
    
    override func viewDidLoad(){
        
        super.viewDidLoad()
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
        imgA.addGestureRecognizer(sglImgATap)
        imgA.addGestureRecognizer(dblPressATap)
        imgA.addGestureRecognizer(lngPressATap)
        
        
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
        imgB.addGestureRecognizer(sglImgBTap)
        imgB.addGestureRecognizer(dblPressBTap)
        imgB.addGestureRecognizer(lngPressBTap)
        BBounds = imgB.frame
        
        
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
        
        imgC.addGestureRecognizer(sglImgCTap)
        imgC.addGestureRecognizer(dblPressCTap)
        imgC.addGestureRecognizer(lngPressCTap)
        
        CBounds = imgC.frame
        
        let sglImgDTap = UITapGestureRecognizer(target: self, action: Selector("sglDDetected"))
        let dblPressDTap = UITapGestureRecognizer(target: self, action: Selector("dblDDetected"))
        let lngPressDTap = UILongPressGestureRecognizer(target: self, action: Selector("lngDDetected"))
        lngPressDTap.minimumPressDuration = 0.40
        
        sglImgDTap.numberOfTapsRequired = 2
        dblPressDTap.numberOfTapsRequired = 1
        dblPressDTap.requireGestureRecognizerToFail(sglImgDTap)
        
        
        imgD.userInteractionEnabled = true
        imgD.alpha = 0.5
        imgD.contentMode = .ScaleAspectFit
        imgD.addGestureRecognizer(sglImgDTap)
        imgD.addGestureRecognizer(dblPressDTap)
        imgD.addGestureRecognizer(lngPressDTap)
        DBounds = imgD.frame
        
     
        //Grab the last set of first - fourth choice images (we're only going to hold onto them until next set is taken)
        imgA.image = UIImage(named: grabFromDirectory("first-option", ext: "jpg"))
        imgB.image = UIImage(named: grabFromDirectory("second-option", ext: "jpg"))
        imgC.image = UIImage(named: grabFromDirectory("third-option", ext: "jpg"))
        imgD.image = UIImage(named: grabFromDirectory("fourth-option", ext: "jpg"))
     
     
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
        
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return [UIInterfaceOrientationMask.LandscapeLeft,UIInterfaceOrientationMask.LandscapeRight]
    }
    

    
}