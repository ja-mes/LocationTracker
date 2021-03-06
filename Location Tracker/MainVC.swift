//
//  MainVC.swift
//  Location Tracker
//
//  Created by James Brown on 3/28/17.
//  Copyright © 2017 James Brown. All rights reserved.
//

import UIKit
import CoreLocation
import CoreData

class MainVC: UIViewController, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate, NSFetchedResultsControllerDelegate {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addressLine1: UILabel!
    @IBOutlet weak var addressLine2: UILabel!
    
    var locationManger: CLLocationManager!
    var controller: NSFetchedResultsController<Record>!
    var currentPlacemark: CLPlacemark?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        tableView.delegate = self
        tableView.dataSource = self
        
        fetchRecords()
        
        locationManger = CLLocationManager()
        locationManger.delegate = self
        locationManger.requestWhenInUseAuthorization()
        locationManger.startUpdatingLocation()

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EditVC" {
            if let destination = segue.destination as? EditVC {
                if let record = sender as? Record {
                    destination.record = record
                }
            }
        }
    }
    
    
    // TABLE VIEW
    func numberOfSections(in tableView: UITableView) -> Int {
        if let sections = controller.sections {
            return sections.count
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = controller.sections {
            return sections[section].numberOfObjects
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "MainCell") as? RecordCell {
            configureCell(cell: cell, indexPath: indexPath)
            return cell
        }
        return UITableViewCell();
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "EditVC", sender: controller.object(at: indexPath))
    }
    
    

    
    // LOCATION MANAGER
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if let location = locationManger.location {
            CLGeocoder().reverseGeocodeLocation(location) { (placemarks, error) in
                if let error = error {
                    print("Reverse geocode failed with error" + error.localizedDescription)
                    return
                }
                
                if let pm = placemarks?[0] {
                    self.displayLocation(pm)
                    
                }
                
            }
            
        }

    }
    
    
    // MARK: FRC
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case.insert:
            if let indexPath = newIndexPath {
                tableView.insertRows(at: [indexPath], with: .fade)
            }
            break
        case.delete:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            break
        case.update:
            if let indexPath = indexPath {
                if let cell = tableView.cellForRow(at: indexPath) as? RecordCell {
                    configureCell(cell: cell, indexPath: indexPath)
                }
            }
            break
        case.move:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            if let indexPath = newIndexPath {
                tableView.insertRows(at: [indexPath], with: .fade)
            }
            break
        }
    }
    
      
    // IBACTIONS
    @IBAction func saveButtonPressed(_ sender: Any) {
        let item = Record(context: context)
        item.address = addressLine1.text
        
        item.city = currentPlacemark?.locality
        item.state = currentPlacemark?.administrativeArea
        item.zip = currentPlacemark?.postalCode
        item.date = NSDate()
        
        ad.saveContext()
    }
    

    @IBAction func addButtonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "EditVC", sender: nil)
    }
    
    // FUNCS
    func displayLocation(_ placemark: CLPlacemark) {
        
        currentPlacemark = placemark
        
        if  let locality = placemark.locality,
            let subThroughfare = placemark.subThoroughfare,
            let throughfare = placemark.thoroughfare,
            let code = placemark.postalCode,
            let area = placemark.administrativeArea {
            
            let line1 = "\(subThroughfare) \(throughfare)"
            let line2 = "\(locality), \(area) \(code)"
            
            addressLine1.text = line1
            addressLine2.text = line2
            
        }
    }
    
    func fetchRecords() {
        let fetchRequest: NSFetchRequest<Record> = Record.fetchRequest()
        
        let dateSort = NSSortDescriptor(key: "date", ascending: false)
        fetchRequest.sortDescriptors = [dateSort]
        
        let newController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        self.controller = newController
        
        controller.delegate = self
        
        do {
            try controller.performFetch()
        } catch {
            let error = error as NSError
            print(error)
        }
    }
    
    func configureCell(cell: RecordCell, indexPath: IndexPath) {
        let record = controller.object(at: indexPath)
        
        cell.addressLine1.text = record.address
        cell.addressLine2.text = record.addressLine2
        
        if let date = record.date {
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "h:mm a"
            cell.timeLbl.text = dateFormatter.string(from: date as Date)
            
            dateFormatter.dateFormat = "MMMM d, yyyy"
            cell.dateLbl.text = dateFormatter.string(from: date as Date)
        }
        
    }

}
