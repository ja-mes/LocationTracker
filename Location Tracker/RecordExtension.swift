//
//  RecordExtension.swift
//  Location Tracker
//
//  Created by James Brown on 3/30/17.
//  Copyright © 2017 James Brown. All rights reserved.
//

import Foundation


extension Record {
    var addressLine2: String? {
        get {
            if let city = city, let state = state, let zip = zip {
                if city.isEmpty && state.isEmpty && zip.isEmpty {
                    return nil
                } else if !city.isEmpty && state.isEmpty && zip.isEmpty {
                    return city
                }
                
                return "\(city), \(state) \(zip)"
            }
            
            return nil
        }
    }
}
