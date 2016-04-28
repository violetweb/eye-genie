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

//  Defaults are :
//                  fillColor :     White
//                  Border Width :  1.0
//                  Border color:   Black
//                  Radius :        100


class ReferencePoint {
    
    
    var target: CALayer?
    
    
    var fillColor: UIColor = UIColor.clearColor() {
        didSet {
            self.referencePoint.fillColor = self.fillColor.CGColor
        }
    }
    
    
    var borderWidth: CGFloat? = 1.0 {
        didSet {
            self.referencePoint.borderWidth = self.borderWidth!
        }
    }
    
    
    
    var borderColor: UIColor = UIColor.blackColor() {
        didSet {
            self.referencePoint.borderColor = self.borderColor.CGColor
        }
    }

    
    
    var radius: CGFloat? = 100.0 {
        didSet {
            self.draw()
        }
    }
    
    var opacity: Float = 0.0 {
        didSet {
            self.referencePoint.opacity = self.opacity
            
        }
    }
    
    
    var referencePoint: CAShapeLayer  {
        didSet{
            self.referencePoint = createReferenceShape();
        }
    }
    
    
    
    init(drawIn: CALayer,fillColor: UIColor, borderWidth: CGFloat, borderColor: UIColor, radius: CGFloat, opacity: Float) {
        self.target = drawIn
        self.fillColor = fillColor
        self.borderWidth = borderWidth
        self.borderColor = borderColor
        self.radius = radius
        self.opacity = opacity
        self.referencePoint = CAShapeLayer()
    }
    
    
    
    private func createReferenceShape()->CAShapeLayer {
        
        let shape = CAShapeLayer()
        shape.path = UIBezierPath(roundedRect: CGRectMake(0,0,2.0*radius!, 2.0*radius!), cornerRadius: 100.0).CGPath
        return shape
    }
    
    func setPosition(position: CGPoint){
        
        referencePoint.position = position
        
    }
    
    
    func draw() {
        
        
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
        
        referencePoint = createReferenceShape()
        referencePoint.fillRule = kCAFillRuleEvenOdd
        referencePoint.zPosition = 20
        
        self.target!.addSublayer(referencePoint)
    }
    
    
    func remove() {
        self.referencePoint.removeFromSuperlayer()
    }
    
    func drag(){
        
        //add code to drag reference point.
    }
    
}