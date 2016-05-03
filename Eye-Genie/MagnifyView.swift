//
//  MagnifyView.swift
//  EyeGenie
//
//  Created by Ryan Maxwell on 2016-05-03.
//  Copyright © 2016 Bceen Ventures. All rights reserved.
//

import Foundation
import UIKit


class MagnifyView: UIView{
    
    
    var touchPoint: CGPoint
    var viewToMagnify: UIView
    
    override init(frame: CGRect) {
        touchPoint = CGPointZero
        viewToMagnify = UIView()
        super.init(frame: frame)
        didLoad()
    }
    
    required init?(coder aDecoder: NSCoder) {
        touchPoint = CGPointZero
        viewToMagnify = UIView()
        super.init(coder: aDecoder)
        didLoad()
    }
    
    convenience init() {
        self.init(frame: CGRectMake(0,0,118,118))
        
    }
    
    func didLoad() {
        //Place your initialization code here
        touchPoint = CGPointZero
        self.layer.cornerRadius = CGFloat(M_PI/2)
        self.layer.masksToBounds = true
        self.touchPoint.x = self.center.x
        self.touchPoint.y = self.center.y

    }
    
    
   func setTouchPointX(pt: CGPoint) {
        self.touchPoint = pt;
        // whenever touchPoint is set, update the position of the magnifier (to just above what's being magnified)
        self.center = CGPointMake(pt.x, pt.y-66);
    }
    
    func getTouchPoint()->CGPoint{
        return self.touchPoint
    }
    
    override func drawRect(rect: CGRect) {
        
        
        let context = UIGraphicsGetCurrentContext();
        let bounds = self.bounds;
        self.layer.cornerRadius = CGFloat(M_PI/2)
        self.layer.masksToBounds = true
        let mask = UIImage(named: "loupe-mask@2x")?.CGImage
        let glass = UIImage(named: "loupe-hi@2x")!
        
        CGContextSaveGState(context);
        CGContextClipToMask(context, bounds, mask);
        CGContextFillRect(context, bounds);
        CGContextScaleCTM(context, 1.2, 1.2);
            
        //draw your subject view here
        CGContextTranslateCTM(context,1*(self.frame.size.width*0.5),1*(self.frame.size.height*0.5));
        //CGContextScaleCTM(context, 1.5, 1.5);
        CGContextTranslateCTM(context,-1*(touchPoint.x),-1*(touchPoint.y));
        self.layer.renderInContext(context!)
        
        
        CGContextRestoreGState(context);
        glass.drawInRect(bounds)
        
    }

    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
   
        let interval = Double(0.5) // eight hours check it...
        let timer = NSTimer.scheduledTimerWithTimeInterval(interval, target:self, selector: Selector("addLoupe"), userInfo: nil, repeats: true)
        
        guard let touches = event!.allTouches() else { return }
        guard let touch = touches.first else { return }
        
        let loupe = self
        loupe.touchPoint = touch.locationInView(self)
        loupe.setNeedsDisplay()
    }

    func addLoupe(){
         self.superview!.addSubview(self)
    }
    

}

