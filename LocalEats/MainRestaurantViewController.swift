//
//  ViewController.swift
//  LocalEats
//
//  Created by Kevin Lowe on 4/19/16.
//  Copyright © 2016 Kevin Lowe. All rights reserved.
//

import UIKit
import CoreLocation

class MainRestaurantViewController: UIViewController, CLLocationManagerDelegate {
    let locationManager = CLLocationManager()
    var locationForYelp: CLLocation!
    var restaurantView: BasicDraggableRestaurantView!
    var loader: YelpAPILoader!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red: 0xF3, green: 0xF3, blue: 0xF3, alpha: 1)
        self.navigationItem.title = "LocalEats"
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
        loader.loadRestaurants(locationForYelp)
        print("finished in locationManager method")
    }
    
    func grabFirstRestaurant() {
        let screen = UIScreen.mainScreen().bounds.size
        restaurantView = BasicDraggableRestaurantView(frame: CGRectMake(screen.width / 2 - 150, 100, 300, 400), restaurant: loader.list.getNextRestaurant()!)
        self.view.addSubview(restaurantView)
    }
}

