//
//  ViewController.swift
//  Capital Cities
//
//  Created by Michele Galvagno on 11/04/2019.
//  Copyright © 2019 Michele Galvagno. All rights reserved.
//

import MapKit
import UIKit

class ViewController: UIViewController, MKMapViewDelegate {
    @IBOutlet var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Map Type", style: .plain, target: self, action: #selector(chooseMapType))
        
        let london = Capital(title: "London", coordinate: CLLocationCoordinate2D(latitude: 51.507222, longitude: -0.1275), info: "Home to the 2012 Summer Olympics")
        let oslo = Capital(title: "Oslo", coordinate: CLLocationCoordinate2D(latitude: 59.95, longitude: 10.75), info: "Founded over a thousand years ago.")
        let paris = Capital(title: "Paris", coordinate: CLLocationCoordinate2D(latitude: 48.8567, longitude: 2.3508), info: "Often called the City of Light")
        let rome = Capital(title: "Rome", coordinate: CLLocationCoordinate2D(latitude: 41.9, longitude: 12.5), info: "Has a whole country inside it.")
        let washington = Capital(title: "Washington DC", coordinate: CLLocationCoordinate2D(latitude: 38.895111, longitude: -77.036667), info: "Named after George himself.")
        
        mapView.addAnnotations([london, oslo, paris, rome, washington])
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is Capital else { return nil }
        
        let identifier = "Capital"
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView
        
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
            annotationView?.pinTintColor = .orange
            
            let btn = UIButton(type: .detailDisclosure)
            annotationView?.rightCalloutAccessoryView = btn
        } else {
            annotationView?.annotation = annotation
            annotationView?.pinTintColor = .orange
        }
        
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        guard let capital = view.annotation as? Capital else { return }
        
        let capitalTitle = capital.title
        print(capitalTitle ?? "This value is empty")
        
        if let webViewController = storyboard?.instantiateViewController(withIdentifier: "WebView") as? DetailViewController {
            if let title = capitalTitle {
                webViewController.title = title
                webViewController.websiteToLoad = "https://en.wikipedia.org/wiki/" + title
                print(webViewController.websiteToLoad ?? "Error parsing URL")
                
                navigationController?.pushViewController(webViewController, animated: true)
            }
        } else {
            print("Something went wrong")
        }
    }
    
    @objc func chooseMapType() {
        let mapTypeAC = UIAlertController(title: "Map Type", message: "Choose your preferred map type", preferredStyle: .alert)
        mapTypeAC.addAction(UIAlertAction(title: "Standard", style: .default, handler: { [weak self] _ in
            self?.mapView.mapType = .standard
        }))
        mapTypeAC.addAction(UIAlertAction(title: "Hybrid", style: .default, handler: { [weak self] _ in
            self?.mapView.mapType = .hybrid
        }))
        mapTypeAC.addAction(UIAlertAction(title: "Satellite", style: .default, handler: { [weak self] _ in
            self?.mapView.mapType = .satellite
        }))
        
        present(mapTypeAC, animated: true)
    }
}

