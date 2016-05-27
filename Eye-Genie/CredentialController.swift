//
//  CredentialController.swift
//  Eye-Genie
//
//  Developer by Valerie Trotter on 2015-12-31.
//  Copyright © 2015 Bceen Ventures. All rights reserved.
//

import UIKit

class CredentialController: UIViewController {
    
    
   
    
    var spinner: UIActivityIndicatorView = UIActivityIndicatorView()
    let defaults = NSUserDefaults.standardUserDefaults()
   
    
    func showActivityIndicator(uiView: UIView) {
        let actInd: UIActivityIndicatorView = UIActivityIndicatorView()
        actInd.frame = CGRectMake(0.0, 0.0, 40.0, 40.0);
        actInd.center = uiView.center
        actInd.hidesWhenStopped = true
        actInd.activityIndicatorViewStyle =
            UIActivityIndicatorViewStyle.WhiteLarge
        uiView.addSubview(actInd)
        spinner.startAnimating()
    }

    func getSupportPath(fileName: String) -> String {
        let documentsURL = NSFileManager.defaultManager().URLsForDirectory(.ApplicationSupportDirectory, inDomains: .UserDomainMask)[0]
        let fileURL = documentsURL.URLByAppendingPathComponent(fileName)
        return fileURL.path!
    }

    func getLoginIdentifier()->String {
        let databasePath = getSupportPath("genie.db") // grab the database.
        let genieDB = FMDatabase(path: databasePath)
        var loginIdentifier:String = ""
        
        if genieDB.open() {
            let querySQL = "SELECT LOGINIDENTIFIER FROM GENERAL WHERE id=1"
            let results:FMResultSet? = genieDB.executeQuery(querySQL, withArgumentsInArray: nil)
    
            if results?.next() == true {
                loginIdentifier = (results?.stringForColumn("LOGINIDENTIFIER")!)!
            }
            genieDB.close()
        } else {
            print("Error: \(genieDB.lastErrorMessage())")
        }
        return loginIdentifier
    }
    
    
    func displayAlert(title: String, message: String) {
        
        self.spinner.stopAnimating()
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
        
    }
    
    
    @IBAction func btnSendLogin(sender: UIButton) {
        
        
         sender.buttonBounce()
        
        //Activate the spinner (don't allow any interaction until results are returned.
        spinner = UIActivityIndicatorView(frame: CGRectMake(0,0,50,50))
        spinner.center = self.view.center
        spinner.hidesWhenStopped = true
        spinner.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        view.addSubview(spinner)
        spinner.startAnimating()
        UIApplication.sharedApplication().beginIgnoringInteractionEvents()
        processEmail() {
            jsonString in
            for (IsSent) in jsonString {
               
                if (IsSent.value as! NSString != "false"){
                     UIApplication.sharedApplication().endIgnoringInteractionEvents()
                     self.displayAlert("Email Result", message: "Your credentials successfully sent to your email address on file.")
                }else{
                    print(IsSent.value)
                    UIApplication.sharedApplication().endIgnoringInteractionEvents()
                    self.displayAlert("Email Result", message: "We are unable to find your credentials in our system. Please contact a customer service representative.")
                    
                }
            }
            
           
    }
    

    
    
    }


    func processEmail(completion: (NSDictionary) -> ()) {
        
        
        //Make sure username and password values are valid enough to pass through the Rest API
        let customAllowedSet =  NSCharacterSet(charactersInString:"=\"#%/<>?@\\^`{|}&").invertedSet
        let CustomerID:String = getLoginIdentifier() as String!
        let escapedCustomerID = CustomerID.stringByAddingPercentEncodingWithAllowedCharacters(customAllowedSet)

        
        //Check User Authorization Status
        let url = NSURL(string: "https://lens.care/EyeWizardService.svc/EyeWizardSend")
        let params: [String: String] = ["CustomerID": "\(escapedCustomerID)"]
        let request = NSMutableURLRequest(URL:url!)
        request.HTTPMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    
        //Send the information in a POST and using JSON!!!! formatting.
        let jsonData = try! NSJSONSerialization.dataWithJSONObject(params, options: NSJSONWritingOptions(rawValue:0))
        request.HTTPBody = jsonData
       
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request, completionHandler: {   (data, response, error)-> Void in
            do {
                let data = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
                completion(data)
            } catch let myJSONError {
                //Add popup to let user know that it was unsuccessful.
                UIApplication.sharedApplication().endIgnoringInteractionEvents()
                self.displayAlert("Email Result", message: "We are unable to send the information at this time; an error occured which may need to be reported.  Try again in a few minutes.  \(myJSONError)")
            }
    
    })
    task.resume()
    
    
    }

    
 
    override func viewDidAppear(animated: Bool){
        
        
    }
    
    
    override func shouldAutorotate() -> Bool {
        return true
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return [UIInterfaceOrientationMask.LandscapeLeft,UIInterfaceOrientationMask.LandscapeRight]
    }

    
}