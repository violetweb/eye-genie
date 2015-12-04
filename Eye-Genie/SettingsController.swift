//
//  SettingsController.swift
//  Eye-Genie
//
//  Created by Ryan Maxwell on 2015-12-01.
//  Copyright © 2015 Bceen Ventures. All rights reserved.
//

import UIKit


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
        
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .PhotoLibrary
        imagePicker.modalPresentationStyle = .Popover
        imagePicker.popoverPresentationController?.barButtonItem = sender
        presentViewController(imagePicker, animated: true, completion: nil)
        
        
        chosenButton = "1"
    }
    
    @IBAction func btnButton2(sender: UIBarButtonItem) {
      
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .PhotoLibrary
        imagePicker.modalPresentationStyle = .Popover
        imagePicker.popoverPresentationController?.barButtonItem = sender
        presentViewController(imagePicker, animated: true, completion: nil)
     
        chosenButton = "2"
    }
    
    @IBAction func btnItem(sender: UIBarButtonItem) {
        
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .PhotoLibrary
        imagePicker.modalPresentationStyle = .Popover
        imagePicker.popoverPresentationController?.barButtonItem = sender
        presentViewController(imagePicker, animated: true, completion:nil)
        chosenButton = "Main"
        
    }
    
    @IBAction func btnButton3(sender: UIBarButtonItem) {
        
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .PhotoLibrary
        imagePicker.modalPresentationStyle = .Popover
        imagePicker.popoverPresentationController?.barButtonItem = sender
        presentViewController(imagePicker, animated: true, completion:nil)
        chosenButton = "3"
    }
    
    
    @IBAction func btnButton4(sender: UIBarButtonItem) {
        
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .PhotoLibrary
        imagePicker.modalPresentationStyle = .Popover
        imagePicker.popoverPresentationController?.barButtonItem = sender
        presentViewController(imagePicker, animated: true, completion:nil)
        chosenButton = "4"
    }
    
    
    
    @IBAction func btnButton5(sender: UIBarButtonItem) {
        
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .PhotoLibrary
        imagePicker.modalPresentationStyle = .Popover
        imagePicker.popoverPresentationController?.barButtonItem = sender
        presentViewController(imagePicker, animated: true, completion:nil)
        chosenButton = "5"
    }
    
    let imagePicker = UIImagePickerController()
   
    
    var chosenButton = "Main"
    
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
    
    
    func saveImage (image: UIImage, path: String, filename: String) -> Bool{
        //let pngImageData = UIImagePNGRepresentation(image)
        let jpgImageData = UIImageJPEGRepresentation(image, 1.0)   // if you want to save as JPEG
        let result = jpgImageData!.writeToFile(path + "/" + filename, atomically: true)
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
    
    
    func saveDesignButton(designId: Int, designImage: String){
        
        let databasePath = getSupportPath("genie.db") // grab the database.
        let genieDB = FMDatabase(path: String(databasePath))
        
        if genieDB.open() {
            
            
            let insertSQL = "UPDATE DESIGNS SET DESIGNIMAGE='\(designImage)' where id=\(designId)"
            let result = genieDB.executeStatements(insertSQL)
            
            if !result {
                print("Error: \(genieDB.lastErrorMessage())")
            }else{
                
            }
            genieDB.close()
            
            
        } else {
            print("Error: \(genieDB.lastErrorMessage())")
        }
        
        

        
    }
    
    func setDefaultGeneral(homeimage: String){
        
        
        let databasePath = getSupportPath("genie.db") // grab the database.
        let genieDB = FMDatabase(path: String(databasePath))
        
        if genieDB.open() {
            
            
           let insertSQL = "UPDATE GENERAL SET HOMEIMAGE='\(homeimage)' where id=1"
           let result = genieDB.executeStatements(insertSQL)
            
           if !result {
                    print("Error: \(genieDB.lastErrorMessage())")
           }else{
                    
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
  
    
    
    
    var pickedImage: UIImage!
    
    
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
       
        
        var newImage: UIImage
        if let possibleImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            newImage = possibleImage
            pickedImage = possibleImage
        } else if let possibleImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            newImage = possibleImage
            pickedImage = possibleImage
        }
       
        if chosenButton=="1" {
            btn1ImageView.image = pickedImage
            saveDesignButton(1, designImage: "btn1-user")
            let path = getSupportPath("images")
            saveImage(pickedImage, path: path, filename: "btn1-user.jpg")
        }else if chosenButton == "2"{
            btn2ImageView.image = pickedImage
            saveDesignButton(2, designImage: "btn2-user")
            let path = getSupportPath("images")
            saveImage(pickedImage, path: path, filename: "btn2-user.jpg")
        }else if chosenButton == "3"{
            btn3ImageView.image = pickedImage
            saveDesignButton(3, designImage: "btn3-user")
            let path = getSupportPath("images")
            saveImage(pickedImage, path: path, filename: "btn3-user.jpg")
        }else if chosenButton == "4"{
            btn4ImageView.image = pickedImage
            saveDesignButton(4, designImage: "btn4-user")
            let path = getSupportPath("images")
            saveImage(pickedImage, path: path, filename: "btn4-user.jpg")
        }else if chosenButton == "5" {
            btn5ImageView.image = pickedImage
            saveDesignButton(5, designImage: "btn5-user")
            let path = getSupportPath("images")
            saveImage(pickedImage, path: path, filename: "btn5-user.jpg")
        }else if chosenButton == "Main" {
            appImageView.image = pickedImage
            setDefaultGeneral("bg-home-user")
            let path = getSupportPath("images")
            saveImage(pickedImage, path: path, filename: "bg-home-user.jpg")
                      
        }
        dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    func grabMainImage(){
        let databasePath = getSupportPath("genie.db") // grab the database.
        let genieDB = FMDatabase(path: String(databasePath))
        if genieDB.open() {
            let querySQL = "SELECT HOMEIMAGE FROM GENERAL WHERE id=1"
            let results:FMResultSet? = genieDB.executeQuery(querySQL, withArgumentsInArray: nil)
            if results?.next() == true {
                appImageView.image = UIImage(named: (fileInDocumentsDirectory((results?.stringForColumn("HOMEIMAGE"))!)))
                print(results?.stringForColumn("HOMEIMAGE")!)
            } else {
                print("Records not found in database for 'General Settings'.")
            }
            genieDB.close()
        }

    }
    
    func grabButtonImageName(designId: Int)-> String{
        let databasePath = getSupportPath("genie.db") // grab the database.
        let genieDB = FMDatabase(path: String(databasePath))
        var imageName = ""
        if genieDB.open() {
            let querySQL = "SELECT DESIGNIMAGE FROM DESIGNS where DESIGNID=\(designId)"
            let results:FMResultSet? = genieDB.executeQuery(querySQL, withArgumentsInArray: nil)
            if results?.next() == true {
                imageName = (results?.stringForColumn("DESIGNIMAGE"))!
                print(results?.stringForColumn("designimage")!)
            } else {
                print("Records not found in database for 'General Settings'.")
            }
            genieDB.close()
        }
        return imageName
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Reset to Defaults
        let value = UIInterfaceOrientation.LandscapeRight.rawValue
        UIDevice.currentDevice().setValue(value, forKey: "orientation")
        imagePicker.delegate = self
        grabMainImage() // Sets the initial values imageray based on any saved results.
        //Set up 4 button images (4 were saved as defaults) (currently hard coded, but will likely be dynamically set from a back end maybe at some point.
        btn1ImageView.image = UIImage(named: (fileInDocumentsDirectory(grabButtonImageName(1))))
        btn2ImageView.image = UIImage(named: (fileInDocumentsDirectory(grabButtonImageName(2))))
        btn3ImageView.image = UIImage(named: (fileInDocumentsDirectory(grabButtonImageName(3))))
        btn4ImageView.image = UIImage(named: (fileInDocumentsDirectory(grabButtonImageName(4))))
        

        
    }


    
    
}
