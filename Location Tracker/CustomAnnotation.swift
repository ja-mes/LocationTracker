//
//  CustomAnnotation.swift
//  Location Tracker
//
//  Created by James Brown on 4/1/17.
//  Copyright © 2017 James Brown. All rights reserved.
//

import MapKit

class CustomAnnotation: NSObject, MKAnnotation {
    var title: String?
    var subtitle: String?
    var coordinate: CLLocationCoordinate2D
    
    init(title: String, subtitle: String, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.subtitle = subtitle
        self.coordinate = coordinate
    }
}
