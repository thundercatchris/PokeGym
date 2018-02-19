//
//  MapViewController.swift
//  PokeGym
//
//  Created by Cerebro on 04/02/2018.
//  Copyright © 2018 thundercatchris. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class CustomPointAnnotation: MKPointAnnotation {
    var imageName: String!
    var team: Int!
    var level: Int?
    
    
}

class MapViewController: UIViewController,  MKMapViewDelegate,  CLLocationManagerDelegate {
    
    @IBOutlet weak var locationButtonImage: UIButton!
    @IBOutlet weak var raidSelectedImage: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    var gyms = [gymObject]()
    var currentLocation = false
    var raidView = false
    
    var locationManager:CLLocationManager!
    
    @IBAction func test(_ sender: Any) {
        //    self.performSegue(withIdentifier: "showMapDetail", sender: "indexPath")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.mapView.delegate = self
        let initialLocation = CLLocation(latitude: 53.802449, longitude: -1.549215)
        let regionRadius: CLLocationDistance = 40000
        func centerMapOnLocation(location: CLLocation) {
            let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius, regionRadius)
            mapView.setRegion(coordinateRegion, animated: true)
        }
        centerMapOnLocation(location: initialLocation)
        getLocation()
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if !(annotation is CustomPointAnnotation) {
            return nil
        }
        return MapAnnotationCell().getMapAnnotation(annotation: annotation as! CustomPointAnnotation, mapView: mapView)
    }
    
    func getAnnotations() {
        let annotations = MapAnnotations().getAnnotations(raidView: raidView, gyms: gyms, mapView: mapView)
        let allAnnotations = self.mapView.annotations
        self.mapView.removeAnnotations(allAnnotations)
        self.mapView.showAnnotations(annotations, animated: true)
    }
    
    
    @IBAction func locationButtonAction(_ sender: Any) {
        currentLocation = !currentLocation
        getLocation()
    }
    
    func getLocation() {
        if (mapView != nil) && gyms.count != 0 {
            mapView.showsUserLocation = currentLocation
            DispatchQueue.main.async() {
                if self.currentLocation {
                    self.mapView.setUserTrackingMode(.follow, animated: true)
                    self.locationButtonImage.imageView?.image = UIImage(named: "locationSelected")
                } else {
                    self.mapView.setUserTrackingMode(.none, animated: true)
                    self.locationButtonImage.imageView?.image = UIImage(named: "location")
                }
                self.getAnnotations()
            }
            
        }
    }
    
    @IBAction func raidSelectedAction(_ sender: Any) {
        raidView = !raidView;
        if (raidView) {
            DispatchQueue.main.async() {
                self.raidSelectedImage.imageView?.image = UIImage(named: "battleSelected")
            }
            raidView = true
        } else {
            DispatchQueue.main.async() {
                self.raidSelectedImage.imageView?.image = UIImage(named: "battle")
            }
            raidView = false
        }
        self.getAnnotations()
    }
    
}

