//
//  ViewController.swift
//  JIT
//
//  Created by amota511 on 5/26/17.
//  Copyright © 2017 Aaron Motayne. All rights reserved.
//

import UIKit
import GoogleMaps
import CoreLocation
import GooglePlaces

class ViewController: UIViewController, CLLocationManagerDelegate {

    var locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    var mapView: GMSMapView!
    //var placesClient: GMSPlacesClient!
    var zoomLevel: Float = 14.0
    var likelyPlaces: [GMSPlace] = []
    var selectedPlace: GMSPlace?
    var destinationMarker: GMSMarker!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //37.621177, -122.378827

        
        let camera = GMSCameraPosition.camera(withLatitude: 37.621177, longitude: -122.378827, zoom: zoomLevel)
        mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        
        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.distanceFilter = 50
        locationManager.startUpdatingLocation()
        locationManager.delegate = self
        
        //placesClient = GMSPlacesClient.shared()
        
        
        view = mapView
        
//        let currentLocation = CLLocationCoordinate2D(latitude: 37.621177, longitude: -122.378827)
//        let marker = GMSMarker(position: currentLocation)
//        
//        marker.title = "SFO Airport"
//        marker.iconView = UIImageView(image: #imageLiteral(resourceName: "jupiter"))
//        marker.iconView!.contentMode = .scaleAspectFit
//        marker.iconView?.frame = CGRect(x: 0, y: 0, width: 60, height: 60)
//        marker.map = mapView
//        
//        //37.275376, -121.854784
        let destinationLocation = CLLocationCoordinate2D(latitude: 37.275376, longitude: -121.854784)
        destinationMarker = GMSMarker(position: destinationLocation)
        
        destinationMarker?.title = "Home"
        destinationMarker?.iconView = UIImageView(image: #imageLiteral(resourceName: "jupiter"))
        destinationMarker?.iconView!.contentMode = .scaleAspectFit
        destinationMarker?.iconView?.frame = CGRect(x: 0, y: 0, width: 60, height: 60)
        destinationMarker.map = mapView
        
        //mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = true

    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location: CLLocation = locations.first!
        print("Location: \(location)")
        
        let camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude,
                                              longitude: location.coordinate.longitude,
                                              zoom: mapView.camera.zoom)
        
        let destinationLocation = CLLocationCoordinate2D(latitude: location.coordinate.latitude,
                                                         longitude: location.coordinate.longitude)
        
        destinationMarker.position = destinationLocation
        
        
        if mapView.isHidden {
            mapView.isHidden = false
            mapView.camera = camera
        } else {
            mapView.animate(to: camera)
        }
        //mapView.selectedMarker?.appearAnimation = .pop
        //listLikelyPlaces()
    }
    
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .restricted:
            print("Location access was restricted.")
        case .denied:
            print("User denied access to location.")
            // Display the map using the default location.
            mapView.isHidden = false
        case .notDetermined:
            print("Location status not determined.")
        case .authorizedAlways: fallthrough
        case .authorizedWhenInUse:
            print("Location status is OK.")
        }
    }
    
    // Handle location manager errors.
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationManager.stopUpdatingLocation()
        print("Error: \(error)")
    }
}

