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
    @IBOutlet weak var dateField: CustomTextField!
    
    
    private var _record: Record!
    var datePicker: UIDatePicker!
    
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
        
        datePicker = UIDatePicker()
        datePicker.datePickerMode = .dateAndTime
        dateField.inputView = datePicker
        dateField.tintColor = UIColor.clear
        datePicker.addTarget(self, action: #selector(handleDatePicker(sender:)), for: .valueChanged)
        
        
        addressField.delegate = self
        cityField.delegate = self
        stateField.delegate = self
        zipField.delegate = self
        dateField.delegate = self
        

        addressField.text = record.address
        cityField.text = record.city
        stateField.text = record.state
        zipField.text = record.zip
        detailsTextView.text = record.details
        
        if let date = record.date {
            displayDate(date: date as Date)
        }
        
        
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

    
    @IBAction func dateEditingBegan(_ sender: Any) {
        dateField.font = UIFont(name: "AvenirNext-Bold", size: 14.0)
    }
    
    @IBAction func dateEditingEnded(_ sender: Any) {
        dateField.font = UIFont(name: "AvenirNext-Regular", size: 14.0)
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
        _record.date = datePicker.date as NSDate
        
        ad.saveContext()
        
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func deleteButtonPressed(_ sender: UIButton) {
        let alertController = UIAlertController(title: "", message: "Are you sure you want to delete this entry?", preferredStyle: .actionSheet)
        
        alertController.popoverPresentationController?.sourceView = sender
        alertController.popoverPresentationController?.sourceRect = CGRect(x: 0, y: sender.frame.height, width: 0, height: 0)
        alertController.popoverPresentationController?.permittedArrowDirections = .up
        
        let deleteAction = UIAlertAction(title: "Delete Entry", style: .destructive, handler: { (action) in
            context.delete(self.record)
            ad.saveContext()
            self.dismiss(animated: true, completion: nil)
        })
        alertController.addAction(deleteAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    
    // MARK: func
    func handleDatePicker(sender: UIDatePicker) {
        displayDate(date: sender.date)
    }
    
    func displayDate(date: Date) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .short
        
        dateField.text = dateFormatter.string(from: date)
    }
}
