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
            self.alpha = 1.0
        }, completion: nil)
    }

    func fadeOut() {
        self.alpha = 1.0
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
    
    
    func setTitleAttributes(){
        
        let shadow = NSShadow()
        shadow.shadowColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        shadow.shadowOffset = CGSizeMake(0, 1)
        let color : UIColor = UIColor(red: 220.0/255.0, green: 104.0/255.0, blue: 1.0/255.0, alpha: 1.0)
        let titleFont : UIFont = UIFont(name: "AmericanTypewriter", size: 16.0)!
        let attributes = [
            NSForegroundColorAttributeName : color,
            NSShadowAttributeName : shadow,
            NSFontAttributeName : titleFont
        ]
        
        UIBarButtonItem.appearance().setTitleTextAttributes(attributes, forState: UIControlState.Normal)
    }
    
    //Takes the desired blur value and the imagename of image to apply the blur.
    func blurImage(blurRadius: Float, imageName: UIImage)->UIImage{
        
        
        let clampFilter = CIFilter(name: "CIAffineClamp")!
        let currentFilter = CIFilter(name: "CIGaussianBlur")
        
        let glContext = EAGLContext(API: .OpenGLES2)
        var context = CIContext(EAGLContext: glContext,
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