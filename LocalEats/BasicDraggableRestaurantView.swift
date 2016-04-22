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
        let viewSize = frame.size
        self.backgroundColor = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1)
        self.layer.borderColor = UIColor(red: 160/255, green: 160/255, blue: 160/255, alpha: 1).CGColor
        self.layer.borderWidth = CGFloat(2.0)
        self.restaurant = restaurant
        
        let imageSize = viewSize.width - 50
        imageView = UIImageView(frame: CGRectMake(25, 25, imageSize, imageSize))
        imageView.image = UIImage(data: NSData(contentsOfURL: NSURL(string: self.restaurant.imageURL)!)!)
        self.addSubview(imageView)
        panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(BasicDraggableRestaurantView.beingDragged(_:)))
        self.addGestureRecognizer(panGestureRecognizer)
        setupLabels()
    }
    
    func setupLabels() {
        let frame = self.frame.size
        let imageY = 25 + frame.width - 50
        let nameSize = CGFloat(30)
        if let restaurantName = restaurant.name {
            let name: UILabel = UILabel(frame: CGRectMake(0, imageY + 5, frame.width, nameSize))
            name.textAlignment = NSTextAlignment.Center
            name.font = UIFont(name: "Helvetica Neue", size: 22)
            name.text = "\(restaurantName)"
            self.addSubview(name)
        }
        
        if let distance = restaurant.distance {
            let distanceLabel: UILabel = UILabel(frame: CGRectMake(15, CGFloat(imageY + 10 + nameSize), frame.width / 2, 30))
            distanceLabel.font = UIFont(name: "Helvetica Neue", size: 20)
            distanceLabel.text = "\(distance) mi"
            self.addSubview(distanceLabel)
        }
        
        if let ratingPic = restaurant.ratingURL {
            let ratingWidth = frame.width / 2 - 10
            let rating: UIImageView = UIImageView(frame: CGRectMake(frame.width / 2, CGFloat(imageY + 12 + nameSize), ratingWidth, 25))
            rating.image = UIImage(data: NSData(contentsOfURL: NSURL(string: ratingPic)!)!)
            self.addSubview(rating)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func beingDragged(gestureRecognizer: UIPanGestureRecognizer) {
        print("dragged")
    }
}
