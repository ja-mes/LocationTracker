//
//  PhotoVC.swift
//  Location Tracker
//
//  Created by James Brown on 4/4/17.
//  Copyright © 2017 James Brown. All rights reserved.
//

import UIKit
import CoreData

class PhotoVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate, NSFetchedResultsControllerDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var controller: NSFetchedResultsController<Photo>!
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
        
        fetchPhotos()
    
    }
    
    @IBAction func doneButtonPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func newButtonPressed(_ sender: UIButton) {
        present(imagePicker, animated: true, completion: nil)
    }
 
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if let sections = controller.sections {
            return sections.count
        }
        
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let sections = controller.sections {
            return sections[section].numberOfObjects
        }
        
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as? PhotoCell {
            configureCell(cell: cell, indexPath: indexPath)
            
            return cell
            
        }
        
        return UICollectionViewCell()
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            
        }
    }
    
    
    // MARK: FRC
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case.insert:
            if let indexPath = newIndexPath {
                collectionView.insertItems(at: [indexPath])
            }
            break
        case.delete:
            if let indexPath = indexPath {
                collectionView.deleteItems(at: [indexPath])
            }
            break
        case.update:
            if let indexPath = indexPath {
                if let cell = collectionView.cellForItem(at: indexPath) as? PhotoCell {
                    configureCell(cell: cell, indexPath: indexPath)
                }
            }
            break
        case.move:
            if let indexPath = indexPath {
                collectionView.deleteItems(at: [indexPath])
            }
            if let indexPath = newIndexPath {
                collectionView.insertItems(at: [indexPath])
            }
            break
        }
    }

    
    func fetchPhotos() {
        let fetchRequest: NSFetchRequest<Photo> = Photo.fetchRequest()
        
        let dateSort = NSSortDescriptor(key: "date", ascending: false)
        fetchRequest.sortDescriptors = [dateSort]
        
        if let record = record {
            fetchRequest.predicate = NSPredicate(format: "record == %@", record)
        }
        
        
        let newController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        self.controller = newController
        
        controller.delegate = self
        
        do {
            try controller.performFetch()
        } catch {
            let error = error as NSError
            print(error.localizedDescription)
        }
    }
    
    func configureCell(cell: PhotoCell, indexPath: IndexPath) {
        let photo = controller.object(at: indexPath)

        if let image = photo.image {
            cell.imageView.image = UIImage(data: image as Data)
        }
    }
}
