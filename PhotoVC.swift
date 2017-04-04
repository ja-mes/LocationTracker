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

    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}
