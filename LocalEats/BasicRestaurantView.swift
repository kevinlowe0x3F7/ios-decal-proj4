//
//  BasicRestaurantView.swift
//  LocalEats
//
//  Created by Jeffrey Liu on 4/23/16.
//  Copyright © 2016 Kevin Lowe. All rights reserved.
//

import UIKit

class BasicRestaurantView: UIView {
    
    var restaurant: Restaurant!
    var imageView: UIImageView!
    var rating: UIImageView!
    var restaurantName : UILabel!
    var restaurantDistance : UILabel!
    var restaurantPhoneNumber : UILabel!
    var restaurantAddress : UILabel!
    
    var originalPoint = CGPoint()
    var xFromCenter = CGFloat()
    var yFromCenter = CGFloat()
    var delegate: BasicRestaurantViewController!
    var overlayView: OverlayView?
    
    init(frame: CGRect, restaurant: Restaurant, delegate: BasicRestaurantViewController) {
        super.init(frame: frame)
        let viewSize = frame.size
        self.backgroundColor = UIColor(red: 213/255, green: 242/255, blue: 229/255, alpha: 1)

        self.restaurant = restaurant
        self.delegate = delegate
        
        if let restaurantOptional = self.restaurant {
            let imageSize = viewSize.width - 100
            imageView = UIImageView(frame: CGRectMake(50, 50, imageSize, imageSize))
            imageView.image = UIImage(data: NSData(contentsOfURL: NSURL(string: restaurantOptional.imageURL)!)!)
            self.addSubview(imageView)
            setupLabels()
        } else {
            placeEmptyLabel()
        }
        addOverlayView()
    }
    
    func setupLabels() {
        let frame = self.frame.size
        let imageY = 25 + frame.width - 50
        let nameSize = CGFloat(40)
        restaurantName = UILabel(frame: CGRectMake(0, 10, frame.width, nameSize))
        restaurantName.text = restaurant.name
        restaurantName.textAlignment = NSTextAlignment.Center
        restaurantName.font = UIFont(name: "Helvetica Neue", size: 28)
        self.addSubview(restaurantName)
        
        
        restaurantDistance = UILabel(frame: CGRectMake(15, CGFloat(imageY + 10 + nameSize), frame.width, 30))
        restaurantDistance.font = UIFont(name: "Helvetica Neue", size: 20)
        restaurantDistance.text = "\(restaurant.distance) mi"
        self.addSubview(restaurantDistance)
        
        
        if let ratingPic = restaurant.ratingURL {
            let ratingWidth = frame.width / 3
            rating = UIImageView(frame: CGRectMake(frame.width / 3, CGFloat(imageY + 2 + nameSize), ratingWidth, 25))
            rating.image = UIImage(data: NSData(contentsOfURL: NSURL(string: ratingPic)!)!)
            self.addSubview(rating)
        }
        
        restaurantAddress = UILabel(frame: CGRectMake(15, CGFloat(imageY + 40 + nameSize), frame.width, 50))
        restaurantAddress.font = UIFont(name: "Helvetica Neue", size: 20)
        restaurantAddress.text = "\(restaurant.address[0]) " + "\(restaurant.address[1]) " + "\(restaurant.address[2]) "
        restaurantAddress.lineBreakMode = .ByWordWrapping // or NSLineBreakMode.ByWordWrapping
        restaurantAddress.numberOfLines = 2
        self.addSubview(restaurantAddress)

        restaurantPhoneNumber = UILabel(frame: CGRectMake(15, CGFloat(imageY + 100 + nameSize), frame.width/2, 30))
        restaurantPhoneNumber.font = UIFont(name: "Helvetica Neue", size: 20)
        restaurantPhoneNumber.text = restaurant.phoneNumber
        self.addSubview(restaurantPhoneNumber)

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
    
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    

}
