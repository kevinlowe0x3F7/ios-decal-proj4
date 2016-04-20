//
//  YelpAPILoader.swift
//  LocalEats
//
//  Created by Kevin Lowe on 4/19/16.
//  Copyright © 2016 Kevin Lowe. All rights reserved.
//

import UIKit
import CoreLocation

class YelpAPILoader {
    /* A list of restaurants object that the YelpAPILoader will pass its JSON into. */
    static var list: RestaurantList = RestaurantList()

    /* Load the initial set of 20 restaurants with the offset as 0. */
    class func loadRestaurants(location: CLLocation) {
        list.updateLocation(location)
        let parameters = ["term": "restaurants", "ll": "\(location.coordinate.latitude),\(location.coordinate.longitude)", "sort": "0"]
        let client = YelpAPIClient()
        client.searchPlacesWithParameters(parameters, successSearch: didLoadRestaurants, failureSearch: failedToLoadRestaurants)
    }
    
    /* Load a set of 20 restaurants with a given offset. */
    class func loadRestaurants(location: CLLocation, offset: Int) {
        list.updateLocation(location)
        let parameters = ["term": "restaurants", "offset": "\(offset)", "ll": "\(location.coordinate.latitude),\(location.coordinate.longitude)", "sort": "0"]
        let client = YelpAPIClient()
        client.searchPlacesWithParameters(parameters, successSearch: didLoadRestaurants, failureSearch: failedToLoadRestaurants)
    }
    
    class func didLoadRestaurants(data: NSData, response: NSHTTPURLResponse) -> Void {
        do {
            let feedDictionary = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
            print(feedDictionary)
            list.updateRestaurants(feedDictionary)
        } catch let error as NSError {
            print("ERROR: \(error.localizedDescription)")
        }
    }
    
    class func failedToLoadRestaurants(error: NSError) -> Void {
        print("ERROR: \(error.localizedDescription)")
    }
}
