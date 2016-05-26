//
//  FileHelper.swift
//  Eye-Genie
//
//  Created by Valerie Trotter on 2015-12-07.
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

func savePNG (image: UIImage, path: String, filename: String) -> Bool{
    let pngImageData = UIImagePNGRepresentation(image)
    let result = pngImageData!.writeToFile(path + "/" + filename, atomically: true)
    return result
    
}


let copytopath = getSupportPath("images") //ApplicationSupport/images
let fm = NSFileManager.defaultManager()
let copyfrompath = NSBundle.mainBundle().resourcePath! + "/appdefaults" // I-Care-New.app directory.

let images = try! fm.contentsOfDirectoryAtPath(copyfrompath)


func dropFilesFromApplicationPath()-> Bool{
   
    
    let pathName = getSupportPath("images")
    var dropped = false;
    let fm = NSFileManager.defaultManager()
    let images = try! fm.contentsOfDirectoryAtPath(pathName)
    
    for image in images {
        let dropitem = pathName + "/" + image
        do {
            try fm.removeItemAtPath(dropitem) // If exists already, first remove it.
            print("\(dropitem) has been dropped successfully.")
            dropped = true
        }catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    return dropped
}

func grabFromDirectory(findimage: String, ext: String)->String{
    
    
   
    var imagePath = ""
    let fm = NSFileManager.defaultManager()
    let path = getSupportPath("images")  // applicationSupportdirectory + images
    let items = try! fm.contentsOfDirectoryAtPath(path)
    for item in items {
        if item.hasPrefix(findimage) {
            imagePath = path + "/" + item + ext
        }
    }
    
    return imagePath
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


