//
//  ColorSegmentedControl.swift
//  EyeGenie
//
//  Created by Valerie Trotter on 2016-03-14.
//  Copyright © 2016 Bceen Ventures. All rights reserved.
//

import UIKit

@IBDesignable class ColorSegmentedControl: UIControl {

    
    private var labels = [UILabel]()
    var thumbView = UIView()

    
    var items: [String] = ["Brown", "Grey"] {
        didSet {
            setupLabels()
        }
    }
      
    var selectedIndex : Int = 0 {
        didSet {
            displayNewSelectedIndex()
        }
    }
    
    @IBInspectable var selectedLabelColor : UIColor = UIColor.whiteColor() {
        didSet {
            setSelectedColors()
        }
    }
    
    @IBInspectable var unselectedLabelColor : UIColor = UIColor.blackColor() {
        didSet {
            setSelectedColors()
        }
    }
    
    @IBInspectable var thumbColor : UIColor = UIColor.whiteColor() {
        didSet {
            setSelectedColors()
        }
    }
    
    @IBInspectable var borderColor : UIColor = UIColor.whiteColor() {
        didSet {
            layer.borderColor = borderColor.CGColor
        }
    }
    
    @IBInspectable var font : UIFont! = UIFont.systemFontOfSize(12) {
        didSet {
            setFont()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)!
        setupView()
    }
    
    func setupView(){
        
        layer.cornerRadius = frame.height / 2
        layer.borderColor = UIColor(white: 1.0, alpha: 0.5).CGColor
        layer.borderWidth = 2
        
        backgroundColor = UIColor.clearColor()
        
        setupLabels()
        
        addIndividualItemConstraints(labels, mainView: self, padding: 0)
        
        insertSubview(thumbView, atIndex: 0)
    }
    
    
    
    
    func setupLabels(){
        
        for label in labels {
            label.removeFromSuperview()
        }
        
        labels.removeAll(keepCapacity: true)
    
        
        var setColor = UIColor.blackColor() // Black default.
        
        for index in 1...items.count {
            
            //Pull out the UI Color.
            switch (items[index-1]) {
                
                case "grey" :
                    setColor = UIColor.grayColor();
                    break;
                case "brown" :
                    setColor = UIColor.brownColor();
                    break;
                case "red" :
                    setColor = UIColor.redColor();
                    break;
                case "green" :
                    setColor = UIColor.greenColor();
                    break;
                case "blue" :
                    setColor = UIColor.blueColor();
                    break;
                default:
                setColor = UIColor.blackColor();
                break;
            }
            
            let label = UILabel(frame: CGRectMake(0, 0, 70, 40))
            label.text = items[index - 1]
            label.backgroundColor = setColor
            label.textAlignment = .Center
            label.font = UIFont(name: "Avenir-Black", size: 15)
            label.textColor = index == 1 ? selectedLabelColor : unselectedLabelColor
           // label.setTranslatesAutoresizingMaskIntoConstraints(false)
            self.addSubview(label)
            labels.append(label)
        }
        
        addIndividualItemConstraints(labels, mainView: self, padding: 0)
    }
    
 
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        var selectFrame = self.bounds
        let newWidth = CGRectGetWidth(selectFrame) / CGFloat(items.count)
        selectFrame.size.width = newWidth
        thumbView.frame = selectFrame
        thumbView.backgroundColor = thumbColor
        thumbView.layer.cornerRadius = thumbView.frame.height / 2
        
        displayNewSelectedIndex()
        
    }
    
    override func beginTrackingWithTouch(touch: UITouch, withEvent event: UIEvent?) -> Bool {
      
        
        let location = touch.locationInView(self)
        
        var calculatedIndex : Int?
        for (index, item) in labels.enumerate() {
            if item.frame.contains(location) {
                calculatedIndex = index
            }
        }
        
        
        if calculatedIndex != nil {
            selectedIndex = calculatedIndex!
            sendActionsForControlEvents(.ValueChanged)
        }
        
        return false
    }
    
    func displayNewSelectedIndex(){
        for (index, item) in labels.enumerate() {
            item.textColor = unselectedLabelColor
        }
        
        var label = labels[selectedIndex]
        label.textColor = selectedLabelColor
        
        
        UIView.animateWithDuration(0.5, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.8, options: .TransitionCurlUp, animations: {
            
            self.thumbView.frame = label.frame
            
            }, completion: nil)
    }
    
    func addIndividualItemConstraints(items: [UIView], mainView: UIView, padding: CGFloat) {
        
        let constraints = mainView.constraints
        
        for (index, button) in items.enumerate() {
            
            var topConstraint = NSLayoutConstraint(item: button, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: mainView, attribute: NSLayoutAttribute.Top, multiplier: 1.0, constant: 0)
            
            var bottomConstraint = NSLayoutConstraint(item: button, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: mainView, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: 0)
            
            var rightConstraint : NSLayoutConstraint!
            
            if index == items.count - 1 {
                
                rightConstraint = NSLayoutConstraint(item: button, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: mainView, attribute: NSLayoutAttribute.Right, multiplier: 1.0, constant: -padding)
                
            }else{
                
                let nextButton = items[index+1]
                rightConstraint = NSLayoutConstraint(item: button, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: nextButton, attribute: NSLayoutAttribute.Left, multiplier: 1.0, constant: -padding)
            }
            
            
            var leftConstraint : NSLayoutConstraint!
            
            if index == 0 {
                
                leftConstraint = NSLayoutConstraint(item: button, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: mainView, attribute: NSLayoutAttribute.Left, multiplier: 1.0, constant: padding)
                
            }else{
                
                let prevButton = items[index-1]
                leftConstraint = NSLayoutConstraint(item: button, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: prevButton, attribute: NSLayoutAttribute.Right, multiplier: 1.0, constant: padding)
                
                let firstItem = items[0]
                
                var widthConstraint = NSLayoutConstraint(item: button, attribute: .Width, relatedBy: NSLayoutRelation.Equal, toItem: firstItem, attribute: .Width, multiplier: 1.0  , constant: 0)
                
                mainView.addConstraint(widthConstraint)
            }
            
            mainView.addConstraints([topConstraint, bottomConstraint, rightConstraint, leftConstraint])
        }
    }
    
    func setSelectedColors(){
        for item in labels {
            item.textColor = unselectedLabelColor
        }
        
        if labels.count > 0 {
            labels[0].textColor = selectedLabelColor
        }
        
        thumbView.backgroundColor = thumbColor
    }
    
    func setFont(){
        for item in labels {
            item.font = font
        }
    }

    
}


