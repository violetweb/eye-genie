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

    
    func generateRandomColor() -> UIColor {
        
        let hue = CGFloat(arc4random() % 256) / 256
        let saturation = CGFloat(arc4random() % 128) / 256 + 0.5
        let brightness = CGFloat(arc4random() % 128) / 256 + 0.5
        
        return UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: 1)
    }

    
    func savePNG (image: UIImage, path: String, filename: String) -> Bool{
        let pngImageData = UIImagePNGRepresentation(image)
        //let jpgImageData = UIImageJPEGRepresentation(image, 1.0)   // if you want to save as JPEG
        let result = pngImageData!.writeToFile(path + "/" + filename, atomically: true)
        return result
        
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
    

    
    
}