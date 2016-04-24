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
    /* List of saved restaurants as a set to be able to quickly see if a restaurant is in the set or not. */
//    var savedRestaurantsSet: Set<Restaurant>!
    /* Their current location or location that they want to base their search off of. */
    var location: CLLocation!
    /* True if user wants to sort by distance, false otherwise. */
    var sortByDistance: Bool!
    
    override init() {
        savedRestaurants = [Restaurant]()
//        savedRestaurantsSet = Set<Restaurant>()
        location = nil
        sortByDistance = false
    }
    
    func updateLocation(loc: CLLocation) {
        location = loc
    }
    
    func addRestaurant(restaurant: Restaurant) {
        print("adding restaurant to user")
        savedRestaurants.append(restaurant)
//        savedRestaurantsSet.insert(restaurant)
    }
    
    func hasSaved(restaurant: Restaurant) -> Bool {
        return savedRestaurants.contains(restaurant)
    }
    
}
