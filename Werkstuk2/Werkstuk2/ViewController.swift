//
//  ViewController.swift
//  Werkstuk2
//
//  Created by student on 03/06/2018.
//  Copyright © 2018 student. All rights reserved.
//

import UIKit
import CoreData
import MapKit
import CoreLocation

class ViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var timePassed: UILabel!
    var time = 0
    var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getRequestStations()
        self.setAnnotations()
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: {_ in
            self.time = self.time + 1
            self.timePassed.text = String(self.time) + NSLocalizedString("s after refresh", comment: "")
        })
    }
    
    var annotationStation = Station()
    
    @IBAction func refresh(_ sender: Any) {
        self.time = 0
        self.getRequestStations()
        self.setAnnotations()
    }
    
    func setAnnotations(){
        self.mapView.removeAnnotations(self.mapView.annotations)
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate
            else {
                return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let stationsFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Station")
        let stations: [Station]
        do {
            stations = try managedContext.fetch(stationsFetch) as! [Station]
            for s in stations {
                let annotation = MapAnnotation(coordinate: CLLocationCoordinate2D(latitude: s.lat, longitude: s.lng), title: s.name!)
                annotation.station = s;
                self.mapView.addAnnotation(annotation)
            }
        } catch {}
    }
    
    func getRequestStations(){
        let url = URL(string: "https://api.jcdecaux.com/vls/v1/stations?apiKey=6d5071ed0d0b3b68462ad73df43fd9e5479b03d6&contract=Bruxelles-Capitale")
        let urlRequest = URLRequest(url: url!)
        let session = URLSession(configuration: URLSessionConfiguration.default)
        let task = session.dataTask(with: urlRequest) {
            (data, response, error) in
            guard let responseData = data else {
                print("Error: did not receive data")
                return
            }
            DispatchQueue.main.async {
                do {
                    let json = try JSONSerialization.jsonObject(with: responseData, options: []) as? [AnyObject]
                    self.onJsonLoaded(stationsJson: json!)
                } catch let error as NSError {
                    print(error)
                }
            }
        }
        task.resume()
    }
    
    func onJsonLoaded(stationsJson: [AnyObject]) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate
            else {
                return
            }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        for index in 0...stationsJson.count-1 {
            let stationFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Station")
            let station = stationsJson[index] as! [String: AnyObject]
            stationFetch.predicate = NSPredicate(format: "number = %d", station["number"] as! Int16)
            var fetchResults: [Station] = [Station]()
            do {
                fetchResults = try managedContext.fetch(stationFetch) as! [Station]
            } catch {}
            let cdxStation = ((fetchResults.count == 0) ? (NSEntityDescription.insertNewObject(forEntityName: "Station", into: managedContext) as! Station) : (fetchResults[0]))
            var position = station["position"] as! [String: AnyObject]
            cdxStation.lat = position["lat"] as! Double
            cdxStation.lng = position["lng"] as! Double
            cdxStation.number = station["number"] as! Int16
            cdxStation.name = station["name"] as? String
            cdxStation.address = station["address"] as? String
            cdxStation.banking = station["banking"] as! Bool
            cdxStation.bonus = station["bonus"] as! Bool
            cdxStation.status = station["status"] as? String
            cdxStation.bike_stands = station["bike_stands"] as! Int16
            cdxStation.av_stands = station["available_bike_stands"] as! Int16
            cdxStation.av_bikes = station["available_bikes"] as! Int16
        }
        do {
            try managedContext.save()
        } catch {
            fatalError("Failure to save context: \(error)")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "goToAnnotation") {
            let vc = segue.destination as! AnnotationViewController
            vc.station = self.annotationStation
        }
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        let temp = view.annotation as? MapAnnotation
        self.annotationStation = (temp?.station)!
        performSegue(withIdentifier: "goToAnnotation", sender: nil)
    }
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        let center = CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        mapView.setRegion(region, animated: true)
    }

}

