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
    func updateUserLocation(userLocation: CLLocationCoordinate2D)
    func showPizzeriaLocation(location: CLLocationCoordinate2D)
    func showDirectionsOverlay(overlay: MKPolyline)
}

class PizzeriaLocationViewModel: NSObject {
    private let pizzeria: Pizzeria
    
    private let locationManager = CLLocationManager()
    
    private(set) var userLocation: CLLocationCoordinate2D?
    
    weak var delegate: PizzeriaLocationViewModelDelegate?
    
    init(pizzeria: Pizzeria) {
        self.pizzeria = pizzeria
        super.init()
        initializerForLocationManager()
        showPizzeriaLocation()
        showsUserLocation()
        locationManager.delegate = self
    }
    
    func initializerForLocationManager() {
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()

    }

     func centerMap(_ loc1: CLLocationCoordinate2D, _ loc2: CLLocationCoordinate2D) {
        // Calcular el centro entre ambas ubicaciones
        let centerLatitude = (loc1.latitude + loc2.latitude) / 2
        let centerLongitude = (loc1.longitude + loc2.longitude) / 2
        let center = CLLocationCoordinate2D(latitude: centerLatitude, longitude: centerLongitude)

        // Calcular la diferencia para definir el span
        let latDelta = abs(loc1.latitude - loc2.latitude) * 1.5
        let lonDelta = abs(loc1.longitude - loc2.longitude) * 1.5
        let span = MKCoordinateSpan(latitudeDelta: latDelta, longitudeDelta: lonDelta)

        // Establecer la región en el mapa
        let region = MKCoordinateRegion(center: center, span: span)
        mapView.setRegion(region, animated: true)

        // Opcional: Añadir pines en ambas ubicaciones
        addPin(at: loc1, title: "San Francisco")
        addPin(at: loc2, title: "Los Ángeles")
    }


    func showsUserLocation() {
        guard let userLocation = userLocation else { return }
        
        delegate?.updateUserLocation(userLocation: userLocation)
    }
    
    func showPizzeriaLocation() {
        guard let location = pizzeria.location else { return }
        
        let pizzeriaLocation = CLLocationCoordinate2D(latitude: location.latitude,
                                                     longitude: location.longitude)
        
        delegate?.showPizzeriaLocation(location: pizzeriaLocation)
    }
    
    func didTapShowDirectionButton() {
        guard let userLocation, let pizzeriaLocation = pizzeria.location else { return }
        
        let pizzeriaCoordinte = CLLocationCoordinate2D(latitude: pizzeriaLocation.latitude,
                                                      longitude: pizzeriaLocation.longitude)
        
        let directionsRequest = MKDirections.Request()
        
        directionsRequest.source = MKMapItem(placemark: MKPlacemark(coordinate: userLocation))
        directionsRequest.destination = MKMapItem(placemark: MKPlacemark(coordinate: pizzeriaCoordinte))
        
        directionsRequest.transportType = .transit
        
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
    }
}
