//
//  AppImageController.swift
//  Eye-Genie
//
//  Created by Ryan Maxwell on 2015-12-02.
//  Copyright © 2015 Bceen Ventures. All rights reserved.
//

import Foundation
//
//  SettingsController.swift
//  Eye-Genie
//
//  Created by Ryan Maxwell on 2015-12-01.
//  Copyright © 2015 Bceen Ventures. All rights reserved.
//

import UIKit


class AppImageController: UIViewController, UIImagePickerControllerDelegate,
UINavigationControllerDelegate {
    
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    let imagePicker = UIImagePickerController()
    
    func setImageFromDirectory(findimage: String){
        
        let fm = NSFileManager.defaultManager()
        //let path = NSBundle.mainBundle().resourcePath!
        let path = getSupportPath("Genie")
        print(path)
        let items = try! fm.contentsOfDirectoryAtPath(path)
        
        /*
        
        for item in items {
        if item.hasPrefix(findimage) {
        appImageView.image = UIImage(named: findimage)
        let saved = saveImage(appImageView.image!, path: path)
        if saved {
        print(path)
        }
        }
        }
        */
    }
    
    
    func saveImage (image: UIImage, path: String ) -> Bool{
        //let pngImageData = UIImagePNGRepresentation(image)
        let jpgImageData = UIImageJPEGRepresentation(image, 1.0)   // if you want to save as JPEG
        let result = jpgImageData!.writeToFile(path, atomically: true)
        return result
        
    }
    
    //We return the APPLICATION SUPPORT DIRECTORY!!!! IMPORTANT.
    //changes in 8.0?  is this correct??
    func supportDirectory() -> String {
        
        
        let folderPath = NSSearchPathForDirectoriesInDomains(.ApplicationSupportDirectory, .UserDomainMask, true)[0]
        let writePath = (folderPath as NSString).stringByAppendingPathComponent("Genie") //  Can we specific ourselves??
        return writePath
    }
    
    
    // Get path for a file in the directory
    func fileInDocumentsDirectory(filename: String) -> String {
        
        return supportDirectory() + filename
    }
    
    
    
    
    func loadImageFromPath(path: String) -> UIImage? {
        
        let image = UIImage(contentsOfFile: path)
        if image == nil {
            print("missing image at: (path)")
        }
        print("(path)") // this is just for you to see the path in case you want to go to the directory, using Finder.
        return image
        
    }
    
    func getSupportPath(fileName: String) -> String {
        let documentsURL = NSFileManager.defaultManager().URLsForDirectory(.ApplicationSupportDirectory, inDomains: .UserDomainMask)[0]
        let fileURL = documentsURL.URLByAppendingPathComponent(fileName)
        return fileURL.path!
    }
    
    
    
    func setDefaultGeneral(imagename: String){
        
        
        let databasePath = getSupportPath("genie.db") // grab the database.
        let genieDB = FMDatabase(path: String(databasePath))
        
        if genieDB.open() {
            
            let insertSQL = "UPDATE GENERAL SET HOMEIMAGE='\(imagename)' where id=1"
            let result = genieDB.executeStatements(insertSQL)
            
            if !result {
                print("Error: \(genieDB.lastErrorMessage())")
            }else{
                /* not necessary
                let querySQL = "SELECT HOMEIMAGE, ACTIVE FROM GENERAL WHERE ACTIVE=1"
                
                let results:FMResultSet? = genieDB.executeQuery(querySQL,
                withArgumentsInArray: nil)
                
                if results?.next() == true {
                appImageView.image = UIImage(named: (results?.stringForColumn("HOMEIMAGE"))!)
                print(results?.stringForColumn("HOMEIMAGE")!)
                } else {
                print("Record not found, setting to default")
                // appImageView.image = UIImage(named: "bg-home") // default.
                }
                */
                
            }
            genieDB.close()
            
            
        } else {
            print("Error: \(genieDB.lastErrorMessage())")
        }
        
        
    }
    
    @IBOutlet weak var btnTest: UIBarButtonItem!
    
    /*
    @IBAction func btnResetToDefault(sender: UIButton) {
    
    setDefaultGeneral("bg-home") // update the db part.
    setImageFromDirectory("bg-home") // find the image from file part.
    
    
    
    }*/
    
    var pickedImage: UIImage!
    
    
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        
        
        
        if let possibleImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            pickedImage = possibleImage
        } else if let possibleImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            pickedImage = possibleImage
        }
        
        dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Reset to Defaults
        let value = UIInterfaceOrientation.LandscapeRight.rawValue
        UIDevice.currentDevice().setValue(value, forKey: "orientation")
        imagePicker.delegate = self
    }
    
    
    
    
}
