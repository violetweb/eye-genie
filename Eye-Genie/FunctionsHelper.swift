//
//  MathHelper.swift
//  Eye-Genie
//
//  Created by Ryan Maxwell on 2016-01-13.
//  Copyright © 2016 Bceen Ventures. All rights reserved.
//

import Foundation
import Metal

class FunctionsHelper {
    
    
    func degreesToRadians(x: Int)->Double{
        return Double(x)/Double(180.0) * M_PI
    }
    
    func radiansToDegrees(x: Int)->Double{
        return Double(x)/M_PI*Double(180.0)
    }
 

}