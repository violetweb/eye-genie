//
//  CustomizationController.swift
//  Eye-Genie
//
//  Written by Valerie Trotter on 2015-12-09.
//  Copyright © 2015 Bceen Ventures. All rights reserved.
//

import UIKit

class CustomizationController:  UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate  {

    
    
    let imagePicker = UIImagePickerController()
    var chosenButton = "Main"

    let button1Tap = UITapGestureRecognizer()
    let button2Tap = UITapGestureRecognizer()
    let button3Tap = UITapGestureRecognizer()
    let button4Tap = UITapGestureRecognizer()
    let appViewTap = UITapGestureRecognizer()
    let imageLogoTap = UITapGestureRecognizer()

 
    @IBOutlet weak var Button4: UIImageView!
    @IBOutlet weak var Button3: UIImageView!
    @IBOutlet weak var Button2: UIImageView!
    @IBOutlet weak var Button1: UIImageView!
    @IBOutlet weak var appImageView: UIImageView!
    @IBOutlet weak var imageLogo: UIImageView!
    
    
    func btnDesign4() {
      
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .PhotoLibrary
        imagePicker.modalPresentationStyle = .Popover
        imagePicker.popoverPresentationController?.sourceView = self.view
        imagePicker.popoverPresentationController?.permittedArrowDirections = .Right
        imagePicker.popoverPresentationController?.sourceRect = ContainerView.bounds
        presentViewController(imagePicker, animated: true, completion: nil)

        chosenButton = "4"

    }
    
    func btnDesign3() {
    
    
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .PhotoLibrary
        imagePicker.modalPresentationStyle = .Popover
        imagePicker.popoverPresentationController?.sourceView = self.view
        imagePicker.popoverPresentationController?.permittedArrowDirections = .Right
        imagePicker.popoverPresentationController?.sourceRect = ContainerView.bounds //CGRectMake(300,300,0,0)
        
        presentViewController(imagePicker, animated: true, completion: nil)
        chosenButton = "3"

    }
    
    
    func btnDesign2() {
        
     
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .PhotoLibrary
        imagePicker.modalPresentationStyle = .Popover
        imagePicker.popoverPresentationController?.sourceView = self.view
        imagePicker.popoverPresentationController?.permittedArrowDirections = .Right
        imagePicker.popoverPresentationController?.sourceRect = ContainerView.bounds
        presentViewController(imagePicker, animated: true, completion: nil)
        chosenButton = "2"

    }
  
    
    func btnDesign1() {
        
        
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .PhotoLibrary
        imagePicker.modalPresentationStyle = .Popover
        imagePicker.popoverPresentationController?.sourceView = self.view
        imagePicker.popoverPresentationController?.permittedArrowDirections = .Right
        imagePicker.popoverPresentationController?.sourceRect = ContainerView.bounds
        presentViewController(imagePicker, animated: true, completion: nil)
        chosenButton = "1"

    }
    
    func btnAppImage() {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .PhotoLibrary
        imagePicker.modalPresentationStyle = .Popover
        imagePicker.popoverPresentationController?.sourceView = self.view
        imagePicker.popoverPresentationController?.permittedArrowDirections = .Right
        imagePicker.popoverPresentationController?.sourceRect = ContainerView.bounds
        presentViewController(imagePicker, animated: true, completion: nil)
        chosenButton = "Main"

    }
    
    
    func btnImageLogo() {
        
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .PhotoLibrary
        imagePicker.modalPresentationStyle = .Popover
        imagePicker.popoverPresentationController?.sourceView = self.view
        imagePicker.popoverPresentationController?.permittedArrowDirections = .Right
        imagePicker.popoverPresentationController?.sourceRect = ContainerView.bounds
        presentViewController(imagePicker, animated: true, completion: nil)
        chosenButton = "Logo"
        
    }

    func btnSwap(chosenB: String){
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .PhotoLibrary
        imagePicker.modalPresentationStyle = .Popover
        imagePicker.popoverPresentationController?.sourceView = self.view
        imagePicker.popoverPresentationController?.permittedArrowDirections = .Right
        imagePicker.popoverPresentationController?.sourceRect = ContainerView.bounds
        presentViewController(imagePicker, animated: true, completion: nil)
        chosenButton = chosenB
    
    }
    
    
    func setMainImageFromDirectory(findimage: String){
        
        let fm = NSFileManager.defaultManager()
        let path = getSupportPath("images")  // applicationSupportdirectory + images
        let items = try! fm.contentsOfDirectoryAtPath(path)
        for item in items {
            if item.hasPrefix(findimage) {
                let itemImage = path + "/" + item
                print("SET MAIN IMAGE FROM DIRECTORY : \(itemImage)")
                appImageView.image = UIImage.init(contentsOfFile: itemImage)
            }
        }
        
    }
    
    
    
    
    func setImageView(findimage: String, imageview: UIImageView){
        
        let fm = NSFileManager.defaultManager()
        let path = getSupportPath("images")  // applicationSupportdirectory + images
        let items = try! fm.contentsOfDirectoryAtPath(path)
        for item in items {
            if item.hasPrefix(findimage) {
                let itemImage = path + "/" + item
                imageview.image = UIImage.init(contentsOfFile: itemImage)
                imageview.setNeedsDisplay()
                
            }
        }
        
    }
    
    func setBtn1FromDirectory(findimage: String){
        
        let fm = NSFileManager.defaultManager()
        let path = getSupportPath("images")  // applicationSupportdirectory + images
        let items = try! fm.contentsOfDirectoryAtPath(path)
        for item in items {
            if item.hasPrefix(findimage) {
                let itemImage = path + "/" + item
                Button1.image = UIImage.init(contentsOfFile: itemImage)
                
            }
        }
        
    }

    
    func setBtn2FromDirectory(findimage: String){
        
        let fm = NSFileManager.defaultManager()
        let path = getSupportPath("images")  // applicationSupportdirectory + images
        let items = try! fm.contentsOfDirectoryAtPath(path)
        for item in items {
            if item.hasPrefix(findimage) {
                let itemImage = path + "/" + item
                Button2.image = UIImage.init(contentsOfFile: itemImage)
                
            }
        }
        
    }
    func setBtn3FromDirectory(findimage: String){
        
        let fm = NSFileManager.defaultManager()
        let path = getSupportPath("images")  // applicationSupportdirectory + images
        let items = try! fm.contentsOfDirectoryAtPath(path)
        for item in items {
            if item.hasPrefix(findimage) {
                let itemImage = path + "/" + item
                Button3.image = UIImage.init(contentsOfFile: itemImage)
                
            }
        }
        
    }
    func setBtn4FromDirectory(findimage: String){
        
        let fm = NSFileManager.defaultManager()
        let path = getSupportPath("images")  // applicationSupportdirectory + images
        let items = try! fm.contentsOfDirectoryAtPath(path)
        for item in items {
            if item.hasPrefix(findimage) {
                let itemImage = path + "/" + item
                Button4.image = UIImage.init(contentsOfFile: itemImage)
                
            }
        }
        
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
        let writePath = (folderPath as NSString).stringByAppendingPathComponent("/images") //  Can we specific ourselves??
        return writePath
    }
    
    
    // Get path for a file in the directory
    func fileInDocumentsDirectory(filename: String) -> String {
        //print(supportDirectory() + filename)
        return supportDirectory() + "/" + filename
    }
    
    
    
    
    func loadImageFromPath(path: String) -> UIImage? {
        
        let image = UIImage(contentsOfFile: path)
        if image == nil {
            print("missing image at: (path)")
        }
        //  print("(path)") // this is just for you to see the path in case you want to go to the directory, using Finder.
        return image
        
    }
    
    func getSupportPath(fileName: String) -> String {
        let documentsURL = NSFileManager.defaultManager().URLsForDirectory(.ApplicationSupportDirectory, inDomains: .UserDomainMask)[0]
        let fileURL = documentsURL.URLByAppendingPathComponent(fileName)
        print(fileURL.path!)
        return fileURL.path!
    }
    
    
    func saveDesignButton(designId: Int, designImage: String){
        
        let databasePath = getSupportPath("genie.db") // grab the database.
        let genieDB = FMDatabase(path: String(databasePath))
        
        if genieDB.open() {
            
            
            let insertSQL = "UPDATE DESIGNS SET imagename='\(designImage)' where id=\(designId)"
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
    
    
    func saveMainImage(homeimage: String){
        
        
        let databasePath = getSupportPath("genie.db") // grab the database.
        let genieDB = FMDatabase(path: String(databasePath))
        
        if genieDB.open() {
            
            
            let insertSQL = "UPDATE GENERAL SET HOMEIMAGE='\(homeimage)' where id=1"
            let result = genieDB.executeStatements(insertSQL)
            print("updating the main image name to : \(insertSQL)")
            if !result {
                print("Error: \(genieDB.lastErrorMessage())")
            }else{
                
            }
            genieDB.close()
            
            
        } else {
            print("Error: \(genieDB.lastErrorMessage())")
        }
        
        
    }

    func saveLogoImage(logoimage: String){
        
        
        let databasePath = getSupportPath("genie.db") // grab the database.
        let genieDB = FMDatabase(path: String(databasePath))
        
        if genieDB.open() {
            
            
            let insertSQL = "UPDATE GENERAL SET LOGOIMAGE='\(logoimage)' where id=1"
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
    

    
    
    var pickedImage: UIImage!
    
    
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        
        if let possibleImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            pickedImage = possibleImage
        } else if let possibleImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            pickedImage = possibleImage
        }
        
        if chosenButton=="1" {
            Button1.image = pickedImage
            saveDesignButton(1, designImage: "btn1-user")
            let path = getSupportPath("images")
            saveImage(pickedImage, path: path, filename: "btn1-user")
        }else if chosenButton == "2"{
            Button2.image = pickedImage
            saveDesignButton(2, designImage: "btn2-user")
            let path = getSupportPath("images")
            saveImage(pickedImage, path: path, filename: "btn2-user")
        }else if chosenButton == "3"{
            Button3.image = pickedImage
            saveDesignButton(3, designImage: "btn3-user")
            let path = getSupportPath("images")
            saveImage(pickedImage, path: path, filename: "btn3-user")
        }else if chosenButton == "4"{
            Button4.image = pickedImage
            saveDesignButton(4, designImage: "btn4-user")
            let path = getSupportPath("images")
            saveImage(pickedImage, path: path, filename: "btn4-user")
        }else if chosenButton == "Main" {
            appImageView.image = pickedImage
            saveMainImage("bg-home-user")
            let path = getSupportPath("images")
            saveImage(pickedImage, path: path, filename: "bg-home-user")
        }else if chosenButton == "Logo" {
            imageLogo.image = pickedImage
            saveLogoImage("yourlogohere-user")
            let path = getSupportPath("images")
            saveImage(pickedImage, path: path, filename: "yourlogohere-user")
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
                setMainImageFromDirectory((results?.stringForColumn("HOMEIMAGE")!)!)
            } else {
                print("Records not found in database for 'General Settings'.")
            }
            genieDB.close()
        }
        
    }
    
    func grabLogoImage(){
        let databasePath = getSupportPath("genie.db") // grab the database.
        let genieDB = FMDatabase(path: String(databasePath))
        if genieDB.open() {
            let querySQL = "SELECT LOGOIMAGE FROM GENERAL WHERE id=1"
            let results:FMResultSet? = genieDB.executeQuery(querySQL, withArgumentsInArray: nil)
            if results?.next() == true {
                setImageView((results?.stringForColumn("LOGOIMAGE")!)!,imageview: imageLogo)
            } else {
                print("Records not found in database for 'General Settings'.")
            }
            genieDB.close()
        }
        
    }

    
    @IBAction func btnResetToDefaults(sender: UIButton) {
        
      
        
        
        //Buttons
        saveDesignButton(1, designImage: "btn-conventional")
        saveDesignButton(2, designImage: "btn-jenna")
        saveDesignButton(3, designImage: "btn-jenna-wide")
        saveDesignButton(4, designImage: "btn-jenna-4k")
        
        setImageView("btn-conventional", imageview: Button1)
        setImageView("btn-jenna", imageview: Button2)
        setImageView("btn-jenna-wide", imageview: Button3)
        setImageView("btn-jenna-4k", imageview: Button4)
        
        
        //Main Image.
        saveMainImage("bg-home")
        grabMainImage()
       
        
        saveLogoImage("yourlogohere")
        grabLogoImage()
        //Reset values to their defaults.
        chosenButton = "5"

    }
  
    func grabButtonImageName(designId: Int)-> String{
        let databasePath = getSupportPath("genie.db") // grab the database.
        let genieDB = FMDatabase(path: String(databasePath))
        var imageName = ""
        if genieDB.open() {
            let querySQL = "SELECT IMAGENAME FROM DESIGNS where ID=\(designId)"
            let results:FMResultSet? = genieDB.executeQuery(querySQL, withArgumentsInArray: nil)
            if results?.next() == true {
                imageName = (results?.stringForColumn("IMAGENAME"))!
            } else {
                print("Records not found in database for 'General Settings'.")
            }
            genieDB.close()
        }
        return imageName
    }
    
    
    @IBOutlet weak var ContainerView: UIView!
    
    
    override func viewDidAppear(animated: Bool)
    {
          //let value = UIInterfaceOrientation.LandscapeRight.rawValue
         // UIDevice.currentDevice().setValue(value, forKey: "orientation")
        imagePicker.delegate = self
        
        grabMainImage() // Sets the initial values imageray based on any saved results.
        grabLogoImage() // Sets logo image
        
        //Set up 4 button images (4 were saved as defaults) (currently hard coded, but will likely be dynamically set from a back end maybe at some point.
        setImageView(grabButtonImageName(1), imageview: Button1)
        setImageView(grabButtonImageName(2), imageview: Button2)
        setImageView(grabButtonImageName(3), imageview: Button3)
        setImageView(grabButtonImageName(4), imageview: Button4)
       
        
        button1Tap.addTarget(self, action: "btnDesign1")
        button2Tap.addTarget(self, action: "btnDesign2")
        button3Tap.addTarget(self, action: "btnDesign3")
        button4Tap.addTarget(self, action: "btnDesign4")
        appViewTap.addTarget(self, action: "btnAppImage")
        imageLogoTap.addTarget(self, action: "btnImageLogo")
        
        Button1.addGestureRecognizer(button1Tap)
        Button2.addGestureRecognizer(button2Tap)
        Button3.addGestureRecognizer(button3Tap)
        Button4.addGestureRecognizer(button4Tap)
        appImageView.addGestureRecognizer(appViewTap)
        imageLogo.addGestureRecognizer(imageLogoTap)

        Button1.userInteractionEnabled = true
        Button2.userInteractionEnabled = true
        Button3.userInteractionEnabled = true
        Button4.userInteractionEnabled = true
        appImageView.userInteractionEnabled = true
        imageLogo.userInteractionEnabled = true
        
    }
    
    override func shouldAutorotate() -> Bool {
        return true
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return [UIInterfaceOrientationMask.LandscapeLeft,UIInterfaceOrientationMask.LandscapeRight]
    }

    
}
