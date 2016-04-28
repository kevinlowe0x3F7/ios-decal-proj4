//
//  BasicRestaurantViewController.swift
//  LocalEats
//
//  Created by Jeffrey Liu on 4/23/16.
//  Copyright © 2016 Kevin Lowe. All rights reserved.
//

import UIKit

class DetailedRestaurantViewController: UIViewController {

    var detailedRestaurantView : DetailedRestaurantView!
    var restaurant : Restaurant!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let myWebView:UIWebView = UIWebView(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.width,	UIScreen.mainScreen().bounds.height))
        
        myWebView.loadRequest(NSURLRequest(URL: NSURL(string: restaurant.businessURL)!))
        
        self.view.addSubview(myWebView)


        
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
