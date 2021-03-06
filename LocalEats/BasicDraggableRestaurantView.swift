//
//  BasicDraggableRestaurantView.swift
//  LocalEats
//
//  Created by Kevin Lowe on 4/20/16.
//  Copyright © 2016 Kevin Lowe. All rights reserved.
//
//  All animation code comes from SwiftTinderCards
//  https://github.com/lgandecki/SwiftTinderCards

import UIKit

let ACTION_MARGIN = CGFloat(120) //distance from center where the action applies. Higher = swipe further in order for the action to be called
let SCALE_STRENGTH = CGFloat(4) //how quickly the card shrinks. Higher = slower shrinking
let SCALE_MAX = CGFloat(0.93) //upper bar for how much the card shrinks. Higher = shrinks less
let ROTATION_MAX = CGFloat(1) //the maximum rotation allowed in radians.  Higher = card can keep rotating longer
let ROTATION_STRENGTH = CGFloat(320) //strength of rotation. Higher = weaker rotation
let ROTATION_ANGLE = CGFloat(M_PI/8) //Higher = stronger rotation angle

class BasicDraggableRestaurantView: UIView {
    var panGestureRecognizer: UIPanGestureRecognizer!
    var tapGestureRecognizer: UITapGestureRecognizer!
    var restaurant: Restaurant!
    var imageView: UIImageView!
    var originalPoint = CGPoint()
    var xFromCenter = CGFloat()
    var yFromCenter = CGFloat()
    var delegate: MainRestaurantViewController!
    var overlayView: OverlayView?
    
    init(frame: CGRect, restaurant: Restaurant, delegate: MainRestaurantViewController) {
        super.init(frame: frame)
        let viewSize = frame.size
        self.backgroundColor = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1)
        self.layer.borderColor = UIColor(red: 160/255, green: 160/255, blue: 160/255, alpha: 1).CGColor
        self.layer.borderWidth = CGFloat(2.0)
        self.restaurant = restaurant
        self.delegate = delegate

        if let restaurantOptional = self.restaurant {
            let imageSize = viewSize.width - 50
            imageView = UIImageView(frame: CGRectMake(25, 25, imageSize, imageSize))
            if let imageAsURL = restaurantOptional.imageURL {
                imageView.image = UIImage(data: NSData(contentsOfURL: NSURL(string: imageAsURL)!)!)
            } else {
                let frame = self.frame.size
                let imageY = frame.width / 2 - 25
                let emptyImageLabel: UILabel = UILabel(frame: CGRectMake(7, imageY, frame.width - 14, 30))
                emptyImageLabel.textAlignment = NSTextAlignment.Center
                emptyImageLabel.font = UIFont(name: "Helvetica Neue", size: 20)
                emptyImageLabel.text = "No image available!"
                self.addSubview(emptyImageLabel)
            }
            self.addSubview(imageView)
            panGestureRecognizer = UIPanGestureRecognizer(target: self, action: "beingDragged:")
            self.addGestureRecognizer(panGestureRecognizer)
            tapGestureRecognizer = UITapGestureRecognizer(target: self.delegate, action: "beingTapped")
            self.addGestureRecognizer(tapGestureRecognizer)
            setupLabels()
        } else {
            placeEmptyLabel()
        }
        addOverlayView()
    }
    
    func setupLabels() {
        let frame = self.frame.size
        let imageY = 25 + frame.width - 50
        let nameSize = CGFloat(30)
        if let restaurantName = restaurant.name {
            let name: UILabel = UILabel(frame: CGRectMake(7, imageY + 5, frame.width - 14, nameSize))
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
    
    func addOverlayView() {
        let frame = self.frame.size
        overlayView = OverlayView(frame: CGRectMake(0, 0, frame.width, frame.height))
        self.addSubview(overlayView!)
    }
    
    func placeEmptyLabel() {
        let frame = self.frame.size
        let label = UILabel(frame: CGRectMake(0, frame.height / 2, frame.width, 100))
        label.numberOfLines = 3
        label.textAlignment = NSTextAlignment.Center
        label.text = "Out of restaurants" + "\n" + "try a different location"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func beingDragged(gestureRecognizer: UIPanGestureRecognizer) {
        xFromCenter = gestureRecognizer.translationInView(self).x
        yFromCenter = gestureRecognizer.translationInView(self).y
        
        switch (gestureRecognizer.state) {
        case .Began:
            self.originalPoint = self.center
            break
        case .Changed:
            //%%% dictates rotation (see ROTATION_MAX and ROTATION_STRENGTH for details)
            let rotationStrength = min(xFromCenter / ROTATION_STRENGTH, ROTATION_MAX);
            
            //%%% degree change in radians
            let rotationAngel = (ROTATION_ANGLE * rotationStrength);
            
            //%%% amount the height changes when you move the card up to a certain point
            let scale = max(1 - fabs(rotationStrength) / SCALE_STRENGTH, SCALE_MAX);
            
            //%%% move the object's center by center + gesture coordinate
            self.center = CGPointMake(self.originalPoint.x + xFromCenter, self.originalPoint.y + yFromCenter);
            
            //%%% rotate by certain amount
            let transform = CGAffineTransformMakeRotation(rotationAngel);
            
            //%%% scale by certain amount
            let scaleTransform = CGAffineTransformScale(transform, scale, scale);
            
            //%%% apply transformations
            self.transform = scaleTransform;
            
            self.updateOverlay(xFromCenter)
            break
        case .Ended:
            afterSwipeAction()
            break
        default:
            break
        }
    }
    
    
    func afterSwipeAction() {
        if (xFromCenter > ACTION_MARGIN) {
            rightAction();
        } else if (xFromCenter < -ACTION_MARGIN){
            leftAction();
        } else {
            animateCardBack()
        }
    }
    
    func rightAction() {
        animateCardToTheRight()
        delegate?.cardSwipedRight(self)
    }
    
    func animateCardToTheRight() {
        let rightEdge = CGFloat(500)
        animateCardOutTo(rightEdge)
    }
    
    func leftAction() {
        animateCardToTheLeft()
        delegate?.cardSwipedLeft(self)
    }
    
    func animateCardToTheLeft() {
        let leftEdge = CGFloat(-500)
        animateCardOutTo(leftEdge)
    }
    
    func animateCardBack() {
        UIView.animateWithDuration(0.3, animations: {
            self.center = self.originalPoint;
            self.transform = CGAffineTransformMakeRotation(0);
            self.overlayView?.alpha = 0
            }
        )
    }
    
    func animateCardOutTo(edge: CGFloat) {
        let finishPoint = CGPointMake(edge, 2*yFromCenter + self.originalPoint.y)
        UIView.animateWithDuration(0.3, animations: {
            self.center = finishPoint;
            }, completion: {
                (value: Bool) in
                self.removeFromSuperview()
        })
    }
    
    func updateOverlay(distance: CGFloat) {
        if (distance > 0) {
            overlayView?.setMode(.Right)
        } else {
            overlayView?.setMode(.Left)
        }
        overlayView?.alpha = min(fabs(distance)/100, 0.4)
    }
}
