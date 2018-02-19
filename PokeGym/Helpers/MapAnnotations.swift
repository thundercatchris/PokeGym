//
//  MapAnnotations.swift
//  PokeGym
//
//  Created by Cerebro on 08/02/2018.
//  Copyright © 2018 thundercatchris. All rights reserved.
//

import Foundation
import MapKit

class MapAnnotations {
    
    func getAnnotations(raidView: Bool, gyms: [gymObject], mapView: MKMapView) -> [MKAnnotation] {
        var annotations = [MKAnnotation]()
        for gym in gyms {
            if let end = gym.raid?.endTime {
                let endDate = Date(timeIntervalSince1970: TimeInterval(end))
                let now = Date()
                
                let team = gym.team
                let annotation = CustomPointAnnotation()
                annotation.coordinate = CLLocationCoordinate2D(latitude: gym.lat, longitude: gym.lon)
                annotation.title = gym.name
                annotation.subtitle = ""
                annotation.team = team
                annotation.imageName = "pokePin\(String(describing: team)).png"
                if endDate > now  { // show only future raids if raid selected
                    annotation.level = gym.raid?.level
                }
                if raidView == false { // show all if raid is not selected
                    annotations.append(annotation)
//                    mapView.addAnnotation(annotation)
                } else {
                    if endDate > now  { // show only future raids if raid selected
                        annotation.level = gym.raid?.level
//                            mapView.addAnnotation(annotation)
                         annotations.append(annotation)
                    }
                }
            }
        }
        return annotations
    }
  
    
}
