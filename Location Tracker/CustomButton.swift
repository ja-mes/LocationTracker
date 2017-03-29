//
//  CustomButton.swift
//  Location Tracker
//
//  Created by James Brown on 3/29/17.
//  Copyright © 2017 James Brown. All rights reserved.
//

import UIKit

@IBDesignable class CustomButton: UIButton {
    @IBInspectable var rounded: CGFloat = 0.0 {
        willSet {
            self.layer.cornerRadius = newValue
        }
    }
    
}
