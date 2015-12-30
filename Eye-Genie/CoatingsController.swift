//
//  CoatingsController.swift
//  Eye-Genie
//
//  Written by Valerie Trotter on 2015-12-30.
//  Copyright © 2015 Bceen Ventures. All rights reserved.
//

import UIKit

class CoatingsController: UIViewController {
    
    
    
    @IBOutlet weak var btnHardcoat3View: UIButton!
    @IBOutlet weak var btnHardcoat2View: UIButton!
    @IBOutlet weak var btnHardcoat1View: UIButton!
    
    @IBOutlet weak var btnHydro1View: UIButton!
    @IBOutlet weak var btnHydro2View: UIButton!
    @IBOutlet weak var btnHydro3View: UIButton!
    
    @IBOutlet weak var btnAR1View: UIButton!
    @IBOutlet weak var btnAR2View: UIButton!
    @IBOutlet weak var btnAR3View: UIButton!
    
  
    @IBAction func btnAR3(sender: UIButton) {
        saveARCoating("ar-coating-3")
         sender.setImage(UIImage(named: "btn-checkmark-on"), forState: .Normal)
        
        btnAR1View.setImage(UIImage(named: "btn-checkmark-off"), forState: .Normal)
        btnAR2View.setImage(UIImage(named: "btn-checkmark-off"), forState: .Normal)
       
  

    }
    
    @IBAction func btnAR2(sender: UIButton) {
        saveARCoating("ar-coating-2")
        sender.setImage(UIImage(named: "btn-checkmark-on"), forState: .Normal)

        btnAR3View.setImage(UIImage(named: "btn-checkmark-off"), forState: .Normal)
       
        btnAR1View.setImage(UIImage(named: "btn-checkmark-off"), forState: .Normal)
    }
    
    @IBAction func btnAR1(sender: UIButton) {
        saveARCoating("ar-coating-1")
        sender.setImage(UIImage(named: "btn-checkmark-on"), forState: .Normal)
        
        btnAR3View.setImage(UIImage(named: "btn-checkmark-off"), forState: .Normal)
               btnAR2View.setImage(UIImage(named: "btn-checkmark-off"), forState: .Normal)

    }
    
    func saveARCoating(arCoatingName: String){
        
        let databasePath = getSupportPath("genie.db") // grab the database.
        let genieDB = FMDatabase(path: String(databasePath))
        
        if genieDB.open() {
            
            
            let insertSQL = "UPDATE GENERAL SET ARCOATINGIMAGE='\(arCoatingName)' where id=1"
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
    
    func saveHydro(hydroName: String){
        
        let databasePath = getSupportPath("genie.db") // grab the database.
        let genieDB = FMDatabase(path: String(databasePath))
        
        if genieDB.open() {
            
            
            let insertSQL = "UPDATE GENERAL SET HYDROIMAGE='\(hydroName)' where id=1"
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
    func saveHardCoat(hardcoatName: String){
        
        let databasePath = getSupportPath("genie.db") // grab the database.
        let genieDB = FMDatabase(path: String(databasePath))
        
        if genieDB.open() {
            
            
            let insertSQL = "UPDATE GENERAL SET HARDCOATIMAGE='\(hardcoatName)' where id=1"
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


    
    
    func setCheckMark(){
        
    }

    
    func getARCoating()->String{

        
        let databasePath = getSupportPath("genie.db") // grab the database.
        let genieDB = FMDatabase(path: String(databasePath))
        var arcoating = "ar-coating-1" // sets the default.
        if genieDB.open() {
            let querySQL = "SELECT ARCOATINGIMAGE FROM GENERAL WHERE id=1"
            let results:FMResultSet? = genieDB.executeQuery(querySQL, withArgumentsInArray: nil)
            if results?.next() == true {
                arcoating = (results?.stringForColumn("ARCOATINGIMAGE"))!
                if (arcoating == "ar-coating-1"){
                    btnAR1View.setImage(UIImage (named: "btn-checkmark-on"), forState: .Normal)
                    btnAR3View.setImage(UIImage(named: "btn-checkmark-off"), forState: .Normal)
                    btnAR2View.setImage(UIImage(named: "btn-checkmark-off"), forState: .Normal)
                    
                }else if (arcoating == "ar-coating-2"){
                    btnAR2View.setImage(UIImage (named: "btn-checkmark-on"), forState: .Normal)
                    btnAR3View.setImage(UIImage(named: "btn-checkmark-off"), forState: .Normal)
                                      btnAR1View.setImage(UIImage(named: "btn-checkmark-off"), forState: .Normal)

                }else if (arcoating == "ar-coating-3"){
                    btnAR3View.setImage(UIImage (named: "btn-checkmark-on"), forState: .Normal)
                    btnAR1View.setImage(UIImage(named: "btn-checkmark-off"), forState: .Normal)
                    btnAR2View.setImage(UIImage(named: "btn-checkmark-off"), forState: .Normal)
                   

                }
            } else {
                print("Records not found in database for 'General Settings'.")
            }
            genieDB.close()
        }
        return arcoating
        
    }
    func getHydro(){
        
        
        let databasePath = getSupportPath("genie.db") // grab the database.
        let genieDB = FMDatabase(path: String(databasePath))
        var arcoating = "hydro-1" // sets the default.
        if genieDB.open() {
            let querySQL = "SELECT HYDROIMAGE FROM GENERAL WHERE id=1"
            let results:FMResultSet? = genieDB.executeQuery(querySQL, withArgumentsInArray: nil)
            if results?.next() == true {
                arcoating = (results?.stringForColumn("HYDROIMAGE"))!
                if (arcoating == "hydro-1"){
                    btnHydro1View.setImage(UIImage (named: "btn-checkmark-on"), forState: .Normal)
                    btnHydro2View.setImage(UIImage(named: "btn-checkmark-off"), forState: .Normal)
                    btnHydro3View.setImage(UIImage(named: "btn-checkmark-off"), forState: .Normal)
                    
                }else if (arcoating == "hydro-2"){
                    btnHydro2View.setImage(UIImage (named: "btn-checkmark-on"), forState: .Normal)
                    btnHydro3View.setImage(UIImage(named: "btn-checkmark-off"), forState: .Normal)
                    btnHydro1View.setImage(UIImage(named: "btn-checkmark-off"), forState: .Normal)
                    
                }else if (arcoating == "hydro-3"){
                    btnHydro3View.setImage(UIImage (named: "btn-checkmark-on"), forState: .Normal)
                    btnHydro1View.setImage(UIImage(named: "btn-checkmark-off"), forState: .Normal)
                    btnHydro2View.setImage(UIImage(named: "btn-checkmark-off"), forState: .Normal)
                    
                    
                }
            } else {
                print("Records not found in database for 'General Settings'.")
            }
            genieDB.close()
        }
        
    }

    func getHardcoat(){
        
        
        let databasePath = getSupportPath("genie.db") // grab the database.
        let genieDB = FMDatabase(path: String(databasePath))
        var arcoating = "hardcoat-1" // sets the default.
        if genieDB.open() {
            let querySQL = "SELECT HARDCOATIMAGE FROM GENERAL WHERE id=1"
            let results:FMResultSet? = genieDB.executeQuery(querySQL, withArgumentsInArray: nil)
            if results?.next() == true {
                arcoating = (results?.stringForColumn("HARDCOATIMAGE"))!
                if (arcoating == "hardcoat-1"){
                    btnHardcoat1View.setImage(UIImage (named: "btn-checkmark-on"), forState: .Normal)
                    btnHardcoat2View.setImage(UIImage(named: "btn-checkmark-off"), forState: .Normal)
                    btnHardcoat3View.setImage(UIImage(named: "btn-checkmark-off"), forState: .Normal)
                    
                }else if (arcoating == "hardcoat-2"){
                    btnHardcoat2View.setImage(UIImage (named: "btn-checkmark-on"), forState: .Normal)
                    btnHardcoat3View.setImage(UIImage(named: "btn-checkmark-off"), forState: .Normal)
                    btnHardcoat1View.setImage(UIImage(named: "btn-checkmark-off"), forState: .Normal)
                    
                }else if (arcoating == "hardcoat-3"){
                    btnHardcoat3View.setImage(UIImage (named: "btn-checkmark-on"), forState: .Normal)
                    btnHardcoat1View.setImage(UIImage(named: "btn-checkmark-off"), forState: .Normal)
                    btnHardcoat2View.setImage(UIImage(named: "btn-checkmark-off"), forState: .Normal)
                    
                    
                }
            } else {
                print("Records not found in database for 'General Settings'.")
            }
            genieDB.close()
        }
        
    }

    
    @IBAction func btnHydro3(sender: UIButton) {
        saveHydro("hydro-3")
        sender.setImage(UIImage(named: "btn-checkmark-on"), forState: .Normal)
        
        btnHydro1View.setImage(UIImage(named: "btn-checkmark-off"), forState: .Normal)
        btnHydro2View.setImage(UIImage(named: "btn-checkmark-off"), forState: .Normal)

    }
    
    @IBAction func btnHydro1(sender: UIButton) {
        saveHydro("hydro-1")
        sender.setImage(UIImage(named: "btn-checkmark-on"), forState: .Normal)
        
        btnHydro2View.setImage(UIImage(named: "btn-checkmark-off"), forState: .Normal)
        btnHydro3View.setImage(UIImage(named: "btn-checkmark-off"), forState: .Normal)
        
    }
    
    @IBAction func btnHydro2(sender: UIButton) {
        saveHydro("hydro-2")
        sender.setImage(UIImage(named: "btn-checkmark-on"), forState: .Normal)
        btnHydro1View.setImage(UIImage(named: "btn-checkmark-off"), forState: .Normal)
        btnHydro3View.setImage(UIImage(named: "btn-checkmark-off"), forState: .Normal)
        
    }
    
    @IBAction func btnHardcoat3(sender: UIButton) {
        saveHardCoat("hardcoat-3")
        sender.setImage(UIImage(named: "btn-checkmark-on"), forState: .Normal)
        btnHardcoat2View.setImage(UIImage(named: "btn-checkmark-off"), forState: .Normal)
        btnHardcoat1View.setImage(UIImage(named: "btn-checkmark-off"), forState: .Normal)

    }
    @IBAction func btnHardcoat2(sender: UIButton) {
        saveHardCoat("hardcoat-2")
        sender.setImage(UIImage(named: "btn-checkmark-on"), forState: .Normal)
        btnHardcoat1View.setImage(UIImage(named: "btn-checkmark-off"), forState: .Normal)
        btnHardcoat3View.setImage(UIImage(named: "btn-checkmark-off"), forState: .Normal)
    }
    @IBAction func btnHardcoat1(sender: UIButton) {
        saveHardCoat("hardcoat-1")
        sender.setImage(UIImage(named: "btn-checkmark-on"), forState: .Normal)
        btnHardcoat2View.setImage(UIImage(named: "btn-checkmark-off"), forState: .Normal)
        btnHardcoat3View.setImage(UIImage(named: "btn-checkmark-off"), forState: .Normal)
        
    }
    //OnViewDidLoad :  set the default based on database and set the correct checkbox.
    
    override func viewDidAppear(animated: Bool){
        
       let arCoatingName = getARCoating()
       getHydro()
       getHardcoat()
        
    }
}