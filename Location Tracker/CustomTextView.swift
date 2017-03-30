//
//  CustomTextView.swift
//  Location Tracker
//
//  Created by James Brown on 3/30/17.
//  Copyright © 2017 James Brown. All rights reserved.
//

import UIKit

@IBDesignable class CustomTextView: UITextView {
    @IBInspectable var borderWidth: CGFloat = 0.0 {
        willSet {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable var borderColor: UIColor = UIColor.clear{
        willSet {
            layer.borderColor = newValue.cgColor
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat = 0.0 {
        willSet {
            layer.cornerRadius = newValue
        }
    }
    
}
