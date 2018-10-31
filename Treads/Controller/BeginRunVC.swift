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

    //    MARK: - Outlets
    @IBOutlet weak var mapView: MKMapView!
    
    //    MARK: Lifecycle Methx
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkLocationAuthStatus()
        mapView.delegate = self
        
        print(Run.getAllRuns())
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        locationManager?.delegate = self
        locationManager?.startUpdatingLocation()
    }

    override func viewDidDisappear(_ animated: Bool) {
        locationManager?.stopUpdatingLocation()
    }
    
    
    
    //    MARK: - Pressed Button Actions
    @IBAction func locationCenterButtonPressed(_ sender: Any) {
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
    
}

