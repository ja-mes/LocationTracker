//
//  MapVC.swift
//  Location Tracker
//
//  Created by James Brown on 3/30/17.
//  Copyright © 2017 James Brown. All rights reserved.
//

import UIKit
import MapKit

class MapVC: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    
    private var _record: Record?
    
    var record: Record? {
        get {
            return _record
        }
        set {
            _record = newValue
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if  let address = record?.address,
            let city = record?.city,
            let state = record?.state,
            let zip = record?.zip
        {
        
            let addressString = "\(address), \(city), \(state) \(zip)"
            
            let geocoder = CLGeocoder()
            
            geocoder.geocodeAddressString(addressString, completionHandler: { (placemarks, error) in
                if let error = error {
                    print("Error geocoding address: " + error.localizedDescription)
                }
                
                if let placemark = placemarks?.first {
                    self.mapView.addAnnotation(MKPlacemark(placemark: placemark))
                    
                    if let coords = placemark.location?.coordinate {
                        self.mapView.setRegion(MKCoordinateRegionMakeWithDistance(coords, 2000, 2000), animated: true)
                    }
                }
            })
        }
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }


}
