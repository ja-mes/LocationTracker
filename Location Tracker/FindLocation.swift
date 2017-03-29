//
//  FindLocation.swift
//  Location Tracker
//
//  Created by James Brown on 3/29/17.
//  Copyright © 2017 James Brown. All rights reserved.
//

import Foundation
import CoreLocation

class FindLocation: NSObject, CLLocationManagerDelegate {
    let locationManager = CLLocationManager();
    
    func grabLocation() {
        locationManager.requestWhenInUseAuthorization();
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
    }
    
}
