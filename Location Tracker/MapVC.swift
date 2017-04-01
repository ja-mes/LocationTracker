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

        if let record = record, let lon = record.lon, let lat = record.lat {
            if let lon = Double(lon), let lat = Double(lat) {
                let region: CLLocationCoordinate2D = CLLocationCoordinate2DMake(lat, lon)
                mapView.setRegion(MKCoordinateRegionMakeWithDistance(region, 2000, 2000), animated: true)
                
                let pin = CustomAnnotation(title: record.address ?? "", subtitle: "", coordinate: region)
                mapView.addAnnotation(pin)    
            }
        }
    }

    @IBAction func backButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }


}
