//
//  PhotoVC.swift
//  Location Tracker
//
//  Created by James Brown on 4/4/17.
//  Copyright © 2017 James Brown. All rights reserved.
//

import UIKit

class PhotoVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var imagePicker: UIImagePickerController!
    var photos: [Photo]?
    
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

        collectionView.delegate = self
        collectionView.dataSource = self
        
        if let p = record?.photos {
            if let pArr = p.allObjects as? [Photo] {
                photos = pArr
            }
        }
        
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
    
    }
    
    @IBAction func doneButtonPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func newButtonPressed(_ sender: UIButton) {
        present(imagePicker, animated: true, completion: nil)
    }
 
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as? PhotoCell {
            if let photos = photos, let data = photos[indexPath.row].image {
                
                cell.imageView.image = UIImage(data: data as Data)

            }
            
            return cell
            
        }
        
        return UICollectionViewCell()
        
    }
}
