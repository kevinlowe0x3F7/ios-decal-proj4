//
//  RestaurantList.swift
//  LocalEats
//
//  Created by Kevin Lowe on 4/19/16.
//  Copyright © 2016 Kevin Lowe. All rights reserved.
//

import UIKit

class RestaurantList: NSObject {
    /* The internal list of restaurant, represented by an array of Restaurant objects. */
    var restaurants: [Restaurant]!
    /* The current restaurant that we are looking at. */
    var currentIndex: Int!
    
    override init() {
        currentIndex = 0
    }
    
    /* Returns the next restaurant in the list, or nil if there are no restaurants left. */
    func getNextRestaurant() -> Restaurant? {
        if currentIndex <= restaurants.count - 1 {
            let nextRestaurant = restaurants[currentIndex]
            currentIndex = currentIndex + 1
            return nextRestaurant
        } else {
            return nil
        }
    }
    
    func updateRestaurants(data: NSDictionary) {
        restaurants = [Restaurant]()
        for restaurantInfo in data.valueForKey("businesses") as! NSArray {
            restaurants.append(Restaurant(info: restaurantInfo as! NSDictionary))
        }
    }
}
