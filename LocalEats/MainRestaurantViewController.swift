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
        self.view.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
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
        let viewWidth = screen.width - 50
        let viewHeight = screen.height - (screen.height * 4 / 10) - 15
        let viewY = (self.navigationController?.navigationBar.frame.size.height)! + UIApplication.sharedApplication().statusBarFrame.size.height + 25
        restaurantView = BasicDraggableRestaurantView(frame: CGRectMake(25, viewY, viewWidth, viewHeight), restaurant: loader.list.getNextRestaurant()!)
        self.view.addSubview(restaurantView)
    }
}

