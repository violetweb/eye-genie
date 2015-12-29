//
//  LoginViewController.swift
//  Eye-Genie
//
//  Created by Ryan Maxwell on 2015-12-01.
//  Copyright © 2015 Bceen Ventures. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    
    
    
    
    @IBOutlet weak var lblWelcome: UILabel!
    @IBOutlet weak var lblInstruction: UILabel!
    @IBOutlet weak var Username: UITextField!
    @IBOutlet weak var Password: UITextField!
    @IBOutlet weak var appImageView: UIImageView!
    @IBOutlet weak var imageLogo: UIImageView!
    
    
    let defaults = NSUserDefaults.standardUserDefaults()
    var spinner: UIActivityIndicatorView = UIActivityIndicatorView()
    var timer = NSTimer()
    var UserLoggedIn = false

    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        // let interval = Double(60) // four hours check it...
        // timer = NSTimer.scheduledTimerWithTimeInterval(interval, target:self, selector: Selector("logoutUser"), userInfo: nil, repeats: true)
        
    }
    
    
    func updateUserLoggedInFlag() {
        // Update the NSUserDefaults flag
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject("loggedIn", forKey: "userLoggedIn")
        defaults.synchronize()
    }
    
    @IBAction func btnLogin(sender: UIButton) {
        
        
        sender.buttonBounce()
        
        // resign the keyboard for text fields
        // by asking if its the first responder, we're saying it has a touch event + ties directly to the touch features...
        if self.Username.isFirstResponder() {
            self.Username.resignFirstResponder()
        }
        
        if self.Password.isFirstResponder() {
            self.Password.resignFirstResponder()
        }
        
        //Activate the spinner (don't allow any interaction until results are returned.
        spinner = UIActivityIndicatorView(frame: CGRectMake(0,0,50,50))
        spinner.center = self.view.center
        spinner.hidesWhenStopped = true
        spinner.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        view.addSubview(spinner)
        spinner.startAnimating()
        UIApplication.sharedApplication().beginIgnoringInteractionEvents()
        
        
        
        if (Username.text!.characters.count>0 && Password.text!.characters.count>4) {
            
            
            processLogin(){
                jsonString in
                for (IsAllowed) in jsonString {
                    
                    if (IsAllowed.value as! NSString == "1"){
                        UIApplication.sharedApplication().endIgnoringInteractionEvents()
                        self.UserLoggedIn = true
                        self.performSegueWithIdentifier("LoginSegue", sender: self)
                        
                    }else{
                        //  print(IsAllowed.value)
                        
                        UIApplication.sharedApplication().endIgnoringInteractionEvents()
                        self.displayAlert("Login Result", message: "We are unable to find an account with the username and password provided.  If you are having trouble logging in, please contact your client service representative.")
                        
                        
                    }
                }
                
                
            }
        }else{
            
            UIApplication.sharedApplication().endIgnoringInteractionEvents()
            self.displayAlert("Login Result", message: "We are unable to find an account with the username and password provided.  If you are having trouble logging in, please contact your client service representative.")
            
            
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
        
        
        self.spinner.stopAnimating()
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
        
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
        getSavedImages()
        // Do any additional setup after loading the view.
        
        //  let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "DismissKeyboard")
        //  view.addGestureRecognizer(tap)
        
        
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */

    
    
    
}
