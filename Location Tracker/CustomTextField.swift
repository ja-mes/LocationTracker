//
//  CustomTextField.swift
//  Location Tracker
//
//  Created by James Brown on 3/30/17.
//  Copyright © 2017 James Brown. All rights reserved.
//

import UIKit

@IBDesignable class CustomTextField: UITextField {
    @IBInspectable var cornerRadius: CGFloat = 0.0 {
        willSet {
            self.layer.cornerRadius = newValue
        }
    }
    
    @IBInspectable var textPadding: CGFloat = 0 {
        willSet {
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: newValue, height: frame.height))
            leftView = paddingView
            leftViewMode = UITextFieldViewMode.always
        }
    }
  
}
