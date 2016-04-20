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
    var savedRestaurantsSet: Set<Restaurant>!
    /* Their current location or location that they want to base their search off of. */
    var location: CLLocation!
    /* Filter options. 0 = Default ($-$$$$), 1 = $ only, 2 = $ or $$, 3 = $, $$, or $$$. */
    var filterOption: Int!
    /* True if user wants to sort by distance, false otherwise. */
    var sortByDistance: Bool!
    
    override init() {
        savedRestaurants = [Restaurant]()
        savedRestaurantsSet = Set<Restaurant>()
        location = nil
        filterOption = 0
        sortByDistance = false
    }
    
    func updateLocation(loc: CLLocation) {
        location = loc
    }
    
    func addRestaurant(restaurant: Restaurant) {
        savedRestaurants.append(restaurant)
        savedRestaurantsSet.insert(restaurant)
    }
    
    func hasSaved(restaurant: Restaurant) -> Bool {
        return savedRestaurantsSet.contains(restaurant)
    }
}
