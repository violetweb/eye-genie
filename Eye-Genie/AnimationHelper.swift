//
//  AnimationHelper.swift
//  Eye-Genie
//
//  Created by Valerie Trotter, Web Developer
//  Copyright © 2015 Bceen Ventures. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    

    func fadeIn() {
       self.alpha = 0.35
       UIView.animateWithDuration(1.0, delay: 0.0, options: UIViewAnimationOptions.CurveEaseIn, animations: {
            self.alpha = 0.9
        }, completion: nil)
    }

    func fadeOut() {
        self.alpha = 0.9
        UIView.animateWithDuration(1.0, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
            self.alpha = 0.35
        }, completion: nil)
    }
   
    //Works for UIButtons
    func buttonBounce(){
        let bounds = self.bounds
        UIView.animateWithDuration(1.0, delay: 0.0, usingSpringWithDamping: 0.2, initialSpringVelocity: 10, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
            self.bounds = CGRect(x: bounds.origin.x - 20, y: bounds.origin.y, width: bounds.size.width + 60, height: bounds.size.height)
                       }, completion: nil)
        
    }
    
    func openStuff(){
        /*
        let tapAlert = UIAlertController(title: "Tapped", message: "You just tapped the tap view", preferredStyle: UIAlertControllerStyle.Alert)
        tapAlert.addAction(UIAlertAction(title: "OK", style: .Destructive, handler: nil))
        self.presentViewController(tapAlert, animated: true, completion: nil)
        */

    }
    
    
    /*
    
    func setButtons(imagename: String){
        
        let normalColor : UIColor = UIColor(hexString: "#ffe700ff")!
        let attributes = [
            NSForegroundColorAttributeName : normalColor
        ]
        
        let highlightColor : UIColor = UIColor.lightGrayColor()
        let hattributes = [
            NSForegroundColorAttributeName : highlightColor
        ]
        
        UIBarButtonItem.appearance().setTitleTextAttributes(attributes, forState: UIControlState.Normal)
       // UIBarButtonItem.appearance().setTitleTextAttributes(hattributes, forState: UIControlState.Selected)
        UIBarButtonItem.appearance().setTitleTextAttributes(hattributes, forState: UIControlState.Highlighted)

        UIBarButtonItem.appearance().setBackgroundImage(UIImage(named: imagename), forState: .Selected, style: .Plain, barMetrics: .Default)
    }
    */
    //Takes the desired blur value and the imagename of image to apply the blur.
    func blurImage(blurRadius: Float, imageName: UIImage)->UIImage{
        
        
        let clampFilter = CIFilter(name: "CIAffineClamp")!
        let currentFilter = CIFilter(name: "CIGaussianBlur")
        
        let glContext = EAGLContext(API: .OpenGLES2)
        let context = CIContext(EAGLContext: glContext,
            options: [
                kCIContextWorkingColorSpace: NSNull()
            ]
        )
        let beginImage = CIImage(image: imageName)
        let transform = CGAffineTransformIdentity
        
        clampFilter.setValue(beginImage!, forKey: "inputImage")
        clampFilter.setValue(NSValue(CGAffineTransform: transform), forKey: "inputTransform")
        
        currentFilter!.setValue(clampFilter.outputImage!, forKey: "inputImage")
        currentFilter!.setValue(blurRadius, forKey: "inputRadius")
        
        let cgimg = context.createCGImage(currentFilter!.outputImage!, fromRect: beginImage!.extent)
        return UIImage(CGImage: cgimg) //has to have the CGImage piece on the end!!!!!
        
    }

   
    
}