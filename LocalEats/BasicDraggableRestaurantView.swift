//
//  BasicDraggableRestaurantView.swift
//  LocalEats
//
//  Created by Kevin Lowe on 4/20/16.
//  Copyright © 2016 Kevin Lowe. All rights reserved.
//

import UIKit

let ACTION_MARGIN = CGFloat(120) //distance from center where the action applies. Higher = swipe further in order for the action to be called
let SCALE_STRENGTH = CGFloat(4) //how quickly the card shrinks. Higher = slower shrinking
let SCALE_MAX = CGFloat(0.93) //upper bar for how much the card shrinks. Higher = shrinks less
let ROTATION_MAX = CGFloat(1) //the maximum rotation allowed in radians.  Higher = card can keep rotating longer
let ROTATION_STRENGTH = CGFloat(320) //strength of rotation. Higher = weaker rotation
let ROTATION_ANGLE = CGFloat(M_PI/8) //Higher = stronger rotation angle

class BasicDraggableRestaurantView: UIView {
    var panGestureRecognizer: UIPanGestureRecognizer!
    var restaurant: Restaurant!
    var imageView: UIImageView!
    
    init(frame: CGRect, restaurant: Restaurant) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.whiteColor()
        self.restaurant = restaurant
        imageView = UIImageView(frame: CGRectMake(0, 0, 300, 300))
        imageView.image = UIImage(data: NSData(contentsOfURL: NSURL(string: self.restaurant.imageURL)!)!)
        self.addSubview(imageView)
        panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(BasicDraggableRestaurantView.beingDragged(_:)))
        self.addGestureRecognizer(panGestureRecognizer)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func beingDragged(gestureRecognizer: UIPanGestureRecognizer) {
        print("dragged")
    }
}
