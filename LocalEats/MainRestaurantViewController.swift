//
//  ViewController.swift
//  LocalEats
//
//  Created by Kevin Lowe on 4/19/16.
//  Copyright © 2016 Kevin Lowe. All rights reserved.
//
//  red button: http://images.all-free-download.com/images/graphiclarge/round_red_x_sign_4229.jpg
//  green button: http://cliparts.co/cliparts/kcK/B8p/kcKB8pagi.jpg
//  yelp loading gif: https://d13yacurqjgara.cloudfront.net/users/145494/screenshots/2053367/yelp-star-animation.gif

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
    var userProfileBarButtonItem: UIBarButtonItem!
    var settingsBarButtonItem: UIBarButtonItem!
    var loaded: Bool!
    var loadingView: UIImageView!
    var loadingLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red: 245/255, green: 245/255, blue: 241/255, alpha: 1)
        self.navigationItem.title = "LocalEats"
        currentOffset = 0
        user = UserProfile()
        user.grabUserContents()
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.user = user
        loaded = false
        
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
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    func presentSettings() {
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("Error while updating location " + error.localizedDescription)
        errorForCoreLocation()
    }

    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status != .AuthorizedWhenInUse {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locationForYelp = locations[locations.count - 1]
        user.updateLocation(locationForYelp)
        if (user.sortByDistance != nil && user.sortByDistance) {
            loader.loadSortedRestaurants(locationForYelp)
        } else {
            loader.loadRestaurants(locationForYelp)
        }
    }
    
    func addButtons() {
        let screen = UIScreen.mainScreen().bounds.size
        let buttonSize = screen.width / 5
        let centerX = screen.width / 2 - buttonSize / 2
        let mainViewHeight = screen.height - (screen.height * 4 / 10) - 15 + (self.navigationController?.navigationBar.frame.size.height)! + UIApplication.sharedApplication().statusBarFrame.size.height + 25
        let buttonY = mainViewHeight + screen.height / 20
        
        yesButton = UIButton(frame: CGRectMake(centerX + screen.width / 5, buttonY, buttonSize, buttonSize))
        yesButton.setImage(UIImage(named: "yes_button_trans.png"), forState: UIControlState.Normal)
        yesButton.addTarget(self, action: "yesButtonTapped", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(yesButton)
        yesButton.alpha = 0
        
        noButton = UIButton(frame: CGRectMake(centerX - screen.width / 5, buttonY, buttonSize, buttonSize))
        noButton.setImage(UIImage(named: "no_button_trans.png"), forState: UIControlState.Normal)
        noButton.addTarget(self, action: "noButtonTapped", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(noButton)
        noButton.alpha = 0
        
        userProfileBarButtonItem = UIBarButtonItem(title: "Likes", style: .Plain, target: self, action: #selector(MainRestaurantViewController.userProfileTapped))
        self.navigationItem.rightBarButtonItem = userProfileBarButtonItem
        
        settingsBarButtonItem = UIBarButtonItem(title: "Settings", style: .Plain, target: self, action: #selector(MainRestaurantViewController.settingsTapped))
        self.navigationItem.leftBarButtonItem = settingsBarButtonItem
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
    
    func userProfileTapped() {
        let vc = SavedRestaurantsTableViewController()
        vc.user = self.user
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func settingsTapped() {
        let vc = SettingsViewController()
        vc.mainViewController = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func grabNextRestaurant() {
        if !loaded {
            loadingView.removeFromSuperview()
            loadingLabel.removeFromSuperview()
            loaded = true
        }
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
            if currentOffset >= 1000 {
                outOfRestaurants()
            } else if (user.sortByDistance != nil && user.sortByDistance) {
                loader.loadSortedRestaurants(locationForYelp, offset: currentOffset)
            } else {
                loader.loadRestaurants(locationForYelp, offset: currentOffset)
            }
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
    
    func loadLaunchElements() {
        loaded = false
        let screen = UIScreen.mainScreen().bounds.size
        let viewWidth = screen.width
        let viewY = (self.navigationController?.navigationBar.frame.size.height)! + UIApplication.sharedApplication().statusBarFrame.size.height + 25
        loadingView = UIImageView(frame: CGRectMake(0, viewY, viewWidth, viewWidth))
        let yelpGif = UIImage.gifWithName("yelp_star")
        loadingView.image = yelpGif
        self.view.addSubview(loadingView)
        
        loadingLabel = UILabel(frame: CGRectMake(0, viewY + viewWidth + 20, viewWidth, 40))
        loadingLabel.font = UIFont(name: "Helvetica Neue", size: 25)
        loadingLabel.textAlignment = NSTextAlignment.Center
        loadingLabel.text = "Loading restaurants..."
        self.view.addSubview(loadingLabel)
    }
    
    func getNewLocation(location: CLLocation) {
        loader.clearRestaurantList()
        currentOffset = 0
        if let restaurantViewOptional = restaurantView {
            restaurantViewOptional.removeFromSuperview()
        }
        yesButton.alpha = 0
        noButton.alpha = 0
        user.updateLocation(location)
        locationForYelp = location
        if (self.loaded != nil && self.loaded) {
            loadLaunchElements()
        }
        if (user.sortByDistance != nil && user.sortByDistance) {
            loader.loadSortedRestaurants(location)
        } else {
            loader.loadRestaurants(location)
        }
    }
    
    func beingTapped() {
        let vc = DetailedRestaurantViewController()
        vc.restaurant = self.restaurantView.restaurant
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func errorForNewLocation() {
        let alertController = UIAlertController(title: "Error", message: "Location not found, please try a different location", preferredStyle: .Alert)
        
        let OKAction = UIAlertAction(title: "OK", style: .Default) { (action:UIAlertAction) in
        }
        
        alertController.addAction(OKAction)
        self.presentViewController(alertController, animated: true, completion:nil)
    }
    
    func errorForCoreLocation() {
        let alertController = UIAlertController(title: "Error with current location", message: "Unable to load restaurants for current location, please enable Location Services", preferredStyle: .Alert)
        
        let OKAction = UIAlertAction(title: "OK", style: .Default) { (action:UIAlertAction) in
        }
        
        alertController.addAction(OKAction)
        self.presentViewController(alertController, animated: true, completion:nil)
    }
    
    func outOfRestaurants() {
        let alertController = UIAlertController(title: "Out of Restaurants!", message: "Try a different location", preferredStyle: .Alert)
        
        let OKAction = UIAlertAction(title: "OK", style: .Default) { (action:UIAlertAction) in
        }
        
        alertController.addAction(OKAction)
        self.presentViewController(alertController, animated: true, completion:nil)
    }
    
}

