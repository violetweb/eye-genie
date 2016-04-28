//
//  CustomButton.swift
//  EyeGenie
//
//  Created by Ryan Maxwell on 2016-03-18.
//  Copyright © 2016 Bceen Ventures. All rights reserved.
//

import UIKit


@IBDesignable class CustomButton: UIControl {

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
    
    
    
}

