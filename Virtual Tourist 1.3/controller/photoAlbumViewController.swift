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
import Foundation
import SwiftyJSON
import Alamofire





class photoAlbumViewController: MainFunctionViewController , MKMapViewDelegate {
    
    @IBOutlet weak var location: MKMapView!
    @IBOutlet weak var photosAlbumColleaction: UICollectionView!
    @IBOutlet weak var action: UIButton!
    @IBOutlet weak var newPhotos: UIButton!
    
    var photos: [Photos]!
    var fetchedResultsController: NSFetchedResultsController<Photos>!
    var pin: Pin!
    var aripotName = ""
    var aripotCity = ""
    var message    = ""
    
    var dataController:DataController!
    
    var listOfPhotos           = [Photos]()
    var listOfPhotosForDeleted = [Photos]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        photosAlbumColleaction.allowsMultipleSelection = true
        photosAlbumColleaction.delegate = self
        photosAlbumColleaction.dataSource = self
        saveListOfPhotos()
        createAnnotation()
    }
    
    func fetchAirports()
    {
        let latitude = pin.latitude
        let longitude = pin.longitute
        
        let headers: HTTPHeaders = [
                              "x-rapidapi-host": "cometari-airportsfinder-v1.p.rapidapi.com",
                              "x-rapidapi-key": "8880868f03msh936f502e1957d44p1f8be6jsnf8e3274005a5",
                              "Content-Type" : "application/json; charset=UTF-8"
        ]
        AF.request("https://cometari-airportsfinder-v1.p.rapidapi.com/api/airports/by-radius?radius=10&lng=\(longitude)&lat=\(latitude)", headers: headers).responseJSON { response in
             switch response.result {
                     case .success(let value):
                          let json = JSON(value)
                          
                      for item in json[].arrayValue {
                        self.aripotName = item["name"].stringValue
                        self.aripotCity = item["city"].stringValue
                                   }
                
                      case .failure(let error):
                          self.message  = "Error, Failed to communicate with source"
                      }
            if(self.aripotName.count <= 0 || self.aripotName == "" || self.aripotName == nil)
            {
                self.message  = "Sory, There is no airport near you"
            }
            else
            {
                self.message =   "aripot name: \(self.aripotName) \n city: \(self.aripotCity)"
            }
            self.showAlert(firstTitle: "AirpotInformation", body: "\(self.message)", secondTitle: "OK")
        }
    }
    
    @IBAction func update(_ sender: Any) {
        
            for photo in listOfPhotos
            {
                self.dataController.viewContext.delete(photo)
            }
            try? self.dataController.viewContext.save()
            listOfPhotos = [Photos]()
            photosAlbumColleaction.reloadData()
            saveListOfPhotos()
    }
    
    func saveListOfPhotos()
    {
        let latitude = pin.latitude
        let longitude = pin.longitute
        
   
            Http.postSession(latitude: latitude, longitude: longitude){ (resultArray,errorString) in
                self.UIUpdatesOnMain
                {
                    guard errorString == nil else
                    {
                         self.showAlert(firstTitle: "Error", body: "Error, Failed to communicate with API", secondTitle: "OK")
                        return
                    }
                    if let resultArray = resultArray
                    {
                        for url in resultArray
                        {
                            let photo = Photos(context:self.dataController.viewContext)
                           photo.photoURL = url
                           photo.pin = self.pin
                           self.listOfPhotos.append(photo)
                        }
                        
                        try? self.dataController.viewContext.save()
                        
                        DispatchQueue.main.async
                        {
                            self.photosAlbumColleaction.reloadData()
                            for url in self.listOfPhotos
                            {
                               print(url)
                            }
                            
                        }
                    }
                    else
                    {
                        self.showAlert(firstTitle: "Error", body: "No images found", secondTitle: "OK")
                    }
                    
                }
            }
    }
        
    func fetchload() -> [Photos]? {
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Photo")
        
        let predicate = NSPredicate(format: "pin == %@", argumentArray: [pin])
        
        
        fetchRequest.predicate = predicate
        do {
            if let result = try
                
                dataController.viewContext.fetch(fetchRequest) as? [Photos] {
                
                return result.count > 0 ? result : nil
            }
        } catch {
            print("Error with data")
        }
        
        return nil
    }
    
    @IBAction func getAirpots(_ sender: Any) {
        fetchAirports()
        
    }
    func UIUpdatesOnMain(_ updates: @escaping () -> Void) {
        DispatchQueue.main.async {
            updates()
        }
    }
    

    
    
    func createAnnotation()
    {
        let annotation = MKPointAnnotation()
        annotation.title      = "pin"
        annotation.subtitle   = "i'm here"
        let lat              = pin.latitude //24.768587
        let long             = pin.longitute //46.806131
        
        annotation.coordinate = CLLocationCoordinate2DMake(lat, long)
        location.addAnnotation(annotation)
        
        //zooming to location
        let coredinate:CLLocationCoordinate2D = CLLocationCoordinate2DMake(lat, long)
        let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        let region = MKCoordinateRegion(center: coredinate, span: span)
        location.setRegion(region, animated: true)
    }
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        
        var pinView = location.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .blue
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}


extension photoAlbumViewController : UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listOfPhotos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
      let cell = (view.frame.width-20)/3
      return CGSize(width: cell , height: cell)
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ImageCollecationView
            let photo = self.listOfPhotos[indexPath.row]
            
            cell.imageView.image = nil
            cell.indicator.isHidden = false
        
            if let imageData = photo.imageData
            {
                let image = UIImage(data: imageData as Data)
                cell.imageView.image = image
                cell.indicator.isHidden = true

            }
            else
            {
                    cell.indicator.startAnimating()
                    Http.staticflicker.downloadsimages(with: photo.photoURL!) { (data, error) in
                     if error == nil
                     {
                        let downloadedImage = UIImage(data: data!)
                        photo.imageData = (data as NSData? as! Data)
                         DispatchQueue.main.async
                         {
                            cell.imageView.image = downloadedImage
                            cell.indicator.stopAnimating()
                            cell.indicator.isHidden = true                            
                         }
                     }
                }
            }
              return cell
        }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        let cell = collectionView.cellForItem(at: indexPath)

        cell?.contentView.alpha = 0.4
         newPhotos.setTitle("Remove Pictures", for: .normal)

        let photo = listOfPhotos[indexPath.row]
        if !listOfPhotosForDeleted.contains(photo) {
            listOfPhotosForDeleted.append(photo)
        }


    }
      func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
     let cell = collectionView.cellForItem(at: indexPath)

        cell?.contentView.alpha = 1.0

          let photo = listOfPhotos[indexPath.row]
        if listOfPhotosForDeleted.count == 0 {
            newPhotos.setTitle("New Collection", for: .normal)
        }
        if listOfPhotosForDeleted.contains(photo) {
            cell?.contentView.alpha = 1.0
            listOfPhotosForDeleted.remove(at: listOfPhotosForDeleted.firstIndex(of: photo)!)
        }

     }

    
    
}




