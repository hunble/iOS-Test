//
//  LocationManager.swift
//  LocationManagerTest
//
//  Created by Ahmar Ijaz on 7/26/18.
//  Copyright © 2018 Arrivy. All rights reserved.
//

import UIKit
import CoreLocation

@objc protocol LocationManagerDelegate {

    func didFoundLocation()
    @objc optional
    func didFailWithError(error: Error)
    @objc optional
    func didUpdateForBattery()
}

final class LocationManager: NSObject, CLLocationManagerDelegate {
    
    // MARK:- Singlton
    static let sharedInstance: LocationManager = {
        let instance = LocationManager()
        instance.configureLocationManager()
        instance.configureBatteryLevelMonitoring()
        return instance
    }()
    private override init() {}
    
    
    // MARK:- Variables
    var locationManager: CLLocationManager = CLLocationManager()
    var locations: [CLLocation] = []
    var delegates: [LocationManagerDelegate] = []
    
    var timerBattery: Timer?
    
    //MARK:- Helpers
    func configureLocationManager() {
        locationManager.delegate = self
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        //locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.requestAlwaysAuthorization()
        //locationManager.startUpdatingLocation()
        
        
        let authorizationStatus = CLLocationManager.authorizationStatus()
        locationManager.requestAlwaysAuthorization()
        //locationManager.requestWhenInUseAuthorization()
        if authorizationStatus != .authorizedAlways {
            // User has not authorized access to location information.
            print("authorizationStatus: \(authorizationStatus)")
        }
        
        
        if !CLLocationManager.significantLocationChangeMonitoringAvailable() {
            // The service is not available.
            print("significantLocationChangeMonitoring NOT Available")
        }
        //locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.distanceFilter = 15
        
        locationManager.allowsBackgroundLocationUpdates = true
        if #available(iOS 11.0, *) {
            locationManager.showsBackgroundLocationIndicator = true
        } else {
            // Fallback on earlier versions
        }
        
        //locationManager.startMonitoringSignificantLocationChanges()
        locationManager.startUpdatingLocation()
        
    }
    
    func configureBatteryLevelMonitoring() {
        UIDevice.current.isBatteryMonitoringEnabled = true
        timerBattery = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(checkBatteryLevels), userInfo: nil, repeats: true)
    }
    
    var batteryLevel: Float {
        return UIDevice.current.batteryLevel
    }

    var batteryLevelPercentage: String {
        return String(format: "%.0f%%", batteryLevel * 100)
    }
    
    var batteryLevelPercentageConsumed: String {
        var batteryUsedInCurrentSession: Float = 0.0
        if let firstBatteryLevel = UserDefaults.standard.value(forKey: "FirstBatteryLevel") as? Float {
            if let lastBatteryLevel = UserDefaults.standard.value(forKey: "LastBatteryLevel") as? Float {
                if firstBatteryLevel != lastBatteryLevel && firstBatteryLevel < lastBatteryLevel {
                    batteryUsedInCurrentSession = firstBatteryLevel - lastBatteryLevel
                }
            }
        }
        return String(format: "%.0f%%", batteryUsedInCurrentSession * 100)
    }

    @objc func checkBatteryLevels() {
        //print("batteryLevel: \(batteryLevel)")
        //print("batteryLevelPercentage: \(batteryLevelPercentage)")
        if let firstBatteryLevel = UserDefaults.standard.value(forKey: "FirstBatteryLevel") as? Float {
            UserDefaults.standard.set(batteryLevel, forKey: "LastBatteryLevel")
            if firstBatteryLevel != batteryLevel {
                for (_, subscriber) in self.delegates.enumerated() {
                    subscriber.didUpdateForBattery?()
                }
            }
        }
        else {
           UserDefaults.standard.set(batteryLevel, forKey: "FirstBatteryLevel")
        }
        
    }
    
    // MARK:- CLLocationManger Delegates
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if let latestLocation = locations.last {
            if self.locations.count > 100 {
                self.locations.removeLast(90)
            }
            self.locations.insert(latestLocation, at: 0)
        } else {
            print("Locations not Found: \(locations)")
        }
        
        for (_, subscriber) in self.delegates.enumerated() {
            subscriber.didFoundLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Unable to retrieve location with error: " + error.localizedDescription)
    }

    
    
}
