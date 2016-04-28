//
//  UserProfile.swift
//  LocalEats
//
//  Created by Kevin Lowe on 4/20/16.
//  Copyright © 2016 Kevin Lowe. All rights reserved.
//

import UIKit
import CoreLocation

class UserProfile: NSObject {
    /* List of saved restaurants. */
    var savedRestaurants: [Restaurant]!
    /* Their current location or location that they want to base their search off of. */
    var location: CLLocation!
    /* True if user wants to sort by distance, false otherwise. */
    var sortByDistance: Bool!
    
    override init() {
        savedRestaurants = [Restaurant]()
        location = nil
        sortByDistance = false
    }
    
    func updateLocation(loc: CLLocation) {
        location = loc
    }
    
    func addRestaurant(restaurant: Restaurant) {
        savedRestaurants.append(restaurant)
    }
    
    func hasSaved(restaurant: Restaurant) -> Bool {
        for i in 0...savedRestaurants.count-1 {
            if (savedRestaurants[i] == restaurant) {
                return true
            }
        }
        return false
    }
    
    func saveContents() {
        let prefs = NSUserDefaults.standardUserDefaults()
        prefs.removePersistentDomainForName(NSBundle.mainBundle().bundleIdentifier!)
        let encodedRestaurants = NSKeyedArchiver.archivedDataWithRootObject(savedRestaurants)
        prefs.setObject(encodedRestaurants, forKey: "savedRestaurants")
        
        prefs.setBool(sortByDistance, forKey: "sorting")
    }
    
    func grabUserContents() {
        let prefs = NSUserDefaults.standardUserDefaults()
        if let restaurantData = prefs.objectForKey("savedRestaurants") as! NSData! {
            savedRestaurants = NSKeyedUnarchiver.unarchiveObjectWithData(restaurantData) as! [Restaurant]
            sortByDistance = prefs.boolForKey("sorting")
        }
    }
}
