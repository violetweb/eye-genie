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
   
    func buttonBounce(){
        
        let bounds = self.bounds
        UIView.animateWithDuration(1.0, delay: 0.0, usingSpringWithDamping: 0.2, initialSpringVelocity: 10, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
            self.bounds = CGRect(x: bounds.origin.x - 20, y: bounds.origin.y, width: bounds.size.width + 60, height: bounds.size.height)
                       }, completion: nil)
        
    }
}