//
//  BeginRunVC.swift
//  Treads
//
//  Created by Paul Hofer on 30.10.18.
//  Copyright © 2018 Hopeli. All rights reserved.
//

import UIKit
import MapKit

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
        
        return MKPolyline(coordinates: coordinate, count: lastRun.locations.count)
    }
    
    
    //    MARK: - Pressed Button Actions
    @IBAction func locationCenterButtonPressed(_ sender: Any) {
    }
    
    @IBAction func lastRunCloseButtonPressed(_ sender: Any) {
        
        lastRunStackView.isHidden = false
        lastRunBackgroundView.isHidden = false
        lastRunCloseButton.isHidden = false
        
    }
    
    
}

//MARK: - Extension for CLLocationManagerDelegate

extension BeginRunVC: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            checkLocationAuthStatus()
            mapView.showsUserLocation = true
            mapView.userTrackingMode = .follow
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

