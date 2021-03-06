//
//  RestaurantList.swift
//  LocalEats
//
//  Created by Kevin Lowe on 4/19/16.
//  Copyright © 2016 Kevin Lowe. All rights reserved.
//

import UIKit
import CoreLocation

class RestaurantList: NSObject {
    /* The internal list of restaurant, represented by an array of Restaurant objects. */
    var restaurants: [Restaurant]!
    /* The current restaurant that we are looking at. */
    var currentIndex: Int!
    /* Current location that this restaurant list's data is based off of. */
    var location: CLLocation!
    
    override init() {
        currentIndex = 0
        location = nil
    }
    
    /* Returns the next restaurant in the list, or nil if there are no restaurants left. */
    func getNextRestaurant() -> Restaurant? {
        if currentIndex <= restaurants.count - 1 {
            let nextRestaurant = restaurants[currentIndex]
            currentIndex = currentIndex + 1
            return nextRestaurant
        } else {
            print("out of restaurants")
            return nil
        }
    }
    
    /* Happens when we have a new location or request more restaurants. */
    func updateRestaurants(data: NSDictionary) {
        currentIndex = 0
        restaurants = [Restaurant]()
        for restaurantInfo in data.valueForKey("businesses") as! NSArray {
            let restaurant = Restaurant(info: restaurantInfo as! NSDictionary)
            restaurants.append(restaurant)
        }
    }
    
    /* Update the current location. */
    func updateLocation(location: CLLocation) {
        self.location = location
    }
}
