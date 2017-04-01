//
//  EditVC.swift
//  Location Tracker
//
//  Created by James Brown on 3/30/17.
//  Copyright © 2017 James Brown. All rights reserved.
//

import UIKit


class EditVC: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var scrollView: UIScrollView!

    @IBOutlet weak var addressField: CustomTextField!
    @IBOutlet weak var cityField: CustomTextField!
    @IBOutlet weak var stateField: CustomTextField!
    @IBOutlet weak var zipField: CustomTextField!
    @IBOutlet weak var detailsTextView: CustomTextView!
    
    
    private var _record: Record!
    
    var record: Record {
        get {
            return _record
        }
        set {
            _record = newValue
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addressField.delegate = self
        cityField.delegate = self
        stateField.delegate = self
        zipField.delegate = self
        

        addressField.text = record.address
        cityField.text = record.city
        stateField.text = record.state
        zipField.text = record.zip
        detailsTextView.text = record.details
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name:NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name:NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "MapVC" {
            if let destination = segue.destination as? MapVC {
                destination.record = record
            }
        }
    }
    
    // MARK: Keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func keyboardWillShow(notification:NSNotification){
        
        var userInfo = notification.userInfo!
        var keyboardFrame:CGRect = (userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)
        
        var contentInset:UIEdgeInsets = self.scrollView.contentInset
        contentInset.bottom = keyboardFrame.size.height
        self.scrollView.contentInset = contentInset
    }
    
    func keyboardWillHide(notification:NSNotification){
        
        let contentInset:UIEdgeInsets = UIEdgeInsets.zero
        self.scrollView.contentInset = contentInset
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }

    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveButtonPressed(_ sender: UIButton) {
        _record.address = addressField.text
        _record.city = cityField.text
        _record.state = stateField.text
        _record.zip = zipField.text
        _record.details = detailsTextView.text
        
        ad.saveContext()
        
        dismiss(animated: true, completion: nil)
    }
    
}
