//
//  PhotoVC.swift
//  Location Tracker
//
//  Created by James Brown on 4/4/17.
//  Copyright © 2017 James Brown. All rights reserved.
//

import UIKit

class PhotoVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
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
        

    }
    
    @IBAction func cancelButtonPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
 
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath)
        
        print(photos?[indexPath.row] ?? "No photo")
        
        return cell
        
    }
}
