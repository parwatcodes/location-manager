//
//  MapViewController.swift
//  Locations-Final Project
//
//  Created by Parwat Kunwar on 2022-09-19.
//

import Foundation
import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    var locationCollectionViewCtrl: LocationCollectionViewController!
    var locationIndex: Int?
    var location = Location();
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadLocationData();
        mapView.delegate = self
        mapView.mapType = .hybrid

        addLocationPin()
    }
    
    func loadLocationData(){
        location = DatabaseHelper.shared.getLocationFromCoreData(index: locationIndex!)
    }
    
    func addLocationPin() {
        let annotation = MKPointAnnotation()
        let lat = CLLocationDegrees(Double(location.latitude!)!)
        let long = CLLocationDegrees(Double(location.longitude!)!)
        let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
        
        let name = location.name
        let info = location.info
        let date = location.date
        
        annotation.coordinate = coordinate
        annotation.title = "\(name ?? "")"
        annotation.subtitle = info
        
        self.mapView.addAnnotation(annotation);

        let coordinateRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: lat, longitude: long),
                                                  latitudinalMeters: 40000, longitudinalMeters: 40000)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        var p = mapView.dequeueReusableAnnotationView(withIdentifier: "pin") as? MKMarkerAnnotationView

        if p == nil {
            p = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: "pin")
            p!.canShowCallout = true
            p!.calloutOffset = CGPoint(x: -5, y: 5)
            p!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            p!.annotation = annotation
        }
        
        return p
    }
    
    @IBAction func Cancel(_ sender: UIButton) {
        locationCollectionViewCtrl = storyboard?.instantiateViewController(withIdentifier: "LocationCollectionViewController") as? LocationCollectionViewController
        
        locationCollectionViewCtrl.modalPresentationStyle = .fullScreen
        self.present(locationCollectionViewCtrl, animated: true, completion: nil)
    }
}
