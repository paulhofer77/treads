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
        mapView.delegate = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        locationManager?.delegate = self
        locationManager?.startUpdatingLocation()
        getLastRun()
    }

    override func viewDidDisappear(_ animated: Bool) {
        locationManager?.stopUpdatingLocation()
    }
    
    //    Mark: - Functions/Methods
    
    func getLastRun() {
        guard let lastRun = Run.getAllRuns()?.first else {
            lastRunStackView.isHidden = false
            lastRunBackgroundView.isHidden = false
            lastRunCloseButton.isHidden = false
            return
        }
        
        paceLabel.text = lastRun.pace.formatTimeDurationToString()
        distanceLabel.text = "\(lastRun.distance.metersToMiles(decimalPlaces: 2))km"
        durationLabel.text = lastRun.duration.formatTimeDurationToString()
        
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
    
}

