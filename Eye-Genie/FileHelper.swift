//
//  FileHelper.swift
//  Eye-Genie
//
//  Created by Ryan Maxwell on 2015-12-07.
//  Copyright © 2015 Bceen Ventures. All rights reserved.
//

import Foundation
import UIKit


func getSupportPath(fileName: String) -> String {
    let documentsURL = NSFileManager.defaultManager().URLsForDirectory(.ApplicationSupportDirectory, inDomains: .UserDomainMask)[0]
    let fileURL = documentsURL.URLByAppendingPathComponent(fileName)
    return fileURL.path!
}



func saveImage (image: UIImage, path: String, filename: String) -> Bool{
    //let pngImageData = UIImagePNGRepresentation(image)
    let jpgImageData = UIImageJPEGRepresentation(image, 1.0)   // if you want to save as JPEG
    let result = jpgImageData!.writeToFile(path + "/" + filename, atomically: true)
    return result
    
}



//We return the APPLICATION SUPPORT DIRECTORY!!!! IMPORTANT.
//changes in 8.0?  is this correct??
func supportDirectoryForImages() -> String {
    
    
    let folderPath = NSSearchPathForDirectoriesInDomains(.ApplicationSupportDirectory, .UserDomainMask, true)[0]
    let writePath = (folderPath as NSString).stringByAppendingPathComponent("/images") //  Can we specific ourselves??
    return writePath
}

//We return the APPLICATION SUPPORT DIRECTORY!!!! IMPORTANT.
//changes in 8.0?  is this correct??
func supportDirectory() -> String {
    
    
    let folderPath = NSSearchPathForDirectoriesInDomains(.ApplicationSupportDirectory, .UserDomainMask, true)[0]
    let writePath = (folderPath as NSString).stringByAppendingPathComponent("") //  Can we specific ourselves??
    return writePath
}



// Get path for a file in the directory
func fileInDocumentsDirectory(filename: String) -> String {
    //print(supportDirectory() + filename)
    return supportDirectory() + "/" + filename
}


