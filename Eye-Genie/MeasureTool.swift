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

/// Render a "Reference Point" Shape
//  has the following attributes :  draggable, magnifyable, lock / release.
//  
//  Defaults are :
//                  fillColor :     White
//                  Border Width :  1.0
//                  Border color:   Black
//                  Radius :        100


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
    
    
    var topPosition: CGPoint
    var bottomPosition: CGPoint
    var leftPosition: CGPoint
    var rightPosition: CGPoint
    
    
    private func drawMeasureTool()->CAShapeLayer {
        
        //Call all the other tools.
      //  let top = drawTopLine()
      //  topPosition = top.position
        
        let bottom = drawBottomLine()
        bottomPosition = bottom.position
        
        let shape = CAShapeLayer()
        //shape.addSublayer(top)
        shape.addSublayer(bottom)
        return shape
        
        
   }
    
    func drawTopLine() ->UIImage {
        
        let frame = CGSize(width: 800, height: 3)
        UIGraphicsBeginImageContext(frame)
        let context = UIGraphicsGetCurrentContext();
        CGContextSetLineWidth(context, 20)
        CGContextMoveToPoint(context,0,0)
        CGContextAddLineToPoint(context, 800, 0);
        CGContextSetRGBFillColor(context, 255, 255, 255, 1);
        CGContextSetRGBStrokeColor(context, 255, 255, 255, 1);
        CGContextStrokePath(context);
        let image = UIGraphicsGetImageFromCurrentImageContext();
        return image
    }
    
    
    
    private func drawBottomLine()->CAShapeLayer{
        
        let shape = CAShapeLayer()
        let path = CGPathCreateMutable()
        CGPathMoveToPoint(path, nil, 40, 450)
        CGPathAddLineToPoint(path, nil, 1000, 450)
        CGPathAddLineToPoint(path, nil, 1000,460)
        CGPathAddLineToPoint(path,nil,40,460)
        CGPathCloseSubpath(path);
        
        shape.path = path
        return shape
        
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
        /*
        var rad: CGFloat = 0
        let size = target!.frame.size
        if let r = self.radius {
        rad = r
        } else {
        rad = min(size.height, size.width)
        }
        */
        
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