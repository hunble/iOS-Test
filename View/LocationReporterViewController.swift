//
//  ViewController.swift
//  locationreporter
//
//  Created by Humble on 5/25/18.
//  Copyright © 2018 arrivy. All rights reserved.
//

import UIKit
import CoreLocation
// import this
import AVFoundation

class LocationReporterViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var latitude: UILabel!
    @IBOutlet weak var longitude: UILabel!
    @IBOutlet weak var hAccuracy: UILabel!
    @IBOutlet weak var altitude: UILabel!
    @IBOutlet weak var vAccuracy: UILabel!
    @IBOutlet weak var distance: UILabel!

    var distance_samples : [Double] = []
    let thressHoldDistance: Double = 50
    var specialLogic: Bool = false
    
    var locationManager: CLLocationManager = CLLocationManager()
    var startLocation: CLLocation!
    var lasttLocation: CLLocation!
    
    // create a sound ID, in this case its the tweet sound.
    let systemSoundID: SystemSoundID = 1016
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
        startLocation = nil
        lasttLocation = nil
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Mark: Action
    @IBAction func startWhenInUse(_ sender: Any) {
        print("startWhenInUse")
        locationManager.requestWhenInUseAuthorization()
        
    }
    
    @IBAction func startAlways(_ sender: Any) {
        print("startAlways")
        locationManager.requestAlwaysAuthorization()
    }
    
    
    @IBAction func startActiveReporting(_ sender: Any) {
        print("startActiveReporting")
        locationManager.startUpdatingLocation()
    }
    
    @IBAction func stopActiveReporting(_ sender: Any) {
        print("stopActiveReporting")
        locationManager.stopUpdatingLocation()
    }
    
    @IBAction func resetDistance(_ sender: Any) {
        print("resetDistance")
        startLocation = nil
        distance.text = String(format: "%.2f", 0.0)
    }
    
    @IBAction func getBackgroundUsePermission(_ sender: Any) {
        print("getBackgroundUsePermission")
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.pausesLocationUpdatesAutomatically = true
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        print(status)
    }
    
    
    @IBAction func startSignificantLocation(_ sender: Any) {
        print("startSignificantLocation")
        startReceivingSignificantLocationChanges()
    }
    @IBAction func stopSignificantLocation(_ sender: Any) {
        print("stopSignificantLocation")
        locationManager.stopMonitoringSignificantLocationChanges()
    }
    
    
    @IBAction func specialLogicStart(_ sender: Any) {
        
        specialLogic = true
        
        locationManager.startUpdatingLocation()
    }
    
    @IBAction func specialLogicStop(_ sender: Any) {
        specialLogic = false
        locationManager.stopMonitoringSignificantLocationChanges()
        
        locationManager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager,
                         didUpdateLocations locations: [CLLocation]) {
        
        let latestLocation: CLLocation = locations[locations.count - 1]
        
        if startLocation == nil {
            startLocation = latestLocation
        }
        if(specialLogic)
        {
            if lasttLocation == nil{
                lasttLocation = latestLocation
            }
            
            // Add Location to the location samples
            if(distance_samples.count<10){
                distance_samples.append(latestLocation.distance(from: lasttLocation))
            }
            else{
                distance_samples.remove(at: 0)
                distance_samples.append(latestLocation.distance(from: lasttLocation))
            }
            
            // Take the highest distance
            var highestDistance : Double = 0
            for sample in distance_samples
            {
                highestDistance = sample > highestDistance ? sample : highestDistance;
            }
            
            print("highest Distance",highestDistance)
            if highestDistance < thressHoldDistance
            {
                locationManager.stopUpdatingLocation()
                locationManager.startMonitoringSignificantLocationChanges()
                return
            }
            else
            {
                locationManager.stopMonitoringSignificantLocationChanges()
                locationManager.startUpdatingLocation()
            }
        }
        
        
        latitude.text = String(format: "%.4f",
                               latestLocation.coordinate.latitude)
        longitude.text = String(format: "%.4f",
                                latestLocation.coordinate.longitude)
        hAccuracy.text = String(format: "%.4f",
                                latestLocation.horizontalAccuracy)
        altitude.text = String(format: "%.4f",
                               latestLocation.altitude)
        vAccuracy.text = String(format: "%.4f",
                                latestLocation.verticalAccuracy)
        
        
        
        let distanceBetween: CLLocationDistance =
            latestLocation.distance(from: startLocation)
        
        distance.text = String(format: "%.2f", distanceBetween)
        
        print("Latitude = \(latestLocation.coordinate.latitude)")
        print("Longitude = \(latestLocation.coordinate.longitude)")
        lasttLocation = latestLocation
        
    }
    
    func locationManager(_ manager: CLLocationManager,
                         didFailWithError error: Error) {        print(error.localizedDescription)
    }
    
    func startReceivingSignificantLocationChanges() {
        let authorizationStatus = CLLocationManager.authorizationStatus()
        locationManager.requestAlwaysAuthorization()
        if authorizationStatus != .authorizedAlways {
            // User has not authorized access to location information.
            return
        }
        
        
        if !CLLocationManager.significantLocationChangeMonitoringAvailable() {
            print("significant location chnage not authorized")
            return
        }
        locationManager.delegate = self
        locationManager.startMonitoringSignificantLocationChanges()
    }
}
