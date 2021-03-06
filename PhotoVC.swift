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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let photo = controller.object(at: indexPath)
        
        let alertController = UIAlertController(title: "", message: "Are you sure you want to delete this photo?", preferredStyle: .actionSheet)
        
        alertController.popoverPresentationController?.sourceView = view
        alertController.popoverPresentationController?.sourceRect = CGRect(x: 0, y: view.frame.height, width: 0, height: 0)
        alertController.popoverPresentationController?.permittedArrowDirections = .up
        
        let deleteAction = UIAlertAction(title: "Delete Photo", style: .destructive, handler: { (action) in
            context.delete(photo)
            ad.saveContext()
        })
        alertController.addAction(deleteAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            if let imageData = UIImageJPEGRepresentation(pickedImage, 1) {
                let photo = Photo(context: context)
                photo.image = imageData as NSData
                photo.date = NSDate()
                record?.addToPhotos(photo)
            }
        } else {
            print("Failure to grab image")
        }
        
        self.dismiss(animated: true, completion: nil)
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
        
        if record != nil {
            do {
                try controller.performFetch()
            } catch {
                let error = error as NSError
                print(error.localizedDescription)
            }
        }
    }
    
    func configureCell(cell: PhotoCell, indexPath: IndexPath) {
        let photo = controller.object(at: indexPath)

        if let image = photo.image {
            cell.imageView.image = UIImage(data: image as Data)
        }
    }
}
