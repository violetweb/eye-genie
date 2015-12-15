//
//  SettingsMenuController.swift
//  Eye-Genie
//
//  Created by Ryan Maxwell on 2015-12-08.
//  Copyright © 2015 Bceen Ventures. All rights reserved.
//


import UIKit

class SettingsMenuController: UITableViewController {

    
   // var menuItems: [MenuItem] = menuItemData
    
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(menuItems.count)
        return menuItems.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath)
        -> UITableViewCell {
            let cell = tableView.dequeueReusableCellWithIdentifier("viewControllerCell", forIndexPath: indexPath) as! MenuCell
            let menuitem = menuItems[indexPath.row] as MenuItem
            cell.menuitem = menuitem
            return cell
    }
    
}