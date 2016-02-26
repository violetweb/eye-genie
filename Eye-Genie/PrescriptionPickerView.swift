//
//  prescriptionPickerView.swift
//  EyeGenie
//
//  Created by Valerie Trotter on 2016-02-23.
//  Copyright © 2016 Bceen Ventures. All rights reserved.
//

import UIKit

class PrescriptionPickerView: UIPickerView, UIPickerViewDelegate, UIPickerViewDataSource {
    
    
    
    let prescriptions = ["1.50", "1.60", "1.67", "1.74"]
    var years = ["-10","-9","-8","-7","-6","-5","-4","-3","-2","-1","+0","+1","+2","+3","+4","+5","+6","+7","+8","+9","+10"]
    
    
    var prescription: Int = 0 {
        didSet {
            selectRow(prescription-1, inComponent: 0, animated: false)
        }
    }
    
    var year: Int = 0 {
        didSet {
            selectRow(year-1, inComponent: 1, animated: true)
        }
    }
    
    var onPrescriptionSelected: ((prescription: Int, year: Int, titleForRow: String) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonSetup()
    }
    
    func commonSetup() {
        
        
        self.delegate = self
        self.dataSource = self
        
    }
    
    // Mark: UIPicker Delegate / Data Source
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch component {
        case 0:
           // return prescriptions[row]
            //Update the image with the apporpriate value..
            
            return prescriptions[row]
        case 1:
            return "\(years[row])"
        default:
            return nil
        }
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0:
            return prescriptions.count
        case 1:
            return years.count
        default:
            return 0
        }
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        
        let prescription = self.selectedRowInComponent(0)+1
        let year = self.selectedRowInComponent(1)+1
        
        if let block = onPrescriptionSelected {
            block(prescription: prescription, year: year, titleForRow: years[year])
        }
        
        self.prescription = prescription
        self.year = year
    }
}