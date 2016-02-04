//
//  CircleDraw.swift
//  EyeGenie
//
//  Created by Valerie Trotter
//  Copyright © 2016 Bceen Ventures. All rights reserved.
//

import Foundation
import UIKit
import CoreGraphics



/// Apply a blur to the background behind the Lens Shape.

class LensShapeBlur {
    
    
    
    private var fillLayer = CAShapeLayer()
    var target: CALayer?
    
    var fillColor: UIColor = UIColor.whiteColor() {
        didSet {
            self.fillLayer.fillColor = self.fillColor.CGColor
        }
    }
    
    var radius: CGFloat? {
        didSet {
            self.draw(opacity)
        }
    }
    
    var opacity: Float = 0.0 {
        didSet {
            self.fillLayer.opacity = self.opacity
            
        }
    }
   
    
    var lensShape: CGPathRef? {
        didSet{
            self.lensShape = drawLensShapeBlur()
        }
    }

    
   
    init(drawIn: CALayer) {
          self.target = drawIn
          self.lensShape = drawLensShapeBlur()
    }
    
    
    //Lens Shape Points 
    
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
    
    
    //Feed points are specific to Lens (redo this as generic)
    func drawLensShapeBlur() ->CGPathRef {
        
        let lensPath = CGPathCreateMutable()
        var points = lensPoints()
        let cpg = points[0]
        
        //Move to the starting location and DRAW lines.
        CGPathMoveToPoint(lensPath, nil, cpg.x, cpg.y)
        for p in points {
            CGPathAddLineToPoint(lensPath, nil, p.x, p.y)
        }
        
        //Now move to outer edge and draw.
        CGPathMoveToPoint(lensPath, nil, 0, 0)
        CGPathAddLineToPoint(lensPath,nil,0,800)
        CGPathAddLineToPoint(lensPath,nil,800,800)
        CGPathAddLineToPoint(lensPath,nil,800,0)
        
        CGPathCloseSubpath(lensPath)
        
        //Return result.
        return lensPath
        
    }

    
  
    func draw(opacity: Float) {
        
          
        guard (target == target) else {
            print("target is nil")
            return
        }
        
        var rad: CGFloat = 0
        let size = target!.frame.size
        if let r = self.radius {
            rad = r
        } else {
            rad = min(size.height, size.width)
        }
        
     
        
        fillLayer.path = lensShape
        fillLayer.fillRule = kCAFillRuleEvenOdd
        fillLayer.fillColor = self.fillColor.CGColor
        fillLayer.opacity = opacity
        fillLayer.zPosition = 2
        
        self.target!.addSublayer(fillLayer)
    }
    
    
    func remove() {
        self.fillLayer.removeFromSuperlayer()
    }
    
}