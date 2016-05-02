//
//  SavedRestaurantTableViewController.swift
//  LocalEats
//
//  Created by Jeffrey Liu on 4/23/16.
//  Copyright © 2016 Kevin Lowe. All rights reserved.
//

import UIKit

class SavedRestaurantsTableViewController: UITableViewController {

    var user : UserProfile!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(red: 245/255, green: 245/255, blue: 241/255, alpha: 1)
        
        tableView.registerClass(SavedRestaurantTableViewCell.self, forCellReuseIdentifier: "SavedRestaurantTableViewCell")
        tableView.reloadData()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        if (self.isBeingDismissed()) {
            let vc = MainRestaurantViewController()
            vc.user = self.user
            self.navigationController?.popToViewController(vc, animated: true)
        }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.user.savedRestaurants.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell:SavedRestaurantTableViewCell = SavedRestaurantTableViewCell(style: .Default, reuseIdentifier: "SavedRestaurantTableViewCell")
        
//        cell.frame = CGRectMake(0, 0, UIScreen.mainScreen().bounds.size.width, 100)
        
        cell.textLabel?.text = self.user.savedRestaurants[indexPath.row].name
        cell.restaurant = self.user.savedRestaurants[indexPath.row]

        cell.backgroundColor = UIColor(red: 245/255, green: 245/255, blue: 241/255, alpha: 1)
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let vc = DetailedRestaurantViewController()
        let cell:SavedRestaurantTableViewCell = tableView.cellForRowAtIndexPath(indexPath) as! SavedRestaurantTableViewCell
        
        vc.restaurant = cell.restaurant
        self.navigationController?.pushViewController(vc, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
 

    
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            user.savedRestaurants.removeAtIndex(indexPath.row)
            
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
}
