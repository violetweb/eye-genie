//
//  ViewController.swift
//  Eye-Genie
//
//  Created by Ryan Maxwell on 2015-12-01.
//  Copyright © 2015 Bceen Ventures. All rights reserved.
//

import UIKit
import GLKit


class ViewController: UIViewController {

   
    
    let clampFilter = CIFilter(name: "CIAffineClamp")!
    let currentFilter = CIFilter(name: "CIGaussianBlur")!
    let bulgeFilter = CIFilter(name: "CIBumpDistortion")!
    let imgPilots = UIImage(named: "cockpit-n")
    let imgPilotsVib = UIImage(named: "cockpit-v")
    let imgPilotsBlur = UIImage(named: "cockpit-b")
    let imgSail = UIImage(named: "sailing")
    let imgAutumn = UIImage(named: "autumn")
    var currentBackground = UIImage(named: "cockpit-v")
    var currentAdd = UIImageView()
    var lensLayer = CALayer()
    var blurShapeLayer = CAShapeLayer()
    var lensShapelayer = CAShapeLayer()
    var magnifyLayer = CAShapeLayer()
    var colorLayer = CAShapeLayer()
    var cutStroke = CAShapeLayer()
    var leftLayer = CAShapeLayer()
    var rightLayer = CAShapeLayer()
    var leftMask =  CAShapeLayer()
    var rightMask = CAShapeLayer()
    var imageLayer = CAShapeLayer()
    var blurRadius: Float = 0
    var context: CIContext!
    var addSlider: Float = 0
    var currentPath = "Conventional"

    
    var pilotsLayer: CALayer{
        return mainImageView.layer
    }
    
    
    @IBOutlet weak var mainImageView: UIView!
    
    @IBAction func btnConventional(sender: AnyObject) {
        
        
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
        newRightLayer.path = drawStrokePath(180, x:920,y:400,radius: 480)
        newRightLayer.zPosition = 6
        newRightLayer.strokeColor = UIColor.yellowColor().CGColor
        newRightLayer.fillColor = UIColor.clearColor().CGColor;
        newRightLayer.lineWidth = 8.0
        rightLayer = newRightLayer
        lensShapelayer.addSublayer(rightLayer)
        
        
        leftMask.path = drawShapePath(1, reverse: false)
        rightMask.path = drawStrokePath(180, x:920, y:400, radius: 480)

    }
    
    
    @IBAction func btnJena(sender: AnyObject) {
    }
    
    
    @IBAction func btnJenaW(sender: AnyObject) {
        
        leftLayer.removeFromSuperlayer()
        let newLeftLayer = CAShapeLayer()
        newLeftLayer.path = drawStrokePath(180, x: -160, y: 400, radius: 480)
        newLeftLayer.zPosition = 6
        newLeftLayer.strokeColor = UIColor.yellowColor().CGColor
        newLeftLayer.fillColor = UIColor.clearColor().CGColor;
        newLeftLayer.lineWidth = 8.0
        leftLayer = newLeftLayer
        lensShapelayer.addSublayer(leftLayer)
        
        
        
        rightLayer.removeFromSuperlayer()
        let newRightLayer = CAShapeLayer()
        newRightLayer.path = drawStrokePath(180, x:1020,y:400,radius: 480)
        newRightLayer.zPosition = 6
        newRightLayer.strokeColor = UIColor.yellowColor().CGColor
        newRightLayer.fillColor = UIColor.clearColor().CGColor;
        newRightLayer.lineWidth = 8.0
        rightLayer = newRightLayer
        lensShapelayer.addSublayer(rightLayer)
        
        
        leftMask.path = drawStrokePath(180, x:-160, y:400, radius: 480)
        rightMask.path = drawStrokePath(180, x:1020, y:400, radius: 480)

        
    }
    
    
    @IBAction func btnJena4k(sender: AnyObject) {
        
        leftLayer.removeFromSuperlayer()
        let newLeftLayer = CAShapeLayer()
        newLeftLayer.path = drawStrokePath(180, x: -200, y: 400, radius: 480)
        newLeftLayer.zPosition = 6
        newLeftLayer.strokeColor = UIColor.yellowColor().CGColor
        newLeftLayer.fillColor = UIColor.clearColor().CGColor;
        newLeftLayer.lineWidth = 8.0
        leftLayer = newLeftLayer
        lensShapelayer.addSublayer(leftLayer)
        
        
        
        rightLayer.removeFromSuperlayer()
        let newRightLayer = CAShapeLayer()
        newRightLayer.path = drawStrokePath(180, x:1040,y:400,radius: 480)
        newRightLayer.zPosition = 6
        newRightLayer.strokeColor = UIColor.yellowColor().CGColor
        newRightLayer.fillColor = UIColor.clearColor().CGColor;
        newRightLayer.lineWidth = 8.0
        rightLayer = newRightLayer
        lensShapelayer.addSublayer(rightLayer)
        
        
        leftMask.path = drawStrokePath(180, x:-200, y:400, radius: 480)
        rightMask.path = drawStrokePath(180, x:1040, y:400, radius: 480)
        
        currentPath = "Jenna4K"

        
    }
    
    @IBAction func sliderAdd(sender: UISlider) {
        //Magnify layer : add this image to the magnify layer.
        blurRadius = sender.value
        swapLensImage(Float(blurRadius),swapToImage: currentBackground!)

    }
    
    @IBAction func sliderPower(sender: UISlider) {
        blurRadius = sender.value
        drawMainLayer(blurRadius, imageName: currentBackground!)
    }
 
    
 
    @IBOutlet weak var sliderAddOutlet: UISlider!
    
    @IBOutlet weak var sliderPowerOutlet: UISlider!
    
    @IBAction func btnCockpit(sender: UIBarButtonItem) {
        
        let blurRadius = Float(sliderPowerOutlet.value)
        drawMainLayer(blurRadius, imageName: UIImage(named: "cockpit-n")!)
        currentBackground = UIImage(named: "cockpit-v")
        //swapLensImage(Float(0), swapToImage: UIImage(named: "cockpit-v")!)
    }
    
    @IBAction func btnAutumn(sender: UIBarButtonItem) {
        let blurRadius = Float(sliderPowerOutlet.value)
        drawMainLayer(blurRadius, imageName: UIImage(named: "autumn-n")!)
        currentBackground = UIImage(named: "autumn")
       // swapLensImage(Float(0), swapToImage: UIImage(named: "autumn")!)
    }
    
    @IBAction func btnSailing(sender: UIBarButtonItem) {
        let blurRadius = Float(sliderPowerOutlet.value)
        drawMainLayer(blurRadius, imageName: UIImage(named: "sailing-n")!)
        currentBackground = UIImage(named: "autumn")
     //   swapLensImage(Float(0), swapToImage: UIImage(named: "sailing")!)

    }
    
    func swapLensImage(blurRadius: Float, swapToImage: UIImage){
        //Magnify layer : add this image to the magnify layer.
        
        let img = magnifyImage(blurRadius,imageName: swapToImage)
        let image = UIImageView(image: img)
        
        magnifyLayer.addSublayer(image.layer) //
        let blurimg = UIImageView(image: blurImg(blurRadius, imageName: image.image!))
        let leftimg = UIImageView(image: blurImg(blurRadius, imageName: image.image!))
        
        let leftBlurLayer = CAShapeLayer()
        leftBlurLayer.zPosition = 5
        leftBlurLayer.path = leftLayer.path
        leftBlurLayer.fillColor = UIColor.clearColor().CGColor
        leftBlurLayer.addSublayer(leftimg.layer)
        leftLayer.mask = leftMask
        leftLayer.addSublayer(leftBlurLayer)
        
        let strokeLeft = drawStrokeLayer(leftMask.path!,strokeWidth: 8.0)
        let strokelineLeft = CAShapeLayer()
        strokelineLeft.strokeColor = UIColor.yellowColor().CGColor
        strokelineLeft.path = strokeLeft
        strokelineLeft.lineWidth = 8.0
        strokelineLeft.zPosition = 9
        leftLayer.addSublayer(strokelineLeft)
        
        
        let rightBlurLayer = CAShapeLayer()
        rightBlurLayer.zPosition = 5
        rightBlurLayer.path = rightLayer.path
        rightBlurLayer.fillColor = UIColor.clearColor().CGColor
        rightBlurLayer.addSublayer(blurimg.layer)
        rightLayer.mask = rightMask
        rightLayer.addSublayer(rightBlurLayer)
        
        let strokeRight = drawStrokeLayer(rightMask.path!,strokeWidth: 8.0)
        let strokelineRight = CAShapeLayer()
        strokelineRight.strokeColor = UIColor.yellowColor().CGColor
        strokelineRight.lineWidth = 8.0
        strokelineRight.path = strokeRight
        strokelineRight.zPosition = 9.0
        rightLayer.addSublayer(strokelineRight)
        
        lensShapelayer.addSublayer(magnifyLayer)
        
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
        
        clampFilter.setValue(beginImage!, forKey: "inputImage")
        clampFilter.setValue(NSValue(CGAffineTransform: transform), forKey: "inputTransform")
        
        currentFilter.setValue(clampFilter.outputImage!, forKey: "inputImage")
        currentFilter.setValue(blurRadius, forKey: "inputRadius")
        
        let cgimg = context.createCGImage(currentFilter.outputImage!, fromRect: beginImage!.extent)
        return UIImage(CGImage: cgimg) //has to have the CGImage piece on the end!!!!!
        
    }
    
    func magnifyImage(blurRadius: Float,imageName: UIImage)->UIImage {
        
        let glContext = EAGLContext(API: .OpenGLES2)
        context = CIContext(EAGLContext: glContext,
            options: [
                kCIContextWorkingColorSpace: NSNull()
            ]
        )
        
        let beginImage = CIImage(image: imageName)
        let transform = CGAffineTransformIdentity
        
        clampFilter.setValue(beginImage!, forKey: "inputImage")
        clampFilter.setValue(NSValue(CGAffineTransform: transform), forKey: "inputTransform")
        
        //  currentFilter.setValue(clampFilter.outputImage!, forKey: "inputImage")
        //   currentFilter.setValue(blurRadius, forKey: "inputRadius")
        
        bulgeFilter.setValue(clampFilter.outputImage!, forKey: "inputImage")
        bulgeFilter.setValue(30*blurRadius, forKey: "inputRadius")
        bulgeFilter.setValue(CIVector(x: 860/2, y: 140), forKey: kCIInputCenterKey)
        bulgeFilter.setValue(1, forKey: "inputScale")
        
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
                
                let sql_stmt = "SELECT P1X, P1Y, C1X, C1Y, P2X, P2Y, C2X,C2Y,C3X,C3Y,P3X, P3Y, C4X, C4Y,C5X,C5Y, P4X,P4Y,C6X,C6Y from DESIGNPOINTS WHERE DESIGNID=1"
                print(sql_stmt)
                let results:FMResultSet? = genieDB.executeQuery(sql_stmt, withArgumentsInArray: nil)
               
                if ((results?.next()) != nil) {
                    print("pre-results next")
                    
                    while results?.next() == true {
                        
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
                        
                        
                        print(p1x)
                        print(p1y)
                        print(p2x)
                        print(p2y)
                        CGPathMoveToPoint(shape, nil, p1x, p1y)
                        CGPathAddCurveToPoint(shape, nil, c1x, c1y, c2x, c2y, p2x, p2y)
                        CGPathAddCurveToPoint(shape, nil, c3x, c3y, c4x, c4y, p3x, p3y)
                        CGPathAddCurveToPoint(shape, nil, c5x, c5y, c6x, c6y, p4x, p4y)
                      
                    }
                }else{
                    print("No results")
                }
            }else{
                print("NIL RESULTS")
            }
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
        
        //var points = polygonPointArray(16, x:x,y:y,radius:480)
        
        CGPathMoveToPoint(drawpath,nil,points[points.count-1].x,points[points.count-1].y)
        
        for p in points{
            CGPathAddLineToPoint(drawpath,nil,p.x,p.y)
            
            //pull values out of the items at every 16th... and quad your way around (first test).
            
        }
        
        //  var curves = [CGFloat(2),CGFloat(2),CGFloat(2),CGFloat(2),CGFloat(2),CGFloat(2),CGFloat(2),CGFloat(2),CGFloat(2),CGFloat(2),CGFloat(2),CGFloat(2),CGFloat(2),CGFloat(2),CGFloat(2),CGFloat(2)]
        // var i = 0
        // for p in points {
        
        //   CGPathAddQuadCurveToPoint(drawpath,nil,p.x/curves[i],p.y/curves[i],p.x,p.y)
        //    i++
        // }
        
        return drawpath
    }
    

    
    //Sets all the LensShape layers DEFAULTS / CHANGE THE NAME OF THIS FUNCTION TO DEFAULT LAYERS
    func setDefaultLayers(imageName: UIImage){
        
        
        //Pilots (Vibrance)
        let img = UIImageView(image: imageName) //change this to the eyeglasses, /lens glass image.
        currentAdd = img
        lensShapelayer.frame = pilotsLayer.bounds
        lensShapelayer.bounds = CGRect(x: 0, y: 0, width: pilotsLayer.frame.width, height: pilotsLayer.frame.height)
        lensShapelayer.contentsGravity = kCAGravityCenter
        currentAdd.layer.zPosition = 3
        
        lensShapelayer.addSublayer(currentAdd.layer) //add pilots image (vib version) to this layer
        lensShapelayer.addSublayer(imageLayer)
        
        //Mask:  Apply Lens Shape
        let maskLayer = drawMaskLayer(UIColor.whiteColor().CGColor)  // replace testing with this when you're ready.
        lensShapelayer.mask = maskLayer
        
        
        //Add a non colored color layer (can be replaced using buttons : color).
        //Color Layer.
        let newColorLayer = drawMaskLayer(UIColor.whiteColor().CGColor)
        newColorLayer.fillColor = UIColor.whiteColor().CGColor
        newColorLayer.fillRule = kCAFillRuleNonZero
        newColorLayer.zPosition = 7
        newColorLayer.opacity = 0.0
        
        
        //COLOR LAYER
        lensShapelayer.addSublayer(colorLayer)
        
        //Stroke the outside of the LensShape.
        let strokeLensShapeLayer = drawStrokeLayer(drawLensPath(), strokeWidth:2.0)
        let strokeline = CAShapeLayer()
        strokeline.strokeColor = UIColor.whiteColor().CGColor
        strokeline.path = strokeLensShapeLayer
        strokeline.zPosition = 8
        lensShapelayer.addSublayer(strokeline)
        
        
        //MagnifyLayer: initially empty, will be set when user moves the sliderAdd.
        magnifyLayer.contentsGravity = kCAGravityCenter
        magnifyLayer.zPosition = 4
        lensShapelayer.addSublayer(magnifyLayer)
        
        
        //Left Shape (stroke layer)
        leftLayer.contentsGravity = kCAGravityCenter
        leftLayer.path = drawShapePath(1,reverse: false)
        leftLayer.strokeColor = UIColor.yellowColor().CGColor
        leftLayer.fillColor = UIColor.clearColor().CGColor;
        leftLayer.lineWidth = 8.0
        leftLayer.zPosition = 6
        lensShapelayer.addSublayer(leftLayer)
        
        
        
        //  Stroke layer
        rightLayer.contentsGravity = kCAGravityCenter
      //  rightLayer.path = drawRightPath(665,ystart:50, cp:430, yp:380, x:550, y:600, numPoints:4)
        
        
        rightLayer.path = drawStrokePath(180, x:980,y:400,radius: 480)
        rightLayer.strokeColor = UIColor.yellowColor().CGColor
        rightLayer.fillColor = UIColor.clearColor().CGColor
        rightLayer.lineWidth = 8.0
        rightLayer.zPosition = 6
        lensShapelayer.addSublayer(rightLayer)
        
        
        //LEFT & RIGHT DOTS (laser marks)
        let leftDot = drawPolygonLayer((lensShapelayer.bounds.size.width/2)/2, y: (lensShapelayer.bounds.size.height/2), radius:5, sides: 360, color: UIColor.yellowColor())
        leftDot.zPosition = 9
        lensShapelayer.addSublayer(leftDot)
        let rightDot = drawPolygonLayer(lensShapelayer.bounds.size.width-(lensShapelayer.bounds.size.width/2)/2, y: (lensShapelayer.bounds.size.height/2), radius:5, sides: 360, color: UIColor.yellowColor())
        rightDot.zPosition = 9
        lensShapelayer.addSublayer(rightDot)
        
        
        //After adding everything to the lens shape... now add this to the CAlayer TopLayer
        lensLayer.addSublayer(lensShapelayer) // testing to see if adding to a CALayer will allow me to pinch size.
        
        
        leftMask.path = drawShapePath(1, reverse: false)
        rightMask.path = drawShapePath(1, reverse: true)
        currentBackground = UIImage(named: "cockpit-v")
         
        pilotsLayer.addSublayer(lensShapelayer)  // append the new layer to the pilotslayer
        lensShapelayer.zPosition = 2
        
        
        
    }

    
    //Function takes "blurRadius" and renders a gaussian blur to the background image.
    func drawMainLayer(blurRadius: Float, imageName: UIImage){
        
        let glContext = EAGLContext(API: .OpenGLES2)
        context = CIContext(EAGLContext: glContext,
            options: [
                kCIContextWorkingColorSpace: NSNull()
            ]
        )
       
        //Set this to current background.
        let beginImage = CIImage(image: imageName)
        currentBackground = imageName
       
        
        let transform = CGAffineTransformIdentity
        clampFilter.setValue(beginImage!, forKey: "inputImage")
        clampFilter.setValue(NSValue(CGAffineTransform: transform), forKey: "inputTransform")
        currentFilter.setValue(clampFilter.outputImage, forKey: "inputImage")
        currentFilter.setValue(blurRadius, forKey: "inputRadius")
        
        
        let cgimg = context.createCGImage(currentFilter.outputImage!, fromRect: beginImage!.extent)
        let processedImage = UIImage(CGImage: cgimg).CGImage //has to have the CGImage piece on the end!!!!!
        
        pilotsLayer.zPosition = 1
        pilotsLayer.backgroundColor = UIColor.blackColor().CGColor
        pilotsLayer.contentsGravity = kCAGravityBottomLeft
        pilotsLayer.masksToBounds = true  //Important: tell this layer to be the boundary which cuts other layers (rect)
        pilotsLayer.contents = processedImage
        
        
    }
    override func viewDidAppear(animated: Bool)
    {
        drawMainLayer(0.0,imageName: imgPilots!)
        setDefaultLayers(imgPilotsVib!)
       // resetColor()
        
        
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

