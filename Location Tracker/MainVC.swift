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
                    self.displayLocation(placemark: pm)
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
    func displayLocation(placemark: CLPlacemark) {
        print(placemark.locality ?? "")
        print(placemark.postalCode ?? "")
    }
}
