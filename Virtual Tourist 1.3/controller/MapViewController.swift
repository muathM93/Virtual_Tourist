//
//  ViewController.swift
//  Virtual Tourist 1.3
//
//  Created by Muath Mohammed on 17/04/1441 AH.
//  Copyright © 1441 MuathMohammed. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class MapViewController: MainFunctionViewController ,  MKMapViewDelegate , NSFetchedResultsControllerDelegate{

    @IBOutlet weak var mapView: MKMapView!
    var dataController: DataController!
    var fetchRequest: NSFetchRequest<Pin> = Pin.fetchRequest()
    var pin:Pin!
    var fetchedResultsController:NSFetchedResultsController<Pin>!

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        setupFetchedResultsController()
    }
    
    func setupFetchedResultsController() {
        if let result = try? dataController.viewContext.fetch(fetchRequest) {
            for pin in result {
                let annotation = MKPointAnnotation()
                annotation.coordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees(pin.latitude), longitude: CLLocationDegrees(pin.longitute))
                mapView.addAnnotation(annotation)
            }
        }
    }
    

    @IBAction func addNewPin(_ sender: UILongPressGestureRecognizer) {
        
          if sender.state == .began
          {
               let pin = Pin(context: dataController.viewContext)
               let touchLocation = sender.location(in: self.mapView)
               let coordinate = mapView.convert(touchLocation, toCoordinateFrom: mapView)
               pin.latitude = Double(coordinate.latitude)
               pin.longitute = Double(coordinate.longitude)
              try? dataController.viewContext.save()
               let annotation = MKPointAnnotation()
               annotation.coordinate = coordinate
               mapView.addAnnotation(annotation)
          }
    }
    
    func deleteNotebook(at indexPath: IndexPath) {
         let notebookToDelete = fetchedResultsController.object(at: indexPath)
        dataController.viewContext.delete(notebookToDelete)
        try? dataController.viewContext.save()
     }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
           
           let reuseId = "pin"
           var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
           
           if pinView == nil {
               pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
               pinView!.canShowCallout = true
               pinView!.pinTintColor = .red
               pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
           }
           else {
               pinView!.annotation = annotation
           }
           
           return pinView
       }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        mapView.deselectAnnotation(view.annotation, animated: true)
        if let annotation = view.annotation {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Pin")
            let predicate = NSPredicate(format: "latitude == %@ AND longitute == %@", argumentArray: [annotation.coordinate.latitude, annotation.coordinate.longitude])
            fetchRequest.predicate = predicate
            do {
                if let result = try
                    
                    dataController.viewContext.fetch(fetchRequest) as? [Pin],
                    let pin = result.first {
                  performSegue(withIdentifier: "passValues", sender: pin)
                
                }
            }
            
            catch {
                self.showAlert(firstTitle: "Massege", body: "Couldn't find any Pins", secondTitle: "OK")
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
          if segue.identifier == "passValues" {
              let vc = segue.destination as! photoAlbumViewController
              vc.pin = (sender as! Pin)
              vc.dataController = dataController
          }
      }
}
