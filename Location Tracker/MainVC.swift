//
//  MainVC.swift
//  Location Tracker
//
//  Created by James Brown on 3/28/17.
//  Copyright © 2017 James Brown. All rights reserved.
//

import UIKit
import CoreLocation

class MainVC: UIViewController, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addressLine1: UILabel!
    @IBOutlet weak var addressLine2: UILabel!
    
    var locationManger: CLLocationManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        locationManger = CLLocationManager()
        locationManger.delegate = self
        locationManger.requestWhenInUseAuthorization()
        locationManger.startUpdatingLocation()

    }
    
    
    // TABLE VIEW
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "MainCell") {
            return cell
        }
        return UITableViewCell();
    }

    
    // LOCATION MANAGER
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if let location = locationManger.location {
            
            CLGeocoder().reverseGeocodeLocation(location) { (placemarks, error) in
                if let error = error {
                    print("Reverse geocode failed with error" + error.localizedDescription)
                    return
                }
                
                if let pm = placemarks?[0] {
                    self.displayLocation(pm)
                }
                
            }
            
        }

    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error while updating location: " + error.localizedDescription)
    }
    
    
    // IBACTIONS
    @IBAction func saveButtonPressed(_ sender: Any) {
        
    }
    
    
    // FUNCS
    func displayLocation(_ placemark: CLPlacemark) {
        if  let locality = placemark.locality,
            let subThroughfare = placemark.subThoroughfare,
            let throughfare = placemark.thoroughfare,
            let code = placemark.postalCode,
            let area = placemark.administrativeArea {
            
            let line1 = "\(subThroughfare) \(throughfare)"
            let line2 = "\(locality), \(area) \(code)"
            
            addressLine1.text = line1
            addressLine2.text = line2
            
        }
    }
}
