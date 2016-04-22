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
    var list: RestaurantList = RestaurantList()
    /* A reference to the view controller that's requesting the data to know that it's done. */
    var viewController: MainRestaurantViewController!
    
    init(vc: MainRestaurantViewController) {
        self.viewController = vc
    }

    /* Load the initial set of 20 restaurants with the offset as 0. */
    func loadRestaurants(location: CLLocation) {
        list.updateLocation(location)
        let parameters = ["term": "restaurants", "ll": "\(location.coordinate.latitude),\(location.coordinate.longitude)", "sort": "0"]
        let client = YelpAPIClient()
        client.searchPlacesWithParameters(parameters, successSearch: didLoadRestaurants, failureSearch: failedToLoadRestaurants)
    }
    
    /* Load a set of 20 restaurants with a given offset. */
    func loadRestaurants(location: CLLocation, offset: Int) {
        list.updateLocation(location)
        let parameters = ["term": "restaurants", "offset": "\(offset)", "ll": "\(location.coordinate.latitude),\(location.coordinate.longitude)", "sort": "0"]
        let client = YelpAPIClient()
        client.searchPlacesWithParameters(parameters, successSearch: didLoadRestaurants, failureSearch: failedToLoadRestaurants)
    }
    
    func didLoadRestaurants(data: NSData, response: NSHTTPURLResponse) -> Void {
        do {
            let feedDictionary = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
            list.updateRestaurants(feedDictionary)
            viewController.grabFirstRestaurant()
            print("finished creating list")
        } catch let error as NSError {
            print("ERROR: \(error.localizedDescription)")
        }
    }
    
    func failedToLoadRestaurants(error: NSError) -> Void {
        print("ERROR: \(error.localizedDescription)")
    }
}
