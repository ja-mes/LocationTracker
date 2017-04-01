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
    
    private var _lat: String?
    private var _lon: String?
    
    var lat: String? {
        get {
            return _lat
        }
        set {
            _lat = newValue
        }
    }
    
    
    var lon: String? {
        get {
            return _lon
        }
        set {
            _lon = newValue
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print(_lon)
        print(_lat)
        
    }

    @IBAction func backButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }


}
