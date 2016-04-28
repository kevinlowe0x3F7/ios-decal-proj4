//
//  SettingsViewController.swift
//  LocalEats
//
//  Created by Jeffrey Liu on 4/27/16.
//  Copyright © 2016 Kevin Lowe. All rights reserved.
//

import UIKit
import MapKit

class SettingsViewController: UIViewController, UITextFieldDelegate {
    
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
        if address.characters.count != 0 {
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
    }
    
    func setUpView() {
        let screen = UIScreen.mainScreen().bounds.size
        let topFifthCenterY = (screen.height / 5)
    
        enterLocationLabel = UILabel(frame: CGRectMake(screen.width / 15, topFifthCenterY, 200, 20))
        enterLocationLabel.text = "Custom Location"
        self.view.addSubview(enterLocationLabel)
        
        locationTextField = UITextField(frame: CGRectMake(screen.width / 15, (1.2*topFifthCenterY), 300, 40))
        locationTextField.placeholder = "Enter location here"
        locationTextField.font = UIFont.systemFontOfSize(15)
        locationTextField.borderStyle = UITextBorderStyle.RoundedRect
        locationTextField.autocorrectionType = UITextAutocorrectionType.No
        locationTextField.keyboardType = UIKeyboardType.Default
        locationTextField.returnKeyType = UIReturnKeyType.Done
        locationTextField.clearButtonMode = UITextFieldViewMode.WhileEditing;
        locationTextField.contentVerticalAlignment = UIControlContentVerticalAlignment.Center
        locationTextField.delegate = self
        self.view.addSubview(locationTextField)
        
        sortSwitch = UISwitch(frame: CGRectMake(screen.width - 70, screen.height / 2 - 30, 0, 0))
        sortSwitch.on = false
        sortSwitch.addTarget(self, action: #selector(SettingsViewController.switchValueDidChange(_:)), forControlEvents: .ValueChanged)
        self.view.addSubview(sortSwitch)
        
        locationLabel = UILabel(frame: CGRectMake(20, (screen.height / 2) - 40, 200, 40))
        locationLabel.text = "Sort by Distance"
        locationLabel.font = locationLabel.font.fontWithSize(screen.width / 20)
        self.view.addSubview(locationLabel)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    func switchValueDidChange(sender:UISwitch!)
    {
        if (sender.on == true){
            self.mainViewController!.user.sortByDistance = true
        } else{
            self.mainViewController!.user.sortByDistance = false
        }
    }
}
