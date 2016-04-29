//
//  SavedRestuarantView.swift
//  LocalEats
//
//  Created by Jeffrey Liu on 4/23/16.
//  Copyright © 2016 Kevin Lowe. All rights reserved.
//

import UIKit

class SavedRestaurantView: UIView {
    var restaurant: Restaurant!
    var imageView: UIImageView!
    var originalPoint = CGPoint()
    var xFromCenter = CGFloat()
    var yFromCenter = CGFloat()
    var delegate: SavedRestaurantsTableViewController!
}
