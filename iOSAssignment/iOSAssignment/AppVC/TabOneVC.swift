//
//  TabOneVC.swift
//  iOSAssignment
//
//  Created by Milan Mia on 9/4/16.
//  Copyright © 2016 Milan Mia. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class TabOneVC: UIViewController,MKMapViewDelegate,CLLocationManagerDelegate {
    //MARK: Var
    var isInitialized = false
    var locationManager = CLLocationManager()
    @IBOutlet weak var mapView: MKMapView!
    
    var lat:String?
    var lng:String?
    
    //MARK: Default methods
    override func viewDidLoad() {
        super.viewDidLoad()
        if (CLLocationManager.locationServicesEnabled()){
            locationManager.requestAlwaysAuthorization()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
            mapView.showsUserLocation = true
            mapView.delegate = self
        }else{
            print("Location service disabled");
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //-----------------------------------------------------------------
    // MARK: - MapKit Location Manager
    //-----------------------------------------------------------------
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if !isInitialized{
            isInitialized = true
            
            let location = locations.last
            manager.stopUpdatingLocation()
            let region = MKCoordinateRegionMake((location?.coordinate)!, MKCoordinateSpanMake(0.01, 0.01))
            mapView.setRegion(region, animated: true)
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = (location?.coordinate)!
            lat = "\((location?.coordinate.latitude)!)"
            lng = "\((location?.coordinate.longitude)!)"
            print("lat Lng: \(lat), \(lng)")
        }
    }
    func mapView(mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
    }
    
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, didChangeDragState newState: MKAnnotationViewDragState, fromOldState oldState: MKAnnotationViewDragState) {
        
        if newState == MKAnnotationViewDragState.Ending {
            let droppedAt = view.annotation?.coordinate
            lat = "\((droppedAt!.latitude))"
            lng = "\((droppedAt!.longitude))"
            print("lat Lng: \(lat), \(lng)")
            //print(droppedAt)
            getReverseGeocodingToGetAddress(droppedAt!)
        }
    }
    
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            
            
        }
    }
    
    //-----------------------------------------------------
    //MARK: ReverseGeoCodingToGetAddress
    //-----------------------------------------------------
    func getReverseGeocodingToGetAddress(senderCoordinate :CLLocationCoordinate2D){
        let location = CLLocation(latitude: senderCoordinate.latitude, longitude: senderCoordinate.longitude)
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { (placemarks, error) -> Void in
            
            if (error == nil){
                //print(placemarks)
                let place = placemarks![0]
                print("locality \(place.locality) Place Name \(place.name) PlaceSubLocality \(place.subLocality) addministratitiveArea \(place.administrativeArea) PostalCOde \(place.postalCode) Country \(place.country)")
                
                
                let placeName = self.isStringNil(place.name) ? "" : place.name!
                let addministrativeArea = self.isStringNil(place.administrativeArea) ? "" : ", \(place.administrativeArea!)"
                let postalCode = self.isStringNil(place.postalCode) ? "" : ", \(place.postalCode!)"
                let country = self.isStringNil(place.country) ? "" :", \(place.country!)"
                
                //self.searchTextField.text = "\(placeName)\(addministrativeArea)\(postalCode)\(country)"
            }else{
                print(error)
            }
        }
    }
    
    func isStringNil(sender : String?) -> Bool{
        return sender == nil ? true : false
    }
}
