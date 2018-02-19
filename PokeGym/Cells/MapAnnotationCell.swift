//
//  MapAnnotation.swift
//  PokeGym
//
//  Created by Cerebro on 08/02/2018.
//  Copyright © 2018 thundercatchris. All rights reserved.
//

import Foundation
import MapKit


class MapAnnotationCell {
    
    
    func getMapAnnotation(annotation: CustomPointAnnotation, mapView: MKMapView) -> MKAnnotationView {
        let cpa = annotation
        let reuseId = String(cpa.team)
        var anView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId)
        if anView == nil {
            anView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            anView?.canShowCallout = true
        } else {
            anView?.annotation = annotation
        }
        anView?.image = UIImage(named:cpa.imageName)
        anView?.frame.size = CGSize(width: 30.0, height: 30)
        
        
        /// Add an info button to the callout "bubble" of the annotation view
//        let rightCalloutButton = UIButton(type: .detailDisclosure)
//        anView?.rightCalloutAccessoryView = rightCalloutButton
        
        /// Add image to the callout "bubble" of the annotation view
        //        let image = UIImage(named: "pokePin1.png")
        //        let leftCalloutImageView = UIImageView(image: image)
        //        anView?.leftCalloutAccessoryView = leftCalloutImageView
        if let level = cpa.level, level != 0 {
            let colour = GetColour().colour(colorInt: (cpa.team)!)
            let label = UILabel(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
            label.layer.borderWidth = 3
            label.layer.cornerRadius = label.frame.size.width / 2
            label.layer.borderColor = colour.cgColor
            //        label.center = CGPoint(x: 160, y: 285)
            label.textAlignment = .center
            label.text = String(describing: level)
            let leftCalloutStringView = label
            anView?.leftCalloutAccessoryView = leftCalloutStringView
            
        } else {
            anView?.leftCalloutAccessoryView = nil
        }
        return anView!
    }
    
}
