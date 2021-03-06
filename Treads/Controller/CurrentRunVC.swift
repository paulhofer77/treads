//
//  OnRunVC.swift
//  Treads
//
//  Created by Paul Hofer on 30.10.18.
//  Copyright © 2018 Hopeli. All rights reserved.
//

import UIKit
import MapKit
import RealmSwift

class CurrentRunVC: LocationVC {

    //    MARK: - Outlets
    
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var paceLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var swipeBackgroundImageView: UIImageView!
    @IBOutlet weak var sliderImageView: UIImageView!
    @IBOutlet weak var pauseButton: UIButton!
    
    
    //    MARK: - Variables
    fileprivate var startLocation: CLLocation!
    fileprivate var lastLocation: CLLocation!
    fileprivate var runDistance: Double = 0.0
    fileprivate var counter: Int = 0
    fileprivate var timer = Timer()
    fileprivate var pace: Int = 0
    fileprivate var coordinateLocations = List<Location>()
    
    //    MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        let swipeGesture = UIPanGestureRecognizer(target: self, action: #selector(endRunSwiped(sender:)))
        sliderImageView.addGestureRecognizer(swipeGesture)
        sliderImageView.isUserInteractionEnabled = true
        swipeGesture.delegate = self as? UIGestureRecognizerDelegate
    }
    
    override func viewWillAppear(_ animated: Bool) {
        locationManager?.delegate = self
        locationManager?.distanceFilter = 10
        startRun()
        
    }
    
    
    //    MARK: - Start & End Run Methods
    func startRun(){
        locationManager?.startUpdatingLocation()
        startTimer()
        pauseButton.setImage(UIImage(named: "pauseButton"), for: .normal)
    }
    
    func pauseRun(){
        startLocation = nil
        lastLocation = nil
        timer.invalidate()
        locationManager?.stopUpdatingLocation()
        pauseButton.setImage(UIImage(named: "resumeButton"), for: .normal)
    }
    
    func endRun(){
        locationManager?.stopUpdatingLocation()
        Run.addRunToRealm(pace: pace, distance: runDistance, duration: counter, locations: coordinateLocations)
    }
    
    func startTimer() {
        durationLabel.text = counter.formatTimeDurationToString()
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }
    
    @objc func updateTimer() {
        counter += 1
        durationLabel.text = counter.formatTimeDurationToString()
    }
    
    func calculatePace(time: Int, km: Double) -> String {
        pace = Int(Double(time) / km)
        return pace.formatTimeDurationToString()
    }
    
    
    @IBAction func pauseButtonPressed(_ sender: UIButton) {
        if timer.isValid {
            pauseRun()
        } else {
            startRun()
        }
        
    }
    
    
    
    //    MARK: - Swipe Function to End Run
    @objc func endRunSwiped (sender: UIPanGestureRecognizer) {
        
        let minAdjust: CGFloat = 80
        let maxAdjust: CGFloat = 130
        
        if let sliderView = sender.view {
            if sender.state == UIGestureRecognizer.State.began || sender.state == UIGestureRecognizer.State.changed {
                let translation = sender.translation(in: self.view)
                if sliderView.center.x >= (swipeBackgroundImageView.center.x - minAdjust) && sliderView.center.x <= (swipeBackgroundImageView.center.x + maxAdjust) {
                    sliderView.center.x = sliderView.center.x + translation.x
                } else if sliderView.center.x >= swipeBackgroundImageView.center.x + maxAdjust {
                    sliderView.center.x = swipeBackgroundImageView.center.x + maxAdjust
                    endRun()
                    dismiss(animated: true, completion: nil)
                } else {
                    sliderView.center.x = swipeBackgroundImageView.center.x - minAdjust
                }
                
                sender.setTranslation(CGPoint.zero, in: self.view)
            } else if sender.state == UIGestureRecognizer.State.ended {
                UIView.animate(withDuration: 0.2) {
                    sliderView.center.x = self.swipeBackgroundImageView.center.x - minAdjust
                }
            }
        }
        
    }
    
}

extension CurrentRunVC: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            checkLocationAuthStatus()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if startLocation == nil {
            startLocation = locations.first
        } else if let location = locations.last {
            runDistance += lastLocation.distance(from: location)
            let newLocation = Location(latitude: Double(lastLocation.coordinate.latitude), longitude: Double(lastLocation.coordinate.longitude))
            coordinateLocations.insert(newLocation, at: 0)
            distanceLabel.text = "\(runDistance.meterToKm(decimalPlaces: 3))"
            if counter > 0 && runDistance > 0 {
                paceLabel.text = calculatePace(time: counter, km: runDistance.meterToKm(decimalPlaces: 3))
            }
        }
        lastLocation = locations.last
    }
    
}
