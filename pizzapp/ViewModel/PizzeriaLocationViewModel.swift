//
//  PizzeriaLocationViewModel.swift
//  pizzapp
//
//  Created by Diplomado on 25/01/25.
//


import UIKit
import MapKit
import CoreLocation

protocol PizzeriaLocationViewModelDelegate: AnyObject {
    func setPizzeriaAnnotation(location: CLLocationCoordinate2D)
    func showDirectionsOverlay(overlay: MKPolyline)
    func updateMapRegion(region: MKCoordinateRegion)
}

class PizzeriaLocationViewModel: NSObject {
    private let pizzeria: Pizzeria

    let pizzeriaPinImage = UIImage(named: "pizza_pin") 
    
    private let locationManager = CLLocationManager()
    
    private(set) var userLocation: CLLocationCoordinate2D?

    private(set) var centerBetweenLocations: CLLocationCoordinate2D?

    private(set) var spanBetweenLocations: MKCoordinateSpan?
    
    weak var delegate: PizzeriaLocationViewModelDelegate?
    
    init(pizzeria: Pizzeria) {
        self.pizzeria = pizzeria
        super.init()
        initializerForLocationManager()
        locationManager.delegate = self
        updateMKMapViewParameters()
        showsLocations()
    }
    
    func initializerForLocationManager() {
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()

    }

    func updateMKMapViewParameters() {
    guard let userLocation = userLocation, 
          let pizzeriaLocation = pizzeria.location else { return }

    let centerLatitude = (userLocation.latitude + pizzeriaLocation.latitude) / 2
    let centerLongitude = (userLocation.longitude + pizzeriaLocation.longitude) / 2
    centerBetweenLocations = CLLocationCoordinate2D(latitude: centerLatitude, longitude: centerLongitude)

    let latDelta = max(abs(userLocation.latitude - pizzeriaLocation.latitude) * 1.5, 0.02)
    let lonDelta = max(abs(userLocation.longitude - pizzeriaLocation.longitude) * 1.5, 0.02)

    spanBetweenLocations = MKCoordinateSpan(latitudeDelta: latDelta, longitudeDelta: lonDelta)

    DispatchQueue.main.async {
        let mapRegion = MKCoordinateRegion(center: self.centerBetweenLocations!,
                                           span: self.spanBetweenLocations!)
        self.delegate?.updateMapRegion(region: mapRegion)
    }
}


    func showsLocations() {
        guard let pizzeriaLocation = pizzeria.location else { return }
        
        let pizzeriaLocation = CLLocationCoordinate2D(latitude: location.latitude,
                                                     longitude: location.longitude)
        
        delegate?.setPizzeriaAnnotation(location: pizzeriaLocation)

    }
    
    
    func didTapShowDirectionButton() {
        guard let userLocation, let pizzeriaLocation = pizzeria.location else { return }
        
        let pizzeriaCoordinte = CLLocationCoordinate2D(latitude: pizzeriaLocation.latitude,
                                                      longitude: pizzeriaLocation.longitude)
        
        let directionsRequest = MKDirections.Request()
        
        directionsRequest.source = MKMapItem(placemark: MKPlacemark(coordinate: userLocation))
        directionsRequest.destination = MKMapItem(placemark: MKPlacemark(coordinate: pizzeriaCoordinte))
        
        directionsRequest.transportType = .automobile
        
        let directions = MKDirections(request: directionsRequest)
        
        directions.calculate { response, error in
            guard error == nil,
                  let response,
                  let route = response.routes.first
            else { return }
            
            self.delegate?.showDirectionsOverlay(overlay: route.polyline)
        }
    }
}

extension PizzeriaLocationViewModel: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        
        let coordinate = CLLocationCoordinate2D(latitude: location.coordinate.latitude,
                                                longitude: location.coordinate.longitude)
        
        userLocation = coordinate
        updateMKMapViewParameters()
    }
}
