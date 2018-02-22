//
//  ViewController.swift
//  GPSdemo
//
//  Created by Jie Cai on 2/19/18.
//  Copyright © 2018 Jie Cai. All rights reserved.
//

// Sourcecode: https://github.com/awseeley/Get-Users-Location/blob/master/GetLocation/ViewController.swift

import UIKit
import CoreLocation
import Firebase
import FirebaseCore
import FirebaseDatabase
import FirebaseAuth
import <GeoFire/GeoFire.h>

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    // Used to start getting the users location
    let locationManager = CLLocationManager()
    
    var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // For use when the app is open & in the background
        locationManager.requestAlwaysAuthorization()
        
        // For use when the app is open
        locationManager.requestWhenInUseAuthorization()
        
        // If location services is enabled get the users location
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest // You can change the locaiton accuary here.
            locationManager.startUpdatingLocation()
        }
    }
    
    // Print out the location & timestamp to the console
    // Currently updated every second
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        ref = Database.database().reference()
        
        let val = [
            "date": "today"
        ]
        
        var geoFire = GeoFire(ref);
        
        geoFire.set("some_key", [37.785326, -122.405696]).then(function());
        
        
        let update = ["electric-skateboard": geoFire]
        
        ref.updateChildValues(update)
        
        
        if let location = locations.first {
            
            // Print current location
            //print(location.coordinate)
            // Print current timestamp
            //print(NSDate())
        }
    }
    
    // If we have been deined access give the user the option to change it
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if(status == CLAuthorizationStatus.denied) {
            showLocationDisabledPopUp()
        }
    }
    
    // Show the popup to the user if we have been deined access
    func showLocationDisabledPopUp() {
        let alertController = UIAlertController(title: "Background Location Access Disabled",
                                                message: "In order to track your longboard we need your location",
                                                preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        let openAction = UIAlertAction(title: "Open Settings", style: .default) { (action) in
            if let url = URL(string: UIApplicationOpenSettingsURLString) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
        alertController.addAction(openAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
}

