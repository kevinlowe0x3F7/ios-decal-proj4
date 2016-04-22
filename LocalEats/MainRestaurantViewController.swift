//
//  ViewController.swift
//  LocalEats
//
//  Created by Kevin Lowe on 4/19/16.
//  Copyright © 2016 Kevin Lowe. All rights reserved.
//
//  red button: http://images.all-free-download.com/images/graphiclarge/round_red_x_sign_4229.jpg
//  green button: hhttp://cliparts.co/cliparts/kcK/B8p/kcKB8pagi.jpg

import UIKit
import CoreLocation

class MainRestaurantViewController: UIViewController, CLLocationManagerDelegate {
    let locationManager = CLLocationManager()
    var locationForYelp: CLLocation!
    var restaurantView: BasicDraggableRestaurantView!
    var loader: YelpAPILoader!
    /* The current offset from one search. */
    var currentOffset: Int!
    var user: UserProfile!
    var yesButton: UIButton!
    var noButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        self.navigationItem.title = "LocalEats"
        currentOffset = 0
        user = UserProfile()
        
        addButtons()
        // Do any additional setup after loading the view, typically from a nib.
        loader = YelpAPILoader(vc: self)
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        if CLLocationManager.authorizationStatus() == .NotDetermined {
            locationManager.requestWhenInUseAuthorization()
        }
        locationManager.requestLocation()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("Error while updating location " + error.localizedDescription)
    }

    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status != .AuthorizedWhenInUse {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locationForYelp = locations[locations.count - 1]
        user.updateLocation(locationForYelp)
        loader.loadRestaurants(locationForYelp)
        print("finished in locationManager method")
    }
    
    func addButtons() {
        let screen = UIScreen.mainScreen().bounds.size
        let buttonSize = screen.width / 5
        let centerX = screen.width / 2 - buttonSize / 2
        let mainViewHeight = screen.height - (screen.height * 4 / 10) - 15 + (self.navigationController?.navigationBar.frame.size.height)! + UIApplication.sharedApplication().statusBarFrame.size.height + 25
        let buttonY = mainViewHeight + screen.height / 20
        
        yesButton = UIButton(frame: CGRectMake(centerX + screen.width / 5, buttonY, buttonSize, buttonSize))
        yesButton.setImage(UIImage(named: "yes_button_trans.png"), forState: UIControlState.Normal)
        yesButton.addTarget(self, action: #selector(MainRestaurantViewController.yesButtonTapped), forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(yesButton)
        yesButton.alpha = 0
        
        noButton = UIButton(frame: CGRectMake(centerX - screen.width / 5, buttonY, buttonSize, buttonSize))
        noButton.setImage(UIImage(named: "no_button_trans.png"), forState: UIControlState.Normal)
        noButton.addTarget(self, action: #selector(MainRestaurantViewController.noButtonTapped), forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(noButton)
        noButton.alpha = 0
    }
    
    func yesButtonTapped() {
        self.restaurantView.animateCardToTheRight()
        if let restaurantToSave = self.restaurantView.restaurant {
            user.addRestaurant(restaurantToSave)
        }
        grabNextRestaurant()
    }
    
    func noButtonTapped() {
        self.restaurantView.animateCardToTheLeft()
        grabNextRestaurant()
    }
    
    func grabNextRestaurant() {
        let screen = UIScreen.mainScreen().bounds.size
        let viewWidth = screen.width - 50
        let viewHeight = screen.height - (screen.height * 4 / 10) - 15
        let viewY = (self.navigationController?.navigationBar.frame.size.height)! + UIApplication.sharedApplication().statusBarFrame.size.height + 25
        if let nextRestaurant = loader.list.getNextRestaurant() {
            if (user.hasSaved(nextRestaurant)) {
                grabNextRestaurant()
            } else {
                restaurantView = BasicDraggableRestaurantView(frame: CGRectMake(25, viewY, viewWidth, viewHeight), restaurant: nextRestaurant, delegate: self)
                self.view.addSubview(restaurantView)
                yesButton.alpha = 1
                noButton.alpha = 1
            }
        } else {
            print("passed 20")
            currentOffset = currentOffset + 20
            loader.loadRestaurants(locationForYelp, offset: currentOffset)
        }
    }
    
    func cardSwipedLeft(view: BasicDraggableRestaurantView) {
        grabNextRestaurant()
    }
    
    func cardSwipedRight(view: BasicDraggableRestaurantView) {
        if let restaurantToSave = view.restaurant {
            user.addRestaurant(restaurantToSave)
        }
        grabNextRestaurant()
    }
    
}

