//
//  ViewController.swift
//  LocalEats
//
//  Created by Kevin Lowe on 4/19/16.
//  Copyright © 2016 Kevin Lowe. All rights reserved.
//
//  red button: http://images.all-free-download.com/images/graphiclarge/round_red_x_sign_4229.jpg
//  green button: http://iconbug.com/data/bc/256/58c263c305e5d8a66579534c3c39645d.png

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

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        self.navigationItem.title = "LocalEats"
        currentOffset = 0
        user = UserProfile()
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

