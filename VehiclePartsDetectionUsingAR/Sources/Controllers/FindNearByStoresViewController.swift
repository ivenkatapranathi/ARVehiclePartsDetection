//
//  FindNearByStoresViewController.swift
//  VehiclePartsDetectionUsingAR
//
//  Created by Venkata Pranathi Immaneni on 3/12/21.
//

import UIKit
import MapKit
 
class FindNearByStoresViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    let locationManager = CLLocationManager()
    var storePlaceMark: MKPlacemark?
   
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mapView.delegate = self
        self.mapView.userTrackingMode = MKUserTrackingMode.follow
        self.mapView.showsUserLocation = true
        
        if(storePlaceMark != nil) {
            self.dropThePinInThePlaceMark(storePlaceMark: self.storePlaceMark!)
        }
        
    }
    
    func dropThePinInThePlaceMark(storePlaceMark: MKPlacemark) {
        mapView.removeAnnotations(self.mapView.annotations)
        let createAnnotation = MKPointAnnotation()
        createAnnotation.coordinate = storePlaceMark.coordinate
        createAnnotation.title = storePlaceMark.title
        if let currentCity = storePlaceMark.locality, let currentState = storePlaceMark.administrativeArea {
            createAnnotation.subtitle = "\(currentCity) \(currentState)"
        }
        self.mapView.addAnnotation(createAnnotation)
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: storePlaceMark.coordinate, span: span)
        self.mapView.setRegion(region, animated: true)
        
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView?{
        if annotation is MKUserLocation {
            return nil
        }
        let reuseId = "pin"
        var calloutpinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        calloutpinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
        calloutpinView?.pinTintColor = UIColor.orange
        calloutpinView?.canShowCallout = true
        let smallSquare = CGSize(width: 30, height: 30)
        let calloutbutton = UIButton(frame: CGRect(origin: .zero, size: smallSquare))
        calloutbutton.setBackgroundImage(UIImage(named: "Star"), for: [])
        calloutbutton.addTarget(self, action: #selector(FindNearByStoresViewController.getDirections), for: .touchUpInside)
        calloutpinView?.leftCalloutAccessoryView = calloutbutton
        return calloutpinView
    }
    
    @objc func getDirections(){
        if let storePlacemark = self.storePlaceMark {
            let createMapItem = MKMapItem(placemark: storePlacemark)
            let getLaunchOptions = [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving]
            createMapItem.openInMaps(launchOptions: getLaunchOptions)
        }
    }

}

extension FindNearByStoresViewController: MKMapViewDelegate {
    
}
