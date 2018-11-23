//
//  LocationsViewController.swift
//  LocationManagerTest
//
//  Created by Ahmar Ijaz on 7/26/18.
//  Copyright © 2018 Arrivy. All rights reserved.
//

import UIKit
import CoreLocation

class LocationsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, LocationManagerDelegate {

    // MAR:- Outlets
    @IBOutlet weak var lblLatitude: UILabel!
    @IBOutlet weak var lblLongitude: UILabel!
    @IBOutlet weak var lblHorizontalAccuracy: UILabel!
    @IBOutlet weak var lblAltitude: UILabel!
    @IBOutlet weak var lblVerticlaAccuracy: UILabel!
    @IBOutlet weak var lblDistance: UILabel!
    @IBOutlet weak var lblSamples: UILabel!
    @IBOutlet weak var lblBatteryConsumption: UILabel!
    @IBOutlet weak var tblLocations: UITableView!


    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        LocationManager.sharedInstance.delegates.append(self)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    // MARK:- Helpers
    func updateUIForLocations() {
        if let latestLocation = LocationManager.sharedInstance.locations.first {
            lblLatitude.text = String(format: "%.7f", latestLocation.coordinate.latitude)
            lblLongitude.text = String(format: "%.7f", latestLocation.coordinate.longitude)
            lblHorizontalAccuracy.text = String(format: "%.7f", latestLocation.horizontalAccuracy)
            lblAltitude.text = String(format: "%.7f", latestLocation.altitude)
            lblVerticlaAccuracy.text = String(format: "%.7f", latestLocation.verticalAccuracy)
            if LocationManager.sharedInstance.locations.count > 1 , let startLocation = LocationManager.sharedInstance.locations[1] as? CLLocation {
                let distanceBetween: CLLocationDistance = latestLocation.distance(from: startLocation)
                lblDistance.text = String(format: "%.7f", distanceBetween)
            }
            lblSamples.text = String(format: "%d", LocationManager.sharedInstance.locations.count)
        }
        tblLocations.reloadData()
    }
    
    
    // MARK:- LocaitonManager Delegate
    func didFoundLocation() {
        self.updateUIForLocations()
    }
    
    func didUpdateForBattery() {
        self.lblBatteryConsumption.text = LocationManager.sharedInstance.batteryLevelPercentageConsumed
    }
    
    // MARK:- UITableView Delegate & DataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return LocationManager.sharedInstance.locations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "locationcell"
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! LocationTableViewCell
        let loc = LocationManager.sharedInstance.locations[indexPath.row]
        var distanceString = ", D: 0 m"
        if LocationManager.sharedInstance.locations.count > 1, indexPath.row > 0, let startLocation = LocationManager.sharedInstance.locations[indexPath.row-1] as? CLLocation {
            let distanceBetween: CLLocationDistance = loc.distance(from: startLocation)
            distanceString = String(format: ", D: %.4f m", distanceBetween)
        }
        cell.lblLocationDetails.text = String(format:"Lat: %.7f , Lng: %.7f%@", loc.coordinate.latitude, loc.coordinate.longitude, distanceString)
        return cell
    }
    

}
