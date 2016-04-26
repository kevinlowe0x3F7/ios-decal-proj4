//
//  BasicRestaurantViewController.swift
//  LocalEats
//
//  Created by Jeffrey Liu on 4/23/16.
//  Copyright © 2016 Kevin Lowe. All rights reserved.
//

import UIKit

class BasicRestaurantViewController: UIViewController {

    var basicRestaurantView : BasicRestaurantView!
    var restaurant : Restaurant!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let screen = UIScreen.mainScreen().bounds.size
        let viewWidth = screen.width
        let viewHeight = screen.height
        let viewY = (self.navigationController?.navigationBar.frame.size.height)! + UIApplication.sharedApplication().statusBarFrame.size.height
        
        basicRestaurantView = BasicRestaurantView(frame: CGRectMake(0, viewY, viewWidth, viewHeight), restaurant: restaurant, delegate: self)
        //addSubview is crucial!
        self.view.addSubview(basicRestaurantView)
        
        
        basicRestaurantView.restaurantName.center.x = self.view.center.x
        basicRestaurantView.imageView.center.x = self.view.center.x
        basicRestaurantView.rating.center.x = self.view.center.x
        basicRestaurantView.rating.center.y = self.view.center.y + 25
//        basicRestaurantView.restaurantAddress.center.x = self.view.center.x
        basicRestaurantView.restaurantPhoneNumber.center.x = self.view.center.x
        basicRestaurantView.restaurantDistance.center.x = self.view.center.x


        
        // Do any additional setup after loading the view.
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
