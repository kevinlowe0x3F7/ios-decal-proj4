//
//  SettingsViewController.swift
//  LocalEats
//
//  Created by Jeffrey Liu on 4/27/16.
//  Copyright © 2016 Kevin Lowe. All rights reserved.
//

import UIKit
import MapKit

class SettingsViewController: UIViewController {
    
    var sortSwitch : UISwitch!
    var locationTextField : UITextField!
    var enterLocationLabel : UILabel!
    var bestMatchLabel : UILabel!
    var locationLabel : UILabel!
    var mainViewController: MainRestaurantViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        self.view.backgroundColor = UIColor(red: 245/255, green: 245/255, blue: 241/255, alpha: 1)
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        let geocoder = CLGeocoder()
        let address = self.locationTextField.text!
        
        geocoder.geocodeAddressString(address, completionHandler: {(placemarks, error) -> Void in
            if((error) != nil){
                print("Error", error)
            }
            if let placemark = placemarks?.first {
                let location = placemark.location
                self.mainViewController!.getNewLocation(location!)
            }
        })
        
    }
    
    func setUpView() {
        let screen = UIScreen.mainScreen().bounds.size
        let topFifthCenterY = (screen.height / 5)
    
        enterLocationLabel = UILabel(frame: CGRectMake(screen.width / 15, topFifthCenterY, 200, 20))
        enterLocationLabel.text = "Enter Location"
        self.view.addSubview(enterLocationLabel)
        
        locationTextField = UITextField(frame: CGRectMake(screen.width / 15, (1.2*topFifthCenterY), 300, 40))
        locationTextField.placeholder = "Enter text here"
        locationTextField.font = UIFont.systemFontOfSize(15)
        locationTextField.borderStyle = UITextBorderStyle.RoundedRect
        locationTextField.autocorrectionType = UITextAutocorrectionType.No
        locationTextField.keyboardType = UIKeyboardType.Default
        locationTextField.returnKeyType = UIReturnKeyType.Done
        locationTextField.clearButtonMode = UITextFieldViewMode.WhileEditing;
        locationTextField.contentVerticalAlignment = UIControlContentVerticalAlignment.Center
        self.view.addSubview(locationTextField)
        
        sortSwitch = UISwitch(frame: CGRect(x: screen.width / 2, y: screen.height / 2, width: 0, height: 0))
        sortSwitch.on = true
        sortSwitch.setOn(true, animated: false);
        sortSwitch.addTarget(self, action: #selector(SettingsViewController.switchValueDidChange(_:)), forControlEvents: .ValueChanged)
        self.view.addSubview(sortSwitch)
        
        bestMatchLabel = UILabel(frame: CGRectMake(screen.width / 6, (screen.height / 2) - 10, 200, 40))
        bestMatchLabel.text = "Location"
        bestMatchLabel.font = bestMatchLabel.font.fontWithSize(30)
        
        self.view.addSubview(bestMatchLabel)
        
        locationLabel = UILabel(frame: CGRectMake(2 * screen.width / 3, (screen.height / 2) - 10, 200, 40))
        locationLabel.text = "Best Match"
        locationLabel.font = locationLabel.font.fontWithSize(30)
        self.view.addSubview(locationLabel)
    }
    
    func switchValueDidChange(sender:UISwitch!)
    {
        if (sender.on == true){
            print("on")
        }
        else{
            print("off")
        }
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
