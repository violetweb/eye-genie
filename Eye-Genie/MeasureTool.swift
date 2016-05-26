//
//  ReferencePoint.swift
//  EyeGenie
//
//  Created by Valerie Trotter
//  Copyright © 2016 Bceen Ventures. All rights reserved.
//

import Foundation
import UIKit
import CoreGraphics


class MeasureTool {
    
    
    var target: CALayer?
    
    
    
    var fillColor: UIColor = UIColor.clearColor() {
        didSet {
            self.measureTool.fillColor = self.fillColor.CGColor
        }
    }
    
    var borderWidth: CGFloat? = 1.0 {
        didSet {
            self.measureTool.borderWidth = self.borderWidth!
        }
    }
    
    var borderColor: UIColor = UIColor.blackColor() {
        didSet {
            self.measureTool.borderColor = self.borderColor.CGColor
        }
    }
    
    
    var radius: CGFloat? = 100.0 {
        didSet {
            //self.draw()
        }
    }
    
    var opacity: Float = 0.0 {
        didSet {
            self.measureTool.opacity = self.opacity
            
        }
    }
    
    
    var measureTool: CAShapeLayer  {
        didSet{
            self.measureTool = drawMeasureTool();
        }
    }
    
    
    
    
    /*
    init(drawIn: CALayer,fillColor: UIColor, borderWidth: CGFloat, borderColor: UIColor, radius: CGFloat, opacity: Float) {
        self.target = drawIn
        self.fillColor = fillColor
        self.borderWidth = borderWidth
        self.borderColor = borderColor
        self.radius = radius
        self.opacity = opacity
        self.measureTool = CAShapeLayer()
        self.rightEye = CGPointZero
        self.leftEye = CGPointZero
        self.faceParams = CGRect()
        self.topPosition = CGPointZero
        self.bottomPosition = CGPointZero
        self.leftPosition = CGPointZero
        self.rightPosition = CGPointZero
        self.innerLeftPosition = CGPointZero
        self.innerRightPosition = CGPointZero
        self.topPosition = CGPointZero
        self.bottomPosition = CGPointZero
        self.leftPosition = CGPointZero
        self.rightPosition = CGPointZero
        self.centerLinePosition = CGPointZero
        self.outerLeftPosition = CGPointZero
        self.outerRightPosition = CGPointZero

      
    }
    */
    init() {
       
        self.fillColor = UIColor.blackColor()
        self.borderWidth = 1.0
        self.borderColor = UIColor.blackColor()
        self.radius = 10
        self.opacity = 1.0
        self.measureTool = CAShapeLayer()
        self.rightEye = CGPointZero
        self.leftEye = CGPointZero
        self.faceParams = CGRect()
        self.topPosition = CGPointZero
        self.bottomPosition = CGPointZero
        self.leftPosition = CGPointZero
        self.rightPosition = CGPointZero
        self.innerLeftPosition = CGPointZero
        self.innerRightPosition = CGPointZero
        self.topPosition = CGPointZero
        self.bottomPosition = CGPointZero
        self.leftPosition = CGPointZero
        self.rightPosition = CGPointZero
        self.centerLinePosition = CGPointZero
        self.outerLeftPosition = CGPointZero
        self.outerRightPosition = CGPointZero
        self.leftEyePosition = CGPointZero
        self.rightEyePosition = CGPointZero
        
    }

    
    func setTopLinePosition(topPos: CGPoint){
        
        self.topPosition = topPos
    }
    
    func setBottomLinePosition(bottomPos: CGPoint){
        
        self.bottomPosition = bottomPos
    }
    
    func getTopLinePosition()->CGPoint{
        
        return self.topPosition
    }
    
    
    func getBottomLinePosition()->CGPoint{
        
        return self.bottomPosition
    }
    
    func setLeftEyePosition(pos: CGPoint){
        self.leftEyePosition = pos
    }
    func getLeftEyePosition()->CGPoint{
        return self.leftEyePosition
    }
    
    func setRightEyePosition(pos: CGPoint){
        self.rightEyePosition = pos
    }
    func getRightEyePosition()->CGPoint{
        return self.rightEyePosition
    }
   
    
    var leftEyePosition: CGPoint
    var rightEyePosition: CGPoint
    
    
    var topPosition: CGPoint
    var bottomPosition: CGPoint
    var leftPosition: CGPoint
    var rightPosition: CGPoint
    
    //actually not using this.
    private func drawMeasureTool()->CAShapeLayer {
        
        //Call all the other tools.
      //  let top = drawTopLine()
      //  topPosition = top.position
        
        //let bottom = drawBottomLine()
        //bottomPosition = bottom.position
        
        let shape = CAShapeLayer()
        return shape
   }
    
    func drawPupil(radius: CGFloat, eyePosition: CGPoint)->UIButton{
        
        
        let frame = CGSize(width:80, height:80)
        UIGraphicsBeginImageContext(frame)
      
        let ctx = UIGraphicsGetCurrentContext();
        var circleRect = CGRectMake(0, 0, 80, 80);
        circleRect = CGRectInset(circleRect, 2.0, 2.0);
        
        CGContextStrokeEllipseInRect(ctx, circleRect)
        
        
        //2
        CGContextBeginPath(ctx);
        CGContextMoveToPoint(ctx, 40.0, 1.0);
        CGContextAddLineToPoint(ctx, 40.0, 79.0);
        CGContextMoveToPoint(ctx, 1.0, 40.0);
        CGContextAddLineToPoint(ctx, 79.0, 40.0)
        CGContextSetLineWidth(ctx, 1);
        CGContextStrokePath(ctx);

        // Fill
        //4 color
        let colorspace = CGColorSpaceCreateDeviceRGB();
        let components = [CGFloat(204.0/255.0), CGFloat(0.0), CGFloat(0.0), CGFloat(1.0)]
        let color = CGColorCreate(colorspace, components);
        
        
        let image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext()
        
        let button = UIButton(type: UIButtonType.Custom)
        button.setImage(image,forState: .Normal)
        button.bounds = CGRectMake(0,0,100,100)
        button.frame = CGRectMake(eyePosition.x,eyePosition.y,100,100)
        button.exclusiveTouch = true
        button.userInteractionEnabled = true
        button.addTarget(self, action: Selector("imageDrag:event:"), forControlEvents: .TouchDown)
        button.addTarget(self, action: Selector("imageDrag:event:"), forControlEvents: .TouchDragInside)
        button.addTarget(self, action: Selector("imageDrag:event:"), forControlEvents: .TouchDragOutside)
        button.addTarget(self, action: Selector("imageDrag:event:"), forControlEvents: .TouchDragEnter)
        
        return button
        
    }
    
    
    
    func drawReferencePoint(position: CGFloat)->UIButton{
        
        
        let frame = CGSize(width:80, height:80)
        UIGraphicsBeginImageContext(frame)
        //UIGraphicsBeginImageContextWithOptions(size, !hasAlpha, scale)
        
        let ctx = UIGraphicsGetCurrentContext();
        
        let myRect = CGRectMake(0, 0, 80, 80);
        //2
        CGContextBeginPath(ctx);
        CGContextMoveToPoint(ctx, 40.0, 1.0);
        CGContextAddLineToPoint(ctx, 40.0, 79.0);
        CGContextMoveToPoint(ctx, 1.0, 40.0);
        CGContextAddLineToPoint(ctx, 79.0, 40.0)
        CGContextSetLineWidth(ctx, 1);
        CGContextStrokePath(ctx);
       
        
        
        // Fill
        //4 color
        let colorspace = CGColorSpaceCreateDeviceRGB();
        let components = [CGFloat(204.0/255.0), CGFloat(0.0/255.0), CGFloat(0.0/255.0), CGFloat(1.0)]
        let color = CGColorCreate(colorspace, components);
        
      
        let loupeImage = UIImage(named: "loupe-mask@2x.png")
        loupeImage!.drawInRect(myRect)
        
        //image!.drawInRect(myRect)
        
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        
       
        UIGraphicsEndImageContext()
        
        let button = UIButton(type: UIButtonType.Custom)
        button.setImage(scaledImage,forState: .Normal)
        button.bounds = CGRectMake(0,0,100,100)
        button.frame = CGRectMake(position,50,100,100)
        button.exclusiveTouch = true
        button.userInteractionEnabled = true
        button.addTarget(self, action: Selector("referenceDrag:event:"), forControlEvents: .TouchDown)
        button.addTarget(self, action: Selector("referenceDrag:event:"), forControlEvents: .TouchDragInside)
        button.addTarget(self, action: Selector("referenceDrag:event:"), forControlEvents: .TouchDragOutside)
        button.addTarget(self, action: Selector("referenceDrag:event:"), forControlEvents: .TouchDragEnter)
        
        return button
        
    }

    
    
    
    var centerLinePosition: CGPoint
    var innerLeftPosition: CGPoint
    var innerRightPosition: CGPoint
    var outerLeftPosition: CGPoint
    var outerRightPosition: CGPoint
    
    
   func drawCenterLine() ->UIButton {
        
        
        let frame = CGSize(width: 50, height: 50)
        
        UIGraphicsBeginImageContext(frame)
        let ctx = UIGraphicsGetCurrentContext();
        
        //2
        CGContextBeginPath(ctx);
        CGContextMoveToPoint(ctx, 25.0, 0.0);
        CGContextAddLineToPoint(ctx, 25.0, 50.0);
        CGContextSetLineWidth(ctx, 1);
        
        //3
        CGContextClosePath(ctx);
        CGContextStrokePath(ctx);
        let image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext()
        
        
        
        let button = UIButton(type: UIButtonType.Custom)
        button.bounds = CGRectMake(0,0,3,50)
        button.frame = CGRectMake(UIScreen.mainScreen().bounds.width/2,100,50,50)
        button.setImage(image,forState: .Normal)
        button.exclusiveTouch = true
        return button

        
    }
    
    private func leftPositionToCenter(itemWidth: CGFloat)->CGFloat{
        
        return CGFloat((UIScreen.mainScreen().bounds.width - itemWidth)/2)
        
    }
    
    //manually set based on the UI View being 970, with 50 on each side.
    let horizontalLineWidth = CGFloat(924.0) // 50 on each side.
    
    
    
    func drawTopLine() ->UIButton {
        
        
        let frame = CGSize(width: horizontalLineWidth, height: 50)
        
        UIGraphicsBeginImageContext(frame)
        let ctx = UIGraphicsGetCurrentContext();
        
        //2
        CGContextBeginPath(ctx);
        CGContextMoveToPoint(ctx, 0.0, 25.0);
        CGContextAddLineToPoint(ctx, horizontalLineWidth, 25.0);
        CGContextSetLineWidth(ctx, 1);
        
        //3
        CGContextClosePath(ctx); 
        CGContextStrokePath(ctx);
        let image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext()
        
        
        let button = UIButton(type: UIButtonType.Custom)
        button.setImage(image,forState: .Normal)
        button.bounds = CGRectMake(0,0,horizontalLineWidth,50)
        
        button.frame = CGRectMake(50,100,horizontalLineWidth,50)
        button.exclusiveTouch = true
        button.userInteractionEnabled = true
        button.addTarget(self, action: Selector("buttonDragHorizontal:event:"), forControlEvents: .TouchDown)
        button.addTarget(self, action: Selector("buttonDragHorizontal:event:"), forControlEvents: .TouchDragInside)
        button.addTarget(self, action: Selector("buttonDragHorizontal:event:"), forControlEvents: .TouchDragOutside)
        button.addTarget(self, action: Selector("buttonDragHorizontal:event:"), forControlEvents: .TouchDragEnter)
        
      
        
        return button

        
    }
    
    
    
    
    func drawBottomLine()->UIButton {
        
        
        let frame = CGSize(width: horizontalLineWidth, height: 50)
        
        UIGraphicsBeginImageContext(frame)
        let ctx = UIGraphicsGetCurrentContext();
        
        //2
        CGContextBeginPath(ctx);
        CGContextMoveToPoint(ctx, 0.0, 25.0);
        CGContextAddLineToPoint(ctx, horizontalLineWidth, 25.0);
        CGContextSetLineWidth(ctx, 1);
        
        //3
        CGContextClosePath(ctx);
        CGContextStrokePath(ctx);
        let image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext()
        
        
        let button = UIButton(type: UIButtonType.Custom)
        button.setImage(image,forState: .Normal)
        button.bounds = CGRectMake(0,0,horizontalLineWidth,50)
        button.frame = CGRectMake(50,350,horizontalLineWidth,50)
        button.exclusiveTouch = true
        button.userInteractionEnabled = true
        button.addTarget(self, action: Selector("buttonDragHorizontal:event:"), forControlEvents: .TouchDown)
        button.addTarget(self, action: Selector("buttonDragHorizontal:event:"), forControlEvents: .TouchDragInside)
        button.addTarget(self, action: Selector("buttonDragHorizontal:event:"), forControlEvents: .TouchDragOutside)
        button.addTarget(self, action: Selector("buttonDragHorizontal:event:"), forControlEvents: .TouchDragEnter)
        
        
        
        return button
    }
    

    
    func drawOuterLeftLine()->UIButton {
        
        
        let frame = CGSize(width: 50, height: 525)
        
        UIGraphicsBeginImageContext(frame)
        let ctx = UIGraphicsGetCurrentContext();
        
        //Define the line in 2d space.
        CGContextBeginPath(ctx);
        CGContextMoveToPoint(ctx, 25.0, 0.0);
        CGContextAddLineToPoint(ctx, 25.0, 525.0);
        CGContextSetLineWidth(ctx, 1);
       
        //3. close
        CGContextClosePath(ctx);
        
        //4 color
        let colorspace = CGColorSpaceCreateDeviceRGB();
        let components = [CGFloat(0.0), CGFloat(102.0/255.0), CGFloat(204.0/255.0), CGFloat(1.0)]
        let color = CGColorCreate(colorspace, components);
        
        //5 stroke.
        CGContextSetStrokeColorWithColor(ctx,  color);
        CGContextStrokePath(ctx);
        
        //6 capture this as an image.
        let image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext()
        
        
        //7 assign image to the button.
        let button = UIButton(type: UIButtonType.Custom)
        button.setImage(image,forState: .Normal)
        button.bounds = CGRectMake(0,0,50,525)
        button.frame = CGRectMake(76,25,50,525)
        button.exclusiveTouch = true
        button.userInteractionEnabled = true
        button.addTarget(self, action: Selector("buttonDragVertical:event:"), forControlEvents: .TouchDown)
        button.addTarget(self, action: Selector("buttonDragVertical:event:"), forControlEvents: .TouchDragInside)
        button.addTarget(self, action: Selector("buttonDragVertical:event:"), forControlEvents: .TouchDragOutside)
        button.addTarget(self, action: Selector("buttonDragVertical:event:"), forControlEvents: .TouchDragEnter)
        
        
        
        return button
    }
    
    func drawInnerLeftLine()->UIButton {
        
        
        let frame = CGSize(width: 50, height: 525)
        
        UIGraphicsBeginImageContext(frame)
        let ctx = UIGraphicsGetCurrentContext();
        
        //2
        CGContextBeginPath(ctx);
        CGContextMoveToPoint(ctx, 25.0, 0.0);
        CGContextAddLineToPoint(ctx, 25.0, 525.0);
        CGContextSetLineWidth(ctx, 1);
        
        //4 color
        let colorspace = CGColorSpaceCreateDeviceRGB();
        let components = [CGFloat(204.0/255.0), CGFloat(0.0/255.0), CGFloat(102.0/255.0), CGFloat(1.0)]
        let color = CGColorCreate(colorspace, components);
        
        
        //3
        CGContextClosePath(ctx);
        CGContextSetStrokeColorWithColor(ctx, color);
        CGContextStrokePath(ctx);
        
        let image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext()
        
        
        let button = UIButton(type: UIButtonType.Custom)
        button.setImage(image,forState: .Normal)
        button.bounds = CGRectMake(0,0,50,525)
        button.frame = CGRectMake(CGFloat(UIScreen.mainScreen().bounds.width/2-150),25,50,525)
        button.exclusiveTouch = true
        button.userInteractionEnabled = true
        button.addTarget(self, action: Selector("buttonDragVertical:event:"), forControlEvents: .TouchDown)
        button.addTarget(self, action: Selector("buttonDragVertical:event:"), forControlEvents: .TouchDragInside)
        button.addTarget(self, action: Selector("buttonDragVertical:event:"), forControlEvents: .TouchDragOutside)
        button.addTarget(self, action: Selector("buttonDragVertical:event:"), forControlEvents: .TouchDragEnter)
        
        
        
        return button
    }
    

    func drawOuterRightLine()->UIButton {
        
        
        let frame = CGSize(width: 50, height: 525)
        
        UIGraphicsBeginImageContext(frame)
        let ctx = UIGraphicsGetCurrentContext();
        
        //Define the line in 2d space.
        CGContextBeginPath(ctx);
        CGContextMoveToPoint(ctx, 25.0, 0.0);
        CGContextAddLineToPoint(ctx, 25.0, 525.0);
        CGContextSetLineWidth(ctx, 1);
        
        //3. close
        CGContextClosePath(ctx);
        
        //4 color
        let colorspace = CGColorSpaceCreateDeviceRGB();
        let components = [CGFloat(0.0), CGFloat(102.0/255.0), CGFloat(204.0/255.0), CGFloat(1.0)]
        let color = CGColorCreate(colorspace, components);
        
        //5 stroke.
        CGContextSetStrokeColorWithColor(ctx,  color);
        CGContextStrokePath(ctx);
        
        //6 capture this as an image.
        let image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext()
        
        //7 assign image to the button.
        let button = UIButton(type: UIButtonType.Custom)
        button.setImage(image,forState: .Normal)
        button.bounds = CGRectMake(0,0,50,525)
        button.frame = CGRectMake(UIScreen.mainScreen().bounds.width-126,25,50,525)
        
        //  print("frame is \("frame)
        button.exclusiveTouch = true
        button.userInteractionEnabled = true
        button.addTarget(self, action: Selector("buttonDragVertical:event:"), forControlEvents: .TouchDown)
        button.addTarget(self, action: Selector("buttonDragVertical:event:"), forControlEvents: .TouchDragInside)
        button.addTarget(self, action: Selector("buttonDragVertical:event:"), forControlEvents: .TouchDragOutside)
        button.addTarget(self, action: Selector("buttonDragVertical:event:"), forControlEvents: .TouchDragEnter)
        
        
        
        
        return button
    }

    
    func drawInnerRightLine()->UIButton {
        
        
        let frame = CGSize(width: 50, height: 525)
        
        UIGraphicsBeginImageContext(frame)
        let ctx = UIGraphicsGetCurrentContext();
        
        //2
        CGContextBeginPath(ctx);
        CGContextMoveToPoint(ctx, 25.0, 0.0);
        CGContextAddLineToPoint(ctx, 25.0, 525.0);
        CGContextSetLineWidth(ctx, 1);
        
        //4 color
        let colorspace = CGColorSpaceCreateDeviceRGB();
        let components = [CGFloat(204.0/255.0), CGFloat(0.0/255.0), CGFloat(102.0/255.0), CGFloat(1.0)]
        let color = CGColorCreate(colorspace, components);
        
        
        //3
        CGContextClosePath(ctx);
        CGContextSetStrokeColorWithColor(ctx, color);
        CGContextStrokePath(ctx);
        
        let image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext()
        
        
        let button = UIButton(type: UIButtonType.Custom)
        button.setImage(image,forState: .Normal)
        button.bounds = CGRectMake(0,0,50,525)
        button.frame = CGRectMake(CGFloat(UIScreen.mainScreen().bounds.width/2+150),25,50,525)
        button.exclusiveTouch = true
        button.userInteractionEnabled = true
        button.addTarget(self, action: Selector("buttonDragVertical:event:"), forControlEvents: .TouchDown)
        button.addTarget(self, action: Selector("buttonDragVertical:event:"), forControlEvents: .TouchDragInside)
        button.addTarget(self, action: Selector("buttonDragVertical:event:"), forControlEvents: .TouchDragOutside)
        button.addTarget(self, action: Selector("buttonDragVertical:event:"), forControlEvents: .TouchDragEnter)
        
        
        
        return button
    }

    
    func setPosition(position: CGPoint){
        
        measureTool.position = position
        
    }
    
    var leftEye: CGPoint {
        willSet(lefteye){
            print(lefteye)
        }
    }
    
    var rightEye: CGPoint {
        willSet(righteye){
            print(righteye)
        }
    }
    
    var faceParams: CGRect {
        willSet(faceparams){
            print(faceparams)
        }
    }
    
    
    func draw(faceparams: CGRect, lefteye: CGPoint, righteye: CGPoint) {
        
        self.faceParams = faceparams
        self.leftEye = lefteye
        self.rightEye = righteye
        
        guard (target == target) else {
            print("target is nil")
            return
        }
        
        measureTool = drawMeasureTool()
        self.target!.addSublayer(measureTool)
    }
    
    
    func remove() {
        self.measureTool.removeFromSuperlayer()
    }
    
    func drag(){
        
        //add code to drag reference point.
    }
    
}