//
//  ViewController.swift
//  Eye-Genie
//
//  Created by Ryan Maxwell on 2015-12-01.
//  Copyright © 2015 Bceen Ventures. All rights reserved.
//

import UIKit
import GLKit


class ViewController: UIViewController,  iCarouselDataSource, iCarouselDelegate{

   
    
    @IBOutlet weak var lblPower: UILabel!
    @IBOutlet weak var lblAdd: UILabel!
    @IBOutlet weak var lblCoating: UILabel!
    @IBOutlet weak var lblHydro: UILabel!
    @IBOutlet weak var lblHardCoat: UILabel!
    @IBOutlet weak var lblPhotochrom: UILabel!
    
    
    
    let imgPilots = UIImage(named: "cockpit-n")
    let imgPilotsVib = UIImage(named: "cockpit-v")
    let imgPilotsBlur = UIImage(named: "cockpit-b")
    let imgSail = UIImage(named: "sailing")
    let imgAutumn = UIImage(named: "autumn")
    var currentBackground = UIImage(named: "cockpit-v")
    
    var currentBackgroundImageName = "cockpit" // append an n = desaturated (for mainlayer), or v = vibrant image (for imageLayer)
    var currentAdd = UIImageView()
    var lensLayer = CALayer()
    
    
    var leftBlurLayer = CAShapeLayer()
    var rightBlurLayer = CAShapeLayer()
    
    var BlurShapelayer = CAShapeLayer()
    
    var lensShapelayer = CAShapeLayer()
    var magnifyLayer = CAShapeLayer()
    var colorLayer = CAShapeLayer()
    var cutStroke = CAShapeLayer()
    var leftLayer = CAShapeLayer()
    var rightLayer = CAShapeLayer()
    var leftMask =  CAShapeLayer()
    var rightMask = CAShapeLayer()
    var existingMask = CAShapeLayer().mask
    var imageLayer = CAShapeLayer()
    var reflectionLayer = CAShapeLayer()
    var hardcoatLayer = CAShapeLayer()
    var hydroLayer = CAShapeLayer()
    var photochromLayer = CAShapeLayer()
    
    var blurRadius: Float = 0
    var context: CIContext!
    var addSlider: Float = 0
    var currentPath = "Conventional"
    var lastSavedLocation = CGPointZero
    var lastSavedImgLocation = CGPointZero
    var lastSavedBlurLocation = CGPointZero
    var lastSavedRightBlurLocation = CGPointZero
    var lastMagnifyLocation = CGPointZero
    
    var timer = NSTimer()
    
    var pilotsLayer: CALayer {
        return mainImageView.layer
    }
    
    
    
    func LogoutTimed(){
        performSegueWithIdentifier("LogoutSegue", sender: timer)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        
        let interval = Double(28800) // eight hours check it...
        timer = NSTimer.scheduledTimerWithTimeInterval(interval, target:self, selector: Selector("LogoutTimed"), userInfo: nil, repeats: true)
       
      
        self.lastSavedLocation = lensShapelayer.position  // Works with panGesture... track the last position.
        self.lastSavedImgLocation = imageLayer.mask!.position
        
        
        if (sliderAddOutlet.value > 0.0){
            self.lastSavedBlurLocation = leftBlurLayer.mask!.position
            self.lastSavedRightBlurLocation = rightBlurLayer.mask!.position
            self.lastMagnifyLocation = magnifyLayer.mask!.position
        }else{
           // self.lastSavedBlurLocation = CGPointZero
          //  self.lastSavedRightBlurLocation = CGPointZero
            //self.lastMagnifyLocation = CGPointZero
        }

    
        
    }
  
    
    //As workaround, could not allow pan if sliderAddOutvalue is greater than zero, or
    // Reset to zero on touchesBegan??
    
    
    @IBAction func panGesture(sender: UIPanGestureRecognizer) {
     
      
        
        let newTranslation = sender.translationInView(mainImageView)
        
        
        if (sender.state == UIGestureRecognizerState.Changed){
          
            
            lensShapelayer.position = CGPointMake(self.lastSavedLocation.x + newTranslation.x , self.lastSavedLocation.y + newTranslation.y)
            imageLayer.mask!.position = CGPointMake(self.lastSavedImgLocation.x + newTranslation.x , self.lastSavedImgLocation.y + newTranslation.y)
        
        
            if (sliderAddOutlet.value > 0.0){
            
            
                leftBlurLayer.mask!.position = CGPointMake(self.lastSavedBlurLocation.x + newTranslation.x, self.lastSavedBlurLocation.y + newTranslation.y)
                rightBlurLayer.mask!.position = CGPointMake(self.lastSavedRightBlurLocation.x + newTranslation.x, self.lastSavedRightBlurLocation.y + newTranslation.y)
                magnifyLayer.mask!.position = CGPointMake(self.lastMagnifyLocation.x + newTranslation.x, self.lastMagnifyLocation.y + newTranslation.y)
                
            }

        
        } else if (sender.state == UIGestureRecognizerState.Ended){
            
            
            self.magnifyLayer.removeFromSuperlayer()
            self.leftBlurLayer.removeFromSuperlayer()
            self.rightBlurLayer.removeFromSuperlayer()
            
            
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), {
                
                
                self.swapLensImage(self.blurRadius, swapToImage: self.currentBackgroundImageName)
                
                dispatch_async(dispatch_get_main_queue(), { // 2
                   
                    
                    self.swapLensImage(self.blurRadius, swapToImage: self.currentBackgroundImageName)
                    


                });
            });

                    }
        
    }
    
    
    
    @IBAction func pinchGesture(sender: UIPinchGestureRecognizer) {
        
        let translate = CATransform3DMakeTranslation(0, 0, 0);
        let scale = CATransform3DMakeScale(sender.scale, sender.scale, 1);
        let transform = CATransform3DConcat(translate, scale);
        
        magScale = Float(sender.scale)
        
        lensShapelayer.transform = transform
        let newTranslation = sender.locationInView(mainImageView)
       
        imageLayer.mask!.frame = lensShapelayer.frame // Match the same frame as the outer layer
        imageLayer.mask!.transform = transform
        
        leftBlurLayer.mask?.frame = lensShapelayer.frame
        rightBlurLayer.mask?.frame = lensShapelayer.frame
        leftBlurLayer.mask?.transform = transform
        rightBlurLayer.mask?.transform = transform
                   
        magnifyLayer.mask?.frame = lensShapelayer.frame
        magnifyLayer.mask?.transform = transform
    }
    
    
    
    
    @IBOutlet weak var mainImageView: UIView!
    
    @IBAction func btnConventional(sender: UIButton) {
        
        
        leftLayer.removeFromSuperlayer()
        let newLeftLayer = CAShapeLayer()
        //newLeftLayer.path = drawStrokePath(180, x: -80, y: 400, radius: 480)
        newLeftLayer.path = drawShapePath(1,reverse: false)
        newLeftLayer.zPosition = 6
        newLeftLayer.strokeColor = UIColor.yellowColor().CGColor
        newLeftLayer.fillColor = UIColor.clearColor().CGColor;
        newLeftLayer.lineWidth = 8.0
        leftLayer = newLeftLayer
        lensShapelayer.addSublayer(leftLayer)
        
        
        
        rightLayer.removeFromSuperlayer()
        let newRightLayer = CAShapeLayer()
        newRightLayer.path = drawShapeMirrorPath(1, reverse: false)
        newRightLayer.zPosition = 6
        newRightLayer.strokeColor = UIColor.yellowColor().CGColor
        newRightLayer.fillColor = UIColor.clearColor().CGColor;
        newRightLayer.lineWidth = 8.0
        rightLayer = newRightLayer
        lensShapelayer.addSublayer(rightLayer)
        
        
        leftMask.path = drawShapePath(1, reverse: false)
        rightMask.path = drawShapeMirrorPath(1, reverse:false)
        
        let blurRadius = Float(sliderPowerOutlet.value)
     //  (Float(blurRadius),swapToImage: currentBackground!)
        Button2.fadeOut()
        Button3.fadeOut()
        Button4.fadeOut()
        sender.fadeIn()
    }
    
   
    @IBOutlet weak var switchAntiReflection: UISwitch!
    @IBOutlet weak var switchHydrophop: UISwitch!
    @IBOutlet weak var switchHardCoat: UISwitch!
    
    
    func getARCoating()->String {
        let databasePath = getSupportPath("genie.db") // grab the database.
        let genieDB = FMDatabase(path: String(databasePath))
        var imagename = "ar-coating-1" // name for default image (always return something)
        if genieDB.open() {
            let querySQL = "SELECT ARCOATINGIMAGE FROM GENERAL WHERE id=1"
            let results:FMResultSet? = genieDB.executeQuery(querySQL, withArgumentsInArray: nil)
            if results?.next() == true {
                imagename = (results?.stringForColumn("ARCOATINGIMAGE")!)!
            } else {
                print("Records not found in database for 'General Settings'.")
            }
            genieDB.close()
        }
        return imagename
    }

    func getHydro()->String {
        let databasePath = getSupportPath("genie.db") // grab the database.
        let genieDB = FMDatabase(path: String(databasePath))
        var imagename = "hydro-1" // name for default image (always return something)
        if genieDB.open() {
            let querySQL = "SELECT HYDROIMAGE FROM GENERAL WHERE id=1"
            let results:FMResultSet? = genieDB.executeQuery(querySQL, withArgumentsInArray: nil)
            if results?.next() == true {
                imagename = (results?.stringForColumn("HYDROIMAGE")!)!
            } else {
                print("Records not found in database for 'General Settings'.")
            }
            genieDB.close()
        }
        return imagename
    }
    
    func getHardcoat()->String {
        let databasePath = getSupportPath("genie.db") // grab the database.
        let genieDB = FMDatabase(path: String(databasePath))
        var imagename = "hardcoat-1" // name for default image (always return something)
        if genieDB.open() {
            let querySQL = "SELECT HARDCOATIMAGE FROM GENERAL WHERE id=1"
            let results:FMResultSet? = genieDB.executeQuery(querySQL, withArgumentsInArray: nil)
            if results?.next() == true {
                imagename = (results?.stringForColumn("HARDCOATIMAGE")!)!
            } else {
                print("Records not found in database for 'General Settings'.")
            }
            genieDB.close()
        }
        return imagename
    }


    
    @IBAction func btnAntiReflectionCoating(sender: UISwitch) {
       
        if self.switchAntiReflection.on {
            
            self.switchAntiReflection.setOn(true, animated: true)
            reflectionLayer.removeFromSuperlayer()

        } else {
            reflectionLayer.mask = drawMaskLayer(UIColor.whiteColor().CGColor)
            reflectionLayer.fillColor = UIColor.whiteColor().CGColor
            reflectionLayer.fillRule = kCAFillRuleNonZero
            reflectionLayer.zPosition = 9
            reflectionLayer.backgroundColor = UIColor.whiteColor().CGColor
            //Background Image has its own layer now.
            
            //Lookup AR coating image to use.
            
            let img = UIImageView(image: UIImage(named: getARCoating()))
            reflectionLayer.addSublayer(img.layer)
            reflectionLayer.opacity = 0.5
            lensShapelayer.addSublayer(reflectionLayer)
            self.switchAntiReflection.setOn(false, animated: true)

            
        }
        
        
    }
    
    @IBAction func btnHydrophop(sender: UISwitch) {
        
        if self.switchHydrophop.on {
            
            self.switchHydrophop.setOn(true, animated: true)
            hydroLayer.removeFromSuperlayer()
            
            
        } else {
            hydroLayer.mask = drawMaskLayer(UIColor.brownColor().CGColor)
            hydroLayer.fillColor = UIColor.clearColor().CGColor
            hydroLayer.fillRule = kCAFillRuleNonZero
            hydroLayer.zPosition = 9
            
            //Background Image has its own layer now.
            let imagename = getHydro()
            let img = UIImageView(image: UIImage(named: imagename))
            hydroLayer.addSublayer(img.layer)
            hydroLayer.opacity = 1.0
            lensShapelayer.addSublayer(hydroLayer)
            self.switchHydrophop.setOn(false, animated: true)
            
            
        }

        
    }
    
    @IBAction func btnHardCoating(sender: UISwitch) {
        
        
        if self.switchHardCoat.on {
            
            self.switchHardCoat.setOn(true, animated: false)
            hardcoatLayer.removeFromSuperlayer()
            
            
        } else {
            hardcoatLayer.mask = drawMaskLayer(UIColor.clearColor().CGColor)
            hardcoatLayer.fillColor = UIColor.clearColor().CGColor
            hardcoatLayer.fillRule = kCAFillRuleNonZero
            hardcoatLayer.zPosition = 9
            
            //Background Image has its own layer now.
            let imagename = getHardcoat()
            let img = UIImageView(image: UIImage(named: imagename))
            hardcoatLayer.addSublayer(img.layer)
            hardcoatLayer.opacity = 1.0
            lensShapelayer.addSublayer(hardcoatLayer)
            self.switchHardCoat.setOn(false, animated: true)
            
            
        }

        
    }
    
    
   
    
    
    @IBOutlet weak var switchPhotochrom: UISwitch!
    
    
    @IBAction func btnPhotochrom(sender: UISwitch) {
        
        
        if self.switchPhotochrom.on{
            
            self.switchPhotochrom.setOn(true, animated: true)
            
            //Change the background image to the Bright one.
            drawBackgroundLayer(blurRadius, imageName: "photochrom", savebg: false)
            imageLayer.removeFromSuperlayer()
            
            //remove the other layers if they are on and deactivate their switches.
            hardcoatLayer.removeFromSuperlayer()
            hydroLayer.removeFromSuperlayer()
            reflectionLayer.removeFromSuperlayer()
            switchAntiReflection.setOn(false, animated: false)
            switchHardCoat.setOn(false,animated: false)
            switchHydrophop.setOn(false,animated: false) //51, 25, 0
            
            //apply the photochrom layer
            photochromLayer = drawMaskLayer(UIColor.whiteColor().CGColor)
            photochromLayer.fillColor = UIColor(hexString: "#3c2f2fff")!.CGColor
            photochromLayer.fillRule = kCAFillRuleNonZero
            photochromLayer.zPosition = 9
            photochromLayer.opacity = 0.5
            lensShapelayer.addSublayer(photochromLayer)
            
            
        }else{
            
          
          drawBackgroundLayer(blurRadius, imageName: currentBackgroundImageName, savebg: true)
          currentAdd.image = UIImage(named: currentBackgroundImageName + "-v")
          imageLayer.addSublayer(currentAdd.layer)
          photochromLayer.removeFromSuperlayer()
          self.switchPhotochrom.setOn(false, animated: true)
          switchAntiReflection.setOn(true, animated: false)
          switchHardCoat.setOn(true,animated: false)
          switchHydrophop.setOn(true,animated: false)

          pilotsLayer.addSublayer(imageLayer)

        }
        
        
    }
    @IBAction func btnJena(sender: UIButton) {
        
       
        leftLayer.removeFromSuperlayer()
        let newLeftLayer = CAShapeLayer()
        newLeftLayer.path = drawShapePath(2, reverse: false)
        newLeftLayer.zPosition = 6
        newLeftLayer.strokeColor = UIColor.yellowColor().CGColor
        newLeftLayer.fillColor = UIColor.clearColor().CGColor;
        newLeftLayer.lineWidth = 8.0
        leftLayer = newLeftLayer
        lensShapelayer.addSublayer(leftLayer)
        
        
        
        rightLayer.removeFromSuperlayer()
        let newRightLayer = CAShapeLayer()
        newRightLayer.path = drawShapeMirrorPath(2, reverse: false)
        newRightLayer.zPosition = 6
        newRightLayer.strokeColor = UIColor.yellowColor().CGColor
        newRightLayer.fillColor = UIColor.clearColor().CGColor;
        newRightLayer.lineWidth = 8.0
        rightLayer = newRightLayer
        lensShapelayer.addSublayer(rightLayer)
        
        
        leftMask.path = drawShapePath(2, reverse:false)
        rightMask.path = drawShapeMirrorPath(2, reverse:false)

        Button1.fadeOut()
        Button3.fadeOut()
        Button4.fadeOut()
        sender.fadeIn()
    }
    
    
    @IBAction func btnJenaW(sender: UIButton) {
        
        
        leftLayer.removeFromSuperlayer()
        let newLeftLayer = CAShapeLayer()
        newLeftLayer.path = drawShapePath(3, reverse: false)
        newLeftLayer.zPosition = 6
        newLeftLayer.strokeColor = UIColor.yellowColor().CGColor
        newLeftLayer.fillColor = UIColor.clearColor().CGColor;
        newLeftLayer.lineWidth = 8.0
        leftLayer = newLeftLayer
        lensShapelayer.addSublayer(leftLayer)
        
        
        
        rightLayer.removeFromSuperlayer()
        let newRightLayer = CAShapeLayer()
        newRightLayer.path = drawShapeMirrorPath(3, reverse:false)
        newRightLayer.zPosition = 6
        newRightLayer.strokeColor = UIColor.yellowColor().CGColor
        newRightLayer.fillColor = UIColor.clearColor().CGColor
        newRightLayer.lineWidth = 8.0
        rightLayer = newRightLayer
        lensShapelayer.addSublayer(rightLayer)
        
        
        leftMask.path = drawShapePath(3, reverse:false)
        rightMask.path = drawShapeMirrorPath(3, reverse:false)
        
        currentPath = "JennaW"
      
        Button1.fadeOut()
        Button2.fadeOut()
        Button4.fadeOut()
        sender.fadeIn()
    }
    
    
    @IBAction func btnJena4k(sender: UIButton) {
        
        leftLayer.removeFromSuperlayer()
        let newLeftLayer = CAShapeLayer()
        newLeftLayer.path = drawShapePath(4, reverse: false)
        newLeftLayer.zPosition = 6
        newLeftLayer.strokeColor = UIColor.yellowColor().CGColor
        newLeftLayer.fillColor = UIColor.clearColor().CGColor;
        newLeftLayer.lineWidth = 8.0
        leftLayer = newLeftLayer
        lensShapelayer.addSublayer(leftLayer)
        
        
        
        rightLayer.removeFromSuperlayer()
        let newRightLayer = CAShapeLayer()
        newRightLayer.path = drawShapeMirrorPath(4, reverse:false)
        newRightLayer.zPosition = 6
        newRightLayer.strokeColor = UIColor.yellowColor().CGColor
        newRightLayer.fillColor = UIColor.clearColor().CGColor
        newRightLayer.lineWidth = 8.0
        rightLayer = newRightLayer
        lensShapelayer.addSublayer(rightLayer)
        
        
        leftMask.path = drawShapePath(4, reverse:false)
        rightMask.path = drawShapeMirrorPath(4, reverse:false)
        currentPath = "Jenna4K"
      
        Button1.fadeOut()
        Button2.fadeOut()
        Button3.fadeOut()
        sender.fadeIn()
        
    }
    
    
    
    
    @IBAction func sliderAdd(sender: UISlider) {
      
        blurRadius = sender.value
        swapLensImage(Float(blurRadius),swapToImage: currentBackgroundImageName)

    }
    
    @IBAction func sliderPower(sender: UISlider) {
        let blurRadius = sender.value // don't save this blurradisu globally...
        drawBackgroundLayer(blurRadius, imageName: currentBackgroundImageName, savebg: true)
       
    }
 
    
 
    @IBOutlet weak var sliderAddOutlet: UISlider!
    
    @IBOutlet weak var sliderPowerOutlet: UISlider!
    /*
    @IBAction func btnTakingPhoto(sender: UIBarButtonItem) {
        
        drawBackgroundLayer(Float(sliderPowerOutlet.value), imageName: "takingphoto", savebg: true)
        currentBackgroundImageName = "takingphoto"
        currentAdd.image = UIImage(named: currentBackgroundImageName + "-v")
        swapLensImage(blurRadius, swapToImage: currentBackgroundImageName)
        if switchPhotochrom.on {
            switchPhotochrom.setOn(false, animated: false)
             photochromLayer.removeFromSuperlayer()
        }

        
    }
    @IBAction func btnPhone(sender: UIBarButtonItem) {
        
        drawBackgroundLayer(Float(sliderPowerOutlet.value), imageName: "phone", savebg: true)
        currentBackgroundImageName = "phone"
        currentAdd.image = UIImage(named: currentBackgroundImageName + "-v")
        swapLensImage(blurRadius, swapToImage: currentBackgroundImageName)
        if switchPhotochrom.on {
            switchPhotochrom.setOn(false, animated: false)
             photochromLayer.removeFromSuperlayer()
        }

        
    }
    @IBAction func btnHotel(sender: UIBarButtonItem) {
        
        
        drawBackgroundLayer(Float(sliderPowerOutlet.value), imageName: "office", savebg: true)
        currentBackgroundImageName = "office"
        currentAdd.image = UIImage(named: currentBackgroundImageName + "-v")
        swapLensImage(blurRadius, swapToImage: currentBackgroundImageName)
        if switchPhotochrom.on {
            switchPhotochrom.setOn(false, animated: false)
             photochromLayer.removeFromSuperlayer()
        }

    }
    
    @IBAction func btnOffice(sender: UIBarButtonItem) {
        
        
        drawBackgroundLayer(Float(sliderPowerOutlet.value), imageName: "office3", savebg: true)
        currentBackgroundImageName = "office3"
        currentAdd.image = UIImage(named: currentBackgroundImageName + "-v")
        swapLensImage(blurRadius, swapToImage: currentBackgroundImageName)
        if switchPhotochrom.on {
            switchPhotochrom.setOn(false, animated: false)
            //Remove the photochrom layer
            photochromLayer.removeFromSuperlayer()
        }

    }
    */
    
    func btnTakingPhoto() {
        
        drawBackgroundLayer(Float(sliderPowerOutlet.value), imageName: "takingphoto", savebg: true)
        currentBackgroundImageName = "takingphoto"
        currentAdd.image = UIImage(named: currentBackgroundImageName + "-v")
        swapLensImage(blurRadius, swapToImage: currentBackgroundImageName)
        if switchPhotochrom.on {
            switchPhotochrom.setOn(false, animated: false)
            photochromLayer.removeFromSuperlayer()
        }
        
        
    }

    func btnPhone() {
        
        drawBackgroundLayer(Float(sliderPowerOutlet.value), imageName: "phone", savebg: true)
        currentBackgroundImageName = "phone"
        currentAdd.image = UIImage(named: currentBackgroundImageName + "-v")
        swapLensImage(blurRadius, swapToImage: currentBackgroundImageName)
        if switchPhotochrom.on {
            switchPhotochrom.setOn(false, animated: false)
            photochromLayer.removeFromSuperlayer()
        }
        
        
    }

    
    func btnOffice() {
        
        
        drawBackgroundLayer(Float(sliderPowerOutlet.value), imageName: "office3", savebg: true)
        currentBackgroundImageName = "office3"
        currentAdd.image = UIImage(named: currentBackgroundImageName + "-v")
        swapLensImage(blurRadius, swapToImage: currentBackgroundImageName)
        if switchPhotochrom.on {
            switchPhotochrom.setOn(false, animated: false)
            //Remove the photochrom layer
            photochromLayer.removeFromSuperlayer()
        }
        
    }
    func btnHotel() {
        
        
        drawBackgroundLayer(Float(sliderPowerOutlet.value), imageName: "office", savebg: true)
        currentBackgroundImageName = "office"
        currentAdd.image = UIImage(named: currentBackgroundImageName + "-v")
        swapLensImage(blurRadius, swapToImage: currentBackgroundImageName)
        if switchPhotochrom.on {
            switchPhotochrom.setOn(false, animated: false)
            photochromLayer.removeFromSuperlayer()
        }
        
    }
    func btnCockpit() {
        
        
        drawBackgroundLayer(Float(sliderPowerOutlet.value), imageName: "cockpit", savebg: true)
        currentBackgroundImageName = "cockpit"
        currentAdd.image = UIImage(named: currentBackgroundImageName + "-v")
        swapLensImage(blurRadius, swapToImage: currentBackgroundImageName)
        if switchPhotochrom.on {
            switchPhotochrom.setOn(false, animated: false)
            photochromLayer.removeFromSuperlayer()
        }
    }

    func btnDesktop() {
        
        drawBackgroundLayer(Float(sliderPowerOutlet.value), imageName: "office2", savebg: true)
        currentBackgroundImageName = "office2"
        currentAdd.image = UIImage(named: currentBackgroundImageName + "-v")
        swapLensImage(blurRadius, swapToImage: currentBackgroundImageName)
        if switchPhotochrom.on {
            switchPhotochrom.setOn(false, animated: false)
            photochromLayer.removeFromSuperlayer()
        }
        
        
    }
    func btnAutumn() {
    
    
        drawBackgroundLayer(Float(sliderPowerOutlet.value), imageName: "autumn", savebg: true)
        currentBackgroundImageName = "autumn"
        currentAdd.image = UIImage(named: currentBackgroundImageName + "-v")
        ///imageLayer.addSublayer(currentAdd.layer)
        swapLensImage(blurRadius, swapToImage: currentBackgroundImageName)
        if switchPhotochrom.on {
            switchPhotochrom.setOn(false, animated: false)
    
        }
    }
    
    func btnSailing() {
        
        drawBackgroundLayer(Float(sliderPowerOutlet.value), imageName: "sailing", savebg: true)
        currentBackgroundImageName = "sailing"
        currentAdd.image = UIImage(named: currentBackgroundImageName + "-v")
        // imageLayer.addSublayer(currentAdd.layer)
        swapLensImage(blurRadius, swapToImage: currentBackgroundImageName)
        
        if switchPhotochrom.on {
            switchPhotochrom.setOn(false, animated: false)
            photochromLayer.removeFromSuperlayer()
        }
        
        
        
    }


  /*
    @IBAction func btnDesktop(sender: UIBarButtonItem) {
        
        drawBackgroundLayer(Float(sliderPowerOutlet.value), imageName: "office2", savebg: true)
        currentBackgroundImageName = "office2"
        currentAdd.image = UIImage(named: currentBackgroundImageName + "-v")
        swapLensImage(blurRadius, swapToImage: currentBackgroundImageName)
        if switchPhotochrom.on {
            switchPhotochrom.setOn(false, animated: false)
             photochromLayer.removeFromSuperlayer()
        }

        
    }
    
    */
    
  
    
    @IBAction func btnCockpit(sender: UIBarButtonItem) {
        
        
              drawBackgroundLayer(Float(sliderPowerOutlet.value), imageName: "cockpit", savebg: true)
        currentBackgroundImageName = "cockpit"
        currentAdd.image = UIImage(named: currentBackgroundImageName + "-v")
        swapLensImage(blurRadius, swapToImage: currentBackgroundImageName)
        if switchPhotochrom.on {
            switchPhotochrom.setOn(false, animated: false)
             photochromLayer.removeFromSuperlayer()
        }
    }
    
    @IBAction func btnAutumn(sender: UIBarButtonItem) {
        
        
        drawBackgroundLayer(Float(sliderPowerOutlet.value), imageName: "autumn", savebg: true)
        currentBackgroundImageName = "autumn"
        currentAdd.image = UIImage(named: currentBackgroundImageName + "-v")
        ///imageLayer.addSublayer(currentAdd.layer)
        swapLensImage(blurRadius, swapToImage: currentBackgroundImageName)
        if switchPhotochrom.on {
            switchPhotochrom.setOn(false, animated: false)
            
        }
    }
    
    @IBAction func btnSailing(sender: UIBarButtonItem) {
        
        drawBackgroundLayer(Float(sliderPowerOutlet.value), imageName: "sailing", savebg: true)
        currentBackgroundImageName = "sailing"
        currentAdd.image = UIImage(named: currentBackgroundImageName + "-v")
       // imageLayer.addSublayer(currentAdd.layer)
        swapLensImage(blurRadius, swapToImage: currentBackgroundImageName)
   
        if switchPhotochrom.on {
            switchPhotochrom.setOn(false, animated: false)
             photochromLayer.removeFromSuperlayer()
        }
       


    }
    
    
    
    func getSupportPath(fileName: String) -> String {
        let documentsURL = NSFileManager.defaultManager().URLsForDirectory(.ApplicationSupportDirectory, inDomains: .UserDomainMask)[0]
        let fileURL = documentsURL.URLByAppendingPathComponent(fileName)
        return fileURL.path!
    }
    
    func grabButtonImageName(designId: Int)-> String{
        let databasePath = getSupportPath("genie.db") // grab the database.
        let genieDB = FMDatabase(path: String(databasePath))
        var imageName = ""
        if genieDB.open() {
            let querySQL = "SELECT IMAGENAME FROM DESIGNS where ID=\(designId)"
            let results:FMResultSet? = genieDB.executeQuery(querySQL, withArgumentsInArray: nil)
            if results?.next() == true {
                imageName = (results?.stringForColumn("IMAGENAME"))!
                print(results?.stringForColumn("IMAGENAME")!)
            } else {
                print("Records not found in database for 'General Settings'.")
            }
            genieDB.close()
        }
        return imageName
    }

    //Need to track the magSize and ScaleSize.
    
    var magSize = Float(20)
    var magScale = Float(1.0)
    
    func swapMagnifyLayer(blurRadius:  Float){
        
        let bulgx = lensShapelayer.position.x
        let bulgy = mainImageView.frame.height - (lensShapelayer.position.y+(lensShapelayer.frame.height/4))
        
        magnifyLayer.removeFromSuperlayer()
        let img = magnifyImage(blurRadius,imageName: UIImage(named: currentBackgroundImageName + "-v")!, bulgeX: bulgx, bulgeY: bulgy, magSize: magSize, magScale: magScale)
        let image = UIImageView(image: img)
        magnifyLayer.addSublayer(image.layer)
        magnifyLayer.path = drawLensPath()
        imageLayer.addSublayer(magnifyLayer)
    }
    
    func swapMagnifyLayerALT(blurRadius:  Float){
        
           
        let bulgx = lensShapelayer.position.x
        let bulgy = mainImageView.frame.height - (lensShapelayer.position.y+(lensShapelayer.frame.height/4))
        
        magnifyLayer.removeFromSuperlayer()
        let img = magnifyImage(blurRadius,imageName: UIImage(named: currentBackgroundImageName + "-v")!, bulgeX: bulgx, bulgeY: bulgy, magSize: magSize, magScale: magScale)
        let image = UIImageView(image: img)
        magnifyLayer.addSublayer(image.layer)
        magnifyLayer.path = drawLensPath()
        imageLayer.addSublayer(magnifyLayer)
    }

    
    
    
    func swapLensImage(blurRadius: Float, swapToImage: String){
      
        
        if (blurRadius>0){
            
            
            
            leftBlurLayer.removeFromSuperlayer()
            rightBlurLayer.removeFromSuperlayer()
            
            
            swapMagnifyLayer(blurRadius)
     
            let bulgx = lensShapelayer.position.x
            let bulgy = mainImageView.frame.height - (lensShapelayer.position.y+(lensShapelayer.frame.height/4))
     
         //   print("\(bulgx) : \(bulgy)")
            
            //Use the magnify image and blur it per sender values.
            let img = UIImageView(image: magnifyImage(blurRadius,imageName: UIImage(named: swapToImage+"-v")!, bulgeX: bulgx, bulgeY: bulgy, magSize: magSize, magScale:magScale))
            let leftimg = UIImageView(image: blurImg(blurRadius, imageName: img.image!))
            let rightimg = UIImageView(image: blurImg(blurRadius, imageName: img.image!))
      
            leftBlurLayer.path = leftMask.path
            leftBlurLayer.fillColor = UIColor.clearColor().CGColor
            leftBlurLayer.addSublayer(leftimg.layer)
            leftBlurLayer.mask = leftMask
        
            rightBlurLayer.path = rightMask.path
            rightBlurLayer.fillColor = UIColor.clearColor().CGColor
            rightBlurLayer.addSublayer(rightimg.layer)
            rightBlurLayer.mask = rightMask
            
            imageLayer.addSublayer(leftBlurLayer)
            imageLayer.addSublayer(rightBlurLayer)
            
        }

    }

    
    func drawStrokeLayer(copyFrom: CGPath, strokeWidth: CGFloat)->CGPathRef{
        
        return CGPathCreateCopyByStrokingPath(copyFrom, nil, strokeWidth, .Butt, .Miter, 0.0)!
    }

    
    func blurImg(blurRadius: Float, imageName: UIImage)->UIImage{
    
        
        let glContext = EAGLContext(API: .OpenGLES2)
        context = CIContext(EAGLContext: glContext,
            options: [
                kCIContextWorkingColorSpace: NSNull()
            ]
        )
        
        
        let beginImage = CIImage(image: imageName)
        let transform = CGAffineTransformIdentity
        
        let clampFilter = CIFilter(name: "CIAffineClamp")!
        let currentFilter = CIFilter(name: "CIGaussianBlur")!
        
        clampFilter.setValue(beginImage!, forKey: "inputImage")
        clampFilter.setValue(NSValue(CGAffineTransform: transform), forKey: "inputTransform")
        
        currentFilter.setValue(clampFilter.outputImage!, forKey: "inputImage")
        currentFilter.setValue(blurRadius, forKey: "inputRadius")
        
        let cgimg = context.createCGImage(currentFilter.outputImage!, fromRect: beginImage!.extent)
        return UIImage(CGImage: cgimg) //has to have the CGImage piece on the end!!!!!
        
    }
    
    
    let glContext = EAGLContext(API: .OpenGLES2)
    let transform = CGAffineTransformIdentity
    let clampFilter = CIFilter(name: "CIAffineClamp")!
    let bulgeFilter = CIFilter(name: "CIBumpDistortion")!

    
    func magnifyImage(blurRadius: Float,imageName: UIImage, bulgeX: CGFloat, bulgeY: CGFloat, magSize: Float, magScale: Float) ->UIImage{
        
        
        
        let beginImage = CIImage(image: imageName)
        
        clampFilter.setValue(beginImage!, forKey: "inputImage")
        clampFilter.setValue(NSValue(CGAffineTransform: transform), forKey: "inputTransform")
        
        bulgeFilter.setValue(clampFilter.outputImage!, forKey: "inputImage")
        bulgeFilter.setValue((magSize*blurRadius)*magScale, forKey: "inputRadius")
        bulgeFilter.setValue(CIVector(x: bulgeX, y: bulgeY), forKey: kCIInputCenterKey)
        bulgeFilter.setValue(magScale, forKey: "inputScale")
        
        let cgimg = context.createCGImage(bulgeFilter.outputImage!, fromRect: beginImage!.extent)
        return UIImage(CGImage: cgimg) //has to have the CGImage piece on the end!!!!!

    
    }
    
 
    
    
    //TODO:  WRITE THIS TO SWING BOTH WAYS.
    func drawShapePath(designId: Int, reverse: Bool)->CGPathRef{
        
        
        let shape = CGPathCreateMutable()
        let documentsURL = NSFileManager.defaultManager().URLsForDirectory(.ApplicationSupportDirectory, inDomains: .UserDomainMask)[0]
        let databasePath = documentsURL.URLByAppendingPathComponent("genie.db").path!
        let genieDB = FMDatabase(path: String(databasePath))
        
        if genieDB.open() {
            if (designId>0){
                //Grabe the values.
                
                let sql_stmt = "SELECT P1X, P1Y, C1X, C1Y, P2X, P2Y, C2X,C2Y,C3X,C3Y,P3X, P3Y, C4X, C4Y,C5X,C5Y, P4X,P4Y,C6X,C6Y from DESIGNPOINTS WHERE DESIGNID=\(designId)"
                print(sql_stmt)
                let results:FMResultSet? = genieDB.executeQuery(sql_stmt, withArgumentsInArray: nil)
               
                if ((results?.next()) != nil) {
                    print("pre-results next")
                    
                
                        
                        let shapes = results?.resultDictionary()
                        print(shapes)
                        //TODO:  CHANGE TO ARRAY.
                        var p1x = shapes!["P1X"] as! CGFloat
                        var p1y = shapes!["P1Y"] as! CGFloat
                        var p2x = shapes!["P2X"] as! CGFloat
                        var p2y = shapes!["P2Y"] as! CGFloat
                        var p3x = shapes!["P3X"] as! CGFloat
                        var p3y = shapes!["P3Y"] as! CGFloat
                        var p4x = shapes!["P4X"] as! CGFloat
                        var p4y = shapes!["P4Y"] as! CGFloat
                        
                        
                        
                        var c1x = shapes!["C1X"] as! CGFloat
                        var c1y = shapes!["C1Y"] as! CGFloat
                        var c2x = shapes!["C2X"] as! CGFloat
                        var c2y = shapes!["C2Y"] as! CGFloat
                        var c3x = shapes!["C3X"] as! CGFloat
                        var c3y = shapes!["C3Y"] as! CGFloat
                        var c4x = shapes!["C4X"] as! CGFloat
                        var c4y = shapes!["C4Y"] as! CGFloat
                        var c5x = shapes!["C5X"] as! CGFloat
                        var c5y = shapes!["C5Y"] as! CGFloat
                        var c6x = shapes!["C6X"] as! CGFloat
                        var c6y = shapes!["C6Y"] as! CGFloat
                        
                        
                        p1x = (p1x+40)*10
                        p1y = (-p1y+40)*10
                        p2x = (p2x+40)*10
                        p2y = (-p2y+40)*10
                        p3x = (p3x+40)*10
                        p3y = (-p3y+40)*10
                        p4x = (p4x+40)*10
                        p4y = (-p4y+40)*10
                        
                        
                        c1x = (c1x+40)*10
                        c1y = (-c1y+40)*10
                        c2x = (c2x+40)*10
                        c2y = (-c2y+40)*10
                        c3x = (c3x+40)*10
                        c3y = (-c3y+40)*10
                        c4x = (c4x+40)*10
                        c4y = (-c4y+40)*10
                        c5x = (c5x+40)*10
                        c5y = (-c5y+40)*10
                        c6x = (c6x+40)*10
                        c6y = (-c6y+40)*10
                        
                        CGPathMoveToPoint(shape, nil, p1x, p1y)
                        CGPathAddCurveToPoint(shape, nil, c1x, c1y, c2x, c2y, p2x, p2y)
                        CGPathAddCurveToPoint(shape, nil, c3x, c3y, c4x, c4y, p3x, p3y)
                        CGPathAddCurveToPoint(shape, nil, c5x, c5y, c6x, c6y, p4x, p4y)
                        CGPathAddLineToPoint(shape, nil, 0, p4y)
                        CGPathAddLineToPoint(shape, nil, 0, p1y)
                        CGPathCloseSubpath(shape)
                    
                    
                
                }else{
                    print("No results")
                }
            }else{
                print("NIL RESULTS")
            }
            genieDB.close()
        }else{
            print("database failed to open.")
        }
        
        
        return shape
    }
    
    
    
    //TODO:  WRITE THIS TO SWING BOTH WAYS.
    //
    func drawShapeMirrorPath(designId: Int, reverse: Bool)->CGPathRef{
        
        
        let shape = CGPathCreateMutable()
        let documentsURL = NSFileManager.defaultManager().URLsForDirectory(.ApplicationSupportDirectory, inDomains: .UserDomainMask)[0]
        let databasePath = documentsURL.URLByAppendingPathComponent("genie.db").path!
        let genieDB = FMDatabase(path: String(databasePath))
        
        if genieDB.open() {
            if (designId>0){
                //Grabe the values.
                
                let sql_stmt = "SELECT P1X, P1Y, C1X, C1Y, P2X, P2Y, C2X,C2Y,C3X,C3Y,P3X, P3Y, C4X, C4Y,C5X,C5Y, P4X,P4Y,C6X,C6Y from DESIGNPOINTS WHERE DESIGNID=\(designId)"
                print(sql_stmt)
                let results:FMResultSet? = genieDB.executeQuery(sql_stmt, withArgumentsInArray: nil)
                
                if ((results?.next()) != nil) {
                    
                    let shapes = results?.resultDictionary()
                   
                    //TODO:  CHANGE TO ARRAY.
                    var p1x = shapes!["P1X"] as! CGFloat
                    var p1y = shapes!["P1Y"] as! CGFloat
                    var p2x = shapes!["P2X"] as! CGFloat
                    var p2y = shapes!["P2Y"] as! CGFloat
                    var p3x = shapes!["P3X"] as! CGFloat
                    var p3y = shapes!["P3Y"] as! CGFloat
                    var p4x = shapes!["P4X"] as! CGFloat
                    var p4y = shapes!["P4Y"] as! CGFloat
                    
                    
                    
                    var c1x = shapes!["C1X"] as! CGFloat
                    var c1y = shapes!["C1Y"] as! CGFloat
                    var c2x = shapes!["C2X"] as! CGFloat
                    var c2y = shapes!["C2Y"] as! CGFloat
                    var c3x = shapes!["C3X"] as! CGFloat
                    var c3y = shapes!["C3Y"] as! CGFloat
                    var c4x = shapes!["C4X"] as! CGFloat
                    var c4y = shapes!["C4Y"] as! CGFloat
                    var c5x = shapes!["C5X"] as! CGFloat
                    var c5y = shapes!["C5Y"] as! CGFloat
                    var c6x = shapes!["C6X"] as! CGFloat
                    var c6y = shapes!["C6Y"] as! CGFloat
                    
                    
                    //formula :  p1x + 80 = brings our starting point to the middle (half of our 800 wide).
                    // to mirror:  800 - (point value + 80) + gives us the mirror point
                    //  + 400 moves over by 400
                    
                    p1x = 800-((p1x+80)*10)+400
                    p1y = (-p1y+40)*10
                    p2x = 800-((p2x+80)*10)+400
                    p2y = (-p2y+40)*10
                    p3x = 800-((p3x+80)*10)+400
                    p3y = (-p3y+40)*10
                    p4x = 800-((p4x+80)*10)+400
                    p4y = (-p4y+40)*10
                    
                    
                    c1x = 800-((c1x+80)*10)+400
                    c1y = (-c1y+40)*10
                    c2x = 800-((c2x+80)*10)+400
                    c2y = (-c2y+40)*10
                    c3x = 800-((c3x+80)*10)+400
                    c3y = (-c3y+40)*10
                    c4x = 800-((c4x+80)*10)+400
                    c4y = (-c4y+40)*10
                    c5x = 800-((c5x+80)*10)+400
                    c5y = (-c5y+40)*10
                    c6x = 800-((c6x+80)*10)+400
                    c6y = (-c6y+40)*10
                    
                    CGPathMoveToPoint(shape, nil, p1x, p1y)
                    CGPathAddCurveToPoint(shape, nil, c1x, c1y, c2x, c2y, p2x, p2y)
                    CGPathAddCurveToPoint(shape, nil, c3x, c3y, c4x, c4y, p3x, p3y)
                    CGPathAddCurveToPoint(shape, nil, c5x, c5y, c6x, c6y, p4x, p4y)
                    CGPathAddLineToPoint(shape, nil, 800, p4y)
                    CGPathAddLineToPoint(shape, nil, 800, p1y)
                    CGPathCloseSubpath(shape)
                    
                }else{
                    print("No results")
                }
            }else{
                print("NIL RESULTS")
            }
            genieDB.close()
        }else{
            print("database failed to open.")
        }
        
        
        return shape
    }

    
    
    //Convert Degrees to Radians!!!!
    func degree2radian(a:CGFloat)->CGFloat {
        let b = CGFloat(M_PI) * a/180
        return b
    }

    
    func polygonPointArray(sides:Int,x:CGFloat,y:CGFloat,radius:CGFloat)->[CGPoint] {
        let angle = degree2radian(360/CGFloat(sides)) //how many sides
        let cx = x // x origin
        let cy = y // y origin
        let r  = radius // radius of circle
        var i = 0
        var points = [CGPoint]()
        while i <= sides {
            let xpo = cx + r * cos(angle * CGFloat(i))
            let ypo = cy + r * sin(angle * CGFloat(i))
            points.append(CGPoint(x: xpo, y: ypo))
            i++;
        }
        return points
    }

    func polygonPath(xa:CGFloat, ya:CGFloat, radius:CGFloat, sides:Int) -> CGPathRef {
        
        let path = CGPathCreateMutable()
        let points = polygonPointArray(sides, x:xa, y:ya,radius:radius)
        //    let points polygonPointArray(sides,y:ya,x:xa,radius:radius)
        let cpg = points[0]
        CGPathMoveToPoint(path, nil, cpg.x, cpg.y)
        for p in points {
            CGPathAddLineToPoint(path, nil, p.x, p.y)
        }
        CGPathCloseSubpath(path)
        return path
    }


    //change this function to our LensShape...
    func drawPolygonLayer(x:CGFloat, y:CGFloat, radius:CGFloat, sides:Int, color:UIColor) -> CAShapeLayer {
        
        let shape = CAShapeLayer()
        shape.path = polygonPath(x, ya: y, radius: radius, sides: sides)
        if (color != UIColor.whiteColor()){
            shape.fillColor = color.CGColor
        }
        
        return shape
        
    }
    
    
    
    //Feed points are specific to Lens (redo this as generic)
    func drawLensPath() ->CGPathRef {
        
        let lensPath = CGPathCreateMutable()
        var points = lensPoints()
        let cpg = points[0]
        CGPathMoveToPoint(lensPath, nil, cpg.x, cpg.y)
        for p in points {
            CGPathAddLineToPoint(lensPath, nil, p.x, p.y)
        }
        CGPathCloseSubpath(lensPath)
        return lensPath

    }
    
    @IBOutlet weak var carousel: iCarousel!
    
    
    func drawMaskLayer(color:CGColor) -> CAShapeLayer{
        let shape = CAShapeLayer()
        shape.path = drawLensPath()
        return shape
        
        
    }
        
    func lensPoints()->[CGPoint]{
            
            var points = [CGPoint]()
            var lenspoints = [770,400,777,374,784,346,788,318,789,288,785,260,774,233,756,211,733,192,707,177,680,165,653,156,627,148,602,142,578,136,555,132,532,129,511,126,490,124,469,122,449,121,429,120,410,120,390,120,371,121,351,121,331,122,310,124,289,125,267,127,244,130,220,133,195,138,169,143,141,150,114,160,87,173,62,189,40,209,24,233,14,259,11,288,12,317,17,346,23,374,30,400,38,425,48,450,58,473,68,495,80,516,93,537,107,556,123,573,139,590,156,605,174,618,193,630,212,641,231,650,251,658,271,664,291,670,311,673,331,677,351,679,371,680,390,680,410,680,429,678,449,676,468,673,487,669,507,664,526,658,545,650,563,642,582,632,600,622,617,610,634,597,651,582,667,567,683,550,697,532,712,513,725,493,737,472,749,449,760,425]
            
            
            for var po=0; po<lenspoints.count-1; po++ {
                if (po%2) == 0{
                    points.append(CGPointMake(CGFloat(lenspoints[po]),CGFloat(lenspoints[po+1])-70)) //-minus 70 on the y plane brings the lens up on the screen
                    // print(String(lenspoints[po]) + " : " + String(lenspoints[po+1]))
                }
            }
            return points
    }
        

    
    
    
    func drawRightPath(xstart: CGFloat, ystart: CGFloat, cp: CGFloat, yp: CGFloat, x: CGFloat, y: CGFloat, numPoints: Int)->CGPathRef{
        
        var points = [CGPoint]()
        var i = 0
        var xpo = xstart
        var ypo = ystart
        while i <= numPoints {
            xpo = xpo - 20
            ypo = ypo + 25
            
            //    print(" \(xpo)  \(ypo)")
            
            points.append(CGPoint(x: xpo, y:ypo))
            i++;
        }
        let drawpath = CGPathCreateMutable()
        
        let cpg = points[0]
        CGPathMoveToPoint(drawpath,nil,cpg.x,cpg.y)
        for p in points{
            CGPathAddLineToPoint(drawpath,nil,p.x,p.y)
        }
        CGPathMoveToPoint(drawpath,nil,points[points.count-1].x,points[points.count-1].y)
        CGPathAddQuadCurveToPoint(drawpath, nil, 320,380, 230, 590)
        CGPathAddQuadCurveToPoint(drawpath, nil, cp,yp,x,y)
        
        CGPathAddQuadCurveToPoint(drawpath,nil,730,425,800,260)
        CGPathAddQuadCurveToPoint(drawpath,nil,800,175,xstart,ystart)
        
        CGPathAddQuadCurveToPoint(drawpath,nil,900,420,807,255)
        CGPathAddQuadCurveToPoint(drawpath,nil,805,120,xstart,ystart)
        
        return drawpath
        
        
        
    }
    

    func drawStrokePath(numPoints:Int, x: CGFloat, y: CGFloat, radius: CGFloat)->CGPathRef{
        
        let drawpath = CGPathCreateMutable()
        var points = polygonPointArray(numPoints, x: x, y: y, radius: radius)
        
        CGPathMoveToPoint(drawpath,nil,points[points.count-1].x,points[points.count-1].y)
        
        for p in points{
            CGPathAddLineToPoint(drawpath,nil,p.x,p.y)
        }
        return drawpath
    }
    

    
    //Sets all the LensShape layers DEFAULTS / CHANGE THE NAME OF THIS FUNCTION TO DEFAULT LAYERS
    func setDefaultLayers(imageName: UIImage){
        
        swapLensImage(blurRadius, swapToImage: currentBackgroundImageName)

        
        //Mask:  Apply Lens Shape
        let maskLayerForImage = drawMaskLayer(UIColor.whiteColor().CGColor)  // replace testing with this when you're ready.
        
        //Background Image has its own layer now.
        let img = UIImageView(image: imageName) //The vibrant version of the image name will be sent over.
        currentAdd = img
  
        
        imageLayer.frame = pilotsLayer.bounds
        imageLayer.bounds = CGRect(x: 0, y: 0, width: pilotsLayer.frame.width, height: pilotsLayer.frame.height)
        imageLayer.contentsGravity = kCAGravityCenter
        imageLayer.fillRule = kCAFillRuleEvenOdd;
        imageLayer.zPosition = 2
        imageLayer.mask = maskLayerForImage
        imageLayer.addSublayer(currentAdd.layer) // let's try not adding an image to the mask, just cut it out!!!
   
        
        

        
        
        leftBlurLayer.frame = pilotsLayer.bounds
        leftBlurLayer.path = leftMask.path
        leftBlurLayer.bounds = CGRect(x: 0, y: 0, width: pilotsLayer.frame.width, height: pilotsLayer.frame.height)
        leftBlurLayer.fillRule = kCAFillRuleEvenOdd;
        leftBlurLayer.zPosition = 4
        
        rightBlurLayer.frame = pilotsLayer.bounds
        rightBlurLayer.path = rightMask.path
        rightBlurLayer.bounds = CGRect(x: 0, y: 0, width: pilotsLayer.frame.width, height: pilotsLayer.frame.height)
        rightBlurLayer.fillRule = kCAFillRuleEvenOdd;
        rightBlurLayer.zPosition = 4

        imageLayer.addSublayer(leftBlurLayer)
        imageLayer.addSublayer(rightBlurLayer)
        
        

    
        //Main layers :     Pilots layer or bottom background layer
        //                  BlurShape Layer holds the left and right blurs
        //                  imageLayer holds the image that moves...
        
        pilotsLayer.addSublayer(imageLayer)
        
        
        //Stroke the outside of the LensShape.
        let strokeLensShapeLayer = drawStrokeLayer(drawLensPath(), strokeWidth:2.0)
        
        
        lensShapelayer.frame = pilotsLayer.bounds
        lensShapelayer.bounds = CGRect(x: 0, y: 0, width: pilotsLayer.frame.width, height: pilotsLayer.frame.height)
        let maskLayer = drawMaskLayer(UIColor.whiteColor().CGColor)
        lensShapelayer.contentsGravity = kCAGravityCenter
        lensShapelayer.fillColor = UIColor.clearColor().CGColor;
        lensShapelayer.mask = maskLayer
        lensShapelayer.path = strokeLensShapeLayer
        

        
        magnifyLayer.frame = lensShapelayer.frame
        magnifyLayer.contentsGravity = kCAGravityCenter
        magnifyLayer.zPosition = 3
        magnifyLayer.mask = drawMaskLayer(UIColor.clearColor().CGColor)
        imageLayer.addSublayer(magnifyLayer)

        
        
        
        //Add a non colored color layer (can be replaced using buttons : color).
        //Color Layer.
        let newColorLayer = drawMaskLayer(UIColor.whiteColor().CGColor)
        newColorLayer.fillColor = UIColor.clearColor().CGColor
        newColorLayer.fillRule = kCAFillRuleNonZero
        newColorLayer.zPosition = 7
        newColorLayer.opacity = 0.0
        
        
        //COLOR LAYER
        lensShapelayer.addSublayer(colorLayer)
        
    
        let strokeline = CAShapeLayer()
        strokeline.strokeColor = UIColor.whiteColor().CGColor
        strokeline.fillColor = UIColor.clearColor().CGColor
        strokeline.path = strokeLensShapeLayer
        strokeline.zPosition = 8
        lensShapelayer.addSublayer(strokeline)
        
        
        //MagnifyLayer: initially empty, will be set when user moves the sliderAdd.
        
        
        //Left stroke (stroke layer)
        leftLayer.contentsGravity = kCAGravityCenter
        leftLayer.path = drawShapePath(1,reverse: false)
        leftLayer.strokeColor = UIColor.yellowColor().CGColor
        leftLayer.fillColor = UIColor.clearColor().CGColor;
        leftLayer.lineWidth = 8.0
        leftLayer.zPosition = 6
        lensShapelayer.addSublayer(leftLayer)
        
        
        
        //  Stroke layer
        rightLayer.contentsGravity = kCAGravityCenter
        rightLayer.path = drawShapeMirrorPath(1,reverse:false)
        rightLayer.strokeColor = UIColor.yellowColor().CGColor
        rightLayer.fillColor = UIColor.clearColor().CGColor
        rightLayer.lineWidth = 8.0
        rightLayer.zPosition = 6
        lensShapelayer.addSublayer(rightLayer)
        
        
        //LEFT & RIGHT DOTS (laser marks)
        let leftDot = drawPolygonLayer((lensShapelayer.bounds.size.width/2)/2, y: (lensShapelayer.bounds.size.height/2), radius:10, sides: 360, color: UIColor.yellowColor())
        leftDot.zPosition = 9
        lensShapelayer.addSublayer(leftDot)
        let rightDot = drawPolygonLayer(lensShapelayer.bounds.size.width-(lensShapelayer.bounds.size.width/2)/2, y: (lensShapelayer.bounds.size.height/2), radius:10, sides: 360, color: UIColor.yellowColor())
        rightDot.zPosition = 9
        lensShapelayer.addSublayer(rightDot)
        
        
        //After adding everything to the lens shape... now add this to the CAlayer TopLayer
       // lensLayer.addSublayer(lensShapelayer) // testing to see if adding to a CALayer will allow me to pinch size.
        
        
        leftMask.path = drawShapePath(1, reverse: false)
        rightMask.path = drawShapeMirrorPath(1, reverse: true)
        currentBackground = UIImage(named: "cockpit-v")
        currentBackgroundImageName = "cockpit"
         
        pilotsLayer.addSublayer(lensShapelayer)  // append the new layer to the pilotslayer
        lensShapelayer.zPosition = 3
        
        
    }

    func drawBackgroundLayer(blurRadius: Float, imageName: String, savebg: Bool){
        
       // let glContext = EAGLContext(API: .OpenGLES2)
        context = CIContext(EAGLContext: glContext,
            options: [
                kCIContextWorkingColorSpace: NSNull()
            ]
        )
        
        let clampFilter = CIFilter(name: "CIAffineClamp")!
        let currentFilter = CIFilter(name: "CIGaussianBlur")!
        let bulgeFilter = CIFilter(name: "CIBumpDistortion")!
        

        
        //Set this to current background.
        var beginImage = CIImage()
        if savebg {
            beginImage = CIImage(image: UIImage(named: imageName + "-n")!)! // append normal
            currentBackgroundImageName = imageName // Save the name!!!! so we can switch, we dont want to switch for photochrom hence, flag!
        }else{
            beginImage = CIImage(image: UIImage(named: imageName)!)!
        }
        let transform = CGAffineTransformIdentity
        clampFilter.setValue(beginImage, forKey: "inputImage")
        clampFilter.setValue(NSValue(CGAffineTransform: transform), forKey: "inputTransform")
        currentFilter.setValue(clampFilter.outputImage, forKey: "inputImage")
        currentFilter.setValue(blurRadius, forKey: "inputRadius")
        
        let cgimg = context.createCGImage(currentFilter.outputImage!, fromRect: beginImage.extent)
        let processedImage = UIImage(CGImage: cgimg).CGImage //has to have the CGImage piece on the end!!!!!
        
        pilotsLayer.zPosition = 1
        pilotsLayer.backgroundColor = UIColor.whiteColor().CGColor
        pilotsLayer.contentsGravity = kCAGravityBottomLeft
        pilotsLayer.masksToBounds = true  //Important: tell this layer to be the boundary which cuts other layers (rect)
        pilotsLayer.contents = processedImage

        
        
    }
    
    //Function takes "blurRadius" and renders a gaussian blur to the background image.
    func drawMainLayer(blurRadius: Float, imageName: UIImage, savebg: Bool){
        
     //   let glContext = EAGLContext(API: .OpenGLES2)
        context = CIContext(EAGLContext: glContext,
            options: [
                kCIContextWorkingColorSpace: NSNull()
            ]
        )
       
        //Set this to current background.
        let beginImage = CIImage(image: imageName)
        if savebg {
            currentBackground = imageName
        }
        
        let transform = CGAffineTransformIdentity
        let clampFilter = CIFilter(name: "CIAffineClamp")!
        let currentFilter = CIFilter(name: "CIGaussianBlur")!
        let bulgeFilter = CIFilter(name: "CIBumpDistortion")!
        

        
        clampFilter.setValue(beginImage!, forKey: "inputImage")
        clampFilter.setValue(NSValue(CGAffineTransform: transform), forKey: "inputTransform")
        currentFilter.setValue(clampFilter.outputImage, forKey: "inputImage")
        currentFilter.setValue(blurRadius, forKey: "inputRadius")
        
        let cgimg = context.createCGImage(currentFilter.outputImage!, fromRect: beginImage!.extent)
        let processedImage = UIImage(CGImage: cgimg).CGImage //has to have the CGImage piece on the end!!!!!
        
        pilotsLayer.zPosition = 1
        pilotsLayer.backgroundColor = UIColor.whiteColor().CGColor
        pilotsLayer.contentsGravity = kCAGravityBottomLeft
        pilotsLayer.masksToBounds = true  //Important: tell this layer to be the boundary which cuts other layers (rect)
        pilotsLayer.contents = processedImage
        
        
    }
    
    func setBtn1FromDirectory(findimage: String){
        
        let fm = NSFileManager.defaultManager()
        let path = getSupportPath("images")  // applicationSupportdirectory + images
        let items = try! fm.contentsOfDirectoryAtPath(path)
        for item in items {
            if item.hasPrefix(findimage) {
                let itemImage = path + "/" + item
                Button1.setBackgroundImage(UIImage.init(contentsOfFile: itemImage), forState: UIControlState.Normal)
                
                
            }
        }
        
    }
    @IBOutlet weak var Button4: UIButton!
    @IBOutlet weak var Button3: UIButton!
    @IBOutlet weak var Button2: UIButton!
    @IBOutlet weak var Button1: UIButton!
    
    
    
    
    
    func setBtn2FromDirectory(findimage: String){
        
        let fm = NSFileManager.defaultManager()
        let path = getSupportPath("images")  // applicationSupportdirectory + images
        let items = try! fm.contentsOfDirectoryAtPath(path)
        for item in items {
            if item.hasPrefix(findimage) {
                let itemImage = path + "/" + item
                
                Button2.setBackgroundImage(UIImage.init(contentsOfFile: itemImage),forState: UIControlState.Normal)
                
            }
        }
        
    }
    func setBtn3FromDirectory(findimage: String){
        
        let fm = NSFileManager.defaultManager()
        let path = getSupportPath("images")  // applicationSupportdirectory + images
        let items = try! fm.contentsOfDirectoryAtPath(path)
        for item in items {
            if item.hasPrefix(findimage) {
                let itemImage = path + "/" + item
                Button3.setBackgroundImage(UIImage.init(contentsOfFile: itemImage), forState: UIControlState.Normal)
                
            }
        }
        
    }
    func setBtn4FromDirectory(findimage: String){
        
        let fm = NSFileManager.defaultManager()
        let path = getSupportPath("images")  // applicationSupportdirectory + images
        let items = try! fm.contentsOfDirectoryAtPath(path)
        for item in items {
            if item.hasPrefix(findimage) {
                let itemImage = path + "/" + item
                Button4.setBackgroundImage(UIImage.init(contentsOfFile: itemImage), forState: UIControlState.Normal)
                
            }
        }
        
    }

    override func viewDidAppear(animated: Bool)
    {
        
       // self.view.setButtons("icon-cockpit")
        drawBackgroundLayer(0.0, imageName: "cockpit", savebg: true)
        setDefaultLayers(imgPilotsVib!)
        
        switchPhotochrom.setOn(false,animated:true)
        switchHydrophop.setOn(true, animated: true)
        switchHardCoat.setOn(true,animated: true)
        switchAntiReflection.setOn(true,animated: true)
        
        
        lblCoating.textColor = UIColor.blackColor()
        lblHydro.textColor = UIColor.blackColor()
        lblHardCoat.textColor = UIColor.blackColor()
        lblPhotochrom.textColor = UIColor.blackColor()
        lblAdd.textColor = UIColor.blackColor()
        lblPower.textColor = UIColor.blackColor()
        
        
        setBtn1FromDirectory(grabButtonImageName(1))
        setBtn2FromDirectory(grabButtonImageName(2))
        setBtn3FromDirectory(grabButtonImageName(3))
        setBtn4FromDirectory(grabButtonImageName(4))
        
        Carasel.type = .Linear
        Carasel.dataSource = self
        Carasel.centerItemWhenSelected = false
        Carasel.contentOffset = CGSize(width: -450,height: 0) // offset the "center" so to speak.
        Carasel.reloadData()
        
        super.viewDidLoad()
        
        
    }
    
    var carouselImages = NSMutableArray(array: ["autumn-v","cockpit-v","office-v","phone-v","office2-v","office3-v","takingphoto-v","sailing-v"])
    
    
    override func viewDidLoad(){
        
        context = CIContext(EAGLContext: glContext,
            options: [
                kCIContextWorkingColorSpace: NSNull()
            ]
        )

       
    }
    
  
    @IBOutlet weak var Carasel: iCarousel!
    
    
    
    func numberOfItemsInCarousel(carousel: iCarousel) -> Int {
        return carouselImages.count
    }
    
     func carousel(carousel: iCarousel, viewForItemAtIndex index: Int, reusingView view: UIView?) -> UIView {
       // "autumn-v","cockpit-v","office-v","phone-v","office2-v","office3-v","takingphoto-v","sailing-v"
        let newButton = UIButton(type: UIButtonType.Custom)
        if (view == nil)  {
            let buttonImage = UIImage(named: "\(carouselImages.objectAtIndex(index))")
            newButton.exclusiveTouch = true
            newButton.setImage(buttonImage, forState: .Normal)
            newButton.frame = CGRectMake(0.0, 0.0, 145, 80)
            newButton.setBackgroundImage(buttonImage, forState: .Normal )
            newButton.backgroundColor = UIColor.clearColor()
            newButton.layer.borderWidth = 2.0
            newButton.layer.borderColor = (UIColor( red: 255, green:255, blue:255, alpha: 1.0 )).CGColor
            if (index == 0){
                newButton.addTarget(self, action: "btnAutumn", forControlEvents: .TouchUpInside)
                newButton.setTitle("Autumn Scene", forState: .Normal)

            } else if (index == 1){
                newButton.addTarget(self, action: "btnCockpit", forControlEvents: .TouchUpInside)
                newButton.setTitle("Cockpit", forState: .Normal)
            } else if (index == 2){
                newButton.addTarget(self, action: "btnHotel", forControlEvents: .TouchUpInside)
                newButton.setTitle("City View", forState: .Normal)
            } else if (index == 3){
                newButton.addTarget(self, action: "btnPhone", forControlEvents: .TouchUpInside)
                 newButton.setTitle("Phone View", forState: .Normal)
            } else if (index == 4){
                newButton.addTarget(self, action: "btnOffice", forControlEvents: .TouchUpInside)
                newButton.setTitle("Office", forState: .Normal)
            } else if (index == 5){
                newButton.addTarget(self, action: "btnDesktop", forControlEvents: .TouchUpInside)
                newButton.setTitle("Meeting", forState: .Normal)
            } else if (index == 6){
                newButton.addTarget(self, action: "btnTakingPhoto", forControlEvents: .TouchUpInside)
                newButton.setTitle("Snapshot", forState: .Normal)
            } else if (index == 7) {
                newButton.addTarget(self, action: "btnSailing", forControlEvents: .TouchUpInside)
                newButton.setTitle("Sailing", forState: .Normal)
            }
            

        }
              return newButton
    }
    
    
    
       override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
        
    }


}

