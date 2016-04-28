//
//  MathHelper.swift
//  Eye-Genie
//
//  Created by Valerie Trotter on 2016-01-13.
//  Copyright © 2016 Bceen Ventures. All rights reserved.
//  Description:  Functions that are reused!

import UIKit

class FunctionsHelper: UIView {
    
    
    func degreesToRadians(x: Int)->Double{
        return Double(x)/Double(180.0) * M_PI
    }
    
    func radiansToDegrees(x: Int)->Double{
        return Double(x)/M_PI*Double(180.0)
    }
   
    
    //  Returns:        UIBarButtonItem
    //  Description:    To create custom image + label Buttons on the Bottom Toolbar!
    func createImageButton(buttonImage:  String, buttonTitle: String, selector: Selector)->UIBarButtonItem {
        
        let button = UIButton(type: UIButtonType.Custom)
        button.setImage(UIImage(named: buttonImage),forState: .Normal)
        
        
        button.bounds = CGRectMake(0,0,140,40)
       
        button.exclusiveTouch = true
        button.addTarget(self, action: selector, forControlEvents: .TouchUpInside)
        button.setTitle(buttonTitle, forState: .Normal)
        button.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        button.setTitleColor(UIColor.redColor(), forState: .Highlighted)

        let barButton = UIBarButtonItem()
        barButton.customView = button
        return barButton
        
        
        
    }

    
    //  Returns:        UIBarButtonItem
    //  Description:    To create custom image + label Buttons on the Bottom Toolbar!
    //Selector("imageTouch:withEvent:")
    func createDragButton(buttonImage:  String, buttonTitle: String, selector: Selector, bounds: CGRect, frame: CGRect)->UIButton {
        
        let button = UIButton(type: UIButtonType.Custom)
        
        if buttonImage != "" {
            button.setImage(UIImage(named: buttonImage),forState: .Normal)
        }
        
        button.bounds = bounds
        button.frame = frame
        button.exclusiveTouch = true
        
        button.addTarget(self, action: selector, forControlEvents: .TouchDown)
        button.addTarget(self, action: Selector("imageDrag:event:"), forControlEvents: .TouchDragInside)
        
        
        button.setTitle(buttonTitle, forState: .Normal)
        button.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        button.setTitleColor(UIColor.redColor(), forState: .Highlighted)
        
        return button
        
        
        
    }
    
}