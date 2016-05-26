//
//  Order.swift
//  EyeGenie
//
//  Created by Valerie Trotter on 2016-04-26.
//  Copyright © 2016 Bceen Ventures. All rights reserved.
//

import Foundation


class Order {
    
    
    var clientID = ""
    var clientName = ""
    var selectedGlasses = ""
    var name = ""
    var dob = ""
    var leftPrescription = Prescription()
    var rightPrescription = Prescription()
    
    struct Prescription {
    
        var SPH = 0
        var CYL = 0
        var Axis = 0
        var Add = 0
        var Prism = 0
        var pBase = 0
        var Material = "OptoTech 1.740"
    
    }
    
    func getSelectedGlasses()->String{
        return selectedGlasses
    }
    
}