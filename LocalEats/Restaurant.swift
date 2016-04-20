//
//  Restaurant.swift
//  LocalEats
//
//  Created by Kevin Lowe on 4/19/16.
//  Copyright © 2016 Kevin Lowe. All rights reserved.
//

import UIKit

func ==(lhs: Restaurant, rhs: Restaurant) -> Bool {
    return lhs.id == rhs.id
}

class Restaurant: NSObject {
    /* The restaurant's name. */
    var name: String!
    /* The restaurant's rating. */
    var rating: Double!
    /* The restaurant's rating image. */
    var ratingURL: String!
    /* The restaurant's distance from the picked location in miles. */
    var distance: Double!
    /* The restaurant's image, referenced by its URL. */
    var imageURL: String!
    /* The restaurant's phone number. */
    var phoneNumber: String!
    /* The restaurant's address, as a list of Strings with each part (ex. "1512 Shattuck Ave", "North Berkeley", "Berkeley, CA 94709"). */
    var address: [String]!
    /* URL to access the complete business site. */
    var businessURL: String!
    /* Unique identifier for the restaurant. */
    var id: String!
    /* Calculate hash value based off of id. */
    override var hashValue: Int {
        get {
            return id.hashValue
        }
    }

    init(info: NSDictionary) {
        if let nameOptional = info.valueForKey("name") {
            name = nameOptional as! String
        } else {
            name = nil
        }
        if let ratingOptional = info.valueForKey("rating") {
            rating = ratingOptional as! Double
        } else {
            rating = nil
        }
        if let ratingURLOptional = info.valueForKey("rating_img_url_large") {
            ratingURL = ratingURLOptional as! String
        } else {
            ratingURL = nil
        }
        if let distanceOptinal = info.valueForKey("distance") {
            distance = (distanceOptinal as! Double) / 1609.344
            distance = round(distance * 100.0) / 100.0
        } else {
            distance = nil
        }
        if let imageURLOptional = info.valueForKey("image_url") {
            imageURL = imageURLOptional as! String
        } else {
            imageURL = nil
        }
        if let phoneNumberOptional = info.valueForKey("display_phone") {
            phoneNumber = phoneNumberOptional as! String
        } else {
            phoneNumber = nil
        }
        if let addressOptional = info.valueForKey("location")?.valueForKey("display_address") {
            address = addressOptional as! [String]
        } else {
            address = nil
        }
        if let businessURLOptional = info.valueForKey("url") {
            businessURL = businessURLOptional as! String
        } else {
            businessURL = nil
        }
        if let idOptional = info.valueForKey("id") {
            id = idOptional as! String
        } else {
            id = nil
        }
    }
    
    /* Helper function to print out all information for this restaurant object. */
    func printInfo() {
        print("name: \(self.name)")
        print("rating: \(self.rating)")
        print("distance in miles: \(self.distance)")
        print("phone number: \(self.phoneNumber)")
        print("address: \(self.address[0])")
        print("id: \(self.id)")
    }
}
