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
                if city == "" && state == "" && zip == "" {
                    return nil
                }
                
                return "\(city), \(state) \(zip)"
            }
            
            return nil
        }
    }
}
