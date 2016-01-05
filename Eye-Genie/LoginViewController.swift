//
//  LoginViewController.swift
//  Eye-Genie
//
//  Created by Valerie Trotter on 2015-12-01.
//  Copyright © 2015 Bceen Ventures. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    
    
    
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var lblWelcome: UILabel!
    @IBOutlet weak var lblInstruction: UILabel!
    @IBOutlet weak var Username: UITextField!
    @IBOutlet weak var Password: UITextField!
    @IBOutlet weak var appImageView: UIImageView!
    @IBOutlet weak var imageLogo: UIImageView!
 
    
    let defaults = NSUserDefaults.standardUserDefaults()
    var timer = NSTimer()
    var UserLoggedIn = false
    var spinnerIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    func saveLoginIdentifier(loginIdentifier: String)->Bool {
        
        let databasePath = getSupportPath("genie.db") // grab the database.
        let genieDB = FMDatabase(path: String(databasePath))
        var loginSuccess = false
        if genieDB.open() {
            
            let insertSQL = "UPDATE GENERAL SET LOGINIDENTIFIER='\(loginIdentifier)' where id=1"
            let result = genieDB.executeStatements(insertSQL)
            if !result {
                print("Error: \(genieDB.lastErrorMessage())")
            }else{
                loginSuccess = true
            }
            genieDB.close()
            
        } else {
            print("Error: \(genieDB.lastErrorMessage())")
        }
        return loginSuccess
    }
    
    
    func updateUserLoggedInFlag() {
        // Update the NSUserDefaults flag
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject("loggedIn", forKey: "userLoggedIn")
        defaults.synchronize()
    }
    
    
    var container: UIView = UIView()
    var loadingView: UIView = UIView()
    
    
    func startSpinner(){
        
        container.frame = appImageView.frame
        container.center = appImageView.center
        container.backgroundColor = UIColorFromHex(0x333333, alpha: 0.7)
        container.layer.zPosition = 2
        
        loadingView.frame = CGRectMake(0, 0, 80, 80)
        loadingView.center = appImageView.center
        loadingView.backgroundColor = UIColorFromHex(0x000000, alpha: 0.5)
        loadingView.clipsToBounds = true
        loadingView.layer.cornerRadius = 10
        loadingView.layer.zPosition = 3
        
        spinnerIndicator.center = appImageView.center
        spinnerIndicator.color = UIColorFromHex(0xffffff, alpha: 1.0)
        spinnerIndicator.frame = CGRectMake(0,0,80,80)
        spinnerIndicator.hidden = false
        spinnerIndicator.startAnimating()

        container.addSubview(loadingView)
        loadingView.addSubview(spinnerIndicator)
        mainView.addSubview(container)

       
        

    }
    
    func stopSpinner(alertTitle: String, alertMessage: String){
       
        UIApplication.sharedApplication().endIgnoringInteractionEvents()
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),
            {
                //dispatch back to the main (UI) thread to stop the activity indicator
                dispatch_async(dispatch_get_main_queue(),
                    {
                        if (alertTitle != "" && alertMessage != ""){
                            self.displayAlert(alertTitle, message: alertMessage)
                            //if there is an alert to display, pass to alert, and it will cancel animation.
                        }else{
                            self.spinnerIndicator.stopAnimating()
                            self.container.removeFromSuperview()
                        }
                        
                });
        });

        
    }
    
    
    @IBAction func btnLogin(sender: UIButton) {
        
      startSpinner()
        // resign the keyboard for text fields
        // by asking if its the first responder, we're saying it has a touch event + ties directly to the touch features...
        if self.Username.isFirstResponder() {
            self.Username.resignFirstResponder()
        }
        
        if self.Password.isFirstResponder() {
            self.Password.resignFirstResponder()
        }
        
        
        UIApplication.sharedApplication().beginIgnoringInteractionEvents()
        
        if (Username.text!.characters.count>0 && Password.text!.characters.count>4) {
            
            processLogin(){
                jsonString in
                    for (IsAllowed) in jsonString {
                        if (IsAllowed.value as! NSString != "0"){
                             UIApplication.sharedApplication().endIgnoringInteractionEvents()
                             self.saveLoginIdentifier(IsAllowed.value as! String)
                             self.UserLoggedIn = true
                             self.performSegueWithIdentifier("LoginSegue", sender: self)
                         }else{
                            self.stopSpinner("Login Result",alertMessage: "We are unable to find an account with the username and password provided.  If you are having trouble logging in, please contact your client service representative.")
                        
                        }
                    }
                
                }
        }else{
            stopSpinner("Login Result", alertMessage: "We are unable to find an account with the username and password provided.  If you are having trouble loggin in, please contact your client service representative.")
            
        }
    }
    
    
    func processLogin(completion: (NSDictionary) -> ()){
       
        
        
        
        //Make sure username and password values are valid enough to pass through the Rest API
        let customAllowedSet =  NSCharacterSet(charactersInString:"=\"#%/<>?@\\^`{|}&").invertedSet
        let escapedUsername = Username.text!.stringByAddingPercentEncodingWithAllowedCharacters(customAllowedSet)
        let escapedPassword = Password.text!.stringByAddingPercentEncodingWithAllowedCharacters(customAllowedSet)
        
        
        //Check User Authorization Status
        let url = NSURL(string: "https://lens.care/EyeWizardService.svc/EyeWizard")
        let params: [String: String] = ["Username": "\(escapedUsername!)", "Password": "\(escapedPassword!)"]
        let request = NSMutableURLRequest(URL:url!)
        
        request.HTTPMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        //Send the information in a POST and using JSON!!!! formatting.
        let jsonData = try! NSJSONSerialization.dataWithJSONObject(params, options: NSJSONWritingOptions(rawValue:0))
        request.HTTPBody = jsonData
      
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request, completionHandler: {   (data, response, error)-> Void in
            //NSJSONReadingOptions.MutableContainers
            
            
           do {
                let data = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
                completion(data)
            
            } catch let myJSONError {
               
                //Add popup to let user know that it was unsuccessful.
                UIApplication.sharedApplication().endIgnoringInteractionEvents()
                self.displayAlert("Login Result", message: "We are unable to login at this time; please try again in a few minutes.")
                
                

            }
            
        })
        task.resume()
        

        
    }
    
    
    func convertStringToDictionary(text: String) -> [String:String]? {
        if let data = text.dataUsingEncoding(NSUTF8StringEncoding) {
            do {
                let json = try NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers) as? [String:String]
                return json
            } catch {
                print("Something went wrong")
            }
        }
        return nil
    }
    
    
    func getSupportPath(fileName: String) -> String {
        let documentsURL = NSFileManager.defaultManager().URLsForDirectory(.ApplicationSupportDirectory, inDomains: .UserDomainMask)[0]
        let fileURL = documentsURL.URLByAppendingPathComponent(fileName)
        return fileURL.path!
    }
    
    
    func displayAlert(title: String, message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        
        //The action Handler
        let callActionHandler = { (action:UIAlertAction!) -> Void in
            self.spinnerIndicator.stopAnimating()
            self.container.removeFromSuperview()
        }
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: callActionHandler))
            
        self.presentViewController(alert, animated: true, completion:nil)
     
   }
    
    //Calls this function when the tap is recognized.
    func DismissKeyboard(){
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    
    override func viewDidAppear(animated: Bool){
        
        
        
        lblWelcome.center.x = view.bounds.width
        lblInstruction.center.y = view.bounds.height-view.bounds.height
        lblInstruction.center.x = view.bounds.width/2
        Username.center.x = view.bounds.width
        Password.center.x = view.bounds.width
        imageLogo.center.y = view.bounds.height-(view.bounds.height+100)
        
        
        UIView.animateWithDuration(0.5, animations: {
            self.lblWelcome.center.x -= self.view.bounds.width/2
        })
        
        UIView.animateWithDuration(0.5, delay: 0.5, options: [], animations: {
            self.Username.center.x -= self.view.bounds.width/2
            }, completion: nil)
        
        UIView.animateWithDuration(0.5, delay: 0.5, options: [], animations: {
            self.Password.center.x -= self.view.bounds.width/2
            }, completion: nil)
        
        UIView.animateWithDuration(0.5, delay: 0.7, options: [], animations: {
            self.lblInstruction.center.y += self.view.bounds.height/6
            }, completion: nil)
        
        UIView.animateWithDuration(1.0, delay: 1.0, options: [], animations: {
            self.imageLogo.center.y += (self.view.bounds.height-200)
        },completion: nil)
        
        
        getSavedImages()
        
    }
    
    
    func setImageFromDirectory(findimage: String){
        
        let fm = NSFileManager.defaultManager()
        let path = getSupportPath("images")  // applicationSupportdirectory + images
        let items = try! fm.contentsOfDirectoryAtPath(path)
        for item in items {
            if item.hasPrefix(findimage) {
                let itemImage = path + "/" + item
                appImageView.image = UIImage.init(contentsOfFile: itemImage)
                
            }
        }
        
    }
    
    
    func insertDefaultGeneral(){
        
        
        let genieDB = FMDatabase(path: String(databasePath))
        
        if genieDB.open() {
            
            let insertSQL = "INSERT INTO GENERAL (HOMEIMAGE, COMPANYNAME, COMPANYPHONE, ACTIVE) VALUES ('bg-home', 'OPTIK KANDR', '416-915-1550', 1)"
            let result = genieDB.executeUpdate(insertSQL,
                withArgumentsInArray: nil)
            
            if !result {
                print("Error: \(genieDB.lastErrorMessage())")
            }else{
                print("inserted general")
            }
        } else {
            print("Error: \(genieDB.lastErrorMessage())")
        }
        
        
    }
    
    /*** TO USE :  UIColorFromHex(0x444444, alpha: 0.7)  ***/
    func UIColorFromHex(rgbValue:UInt32, alpha:Double=1.0)->UIColor {
        let red = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
        let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
        let blue = CGFloat(rgbValue & 0xFF)/256.0
        return UIColor(red:red, green:green, blue:blue, alpha:CGFloat(alpha))
    }
    

    
 
    
    
    
    func getSavedImages(){
        
        //Save to DATABASE.
        databasePath = getSupportPath("genie.db") // grab the database.
        let genieDB = FMDatabase(path: databasePath)
        
        if genieDB.open() {
            let querySQL = "SELECT HOMEIMAGE, LOGOIMAGE, ACTIVE FROM GENERAL WHERE id=1"
            
            let results:FMResultSet? = genieDB.executeQuery(querySQL,
                withArgumentsInArray: nil)
            
            if results?.next() == true {
                let homeimage = results?.stringForColumn("HOMEIMAGE")!
                setImageFromDirectory(homeimage!)
                let logoimage = results?.stringForColumn("LOGOIMAGE")!
                setImageView(logoimage!, imageview: imageLogo)
            } else {
                setImageFromDirectory("bg-home")
                setImageView("yourlogohere", imageview: imageLogo)

            }
            genieDB.close()
        } else {
            print("Error: \(genieDB.lastErrorMessage())")
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
                
            }
        }
        
    }

    
    
    var databasePath = String()
    
    //Add all tables here, as "set-up" with default values.
    func setUpDatabase(){
        
        
        if !NSFileManager.defaultManager().fileExistsAtPath(databasePath) {
            databasePath = getSupportPath("genie.db") // grab the database.
            
            let genieDB = FMDatabase(path: String(databasePath))
            
            if genieDB == nil {
                print("Error: \(genieDB.lastErrorMessage())")
            }
            
            if genieDB.open() {
                
                let sql_stmt1 = "CREATE TABLE IF NOT EXISTS GENERAL (ID INTEGER PRIMARY KEY AUTOINCREMENT, HOMEIMAGE TEXT, COMPANYNAME TEXT, COMPANYPHONE TEXT, ACTIVE INTEGER)"
                if !genieDB.executeStatements(sql_stmt1) {
                    print("Error: \(genieDB.lastErrorMessage())")
                }else{
                    insertDefaultGeneral()
                }
                let sql_stmt2 = "CREATE TABLE IF NOT EXISTS DESIGNS (ID INTEGER PRIMARY KEY AUTOINCREMENT, DESIGNTYPENAME TEXT, IMAGENAME TEXT, MAXBLUR INTEGER)"
                if !genieDB.executeStatements(sql_stmt2) {
                    print("Error: \(genieDB.lastErrorMessage())")
                }
                let sql_stmt3 = "CREATE TABLE IF NOT EXISTS DESIGNPOINTS (ID INTEGER PRIMARY KEY AUTOINCREMENT, DESIGNID INTEGER, P1X REAL, P1Y REAL, P2X REAL, P2Y REAL, P3X REAL, P3Y REAL, P4X REAL, P4Y REAL)"
                if !genieDB.executeStatements(sql_stmt3) {
                    print("Error: \(genieDB.lastErrorMessage())")
                }
                let sql_stmt4 = "CREATE TABLE IF NOT EXISTS MATERIAL (ID INTEGER PRIMARY KEY AUTOINCREMENT, MATERIALNAME TEXT, MATERIALINDEX REAL, ABBEVALUE REAL, SPECIFICGRAVITY REAL)"
                if !genieDB.executeStatements(sql_stmt4) {
                    print("Error: \(genieDB.lastErrorMessage())")
                }else{
                    print("table created for material")
                }
                
                
                
                genieDB.close()
                
                
            } else {
                print("Error: \(genieDB.lastErrorMessage())")
            }
            
        }
        
    }
    
    func resetDatabase(){
        
        
    }
    
    
    override func viewDidLoad() {
       
        super.viewDidLoad()
       // getSavedImages()
        
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
 
    
    
    
}
