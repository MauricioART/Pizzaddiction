//
//  PizzeriaLocationViewController.swift
//  pizzapp
//
//  Created by Diplomado on 25/01/25.
//

import UIKit
import MapKit
import CoreLocation

class PizzeriaLocationViewController: UIViewController {
    private let viewModel: PizzeriaLocationViewModel
    
    private lazy var mapView: MKMapView = {
        let mapView = MKMapView()
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.preferredConfiguration = MKHybridMapConfiguration()
        mapView.showsUserLocation = true
        return mapView
    }()
    
    
    private lazy var showDirectionsButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        
        var config = UIButton.Configuration.filled()
        config.title = "Show route"
        config.image = UIImage(systemName: "close.fill") 
        config.imagePlacement = .leading 
        config.imagePadding = 8 
        config.baseBackgroundColor = .systemBlue
        config.baseForegroundColor = .white

        button.configuration = config
        
        button.addTarget(self,
                         action: #selector(didTapShowDirectionsButton),
                         for: .touchUpInside)
        return button
    }()

    private lazy var closeButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        
        var config = UIButton.Configuration.filled()
        config.title = "Close"
        config.image = UIImage(systemName: "close.fill") 
        config.imagePlacement = .leading 
        config.imagePadding = 8 
        config.baseBackgroundColor = .systemBlue
        config.baseForegroundColor = .white

        button.configuration = config
        
        button.addTarget(self,
                         action: #selector(didTapCloseButton),
                         for: .touchUpInside)
        return button
    }()
    
    init(pizzeria: Pizzeria) {
        self.viewModel = PizzeriaLocationViewModel(pizzeria: pizzeria)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        setupView()
        
        viewModel.delegate = self
        mapView.delegate = self
    }
    
    func setupView() {
        view.addSubview(mapView)
        
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            mapView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
        view.addSubview(closeButton)
        view.addSubview(showDirectionsButton)
        NSLayoutConstraint.activate([
            closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            closeButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -8),
            
            showDirectionsButton.bottomAnchor.constraint(equalTo: showPizzeriaLocation.topAnchor, constant: 8),
            showDirectionsButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    @objc
    func didTapCloseButton() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc
    func didTapShowDirectionsButton() {
        viewModel.didTapShowDirectionButton()
    }
}

// MARK: - PizzeriaLocationViewModelDelegate
extension PizzeriaLocationViewController: PizzeriaLocationViewModelDelegate {
    func showDirectionsOverlay(overlay: MKPolyline) {
        mapView.addOverlay(overlay)
    }
    
    func updateUserLocation(userLocation: CLLocationCoordinate2D) {
        let userAnnotation = MKPointAnnotation()
        userAnnotation.coordinate = userLocation
        
        mapView.addAnnotation(userAnnotation)
        
        let mapRegion = MKCoordinateRegion(center: userLocation,
                                           span: MKCoordinateSpan(latitudeDelta: 0.01,
                                                                  longitudeDelta: 0.01))
        
        mapView.region = mapRegion
    }
    
    func showPizzeriaLocation(location: CLLocationCoordinate2D) {
        let userAnnotation = MKPointAnnotation()
        userAnnotation.coordinate = location
        
        mapView.addAnnotation(userAnnotation)
        
        let mapRegion = MKCoordinateRegion(center: location,
                                           span: MKCoordinateSpan(latitudeDelta: 0.01,
                                                                  longitudeDelta: 0.01))
        
        mapView.region = mapRegion
    }
}

// MARK: - MKMapViewDelegate
extension PizzeriaLocationViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: any MKAnnotation) -> MKAnnotationView? {
        
        guard !(annotation is MKUserLocation) else { return nil }
        
        let annotationView = MKAnnotationView(annotation: annotation,
                                              reuseIdentifier: nil)
        
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: any MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = .cyan
        renderer.lineWidth = 8.0
        return renderer
    }
}
