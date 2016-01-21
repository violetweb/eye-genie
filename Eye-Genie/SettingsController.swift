//
//  SettingsController.swift
//  Eye-Genie
//
//  Created by Ryan Maxwell on 2015-12-01.
//  Copyright © 2015 Bceen Ventures. All rights reserved.
//

import UIKit


class SettingsController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate,UITableViewDelegate {
    
    
    var DesignsController: UIViewController?
    var CredentialController: UIViewController?
    var CustomizationController: UIViewController?
    var CoatingsController: UIViewController?
    var RootController:  UIViewController?
    
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    
    
    let imagePicker = UIImagePickerController()
   
    
    var chosenButton = "Main"
    
    
    
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
    
   @IBOutlet weak var SettingsContainer: UIView!
    
    
    func saveMainImage(homeimage: String){
        
        
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
  
    
    private var activeViewController: UIViewController? {
        didSet {
            removeInactiveViewController(oldValue)
            updateActiveViewController()
        }
    }
    
    private func removeInactiveViewController(inactiveViewController: UIViewController?) {
        if let inActiveVC = inactiveViewController {
            // call before removing child view controller's view from hierarchy
            inActiveVC.willMoveToParentViewController(nil)
            
            inActiveVC.view.removeFromSuperview()
            
            // call after removing child view controller's view from hierarchy
            inActiveVC.removeFromParentViewController()
        }
    }
    
    private func updateActiveViewController() {
       
        if let activeVC = activeViewController {
            // call before adding child view controller's view as subview
            self.addChildViewController(activeVC)
            activeVC.view.frame = SettingsContainer.bounds
            SettingsContainer.addSubview(activeVC.view)
            // call before adding child view controller's view as subview
            activeVC.didMoveToParentViewController(self)
        }else{
            print("didn't match.")
        }
    }
    
    

    @IBOutlet weak var navigationBar: UINavigationBar!

    
    @IBAction func segmentToggle(sender: UISegmentedControl) {
        
        
        if (sender.selectedSegmentIndex==0) {
          activeViewController = (storyboard?.instantiateViewControllerWithIdentifier("CustomizationController"))! as UIViewController
          SettingsContainer.addSubview(activeViewController!.view)
          
        } else if (sender.selectedSegmentIndex==1) {
            activeViewController = (storyboard?.instantiateViewControllerWithIdentifier("CoatingsController"))! as UIViewController
            SettingsContainer.addSubview(activeViewController!.view)
          
        }else if (sender.selectedSegmentIndex==2){
            activeViewController = (storyboard?.instantiateViewControllerWithIdentifier("DesignsController"))! as UIViewController
            SettingsContainer.addSubview(activeViewController!.view)
        } else if (sender.selectedSegmentIndex==3){
            activeViewController = (storyboard?.instantiateViewControllerWithIdentifier("CoatingsController"))! as UIViewController
            SettingsContainer.addSubview(activeViewController!.view)
        }else if (sender.selectedSegmentIndex == 4){
            activeViewController = (storyboard?.instantiateViewControllerWithIdentifier("OrderController"))! as UIViewController
            SettingsContainer.addSubview(activeViewController!.view)
            
        }
        
        
        
    }
   
    override func viewDidAppear(animated: Bool)
    {
        
        RootController = (storyboard?.instantiateViewControllerWithIdentifier("SettingsController"))! as UIViewController
       activeViewController = (storyboard?.instantiateViewControllerWithIdentifier("CustomizationController"))! as UIViewController
        SettingsContainer.addSubview(activeViewController!.view)

        

    }
   
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
             // updateActiveViewController()
        
   }

    override func shouldAutorotate() -> Bool {
        return true
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return [UIInterfaceOrientationMask.LandscapeLeft,UIInterfaceOrientationMask.LandscapeRight]
    }

    
    
}
