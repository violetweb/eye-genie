//
//  ViewController.swift
//  Eye-Genie
//
//  Created by Ryan Maxwell on 2015-12-01.
//  Copyright © 2015 Bceen Ventures. All rights reserved.
//

import UIKit
import GLKit
import AVFoundation


class ViewController: UIViewController,  iCarouselDataSource, iCarouselDelegate {

   
    
    @IBOutlet weak var lblPower: UILabel!
    @IBOutlet weak var lblAdd: UILabel!
    @IBOutlet weak var lblCoating: UILabel!
    @IBOutlet weak var lblHydro: UILabel!
    @IBOutlet weak var lblHardCoat: UILabel!
    @IBOutlet weak var lblPhotochrom: UILabel!
    
    
    @IBAction func btnSwitch(sender: UIButton) {
        
        //Switch to Thickness // will change this layout to a pageviewcontroller later.
        self.performSegueWithIdentifier("ThicknessSegue", sender: self)

    }
    
    var cameraActive = false
    var panLens = true
    var panTransitions = false
    
    var currentBackground = UIImage(named: "progressive-bkg-v")
    var currentBackgroundImageName = "progressive-bkg" // append an n = desaturated (for mainlayer), or v = vibrant image (for imageLayer)
    var currentAdd = UIImageView()
    var lensLayer = CALayer()        //pilotslayer 2
    var backgroundLayer = CALayer()  //pilotslayer 1
    
    var imageLayer = CALayer()
    var leftBlurLayer = CAShapeLayer()
    var rightBlurLayer = CAShapeLayer()
    
    
    
    var BlurShapelayer = CAShapeLayer()
    
    //Lens Shape Layers
    var lensShapelayer = CAShapeLayer()
    var magnifyLayer = CAShapeLayer()
    var colorLayer = CAShapeLayer()
    var cutStroke = CAShapeLayer()
    var leftLayer = CAShapeLayer()
    var rightLayer = CAShapeLayer()
    var leftMask =  CAShapeLayer()
    var rightMask = CAShapeLayer()
    var existingMask = CAShapeLayer().mask
  
    //Coatings Layers
    var reflectionLayer = CAShapeLayer()
    var hardcoatLayer = CAShapeLayer()
    var hydroLayer = CAShapeLayer()
    var photochromLayer = CAShapeLayer()
    var coatingsLayer = CAShapeLayer()
    
    var blurRadius: Float = 0
    var context: CIContext!
    var addSlider: Float = 0
    var currentPath = "Conventional"
    
    //Position based variables
    var lastSavedLocation = CGPointZero
    var lastSavedImgLocation = CGPointZero
    var lastSavedBlurLocation = CGPointZero
    var lastSavedRightBlurLocation = CGPointZero
    var lastBackgroundPosition = CGPointZero
    var lastMagnifyLocation = CGPointZero
    var lastHandsPosition = CGPointZero
    var initialLensPosition = CGPointZero
    var initialLensMaskPosition = CGPointZero
    var initialLeftBlurPosition = CGPointZero
    var initialRightBlurPosition = CGPointZero
    
    var hydroPosition = CGPointZero
    var reflectionPosition = CGPointZero
    var hardcoatPosition = CGPointZero
    var panBackground = false
    
    var timer = NSTimer()
    
    var pilotsLayer: CALayer {
        return mainImageView.layer
    }
    
    
    //Thickenss tab .
    var thicknessLayer = CALayer()
    var prescriptionLeftPicker = PrescriptionPickerView()
    var prescriptionRightPicker = PrescriptionPickerView()

    var fullBackgroundLayer: CALayer {
        return globalUIView.layer
    }
    
    
    func LogoutTimed(){
        performSegueWithIdentifier("LogoutSegue", sender: timer)
    }
    
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        
        let interval = Double(28800) // eight hours check it...
        timer = NSTimer.scheduledTimerWithTimeInterval(interval, target:self, selector: Selector("LogoutTimed"), userInfo: nil, repeats: true)
       

        if (panLens){
            
            
            self.lastSavedLocation = lensShapelayer.position  // Works with panGesture... track the last position.
            self.lastSavedImgLocation = imageLayer.mask!.position
    
            if (sliderAddOutlet.value > 0.0){
                self.lastSavedBlurLocation = leftBlurLayer.mask!.position
                self.lastSavedRightBlurLocation = rightBlurLayer.mask!.position
                self.lastMagnifyLocation = magnifyLayer.mask!.position
                
            }
            
        }else{
            //slider is the pan gesture....
            if (panTransitions){
                self.lastBackgroundPosition = backgroundLayer.position
            }
            if (panBackground){
                self.lastBackgroundPosition = backgroundLayer.mask!.position
                self.lastHandsPosition = handsLayer.position
            }else{
              
                self.lastHandsPosition = handsLayer.position
                self.hydroPosition = hydroLayer.position
               
            }
        }
    
        
    }
  
    
    //As workaround, could not allow pan if sliderAddOutvalue is greater than zero, or
    // Reset to zero on touchesBegan??
    
    
    @IBAction func panGesture(sender: UIPanGestureRecognizer) {
     
        if (panLens){
        
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
                
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), {
                

               self.swapLensImage(self.blurRadius, swapToImage: self.currentBackgroundImageName)
                
                dispatch_async(dispatch_get_main_queue(), { // 2
                    self.swapLensImage(self.blurRadius, swapToImage: self.currentBackgroundImageName)
                    

                });
            });

            }
        }else{
            
            if (panBackground){
                
                
                let newTranslation = sender.translationInView(globalUIView)
                let newpos = self.lastBackgroundPosition.x + newTranslation.x

              
                    if (newpos > 550 && newpos < 1470){
                        backgroundLayer.mask!.position = CGPointMake(newpos, self.lastBackgroundPosition.y)
                        handsLayer.position = CGPointMake(self.lastHandsPosition.x+newTranslation.x, self.lastHandsPosition.y)
                    }
                
                
            }else{
                
                let newTranslation = sender.translationInView(mainImageView)
                let velocity = sender.velocityInView(mainImageView)
                
                
                if (sender.state == UIGestureRecognizerState.Changed){
                    
                    
                    if (panTransitions){
                        
                        let newpos = self.lastBackgroundPosition.x + newTranslation.x
                        
                        var percentage = Float(newpos/1962)/2 //Width of the part where we start to consider the opacity, divided by 2, cause we don't want full opacity **max of 50% never 1.0)***.
                        percentage = -percentage
                        
                        if (newpos > -1825 && newpos < 500){
                            backgroundLayer.position = CGPointMake(newpos, backgroundLayer.position.y)
                            colorLayer.opacity = percentage
                            
                        }
                       
                        
                    }else{
                    
                        let newpos = self.handsLayer.position.x+newTranslation.x
                        if (newpos < 800 && newpos >  0){
                            hydroLayer.position = CGPointMake(self.hydroLayer.position.x + newTranslation.x, self.hydroLayer.position.y)
                            handsLayer.position = CGPointMake(newpos, self.handsLayer.position.y)
                        }
                    }
                }
       
            }
        }
        
    }
    
    
    @IBOutlet weak var btnAntiSmudge: UIButton!
    
    @IBOutlet var globalUIView: UIView!
    
    @IBAction func pinchGesture(sender: UIPinchGestureRecognizer) {
        
        let translate = CATransform3DMakeTranslation(0, 0, 0);
        let scale = CATransform3DMakeScale(sender.scale, sender.scale, 1);
        let transform = CATransform3DConcat(translate, scale);
        
        magScale = Float(sender.scale)
        
        lensShapelayer.transform = transform
        
       
        imageLayer.mask!.frame = lensShapelayer.frame  // Match the same frame as the outer layer
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
        newLeftLayer.lineWidth = 5.0
        leftLayer = newLeftLayer
        lensShapelayer.addSublayer(leftLayer)
        
        
        
        rightLayer.removeFromSuperlayer()
        let newRightLayer = CAShapeLayer()
        newRightLayer.path = drawShapeMirrorPath(1, reverse: false)
        newRightLayer.zPosition = 6
        newRightLayer.strokeColor = UIColor.yellowColor().CGColor
        newRightLayer.fillColor = UIColor.clearColor().CGColor;
        newRightLayer.lineWidth = 5.0
        rightLayer = newRightLayer
        lensShapelayer.addSublayer(rightLayer)
        
        
        leftMask.path = drawShapePath(1, reverse: false)
        rightMask.path = drawShapeMirrorPath(1, reverse:false)
        
        //let blurRadius = Float(sliderPowerOutlet.value)
     //  (Float(blurRadius),swapToImage: currentBackground!)
        Button2.fadeOut()
        Button3.fadeOut()
        Button4.fadeOut()
        sender.fadeIn()
    }
    
    
    
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


    
    @IBAction func btnAntiReflectionCoating(sender: UIButton) {
       
        
        panLens = false
        
        hydroLayer.hidden = false
       
        
        //Change the background image to the Bright one + 5 Blur radius please.
        drawBackgroundLayer(5.0, imageName: "antireflection-v", savebg: false)
        
        removeNamedLayer(pilotsLayer, namedLayer: "imageLayer")
        
        removeNamedLayer(hydroLayer, namedLayer: "coatingsLayerImage")
        
        
        let imagelayer = UIImageView(image:UIImage(named: "antireflection-v"))
        imagelayer.layer.name = "lensBGImage"
        lensShapelayer.addSublayer(imagelayer.layer)
        
        handsLayer.position.x = 400
        
        hydroLayer.fillColor = UIColor.clearColor().CGColor
        hydroLayer.fillRule = kCAFillRuleNonZero
        hydroLayer.zPosition = 9
        hydroLayer.contentsGravity = kCAGravityBottomRight
        hydroLayer.position.x = 400
        let img = UIImageView(image: UIImage(named: getARCoating()))
        img.layer.name = "coatingsLayerImage"
        hydroLayer.addSublayer(img.layer)
        hydroLayer.name = "coatingLayer"
        lensShapelayer.addSublayer(hydroLayer)

        lastHandsPosition = handsLayer.position
    }
    
    @IBAction func btnHydrophop(sender: UIButton) {
       
        
        //Change the background image to the Bright one + 5 Blur radius please.
        drawBackgroundLayer(5.0, imageName: "hydrophop-v", savebg: false)
        
        imageLayer.removeFromSuperlayer()
        
        //Apply the Image to the LensShape now.
        let imagelayer = UIImageView(image: UIImage(named: "hydrophop-v"))
        imagelayer.layer.name = "lensBGImage"
        
        lensShapelayer.addSublayer(imagelayer.layer)
        handsLayer.position.x = 400
        
        
        
        
        removeNamedLayer(hydroLayer, namedLayer: "coatingsLayerImage")
        

        
        //Null and reset hydroLayers.
        hydroLayer.fillColor = UIColor.clearColor().CGColor
        hydroLayer.fillRule = kCAFillRuleNonZero
        hydroLayer.zPosition = 9
        hydroLayer.position.x = 400
        hydroLayer.contentsGravity = kCAGravityBottomRight
        hydroLayer.name = "coatingsLayer"
        let img = UIImageView(image: UIImage(named: getHydro()))
        img.layer.name = "coatingsLayerImage"
        hydroLayer.addSublayer(img.layer)
            
        lensShapelayer.addSublayer(hydroLayer)
        lastHandsPosition = handsLayer.position
        
       
    }
    
    func removeNamedLayer(mainLayer: CALayer, namedLayer: String){
        
        //If the ImageLayer exists, remove it.
        if let sublayers = mainLayer.sublayers {
            for layer in sublayers {
                
                if layer.name == namedLayer {
                    print("\(layer.name) found and removed.")
                    layer.removeFromSuperlayer()
                }
            }
        }

    }
    
    
    @IBAction func btnHardCoating(sender: UIButton) {
        
        
        //Change the background image to the Bright one + 5 Blur radius please.
        drawBackgroundLayer(5.0, imageName: "antiscratch-v", savebg: false)
        removeNamedLayer(pilotsLayer, namedLayer: "imageLayer")
        
        //Add same image to the lens shape.
        let imagelayer = UIImageView(image: UIImage(named: "antiscratch-v"))
        imagelayer.layer.name = "lensBGImage"
        lensShapelayer.addSublayer(imagelayer.layer)
        
        removeNamedLayer(hydroLayer, namedLayer: "coatingsLayerImage")
        
        handsLayer.position.x = 400
        hydroLayer.removeFromSuperlayer()
        hydroLayer.fillColor = UIColor.clearColor().CGColor
        hydroLayer.fillRule = kCAFillRuleNonZero
        hydroLayer.zPosition = 9
        hydroLayer.contentsGravity = kCAGravityBottomRight
        hydroLayer.position.x = 400
        let img = UIImageView(image: UIImage(named: getHardcoat()))
        img.layer.name = "coatingsLayerImage"
        hydroLayer.addSublayer(img.layer)
        
        lensShapelayer.addSublayer(hydroLayer)
        lastHandsPosition = handsLayer.position
    }
    
    let handsLayer = CALayer()
   
    @IBAction func btnDriverwear(sender: UIBarButtonItem) {
        
        
        //mainimageview / global ui view
        panLens = false
        globalImageView.hidden = true
        mainImageView.hidden = false

        panBackground = true
        prescriptionView.hidden = true
        sidebarView.hidden = true
        thicknessLayer.hidden = true
        lensLeftImage.hidden = true
        lensRightImage.hidden = true
        Button1.hidden = true
        Button2.hidden = true
        Button3.hidden = true
        Button4.hidden = true
        btnHardCoat.hidden = true
        btnHydrophop.hidden = true
        btnAntiReflection.hidden = true
        btnAntiSmudge.hidden = true
       
       
        removeNamedLayer(pilotsLayer, namedLayer: "imageLayer")
        removeNamedLayer(pilotsLayer, namedLayer: "lensShapelayer")
        
         
        backgroundLayer.position = CGPointMake(512,330) //Half the width half the height.
        coatingsLayer.bounds = backgroundLayer.bounds
        coatingsLayer.frame = backgroundLayer.frame
        coatingsLayer.contents = UIImage(named: "driverwear-bkg")!.CGImage
        coatingsLayer.contentsGravity = kCAGravityBottomLeft
        coatingsLayer.zPosition = 1
        pilotsLayer.addSublayer(coatingsLayer)
  
        //dump hands before
        removeNamedLayer(pilotsLayer, namedLayer: "handsLayer")
        
        handsLayer.bounds = coatingsLayer.bounds
        handsLayer.contents = UIImage(named: "with-without")!.CGImage
        handsLayer.frame = coatingsLayer.frame
        handsLayer.contentsGravity = kCAGravityBottomLeft
        handsLayer.backgroundColor = UIColor.clearColor().CGColor
        handsLayer.zPosition = 3
        
        pilotsLayer.addSublayer(handsLayer)
        
        backgroundLayer.contents = UIImage(named: "driverwear-coating")!.CGImage
        pilotsLayer.addSublayer(backgroundLayer)
     
        
        let mask = CALayer()
        mask.frame = backgroundLayer.frame
        mask.bounds          = backgroundLayer.bounds
        mask.backgroundColor = UIColor.whiteColor().CGColor
        backgroundLayer.mask = mask;
        
       // backgroundLayer.mask!.position = CGPointMake(backgroundLayer.mask!.position.x - backgroundLayer.bounds.width/2, backgroundLayer.mask!.position.y)
        
        //Background Layer Contains the "coated" Image!!!!
        backgroundLayer.mask!.position = CGPointMake(backgroundLayer.mask!.position.x + backgroundLayer.bounds.width/2,backgroundLayer.mask!.position.y)
    
    }
    
    
    @IBAction func btnPhotochrom(sender: UIButton) {
        
        
        
            //Change the background image to the Bright one.
            drawBackgroundLayer(blurRadius, imageName: "photochrom", savebg: false)
            imageLayer.removeFromSuperlayer()
            
            //remove the other layers if they are on and deactivate their switches.
            hardcoatLayer.removeFromSuperlayer()
            hydroLayer.removeFromSuperlayer()
            reflectionLayer.removeFromSuperlayer()
        
            
            //apply the photochrom layer
            let shape = CAShapeLayer()
            shape.path = drawHalfLensPath()
            photochromLayer = shape     //drawMaskLayer(UIColor.whiteColor().CGColor)
            photochromLayer.fillColor = UIColor(hexString: "#3c2f2fff")!.CGColor
            photochromLayer.fillRule = kCAFillRuleNonZero
            photochromLayer.zPosition = 9
            photochromLayer.opacity = 0.5
            lensShapelayer.addSublayer(photochromLayer)
            
        
        
    }
    @IBAction func btnJena(sender: UIButton) {
        
       
        leftLayer.removeFromSuperlayer()
        let newLeftLayer = CAShapeLayer()
        newLeftLayer.path = drawShapePath(2, reverse: false)
        newLeftLayer.zPosition = 6
        newLeftLayer.strokeColor = UIColor.yellowColor().CGColor
        newLeftLayer.fillColor = UIColor.clearColor().CGColor;
        newLeftLayer.lineWidth = 5.0
        leftLayer = newLeftLayer
        lensShapelayer.addSublayer(leftLayer)
        
        
        
        rightLayer.removeFromSuperlayer()
        let newRightLayer = CAShapeLayer()
        newRightLayer.path = drawShapeMirrorPath(2, reverse: false)
        newRightLayer.zPosition = 6
        newRightLayer.strokeColor = UIColor.yellowColor().CGColor
        newRightLayer.fillColor = UIColor.clearColor().CGColor;
        newRightLayer.lineWidth = 5.0
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
        newLeftLayer.lineWidth = 5.0
        leftLayer = newLeftLayer
        lensShapelayer.addSublayer(leftLayer)
        
        
        
        rightLayer.removeFromSuperlayer()
        let newRightLayer = CAShapeLayer()
        newRightLayer.path = drawShapeMirrorPath(3, reverse:false)
        newRightLayer.zPosition = 6
        newRightLayer.strokeColor = UIColor.yellowColor().CGColor
        newRightLayer.fillColor = UIColor.clearColor().CGColor
        newRightLayer.lineWidth = 5.0
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
        newLeftLayer.lineWidth = 5.0
        leftLayer = newLeftLayer
        lensShapelayer.addSublayer(leftLayer)
        
        
        
        rightLayer.removeFromSuperlayer()
        let newRightLayer = CAShapeLayer()
        newRightLayer.path = drawShapeMirrorPath(4, reverse:false)
        newRightLayer.zPosition = 6
        newRightLayer.strokeColor = UIColor.yellowColor().CGColor
        newRightLayer.fillColor = UIColor.clearColor().CGColor
        newRightLayer.lineWidth = 5.0
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
        if (cameraActive){
            
        }else{
            swapLensImage(Float(blurRadius),swapToImage: currentBackgroundImageName)
        }
        
    }
    
    @IBAction func sliderPower(sender: UISlider) {
        
        let blurRadius = sender.value // don't save this blurradisu globally...
        
        if (cameraActive){
            
            let lensshape = LensShapeBlur(drawIn: pilotsLayer) // Preview Layer is the background layer in VideoMode.
            lensshape.draw(blurRadius/100)
            
            //drawBackgroundLayer(blurRadius, imageName: blurImageName, savebg: true)
        }else{
            drawBackgroundLayer(blurRadius, imageName: currentBackgroundImageName, savebg: true)
        }
        
    }
 
    
    
 
    @IBOutlet weak var sliderAddOutlet: UISlider!
    
    @IBOutlet weak var sliderPowerOutlet: UISlider!
    
    func btnTakingPhoto() {
        
        drawBackgroundLayer(Float(sliderPowerOutlet.value), imageName: "takingphoto", savebg: true)
        currentBackgroundImageName = "takingphoto"
        currentAdd.image = UIImage(named: currentBackgroundImageName + "-v")
        swapLensImage(blurRadius, swapToImage: currentBackgroundImageName)
        
        
        
    }

    func btnPhone() {
        
        drawBackgroundLayer(Float(sliderPowerOutlet.value), imageName: "phone", savebg: true)
        currentBackgroundImageName = "phone"
        currentAdd.image = UIImage(named: currentBackgroundImageName + "-v")
        swapLensImage(blurRadius, swapToImage: currentBackgroundImageName)
        
        
    }

    
    func btnOffice() {
        
        
        drawBackgroundLayer(Float(sliderPowerOutlet.value), imageName: "office3", savebg: true)
        currentBackgroundImageName = "office3"
        currentAdd.image = UIImage(named: currentBackgroundImageName + "-v")
        swapLensImage(blurRadius, swapToImage: currentBackgroundImageName)
      
    }
    func btnHotel() {
        
        
        drawBackgroundLayer(Float(sliderPowerOutlet.value), imageName: "office", savebg: true)
        currentBackgroundImageName = "office"
        currentAdd.image = UIImage(named: currentBackgroundImageName + "-v")
        swapLensImage(blurRadius, swapToImage: currentBackgroundImageName)
       
        
    }
    func btnCockpit() {
        
        
        drawBackgroundLayer(Float(sliderPowerOutlet.value), imageName: "cockpit", savebg: true)
        currentBackgroundImageName = "cockpit"
        currentAdd.image = UIImage(named: currentBackgroundImageName + "-v")
        swapLensImage(blurRadius, swapToImage: currentBackgroundImageName)
           }

    func btnProgress3() {
        
        drawBackgroundLayer(Float(sliderPowerOutlet.value), imageName: "progressive-bkg3", savebg: true)
        currentBackgroundImageName = "progressive-bkg3"
        currentAdd.image = UIImage(named: currentBackgroundImageName + "-v")
        swapLensImage(blurRadius, swapToImage: currentBackgroundImageName)
        
        
    }
    func btnProgress2() {
    
    
        drawBackgroundLayer(Float(sliderPowerOutlet.value), imageName: "progressive-bkg2", savebg: true)
        currentBackgroundImageName = "progressive-bkg2"
        currentAdd.image = UIImage(named: currentBackgroundImageName + "-v")
        swapLensImage(blurRadius, swapToImage: currentBackgroundImageName)
      
    }
    func btnProgress() {
        
        
        drawBackgroundLayer(Float(sliderPowerOutlet.value), imageName: "progressive-bkg", savebg: true)
        currentBackgroundImageName = "progressive-bkg"
        currentAdd.image = UIImage(named: currentBackgroundImageName + "-v")
        ///imageLayer.addSublayer(currentAdd.layer)
        swapLensImage(blurRadius, swapToImage: currentBackgroundImageName)
       
    }

    func btnReading() {
        
        session.stopRunning()
        cameraActive = false
        currentBackgroundImageName = "reading"
        currentAdd.image = UIImage(named: currentBackgroundImageName + "-v")
        drawBackgroundLayer(Float(sliderPowerOutlet.value), imageName: "reading", savebg: true)
        swapLensImage(blurRadius, swapToImage: currentBackgroundImageName)
       
        
        
        
    }

    @IBOutlet weak var btnPhotochrom: UIButton!
    
    
    
    //Camera Capture requiered properties
    var videoDataOutput: AVCaptureVideoDataOutput!;
    var videoDataOutputQueue : dispatch_queue_t!;
    var previewLayer:AVCaptureVideoPreviewLayer!;
    var lensPreviewLayer:AVCaptureVideoPreviewLayer!;
    var captureDevice : AVCaptureDevice!
    let session = AVCaptureSession()
    // Loop through all the capture devices on this phone
    var orientation = AVCaptureVideoOrientation.LandscapeLeft
   
    
    func btnVideo() {
        //Empty the Layers from mainImageview
        cameraActive = true
     
        setupAVCapture();
    }

    
    func setupAVCapture(){
    
        session.sessionPreset = AVCaptureSessionPreset1920x1080
        let devices = AVCaptureDevice.devices();
        for device in devices {
                // Make sure this particular device supports video, set it to the back camera
            if (device.hasMediaType(AVMediaTypeVideo)) {
                if(device.position == AVCaptureDevicePosition.Back) {
                    captureDevice = device as? AVCaptureDevice;
                    if captureDevice != nil {
                        beginSession();
                        break;
                    }
                }
            }
        }
    }
    
    func beginSession(){
        var err : NSError? = nil
        var deviceInput:AVCaptureDeviceInput?
        do {
            deviceInput = try AVCaptureDeviceInput(device: captureDevice)
        } catch let error as NSError {
            err = error
            deviceInput = nil
        };
        if err != nil {
            print("error: \(err?.localizedDescription)");
        }
        if self.session.canAddInput(deviceInput){
            self.session.addInput(deviceInput);
        }
        
        
        self.videoDataOutput = AVCaptureVideoDataOutput();

        self.videoDataOutput.alwaysDiscardsLateVideoFrames=true;
        self.videoDataOutputQueue = dispatch_queue_create("VideoDataOutputQueue", DISPATCH_QUEUE_SERIAL);
       // self.videoDataOutput.setSampleBufferDelegate(self, queue:self.videoDataOutputQueue);
        if session.canAddOutput(self.videoDataOutput){
            session.addOutput(self.videoDataOutput);
        }
        self.videoDataOutput.connectionWithMediaType(AVMediaTypeVideo).enabled = true
        
     
        
        self.previewLayer = AVCaptureVideoPreviewLayer(session: self.session);
        self.previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
        
        //self.lensPreviewLayer = AVCaptureVideoPreviewLayer(session: self.session);
        //self.lensPreviewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
        

        
        if UIDeviceOrientationIsLandscape(UIDeviceOrientation.LandscapeLeft) {
            orientation = AVCaptureVideoOrientation.LandscapeRight
            self.previewLayer.transform = CATransform3DMakeRotation(CGFloat(-M_PI)/CGFloat(2), 0, 0, 1)
           /// self.lensPreviewLayer.transform = CATransform3DMakeRotation(CGFloat(-M_PI)/CGFloat(2), 0, 0, 1)

        }else if UIDeviceOrientationIsLandscape(UIDeviceOrientation.LandscapeRight){
            self.previewLayer.transform = CATransform3DMakeRotation(CGFloat(M_PI)/CGFloat(2), 0, 0, 1)
           // self.lensPreviewLayer.transform = CATransform3DMakeRotation(CGFloat(M_PI)/CGFloat(2), 0, 0, 1)

        }
        if self.videoDataOutput.connectionWithMediaType(AVMediaTypeVideo).supportsVideoOrientation == true {
            self.videoDataOutput.connectionWithMediaType(AVMediaTypeVideo).videoOrientation = orientation
            
        }

        //Swap out the image for the Live Video FEED.
        previewLayer.frame = mainImageView.bounds;
        backgroundLayer.removeFromSuperlayer()
        backgroundLayer = self.previewLayer
        pilotsLayer.addSublayer(backgroundLayer)
        
        
        
         dispatch_async(dispatch_get_main_queue(), {
            self.session.startRunning();
        })
    }
    
    func captureOutput(captureOutput: AVCaptureStillImageOutput!, didOutputSampleBuffer sampleBuffer: CMSampleBuffer!, fromConnection connection: AVCaptureConnection!) -> UIImage{
    
        var image = UIImage()
        if let connection = captureOutput!.connectionWithMediaType(AVMediaTypeVideo) {
            captureOutput?.captureStillImageAsynchronouslyFromConnection(connection, completionHandler: {(sampleBuffer, error) in
                if (sampleBuffer != nil) {
                    let imageData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(sampleBuffer)
                    let dataProvider = CGDataProviderCreateWithCFData(imageData)
                    let cgImageRef = CGImageCreateWithJPEGDataProvider(dataProvider, nil, true, CGColorRenderingIntent.RenderingIntentDefault)
                    image = UIImage(CGImage: cgImageRef!, scale: 1.0, orientation: UIImageOrientation.Right)
                }
            })
        }
        return image
    }

    
    
    // clean up AVCapture
    func stopCamera(){
        
            session.stopRunning()
        
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
        
    }
    
    @IBAction func btnAutumn(sender: UIBarButtonItem) {
        
        
        drawBackgroundLayer(Float(sliderPowerOutlet.value), imageName: "autumn", savebg: true)
        currentBackgroundImageName = "autumn"
        currentAdd.image = UIImage(named: currentBackgroundImageName + "-v")
        ///imageLayer.addSublayer(currentAdd.layer)
        swapLensImage(blurRadius, swapToImage: currentBackgroundImageName)
       
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
        
        /*** SET THE BULGE AREA ***/
        let bulgx = lensShapelayer.position.x-112 //adjustment for the full image (sidebar).
        let bulgy = mainImageView.frame.height - (lensShapelayer.position.y+(lensShapelayer.frame.height/4))
        
        /*** set the MAGNIFY LAYER ***/
        magnifyLayer.removeFromSuperlayer()
        let img = magnifyImage(blurRadius,imageName: UIImage(named: currentBackgroundImageName + "-v")!, bulgeX: bulgx, bulgeY: bulgy, magSize: magSize, magScale: magScale)
      
        let image = UIImageView(image: img)
        magnifyLayer.addSublayer(image.layer)
        magnifyLayer.path = drawLensPath()
        imageLayer.addSublayer(magnifyLayer)
    }
    
    func swapMagnifyLayerALT(blurRadius:  Float){
        
           
        let bulgx = lensShapelayer.position.x - 112
        let bulgy = mainImageView.frame.height - (lensShapelayer.position.y+(lensShapelayer.frame.height/4))
        
        magnifyLayer.removeFromSuperlayer()
        let img = magnifyImage(blurRadius,imageName: UIImage(named: currentBackgroundImageName + "-v")!, bulgeX: bulgx, bulgeY: bulgy, magSize: magSize, magScale: magScale)
        let image = UIImageView(image: img)
        magnifyLayer.addSublayer(image.layer)
        magnifyLayer.path = drawLensPath()
        imageLayer.addSublayer(magnifyLayer)
    }

      
    
    
    func swapLensImage(blurRadius: Float, swapToImage: String){
      
        
   
            leftBlurLayer.removeFromSuperlayer()
            rightBlurLayer.removeFromSuperlayer()
        
            swapMagnifyLayer(blurRadius)
     
            let bulgx = lensShapelayer.frame.width-112 //adjustment for sidebar
            let bulgy = mainImageView.frame.height - (lensShapelayer.position.y+(lensShapelayer.frame.height/3))
        
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
        currentFilter.setValue(blurRadius*2, forKey: "inputRadius")
        
        let cgimg = context.createCGImage(currentFilter.outputImage!, fromRect: beginImage!.extent)
        return UIImage(CGImage: cgimg) //has to have the CGImage piece on the end!!!!!
        
    }
    
    
    let glContext = EAGLContext(API: .OpenGLES2)
    let transform = CGAffineTransformIdentity
    let clampFilter = CIFilter(name: "CIAffineClamp")!
    let bulgeFilter = CIFilter(name: "CIBumpDistortion")!

    func croppIngimage(imageToCrop:UIImage, toRect rect:CGRect) -> UIImage{
        
        let imageRef:CGImageRef = CGImageCreateWithImageInRect(imageToCrop.CGImage, rect)!
        var cropped:UIImage = UIImage(CGImage:imageRef)
        return cropped
    }
    
    
    func magnifyImage(blurRadius: Float,imageName: UIImage, bulgeX: CGFloat, bulgeY: CGFloat, magSize: Float, magScale: Float) ->UIImage{
        
        
        let beginImage = CIImage(image: imageName)
        
        
        
        clampFilter.setValue(beginImage!, forKey: "inputImage")
        clampFilter.setValue(NSValue(CGAffineTransform: transform), forKey: "inputTransform")
        
        bulgeFilter.setValue(clampFilter.outputImage!, forKey: "inputImage")
        //bulgeFilter.setValue((magSize*blurRadius)*magScale, forKey: "inputRadius")
        if (sliderAddOutlet.value>0) {
            bulgeFilter.setValue((40*(sliderAddOutlet.value+4))/magScale, forKey: "inputRadius")
        }else{
            bulgeFilter.setValue(0, forKey: "inputRadius")
        }
        bulgeFilter.setValue(CIVector(x: bulgeX, y: bulgeY), forKey: kCIInputCenterKey)
       // print("Mag:\(magScale)")
        //bulgeFilter.setValue(magScale, forKey: "inputScale")
        
        let cgimg = context.createCGImage(bulgeFilter.outputImage!, fromRect: beginImage!.extent)
        return UIImage(CGImage: cgimg) //has to have the CGImage piece on the end!!!!!


    }
    
 
    
    
    //TODO:  WRITE THIS TO SWING BOTH WAYS.
    /*      GRABS THE DATA POINTS FOR THE LENS SHAPE VARIATIONS
     *      */
    func drawShapePath(designId: Int, reverse: Bool)->CGPathRef{
        
        
        let shape = CGPathCreateMutable()
        let documentsURL = NSFileManager.defaultManager().URLsForDirectory(.ApplicationSupportDirectory, inDomains: .UserDomainMask)[0]
        let databasePath = documentsURL.URLByAppendingPathComponent("genie.db").path!
        let genieDB = FMDatabase(path: String(databasePath))
        
        if genieDB.open() {
            if (designId>0){
                //Grabe the values.
                
                let sql_stmt = "SELECT P1X, P1Y, C1X, C1Y, P2X, P2Y, C2X,C2Y,C3X,C3Y,P3X, P3Y, C4X, C4Y,C5X,C5Y, P4X,P4Y,C6X,C6Y from DESIGNPOINTS WHERE DESIGNID=\(designId)"
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
                        
                        
                        p1x = ((p1x+40)*10)-80
                        p1y = (-p1y+40)*10
                        p2x = ((p2x+40)*10)-80
                        p2y = (-p2y+40)*10
                        p3x = ((p3x+40)*10)-80
                        p3y = (-p3y+40)*10
                        p4x = ((p4x+40)*10)-80
                        p4y = (-p4y+40)*10
                        
                        
                        c1x = (c1x+40)*10-80
                        c1y = (-c1y+40)*10
                        c2x = (c2x+40)*10-80
                        c2y = (-c2y+40)*10
                        c3x = (c3x+40)*10-80
                        c3y = (-c3y+40)*10
                        c4x = (c4x+40)*10-80
                        c4y = (-c4y+40)*10
                        c5x = (c5x+40)*10-80
                        c5y = (-c5y+40)*10
                        c6x = (c6x+40)*10-80
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
                    
                    p1x = 800-((p1x+80)*10)+400+80
                    p1y = (-p1y+40)*10
                    p2x = 800-((p2x+80)*10)+400+80
                    p2y = (-p2y+40)*10
                    p3x = 800-((p3x+80)*10)+400+80
                    p3y = (-p3y+40)*10
                    p4x = 800-((p4x+80)*10)+400+80
                    p4y = (-p4y+40)*10
                    
                    
                    c1x = 800-((c1x+80)*10)+400+80
                    c1y = (-c1y+40)*10
                    c2x = 800-((c2x+80)*10)+400+80
                    c2y = (-c2y+40)*10
                    c3x = 800-((c3x+80)*10)+400+80
                    c3y = (-c3y+40)*10
                    c4x = 800-((c4x+80)*10)+400+80
                    c4y = (-c4y+40)*10
                    c5x = 800-((c5x+80)*10)+400+80
                    c5y = (-c5y+40)*10
                    c6x = 800-((c6x+80)*10)+400+80
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
    
    //Feed points are specific to Lens (redo this as generic)
    func drawHalfLensPath() ->CGPathRef {
        
        let lensPath = CGPathCreateMutable()
        CGPathMoveToPoint(lensPath, nil, 400, 0)
        CGPathAddLineToPoint(lensPath,nil,400,660)
        CGPathAddLineToPoint(lensPath,nil,-400,660)
        CGPathAddLineToPoint(lensPath,nil,-400,0)
        CGPathCloseSubpath(lensPath)
        return lensPath
        
    }

    
    
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
    
    func setUpLensShapeLayer(){
        
        
        //Stroke the outside of the LensShape.
        let strokeLensShapeLayer = drawStrokeLayer(drawLensPath(), strokeWidth:2.0)
        
        
        lensShapelayer.frame = pilotsLayer.bounds
        lensShapelayer.bounds = CGRect(x: 0, y: 0, width: pilotsLayer.frame.width, height: pilotsLayer.frame.height)
        let maskLayer = drawMaskLayer(UIColor.whiteColor().CGColor)
        lensShapelayer.contentsGravity = kCAGravityCenter
        lensShapelayer.fillColor = UIColor.clearColor().CGColor;
        lensShapelayer.mask = maskLayer
        lensShapelayer.path = strokeLensShapeLayer
        lensShapelayer.name = "lensShapelayer"
        //Add a non colored color layer (can be replaced using buttons : color).
        //Color Layer.
        let newColorLayer = drawMaskLayer(UIColor.whiteColor().CGColor)
        newColorLayer.fillColor = UIColor.clearColor().CGColor
        newColorLayer.fillRule = kCAFillRuleNonZero
        newColorLayer.zPosition = 7
        newColorLayer.opacity = 0.0
        colorLayer.addSublayer(newColorLayer)
        colorLayer.name = "colorLayer"
        
        //COLOR LAYER
        lensShapelayer.addSublayer(colorLayer)
        
        
        let strokeline = CAShapeLayer()
        strokeline.strokeColor = UIColor.whiteColor().CGColor
        strokeline.fillColor = UIColor.clearColor().CGColor
        strokeline.path = strokeLensShapeLayer
        strokeline.zPosition = 8
        strokeline.name = "OuterStrokeLine"
        lensShapelayer.addSublayer(strokeline)
        
        
        //MagnifyLayer: initially empty, will be set when user moves the sliderAdd.
        
        
        //Left stroke (stroke layer)
        leftLayer.contentsGravity = kCAGravityCenter
        leftLayer.path = drawShapePath(1,reverse: false)
        leftLayer.strokeColor = UIColor.yellowColor().CGColor
        leftLayer.fillColor = UIColor.clearColor().CGColor;
        leftLayer.lineWidth = 5.0
        leftLayer.zPosition = 6
        leftLayer.name = "leftStrokeLine"
        lensShapelayer.addSublayer(leftLayer)
        
        
        
        //  Stroke layer
        rightLayer.contentsGravity = kCAGravityCenter
        rightLayer.path = drawShapeMirrorPath(1,reverse:false)
        rightLayer.strokeColor = UIColor.yellowColor().CGColor
        rightLayer.fillColor = UIColor.clearColor().CGColor
        rightLayer.lineWidth = 5.0
        rightLayer.zPosition = 6
        rightLayer.name = "rightStrokeLine"
        lensShapelayer.addSublayer(rightLayer)
        
        //112 / 224 sidebar adjustments
        //LEFT & RIGHT DOTS (laser marks)
        let leftDot = drawPolygonLayer(((lensShapelayer.bounds.size.width-112)/2)/2-40, y: (lensShapelayer.bounds.size.height/2)+40, radius:12, sides: 360, color: UIColor.whiteColor())
        leftDot.fillColor = UIColor.clearColor().CGColor
        leftDot.lineWidth = 2.0
        leftDot.contentsGravity = kCAGravityCenter
        leftDot.strokeColor = UIColor.yellowColor().CGColor
        leftDot.zPosition = 9
        leftDot.name = "LeftDot"
        lensShapelayer.addSublayer(leftDot)
        let rightDot = drawPolygonLayer((lensShapelayer.bounds.size.width-224)-(lensShapelayer.bounds.size.width/2)/2+40, y: (lensShapelayer.bounds.size.height/2)+40, radius:12, sides: 360, color: UIColor.whiteColor())
        rightDot.strokeColor = UIColor.yellowColor().CGColor
        rightDot.fillColor = UIColor.clearColor().CGColor
        rightDot.lineWidth = 2.0
        rightDot.zPosition = 9
        rightDot.contentsGravity = kCAGravityCenter
        rightDot.name = "RightDot"
        lensShapelayer.addSublayer(rightDot)
        

        
    }

    
    //Sets all the LensShape layers DEFAULTS / CHANGE THE NAME OF THIS FUNCTION TO DEFAULT LAYERS
    func setDefaultLayers(imageName: UIImage){
        
        swapLensImage(blurRadius, swapToImage: currentBackgroundImageName)

        
        //Mask:  Apply Lens Shape
        let maskLayerForImage = drawMaskLayer(UIColor.whiteColor().CGColor)  // replace testing with this when you're ready.
        
        //Background Image has its own layer now.
        let img = UIImageView(image: imageName) //The vibrant version of the image name will be sent over.
        currentAdd = img
  
        
        //change : 02/03/2016 the imageLayer to CALayer from ShapeLayer
        //          Image layer holds the vibrant version of the background image
        //          It is then clipped / masked to the shape of the Lens.
        imageLayer.frame = pilotsLayer.bounds
        imageLayer.bounds = CGRect(x: 0, y: 0, width: pilotsLayer.frame.width, height: pilotsLayer.frame.height)
        imageLayer.contentsGravity = kCAGravityBottomLeft
        imageLayer.zPosition = 2
        imageLayer.mask = maskLayerForImage
        imageLayer.addSublayer(currentAdd.layer)
        imageLayer.name = "imageLayer";
        
        
        leftBlurLayer.frame = pilotsLayer.bounds
        leftBlurLayer.path = leftMask.path
        leftBlurLayer.bounds = CGRect(x: 0, y: 0, width: pilotsLayer.frame.width, height: pilotsLayer.frame.height)
        leftBlurLayer.fillRule = kCAFillRuleEvenOdd;
        leftBlurLayer.zPosition = 4
        leftBlurLayer.name = "leftBlurLayer"
        
        rightBlurLayer.frame = pilotsLayer.bounds
        rightBlurLayer.path = rightMask.path
        rightBlurLayer.bounds = CGRect(x: 0, y: 0, width: pilotsLayer.frame.width, height: pilotsLayer.frame.height)
        rightBlurLayer.fillRule = kCAFillRuleEvenOdd;
        rightBlurLayer.zPosition = 4
        rightBlurLayer.name = "rightBlurLayer"
        
        imageLayer.addSublayer(leftBlurLayer)
        imageLayer.addSublayer(rightBlurLayer)
        
        

    
        //Main layers :     Pilots layer or bottom background layer
        //                  BlurShape Layer holds the left and right blurs
        //                  imageLayer holds the image that moves...
        //                  magnifyLayer holds the blured images.
        //                  colorLayers (not currently implemented).
        
        pilotsLayer.addSublayer(imageLayer)
        
        
        setUpLensShapeLayer()
        
        magnifyLayer.frame = lensShapelayer.frame
        magnifyLayer.contentsGravity = kCAGravityCenter
        magnifyLayer.zPosition = 3
        magnifyLayer.mask = drawMaskLayer(UIColor.clearColor().CGColor)
        magnifyLayer.name = "magnifyLayer"
        imageLayer.addSublayer(magnifyLayer)

       
        
        
        
        leftMask.path = drawShapePath(1, reverse: false)
        rightMask.path = drawShapeMirrorPath(1, reverse: true)
        pilotsLayer.addSublayer(lensShapelayer)  // append the new layer to the pilotslayer
        lensShapelayer.zPosition = 3
        
        
    }
    
    @IBInspectable var counterColor: UIColor = UIColor.whiteColor()
    
    func drawThicknessShape(arc: CGFloat)->CAShapeLayer {
       
        
         let shapeWidth = CGFloat(500)
    
        let startingPoint = CGPointMake(50,thicknessLayer.frame.origin.y+(thicknessLayer.bounds.height/2))
        let finishingPoint = CGPointMake(shapeWidth-50,thicknessLayer.frame.origin.y+(thicknessLayer.bounds.height/2)) // 300 across.
        let curvePoint = CGPointMake(thicknessLayer.bounds.width/4,thicknessLayer.frame.origin.y) // make this the arc... dynamicit.
        
        let drawpath = CGPathCreateMutable()
        CGPathMoveToPoint(drawpath, nil, startingPoint.x, startingPoint.y)
        CGPathAddQuadCurveToPoint(drawpath, nil, curvePoint.x, curvePoint.y, finishingPoint.x, finishingPoint.y)
        CGPathAddLineToPoint(drawpath, nil, finishingPoint.x, finishingPoint.y+30)
        CGPathAddQuadCurveToPoint(drawpath,nil,curvePoint.x,curvePoint.y+30,startingPoint.x,startingPoint.y+30)
        
        let shape = CAShapeLayer()
        shape.path = drawpath
        shape.fillColor = UIColor.whiteColor().CGColor
       // shape.backgroundColor = UIColor.blackColor().CGColor
        shape.zPosition=4
        //fullBackgroundLayer.addSublayer(shape)
        return shape
    }
    
    
    /***    STATIC WIDTH SET TO 500     ***
    ****    LOCATION : Left or Right    ***
    ***     -9 : Thickest value.
    ***************************************/
    
    var leftLensShape = CALayer()
    var rightLensShape = CALayer()
    
    func drawPrescription(drawright: Bool, AddPower: CGFloat, refractiveIndex: String){
        
      
        let shapeWidth = CGFloat(500) // Static shape width.
        
        var tV = (10 - AddPower)
        let centerThickness = CGFloat(20) // the height distance of thickness at the center.
        var applyRefractiveIndex = CGFloat(3.5) // our default
        
        switch (refractiveIndex) {
            case "1.5":   applyRefractiveIndex = 3.5
            case "1.6":   applyRefractiveIndex = 3.25
            case "1.67":  applyRefractiveIndex = 3.0
            case "1.74":  applyRefractiveIndex = 2.5
            default:    applyRefractiveIndex = 3.5
        }

        var CurveSteepnessBottom = -(tV*applyRefractiveIndex)+centerThickness
        var curveSteepnessTop = CGFloat(50)
     
        
        if (AddPower>=0){
            //Refractive index applied to calculations before nullifying it for the "edges"...
            curveSteepnessTop = ((AddPower+1)*10)+(applyRefractiveIndex*5) // Steepness of top curve.
            CurveSteepnessBottom = +((AddPower+1)*5)+(applyRefractiveIndex*5)
            
            //NULLIFYING VALUES FOR THE END POINTS.
            tV = 1 // nullify
            applyRefractiveIndex = 1 // nullify (nullifies the "end points"... no more scaling these.
        }
        
        var startingPoint = CGPointMake(50,thicknessLayer.frame.origin.y+(thicknessLayer.bounds.height/2))
        var finishingPoint = CGPointMake(shapeWidth-50,thicknessLayer.frame.origin.y+(thicknessLayer.bounds.height/2)) // 300 across.
        var curvePoint = CGPointMake(thicknessLayer.bounds.width/4,startingPoint.y-curveSteepnessTop) // make this the arc.
        
     
        if drawright {
            startingPoint = CGPointMake(thicknessLayer.bounds.width-(shapeWidth-50),thicknessLayer.frame.origin.y+(thicknessLayer.bounds.height/2))
            finishingPoint = CGPointMake(thicknessLayer.bounds.width-(shapeWidth-450),thicknessLayer.frame.origin.y+(thicknessLayer.bounds.height/2))
            curvePoint = CGPointMake(thicknessLayer.bounds.width-(thicknessLayer.bounds.width/4),startingPoint.y-curveSteepnessTop)
        }
        
         //(1,2,3,4,5,6,7,8,9,10 turn negs into pos
        
        let drawpath = CGPathCreateMutable()
        CGPathMoveToPoint(drawpath, nil, startingPoint.x, startingPoint.y)
        //Affecting the curvepoint on the top
        CGPathAddQuadCurveToPoint(drawpath, nil, curvePoint.x, curvePoint.y, finishingPoint.x, finishingPoint.y)
        CGPathAddLineToPoint(drawpath, nil, finishingPoint.x, finishingPoint.y+(tV*applyRefractiveIndex))  //y point = right side height of edges of lens.
        CGPathAddQuadCurveToPoint(drawpath,nil,curvePoint.x,curvePoint.y+CurveSteepnessBottom,startingPoint.x,startingPoint.y+(tV*applyRefractiveIndex)) // startingPoint.y = left side height of lens
        CGPathCloseSubpath(drawpath)
        
        
        let shape = CAShapeLayer()
        shape.path = drawpath
        shape.fillColor = UIColor.whiteColor().CGColor
        shape.zPosition=4
        
        if drawright {
            rightLensShape.backgroundColor = UIColor.grayColor().CGColor
            rightLensShape.frame = CGRect(x:0,y:400,width:globalUIView.bounds.width,height:180)
            rightLensShape.bounds = thicknessLayer.frame
            rightLensShape.zPosition = 4
            rightLensShape.mask = shape
            thicknessLayer.addSublayer(rightLensShape)
        }else{
            leftLensShape.backgroundColor = UIColor.grayColor().CGColor
            leftLensShape.frame = CGRect(x:0,y:400,width:globalUIView.bounds.width,height:180)
            leftLensShape.bounds = thicknessLayer.frame
            leftLensShape.zPosition = 4
            leftLensShape.mask = shape
            thicknessLayer.addSublayer(leftLensShape)
        }
        
     }
  
    @IBOutlet weak var btnAntiReflection: UIButton!
    
    
    @IBOutlet weak var btnHardCoat: UIButton!
    @IBOutlet weak var btnHydrophop: UIButton!
    @IBOutlet weak var iconArrow: UIView!
    
    
    @IBOutlet weak var iCarosel: iCarousel!
    
    @IBAction func btnCoatings(sender: UIBarButtonItem) {

        panLens = false
        panTransitions = false
        panBackground = false
        
        
        mainImageView.hidden = false
        sidebarView.hidden = true
        Button1.hidden = false
        Button2.hidden = false
        Button3.hidden = false
        Button4.hidden = false
        
        //Turn off Thickness Layers
        prescriptionView.hidden = true
        lensLeftImage.hidden = true
        lensRightImage.hidden = true
        thicknessLayer.hidden = true
        
        //If the LensShape was removed via transitions or otherwise, add it back
        var hasLens = false
        if let sublayers = pilotsLayer.sublayers {
            
            for layer in sublayers {
                print(layer.name)
                if layer.name == "lensShapelayer"{
                    hasLens = true
                }
                
            }
        }
        if (!hasLens){
            
            setUpLensShapeLayer()
            pilotsLayer.addSublayer(lensShapelayer) // okay to add it now, its all set back up :)
        }
        
        colorLayer.opacity = 0.0
        
        removeNamedLayer(pilotsLayer, namedLayer: "handsLayer")
             //Make it fresh again.!
        handsLayer.frame = pilotsLayer.bounds
        handsLayer.bounds = pilotsLayer.bounds
        handsLayer.contents = UIImage(named: "with-without")!.CGImage
        handsLayer.contentsGravity = kCAGravityBottomLeft
        handsLayer.backgroundColor = UIColor.clearColor().CGColor
        handsLayer.zPosition = 3
        pilotsLayer.addSublayer(handsLayer)

      
        
        //Reposition lens back to center (turned off the "movement") so we can move the "coatingsLayer".
        lensShapelayer.position = initialLensPosition // return to start position.
        imageLayer.mask!.position = initialLensMaskPosition
        
        
        sliderAddOutlet.hidden = true
        sliderPowerOutlet.hidden = true
        lblAdd.hidden = true
        lblPower.hidden = true
        iCarosel.hidden = true
        
        btnHydrophop.hidden = false
        btnHardCoat.hidden = false
       // btnPhotochrom.hidden = false
        btnAntiReflection.hidden = false
        
        
        
        //Fire the default for this (hydro)
        btnHydrophop.sendActionsForControlEvents(.TouchUpInside)
        
    }
    
    
    @IBAction func btnProgressive(sender: UIBarButtonItem) {
        
        panLens = true
        currentBackgroundImageName = "progressive-bkg"
        mainImageView.hidden = false
        sidebarView.hidden = false
        Button1.hidden = false
        Button2.hidden = false
        Button3.hidden = false
        Button4.hidden = false
        iCarosel.hidden = false
        sliderPowerOutlet.hidden = false
        sliderAddOutlet.hidden = false
        lblAdd.hidden = false
        lblPower.hidden = false
        
        btnAntiReflection.hidden = true
        btnHydrophop.hidden = true
        btnHardCoat.hidden = true
        btnPhotochrom.hidden = true
        
        
        prescriptionView.hidden = true
        lensLeftImage.hidden = true
        lensRightImage.hidden = true
       
        removeNamedLayer(lensShapelayer, namedLayer: "lensBGImage")
        colorLayer.removeFromSuperlayer()
        coatingsLayer.removeFromSuperlayer()
        hydroLayer.removeFromSuperlayer()
        thicknessLayer.removeFromSuperlayer()
        handsLayer.removeFromSuperlayer()
        
        blurRadius = 0.0
        sliderAddOutlet.value = 0.0
        sliderPowerOutlet.value = 0.0
        
        
        //Reset the positions too
        lensShapelayer.position = initialLensPosition
        imageLayer.mask!.position = initialLensMaskPosition
        rightBlurLayer.mask!.position = initialRightBlurPosition
        leftBlurLayer.mask!.position = initialLeftBlurPosition
        
        drawBackgroundLayer(blurRadius, imageName: currentBackgroundImageName, savebg: true)
        setDefaultLayers(UIImage(named: currentBackgroundImageName + "-v")!)
        
    }
    
    
    @IBAction func btnTransitions(sender: UIBarButtonItem) {
        
        
        panLens = false
        panBackground = false
        
        panTransitions = true
        
        //Turn off Defaults
        mainImageView.hidden = false
        sidebarView.hidden = true
        Button1.hidden = true
        Button2.hidden = true
        Button3.hidden = true
        Button4.hidden = true
        btnHydrophop.hidden = true
        btnAntiReflection.hidden = true
        btnHardCoat.hidden = true
        btnPhotochrom.hidden = true
        globalImageView.hidden = true
        
        //Turn off Thickness Layers
        prescriptionView.hidden = true
        lensLeftImage.hidden = true
        lensRightImage.hidden = true
        thicknessLayer.hidden = true
        
        
        //If the LensShape was removed via transitions or otherwise, add it back
       
        var hasLens = false
        if let sublayers = pilotsLayer.sublayers {
            
            for layer in sublayers {
                print(layer.name)
                if layer.name == "lensShapelayer"{
                    hasLens = true
                }
            }
        }
        if (!hasLens){
            
            setUpLensShapeLayer()
            pilotsLayer.addSublayer(lensShapelayer) // okay to add it now, its all set back up :)
        }
        
        imageLayer.removeFromSuperlayer()
        hydroLayer.removeFromSuperlayer()
        coatingsLayer.removeFromSuperlayer()
        handsLayer.removeFromSuperlayer()
        
        removeNamedLayer(lensShapelayer, namedLayer:"lensBGImage")
        
        blurRadius = 0.0
        //Change the background image to the Bright one + 5 Blur radius please.
        drawBackgroundLayer(blurRadius, imageName: "transitions", savebg: false)
        
        colorLayer.removeFromSuperlayer()
        let ncolorLayer = drawMaskLayer(UIColor.whiteColor().CGColor)
        ncolorLayer.fillColor = UIColor.brownColor().CGColor
        ncolorLayer.fillRule = kCAFillRuleNonZero
        ncolorLayer.zPosition = 6
        ncolorLayer.opacity = 0.0
        colorLayer = ncolorLayer
        lensShapelayer.addSublayer(colorLayer)
        lensShapelayer.position.x = 512 + 96 // Center it.
        
        lastBackgroundPosition = CGPointMake(backgroundLayer.position.x,backgroundLayer.position.y)

        
        
    }
  
    @IBOutlet weak var sidebarView: UIView!
    @IBOutlet weak var globalImageView: UIImageView!
    @IBOutlet weak var prescriptionView: UIView!
    @IBOutlet weak var lensLeftImageView: UIImageView!
    
    func setUpThickness(){
        
        //Clear these out before setting them up... this gets called everytime the btnThickness gets calle.d
        
        lensLeftImage.frame = CGRect(x:370,y:120, width:100,height:80)
        lensLeftImage.bounds = CGRect(x:0,y:0,width:10,height:80)
        lensLeftImage.backgroundColor = UIColor.clearColor().CGColor
        lensLeftImage.contents = UIImage(named: "lensplus")!.CGImage
        lensLeftImage.zPosition = 4
        lensLeftImage.contentsGravity = kCAGravityResize
        
        self.fullBackgroundLayer.addSublayer(lensLeftImage)
        
        self.lensRightImage.frame = CGRect(x:555,y:120,width:100,height:80)
        lensRightImage.bounds = CGRect(x:0,y:0,width:10,height:80)
        lensRightImage.backgroundColor = UIColor.clearColor().CGColor
        lensRightImage.zPosition = 4
        lensRightImage.contents = UIImage(named: "lensplus-mirror")!.CGImage
        lensRightImage.contentsGravity = kCAGravityResize
        
        
        self.fullBackgroundLayer.addSublayer(lensRightImage)
        

        prescriptionLeftPicker.selectRow(0, inComponent: 0, animated: true)
        prescriptionLeftPicker.selectRow(10, inComponent: 1, animated: true)
        prescriptionRightPicker.selectRow(0, inComponent: 0, animated: true)
        prescriptionRightPicker.selectRow(10, inComponent: 1, animated: true)
        
        
        prescriptionLeftPicker.onPrescriptionSelected = { (prescription: Int, year: Int, titleForRow: String, prescriptionValue: String) in
            
            //Lens image that swaps out when user chooses the prescription
            
         //   self.fullBackgroundLayer.addSublayer(self.lensLeftImage)
            
            //Swap out the prescription drawing/rendering based on value selected by user.
            let addpower: Float = (titleForRow as NSString).floatValue
            self.drawPrescription(false, AddPower: CGFloat(addpower), refractiveIndex: prescriptionValue)
            //increment addpower to the width combined with resizeaspect grows the image.
            if ( Int(addpower) >= 0){
                self.lensLeftImage.frame = CGRect(x:370,y:120, width:100,height:80)
                self.lensLeftImage.contents = UIImage(named: "lensplus")!.CGImage
                self.lensLeftImage.bounds = CGRect(x:0,y:0,width:10+Int(addpower*2),height:80)
                
            }else{
                self.lensLeftImage.frame = CGRect(x:360,y:120, width:100,height:80)
                self.lensLeftImage.contents = UIImage(named: "lensminus")!.CGImage
                self.lensLeftImage.bounds = CGRect(x:0,y:0,width:10-Int(addpower*3),height:80)
                
            }
            
            
        }
        
        prescriptionRightPicker.onPrescriptionSelected = { (prescription: Int, year: Int, titleForRow: String, prescriptionValue: String) in
            
            
            
          //  self.fullBackgroundLayer.addSublayer(self.lensRightImage)
            
            //Swap out the prescription drawing/rendering based on value selected by user.
            let addpower: Float = (titleForRow as NSString).floatValue
            self.drawPrescription(true, AddPower: CGFloat(addpower), refractiveIndex: prescriptionValue)
            if (Int(addpower) >= 0){
                
                self.lensRightImage.frame = CGRect(x:550,y:120,width:100,height:80)
                self.lensRightImage.contents = UIImage(named: "lensplus-mirror")!.CGImage
                self.lensRightImage.bounds = CGRect(x:0,y:0,width:10+Int(addpower*2),height:80)
                
            }else{
                self.lensRightImage.frame = CGRect(x:555,y:120,width:100,height:80)
                self.lensRightImage.contents = UIImage(named: "lensminus-mirror")!.CGImage
                self.lensRightImage.bounds = CGRect(x:0,y:0,width:10-Int(addpower*2),height:80)
            }
            
            
        }

    }
    
    var plusMinusData = [String]()
    
    @IBAction func btnThickness(sender: UIBarButtonItem) {
        
        
        setUpThickness()
        
        ////Swap the global image out for the Thickness image and unhide thickness related dials.
        globalImageView.hidden = false
        globalImageView.image = UIImage(named: "woman")!
        mainImageView.hidden = true
        prescriptionView.hidden = false
        lensLeftImage.hidden = false
        lensRightImage.hidden = false
        thicknessLayer.hidden = false
        
        //Hide sidebar + buttons!
        sidebarView.hidden = true
        Button1.hidden = true
        Button2.hidden = true
        Button3.hidden = true
        Button4.hidden = true
        btnHydrophop.hidden = true
        btnHardCoat.hidden = true
        btnAntiReflection.hidden = true
        
        
        //remove nonapplicable layers.
       // imageLayer.removeFromSuperlayer()
        lensShapelayer.removeFromSuperlayer()
        backgroundLayer.removeFromSuperlayer() // Idea is to remove the "lens one" use the global one to assign the background iamge.
        handsLayer.removeFromSuperlayer()
        
        
        
        //Draw Default Thickness Shape.
        thicknessLayer.backgroundColor = UIColor.darkGrayColor().CGColor
        thicknessLayer.frame = CGRect(x:0,y:400,width:globalUIView.bounds.width,height:180)
        thicknessLayer.bounds = thicknessLayer.frame
        thicknessLayer.opacity = 0.9
        thicknessLayer.zPosition = 4
        drawPrescription(false, AddPower: -10, refractiveIndex: "1.5") // set to the default value of the dial
        drawPrescription(true, AddPower: -10, refractiveIndex: "1.5")
        fullBackgroundLayer.addSublayer(thicknessLayer)
        
        
        
    }
    
    
    @IBOutlet weak var prescriptionResult: UILabel!
    
    
    /***    DESCRIPTION:    BACKGROUND Layer Image:  the "-n" version, desaturated image
     ***    blurRadius:     Accepts blurRadius, as passed by the sliderPower
     ***    imageName:      Which image to use.
     ***    savebg:         Is this the "active" image
     ***/
    func drawBackgroundLayer(blurRadius: Float, imageName: String, savebg: Bool){
        
       backgroundLayer.removeFromSuperlayer()
       backgroundLayer.mask = nil
        
       // let glContext = EAGLContext(API: .OpenGLES2) moved to global for reuse.
        context = CIContext(EAGLContext: glContext,
            options: [
                kCIContextWorkingColorSpace: NSNull()
            ]
        )
        
        let clampFilter = CIFilter(name: "CIAffineClamp")!
        let currentFilter = CIFilter(name: "CIGaussianBlur")!
   
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
        
        
        //
        // change the extent : let cgimg = context.createCGImage(currentFilter.outputImage!, fromRect: beginImage.extent)
        let cgimg = context.createCGImage(currentFilter.outputImage!,fromRect: beginImage.extent)
        let processedImage = UIImage(CGImage: cgimg).CGImage //has to have the CGImage piece on the end!!!!!
        
       // pilotsLayer.zPosition = 1
       // pilotsLayer.backgroundColor = UIColor.whiteColor().CGColor
       // pilotsLayer.contentsGravity = kCAGravityBottomLeft
       // pilotsLayer.masksToBounds = true  //Important: tell this layer to be the boundary which cuts other layers (rect)
       // pilotsLayer.contents = processedImage (replaced with its own background Layer see not from 2/4/2016 below.
        
        //try adding background image to its own layer 2/4/2016.
        backgroundLayer.frame = mainImageView.bounds
        backgroundLayer.contentsGravity = kCAGravityBottomLeft
        backgroundLayer.contents = processedImage
        backgroundLayer.zPosition = 1
        pilotsLayer.addSublayer(backgroundLayer) // Our first layer on the pilots layer. #1
        
        
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
        var beginImage = CIImage(image: imageName) // full size.
        if savebg {
            currentBackground = imageName
        }
        
        //Chop the size down for the Progressive View.
      //  let imageSize = CGRect(x: 0, y: 0, width: 825, height: 660)
      //  let smallerImage = context.createCGImage(beginImage!, fromRect: imageSize)
        
        
        let transform = CGAffineTransformIdentity
        let clampFilter = CIFilter(name: "CIAffineClamp")!
        let currentFilter = CIFilter(name: "CIGaussianBlur")!
      //  let bulgeFilter = CIFilter(name: "CIBumpDistortion")!
        

        
        
        clampFilter.setValue(beginImage!, forKey: "inputImage")
        clampFilter.setValue(NSValue(CGAffineTransform: transform), forKey: "inputTransform")
        currentFilter.setValue(clampFilter.outputImage, forKey: "inputImage")
        currentFilter.setValue(blurRadius, forKey: "inputRadius")
        
        let cgimg = context.createCGImage(currentFilter.outputImage!, fromRect: beginImage!.extent)
       // let cgimg = context.createCGImage(currentFilter.outputImage!, fromRect: CGRectMake(0,0,800,660))

        let processedImage = UIImage(CGImage: cgimg).CGImage //has to have the CGImage piece on the end!!!!!
        
        //pilotsLayer.zPosition = 1
       // pilotsLayer.backgroundColor = UIColor.whiteColor().CGColor
       // pilotsLayer.contentsGravity = kCAGravityBottomLeft
       // pilotsLayer.masksToBounds = true  //Important: tell this layer to be the boundary which cuts other layers (rect)
       // pilotsLayer.contents = processedImage
        
        
        //try adding background image to its own layer 2/4/2016.
        backgroundLayer.frame = mainImageView.bounds
        backgroundLayer.contentsGravity = kCAGravityBottomLeft
        backgroundLayer.contents = processedImage
        backgroundLayer.zPosition = 1
        pilotsLayer.addSublayer(backgroundLayer) // Our first layer on the pilots layer. #1

        
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
    
    let lensLeftImage = CALayer()
    let lensRightImage = CALayer()

    override func viewDidAppear(animated: Bool)
    {
        
        
        blurRadius = 0.0
        drawBackgroundLayer(blurRadius, imageName: currentBackgroundImageName, savebg: true)
        setDefaultLayers(UIImage(named: currentBackgroundImageName + "-n")!)
     
        setBtn1FromDirectory(grabButtonImageName(1))
        setBtn2FromDirectory(grabButtonImageName(2))
        setBtn3FromDirectory(grabButtonImageName(3))
        setBtn4FromDirectory(grabButtonImageName(4))
        
        iCarosel.type = .Rotary
        iCarosel.dataSource = self
        iCarosel.centerItemWhenSelected = false
        iCarosel.reloadData()
        
        
        prescriptionLeftPicker = PrescriptionPickerView(frame: CGRect(x: fullBackgroundLayer.frame.width/4-150,y: 0,width: 300,height: 150))
        prescriptionRightPicker = PrescriptionPickerView(frame: CGRect(x: fullBackgroundLayer.frame.width-fullBackgroundLayer.frame.width/4-150,y: 0,width: 300,height: 150))
        
        prescriptionView.addSubview(prescriptionLeftPicker)
        prescriptionView.addSubview(prescriptionRightPicker)
        
        initialLensPosition = lensShapelayer.position // Set the initial Lens Position (we set it back when necessary
        initialLensMaskPosition = imageLayer.mask!.position
        initialLeftBlurPosition = leftBlurLayer.mask!.position
        initialRightBlurPosition = rightBlurLayer.mask!.position
        
        colorLayer.opacity = 0.0
        
        super.viewDidLoad()
        
        
    }
    
    
    @IBOutlet weak var btnProgressive: UIBarButtonItem!
    
    
   
    
    
    override func viewDidLoad(){
        
        //Turn off other layers buttons, et el.
        prescriptionView.hidden = true
        lensLeftImage.hidden = true
        lensRightImage.hidden = true
        btnAntiReflection.hidden = true
        btnHydrophop.hidden = true
        btnAntiReflection.hidden = true
        btnPhotochrom.hidden = true
        btnHardCoat.hidden = true
        btnAntiSmudge.hidden = true

        //Global Context
        context = CIContext(EAGLContext: glContext,
            options: [
                kCIContextWorkingColorSpace: NSNull()
            ]
        )

        
        
   }
    
    @IBOutlet weak var BottomToolbar: UIToolbar!
  
    
    
    func numberOfItemsInCarousel(carousel: iCarousel) -> Int {
        return carouselImages.count
    }
 
   var carouselImages = NSMutableArray(array: ["progressive-bkg-v","progressive-bkg2-v","progressive-bkg3-v","cockpit-v"])
    
   func carousel(carousel: iCarousel, viewForItemAtIndex index: Int, reusingView view: UIView?) -> UIView {
   
        let newButton = UIButton(type: UIButtonType.Custom)
    
        if (view == nil)  {
            let buttonImage = UIImage(named: "\(carouselImages.objectAtIndex(index))")
            newButton.exclusiveTouch = true
            newButton.setImage(buttonImage, forState: .Normal)
            newButton.frame = CGRectMake(0.0, 0.0, 171, 110)
            newButton.setBackgroundImage(buttonImage, forState: .Normal )
            newButton.backgroundColor = UIColor.clearColor()
            newButton.layer.borderWidth = 10.0
            newButton.layer.borderColor = (UIColor( red: 255, green:255, blue:255, alpha: 1.0 )).CGColor
            if (index == 0){
                newButton.addTarget(self, action: "btnProgress", forControlEvents: .TouchUpInside)
                newButton.setTitle("Progressive", forState: .Normal)
            }else if (index == 1){
                newButton.addTarget(self, action: "btnProgress2", forControlEvents: .TouchUpInside)
                newButton.setTitle("Progressive 2", forState: .Normal)

            } else if (index == 2){
                newButton.addTarget(self, action: "btnProgress3", forControlEvents: .TouchUpInside)
                newButton.setTitle("Progressive 3", forState: .Normal)
            } else if (index == 3){
                newButton.addTarget(self, action: "btnCockpit", forControlEvents: .TouchUpInside)
                newButton.setTitle("Cockpit", forState: .Normal)
            }
            /*
            else if (index == 6) {
                newButton.addTarget(self, action: "btnVideo", forControlEvents: .TouchUpInside)
                newButton.setTitle("Snapshot", forState: .Normal)
            }
            */

        }
              return newButton
    }
    
    func carousel(carousel: iCarousel, valueForOption option: iCarouselOption, withDefault value: CGFloat) -> CGFloat {
        
        if (option == .FadeMin) {
            return 1.0;
        } else if (option == .FadeMinAlpha)    {
            return 1.0;
        }
        return value;
    }

    
    
    
       override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
        
    }
    
    override func shouldAutorotate() -> Bool {
        return true
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return [UIInterfaceOrientationMask.LandscapeLeft,UIInterfaceOrientationMask.LandscapeRight]
    }


}

