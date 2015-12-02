//
//  SettingsController.swift
//  Eye-Genie
//
//  Created by Ryan Maxwell on 2015-12-01.
//  Copyright © 2015 Bceen Ventures. All rights reserved.
//

import UIKit
import GLKit


class SettingsController: UIViewController, UIImagePickerControllerDelegate,
UINavigationControllerDelegate {
    
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func btnBack(sender: UIBarButtonItem) {
         self.performSegueWithIdentifier("LogoutSegue", sender: self)
    
        
    }
    
    @IBOutlet weak var appImageView: UIImageView!
    
    @IBAction func btnButton1(sender: UIBarButtonItem) {
        btn1Image.allowsEditing = false
        btn1Image.sourceType = .PhotoLibrary
        btn1Image.modalPresentationStyle = .Popover
        btn1Image.popoverPresentationController?.barButtonItem = sender
        presentViewController(btn1Image, animated: true, completion: nil)
        
    }
    
    @IBAction func btnButton2(sender: UIBarButtonItem) {
        btn2Image.allowsEditing = false
        btn2Image.sourceType = .PhotoLibrary
        btn2Image.modalPresentationStyle = .Popover
        btn2Image.popoverPresentationController?.barButtonItem = sender
        presentViewController(btn2Image, animated: true, completion: nil)
        
     
        
    }
    
    @IBAction func btnItem(sender: UIBarButtonItem) {
        
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .PhotoLibrary
        imagePicker.modalPresentationStyle = .Popover
        imagePicker.popoverPresentationController?.barButtonItem = sender
        presentViewController(imagePicker, animated: true, completion: nil)
        
       

    }
  
    @IBAction func btnLaunchPicker(sender: UIButton) {
     

    }
   
       let imagePicker = UIImagePickerController()
       let btn1Image = UIImagePickerController()
       let btn2Image =  UIImagePickerController()
    
    
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
        setDefaultGeneral("newhomeimage")
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

    
    @IBOutlet weak var btn1ImageView: UIImageView!
    @IBOutlet weak var btn2ImageView: UIImageView!
    @IBOutlet weak var btn3ImageView: UIImageView!
    @IBOutlet weak var btn4ImageView: UIImageView!
    @IBOutlet weak var btn5ImageView: UIImageView!
    
    func button1PickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]){
        
        
        var newImage: UIImage
        
        if let possibleImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            newImage = possibleImage
        } else if let possibleImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            newImage = possibleImage
            btn1ImageView.contentMode = .ScaleAspectFit //3
            btn1ImageView.image = newImage //4
            dismissViewControllerAnimated(true, completion: nil)

        }
        
       
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]){
        
        var newImage: UIImage
        
        if let possibleImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            newImage = possibleImage
        } else if let possibleImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            newImage = possibleImage
            appImageView.contentMode = .ScaleAspectFit //3
            appImageView.image = newImage //4
            
            
            let imagePath = fileInDocumentsDirectory("/newhomeimage.jpg") // Can only have one active home image at a time, so hard-coded naming is ok.
            var saved = saveImage(newImage, path: imagePath)

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
