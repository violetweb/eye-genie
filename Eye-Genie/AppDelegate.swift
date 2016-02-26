//
//  AppDelegate.swift
//  Eye-Genie
//
//  Created by Valerie Trotter on 2015-12-01.
//  Copyright © 2015 Bceen Ventures. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
   
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        dropData() //- dumps the genie.db and resets up everything... used while testing.
        setUpDatabase()
        setUpFiles()

        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        
      //  var timer = NSTimer()
      //  let interval = Double(60) // four hours check it...
      //  timer = NSTimer.scheduledTimerWithTimeInterval(interval, target:self, selector: Selector("Logout"), userInfo: nil, repeats: true)
             //All attempts to have an auto-logout result in some strange error being throw which crashes the application.
      //  print("Entered background")
        
        
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    
    
    func getSupportPath(fileName: String) -> String {
        let documentsURL = NSFileManager.defaultManager().URLsForDirectory(.ApplicationSupportDirectory, inDomains: .UserDomainMask)[0]
        let fileURL = documentsURL.URLByAppendingPathComponent(fileName)
        return fileURL.path!
    }
    
    
      func dropData(){
        databasePath = getSupportPath("genie.db") // grab the database.
        if (NSFileManager.defaultManager().fileExistsAtPath(databasePath)) {
            do{
                try NSFileManager.defaultManager().removeItemAtPath(databasePath)
                
            } catch let error as NSError {
                print("failed: \(error.localizedDescription)")
            }
        }
    }
    
    
    //not using this but its here.
    func dropDataTables(){
        
        /*
        
        let genieDB = FMDatabase(path: String(databasePath))
        if genieDB.open() {
        
        var insertSQL = "DROP TABLE IF EXISTS GENERAL"
        do {
        try genieDB.executeUpdate(insertSQL, values: nil)
        
        } catch let error as NSError {
        print("failed: \(error.localizedDescription)")
        }
        insertSQL = "DROP TABLE IF EXISTS DESIGNS"
        do {
        try genieDB.executeUpdate(insertSQL, values: nil)
        
        } catch let error as NSError {
        print("failed: \(error.localizedDescription)")
        }
        insertSQL = "DROP TABLE IF EXISTS DESIGNPOINTS"
        do {
        try genieDB.executeUpdate(insertSQL, values: nil)
        
        } catch let error as NSError {
        print("failed: \(error.localizedDescription)")
        }
        
        
        
        }
        */
        
    }
    var databasePath = String()
    
    func insertDesigns(){
        
        
        let genieDB = FMDatabase(path: String(databasePath))
        
        
        if genieDB.open() {
            
            var insertSQL = "INSERT INTO DESIGNS (DESIGNTYPENAME, IMAGENAME, MAXBLUR) VALUES ('Conventional', 'btn-conventional', '10')"
            if genieDB.executeUpdate(insertSQL,  withArgumentsInArray: nil){
                print("Conventional added")
            }
            
            insertSQL = "INSERT INTO DESIGNS (DESIGNTYPENAME, IMAGENAME, MAXBLUR) VALUES ('Jenna', 'btn-jenna', '10')"
            if genieDB.executeUpdate(insertSQL,  withArgumentsInArray: nil){
                print("Jenna Image added")
            }
            insertSQL = "INSERT INTO DESIGNS (DESIGNTYPENAME, IMAGENAME, MAXBLUR) VALUES ('Jenna Wide', 'btn-jenna-wide', '10')"
            if genieDB.executeUpdate(insertSQL,  withArgumentsInArray: nil){
                print("Jenna Wide Image added")
            }
            
            insertSQL = "INSERT INTO DESIGNS (DESIGNTYPENAME, IMAGENAME, MAXBLUR) VALUES ('Jenna 4K', 'btn-jenna-4k', '10')"
            if genieDB.executeUpdate(insertSQL,  withArgumentsInArray: nil){
                print("Jenna 4K Image added")
            }
            
            
            //BASIC / CONVENTIONAL
            insertSQL = "INSERT INTO DESIGNPOINTS (DESIGNID,P1X, P1Y, P2X, P2Y, P3X, P3Y, P4X,P4Y,C1X,C1Y,C2X,C2Y,C3X,C3Y,C4X,C4Y,C5X,C5Y,C6X,C6Y) VALUES (1,-40.02,30.66,-7.59,4.63,-7.02,-17.33,-8.72,-40.11,-26.52,22.80,-12.77,11.24,-2.41, -1.98, -2.73, -11.46, -11.30, -23.20, -9.27, -29.41)"
            if genieDB.executeUpdate(insertSQL, withArgumentsInArray: nil){
                print("Conventional Records added.")
            }
            
            //JENNA
            insertSQL = "INSERT INTO DESIGNPOINTS (DESIGNID,P1X, P1Y, P2X, P2Y, P3X, P3Y, P4X,P4Y,C1X,C1Y,C2X,C2Y,C3X,C3Y,C4X,C4Y,C5X,C5Y,C6X,C6Y) VALUES (2,-40.37,18.51,-10.70,1.75,-10.19,-15.80,-13.23,-39.87,-25.17,13.47,-16.52,7.36,-4.87,-3.86,-4.37,-9.05,-16.00,-22.55,-13.78,-29.18)"
            
            if genieDB.executeUpdate(insertSQL, withArgumentsInArray: nil){
                print("Jenna record added")
            }
            
            //JENNA WIDE
            insertSQL = "INSERT INTO DESIGNPOINTS (DESIGNID,P1X, P1Y, P2X, P2Y, P3X, P3Y, P4X,P4Y,C1X,C1Y,C2X,C2Y,C3X,C3Y,C4X,C4Y,C5X,C5Y,C6X,C6Y) VALUES (3,-39.88,7.01,-10.70,1.75,-12.31,-15.40,-21.88,-40.69,-25.25, 6.45,-16.52,7.36,-4.87,-3.86,-7.60,-8.52,-17.01,-22.27,-22.43,-29.99)"
            if genieDB.executeUpdate(insertSQL, withArgumentsInArray: nil){
                print("Jenna Wide Added")
            }
            
            //JENNA 4K
            insertSQL = "INSERT INTO DESIGNPOINTS (DESIGNID,P1X, P1Y, P2X, P2Y, P3X, P3Y, P4X,P4Y,C1X,C1Y,C2X,C2Y,C3X,C3Y,C4X,C4Y,C5X,C5Y,C6X,C6Y) VALUES (4,-40.11,10.13,-11.24,0.04,-14.78,-14.33,-21.09,-39.97,-28.61,8.41,-16.24,5.31,-6.24,-5.23,-10.49,-8.91,-19.07,-19.76,-21.12,-34.23)"
            if genieDB.executeUpdate(insertSQL, withArgumentsInArray: nil){
                print("Jenna 4 K Added")
                
            }
            
            insertSQL = "INSERT INTO DESIGNPOINTS (DESIGNID,P1X, P1Y, P2X, P2Y, P3X, P3Y, P4X,P4Y,C1X,C1Y,C2X,C2Y,C3X,C3Y,C4X,C4Y,C5X,C5Y,C6X,C6Y) VALUES (5,-40.44,11.40,-7.98,2.62,-8.52,-7.76,-32.38,-39.69,-24.85,8.45,0.38,5.84,-16.34,-0.60,-12.36,-3.47,-4.68,-12.05,-32.51,-26.28)"
            if genieDB.executeUpdate(insertSQL, withArgumentsInArray: nil){
                print("Jenna 4 K Added")
            }
            
        genieDB.close()
        }else{
            print("Database failed to open")
        }
        
        
        
        
        
        
    }
    
    
    func insertDefaultGeneral(){
        
        
        let genieDB = FMDatabase(path: String(databasePath))
        if genieDB.open() {
            
            let insertSQL = "INSERT INTO GENERAL (HOMEIMAGE, LOGOIMAGE, ARCOATINGIMAGE, HYDROIMAGE, HARDCOATIMAGE, COMPANYNAME, COMPANYPHONE, ACTIVE) VALUES ('bg-home', 'yourlogohere', 'ar-coating-1','hydro-1', 'hardcoat-1', 'OPTIK KANDR', '416-915-1550', 1)"
            let result = genieDB.executeUpdate(insertSQL,
                withArgumentsInArray: nil)
            
            if !result {
                print("Error: \(genieDB.lastErrorMessage())")
            }else{
                print("inserted general")
            }
            
            genieDB.close()
        } else {
            print("Error: \(genieDB.lastErrorMessage())")
        }
        
        
    }
    
    
    //TODO:  CREATE FUNCTION THAT "CREATES THE APPLICATION SUPPORT DIRECTORY, SO THAT WE CAN COPY THE GENIEDB TO THAT, INSTEAD OF USING THE DOCUMENTS DIRECTORY!!!!!!!
    func setUpFiles(){
        
        let documentsURL = NSFileManager.defaultManager().URLsForDirectory(.ApplicationSupportDirectory, inDomains: .UserDomainMask)[0]
        let fileURL = documentsURL.URLByAppendingPathComponent("images")
        if !NSFileManager.defaultManager().fileExistsAtPath(fileURL.path!, isDirectory: nil){
            do {
                try NSFileManager.defaultManager().createDirectoryAtPath(fileURL.path!, withIntermediateDirectories: true, attributes:nil)
                print("Created Application Support Directory")
            } catch {
                print("Did not create a directory for support")
            }
        }
        
        
        let copytopath = getSupportPath("images") //ApplicationSupport/images
        let fm = NSFileManager.defaultManager()
        let copyfrompath = NSBundle.mainBundle().resourcePath! + "/appdefaults" // I-Care-New.app directory.
        
        let images = try! fm.contentsOfDirectoryAtPath(copyfrompath)
        
        for image in images {
            let copyitem = copyfrompath + "/" + image
            let copytoitem = copytopath + "/" + image
            do {
                //try fm.removeItemAtPath(copytoitem) // If exists already, first remove it.
                try fm.copyItemAtPath(copyitem,toPath: copytoitem)
                print("Copied files from appdefaults to application support directory.")
            }catch let error as NSError {
                print(error.localizedDescription)
            }
        }
        
        
        
        
        
         let imagelist = try! fm.contentsOfDirectoryAtPath(copytopath)
          for image in imagelist {
                  print(image)
          }
        
        
        /*
        
        do {
        try fm.createDirectoryAtPath(copytopath, withIntermediateDirectories: false, attributes: nil)
        } catch let error as NSError {
        print(error.localizedDescription);
        }
        */
        
    }
    
    
    //Add all tables here, as "set-up" with default values.
    func setUpDatabase(){
        
        
        var appSupportDir = NSSearchPathForDirectoriesInDomains(.ApplicationSupportDirectory, .UserDomainMask, true)
        if !NSFileManager.defaultManager().fileExistsAtPath(appSupportDir[0], isDirectory: nil){
            do {
                try NSFileManager.defaultManager().createDirectoryAtPath(appSupportDir[0], withIntermediateDirectories: true, attributes:nil)
            } catch {
                print("Did not create a directory for support")
            }
        }
        
        
        let documentsURL = NSFileManager.defaultManager().URLsForDirectory(.ApplicationSupportDirectory, inDomains: .UserDomainMask)[0]
        databasePath = documentsURL.URLByAppendingPathComponent("genie.db").path!
        
        if !NSFileManager.defaultManager().fileExistsAtPath(databasePath) {
            
            
            let genieDB = FMDatabase(path: String(databasePath))
            
            if genieDB == nil {
                print("Error: \(genieDB.lastErrorMessage())")
            }
            
            if genieDB.open() {
                print("opened the database successfully")
                let sql_stmt1 = "CREATE TABLE IF NOT EXISTS GENERAL (ID INTEGER PRIMARY KEY AUTOINCREMENT, HOMEIMAGE TEXT, LOGOIMAGE TEXT, ARCOATINGIMAGE TEXT, HYDROIMAGE TEXT, HARDCOATIMAGE TEXT, LOGINIDENTIFIER TEXT, COMPANYNAME TEXT, COMPANYPHONE TEXT, ACTIVE INTEGER)"
                if !genieDB.executeStatements(sql_stmt1) {
                    print("Error: \(genieDB.lastErrorMessage())")
                }else{
                    insertDefaultGeneral()
                }
                let sql_stmt2 = "CREATE TABLE IF NOT EXISTS DESIGNS (ID INTEGER PRIMARY KEY AUTOINCREMENT, DESIGNTYPENAME TEXT, IMAGENAME TEXT, MAXBLUR INTEGER)"
                if !genieDB.executeStatements(sql_stmt2) {
                    print("Error: \(genieDB.lastErrorMessage())")
                }else{
                }
                let sql_stmt3 = "CREATE TABLE IF NOT EXISTS DESIGNPOINTS (ID INTEGER PRIMARY KEY AUTOINCREMENT, DESIGNID INTEGER, P1X REAL, P1Y REAL, P2X REAL, P2Y REAL, P3X REAL, P3Y REAL, P4X REAL, P4Y REAL, C1X REAL, C1Y REAL, C2X REAL, C2Y REAL, C3X REAL, C3Y REAL, C4X REAL, C4Y REAL, C5X REAL, C5Y REAL, C6X REAL, C6Y REAL)"
                if !genieDB.executeStatements(sql_stmt3) {
                    print("Error: \(genieDB.lastErrorMessage())")
                }else{
                   insertDesigns()
                    
                }
                let sql_stmt4 = "CREATE TABLE IF NOT EXISTS MATERIAL (ID INTEGER PRIMARY KEY AUTOINCREMENT, MATERIALNAME TEXT, MATERIALINDEX REAL, ABBEVALUE REAL, SPECIFICGRAVITY REAL)"
                if !genieDB.executeStatements(sql_stmt4) {
                    print("Error: \(genieDB.lastErrorMessage())")
                }else{
                    print("table created for material")
                }
              
                
                genieDB.close()
                print("Database initialized; skipped as already exists")
                
            } else {
                print("Error: \(genieDB.lastErrorMessage())")
            }
            
        }else{
            print("Database already initialized")
        }
        
    }

    

}

