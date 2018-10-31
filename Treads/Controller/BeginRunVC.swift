//
//  BeginRunVC.swift
//  Treads
//
//  Created by Paul Hofer on 30.10.18.
//  Copyright © 2018 Hopeli. All rights reserved.
//

import UIKit
import MapKit
import RealmSwift

class BeginRunVC: LocationVC {

    //    Mark: - Variables
    
    //    MARK: - Outlets
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var lastRunCloseButton: UIButton!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var paceLabel: UILabel!
    @IBOutlet weak var lastRunBackgroundView: UIView!
    @IBOutlet weak var lastRunStackView: UIStackView!
    
    
    //    MARK: Lifecycle Methx
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkLocationAuthStatus()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        mapView.delegate = self
        locationManager?.delegate = self
        locationManager?.startUpdatingLocation()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setupMapView()
    }

    override func viewDidDisappear(_ animated: Bool) {
        locationManager?.stopUpdatingLocation()
    }
    
    //    Mark: - Functions/Methods
    
    func setupMapView() {
        if let overlay = addLastRunToMap() {
            if mapView.overlays.count > 0 {
                mapView.removeOverlays(mapView.overlays)
            }
            mapView.addOverlay(overlay)
            lastRunStackView.isHidden = false
            lastRunBackgroundView.isHidden = false
            lastRunCloseButton.isHidden = false
        } else {
            lastRunStackView.isHidden = true
            lastRunBackgroundView.isHidden = true
            lastRunCloseButton.isHidden = true
            centerMapOnUserLocation()
        }
    }
    
    func addLastRunToMap() -> MKPolyline? {
        guard let lastRun = Run.getAllRuns()?.first else { return nil }
        
        paceLabel.text = lastRun.pace.formatTimeDurationToString()
        distanceLabel.text = "\(lastRun.distance.metersToMiles(decimalPlaces: 2))km"
        durationLabel.text = lastRun.duration.formatTimeDurationToString()
        
        var coordinate = [CLLocationCoordinate2D]()
        for location in lastRun.locations {
            coordinate.append(CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude))
        }
        mapView.userTrackingMode = .none
//       it is just to show how to sort by Primary Key
//       it is redundenat because we already got the info from lastrun above
        guard let locations = Run.getRun(by: lastRun.id)?.locations else  {return MKPolyline() }
        mapView.setRegion(centerMapOnPreviousRoute(locations: locations), animated: true)
        
        return MKPolyline(coordinates: coordinate, count: locations.count)
    }
    
    
    func centerMapOnUserLocation() {
        mapView.userTrackingMode = .follow
        let coordinateRegion = MKCoordinateRegion.init(center: mapView.userLocation.coordinate, latitudinalMeters: 100, longitudinalMeters: 100)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    func centerMapOnPreviousRoute(locations: List<Location>) -> MKCoordinateRegion {
        
        guard let initialLocation = locations.first else { return MKCoordinateRegion() }
        var minLat = initialLocation.latitude
        var minLng = initialLocation.longitude
        var maxLat = minLat
        var maxLng = minLng
        
        for location in locations {
            minLat = min(minLat, location.latitude)
            minLng = min(minLng, location.longitude)
            maxLat = max(maxLat, location.latitude)
            maxLng = max(maxLng, location.longitude)
            
        }
        
        return MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: (minLat + maxLat) / 2, longitude: (minLng + maxLng) / 2), span: MKCoordinateSpan(latitudeDelta: (maxLat - minLat) * 1.4, longitudeDelta: (maxLng - minLng) * 1.4))
        
        
    }
    
    //    MARK: - Pressed Button Actions
    @IBAction func locationCenterButtonPressed(_ sender: Any) {
        centerMapOnUserLocation()
    
    }
    
    @IBAction func lastRunCloseButtonPressed(_ sender: Any) {
        
        lastRunStackView.isHidden = true
        lastRunBackgroundView.isHidden = true
        lastRunCloseButton.isHidden = true
        centerMapOnUserLocation()
        
    }
    
    
}

//MARK: - Extension for CLLocationManagerDelegate

extension BeginRunVC: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            checkLocationAuthStatus()
            mapView.showsUserLocation = true
//            mapView.userTrackingMode = .follow
        }
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let polyLine = overlay as! MKPolyline
        let renderer = MKPolylineRenderer(polyline: polyLine)
        
        renderer.strokeColor = #colorLiteral(red: 0.1019607857, green: 0.2784313858, blue: 0.400000006, alpha: 1)
        renderer.lineWidth = 4
        
        return renderer
        
    }
    
}

