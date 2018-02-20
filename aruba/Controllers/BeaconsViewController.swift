//
//  BeaconsViewController.swift
//  aruba
//
//  Created by Jordan Capa on 20/02/18.
//  Copyright © 2018 everis. All rights reserved.
//

import UIKit
import CoreLocation

class BeaconsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, AddBeaconControllerDelegate {
    
    var beacons:[Beacon] = []
    var beacon: CLBeacon?
    
    @IBOutlet weak var tableView: UITableView!
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.getBeacons()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.beacons.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "defaultCell", for: indexPath) as! BeaconTableViewCell
        
        //cell.textLabel?.text = self.beacons[indexPath.row].name
        //cell.detailTextLabel?.text = "\(String(describing: self.beacons[indexPath.row].uuid!))"
        cell.beacon = self.beacons[indexPath.row]
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let beacon = self.beacons[indexPath.row]
            self.stopMonitoringItem(beacon)
            BeaconManager.shareInstance.deleteBeacon(beacon: beacon)
        }
        self.getBeacons()
    }
    
    // MARK: - AddBeaconControllerDelegate
    
    func addBeacon(beacon: Beacon){
        self.beacons.append(beacon)
        self.startMonitoringItem(beacon)
        self.tableView.reloadData()
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let addBeaconView = segue.destination as! AddBeaconViewController
        addBeaconView.delegate = self
    }
    
    
    // MARK: - Own Methods
    
    func getBeacons(){
        self.beacons = BeaconManager.shareInstance.getBeacons()
        self.tableView.reloadData()
    }
    
    func initView(){
        locationManager.requestAlwaysAuthorization()
        locationManager.delegate = self
    }
    
    func startMonitoringItem(_ beacon: Beacon) {
        let beaconRegion = beacon.asBeaconRegion()
        locationManager.startMonitoring(for: beaconRegion)
        locationManager.startRangingBeacons(in: beaconRegion)
    }
    
    func stopMonitoringItem ( _ beacon: Beacon) {
        let beaconRegion = beacon.asBeaconRegion()
        locationManager.stopMonitoring(for: beaconRegion)
        locationManager.stopRangingBeacons(in: beaconRegion)
    }
    
    func compare(_ item: Beacon, _ beacon: CLBeacon) -> Bool {
        return ((beacon.proximityUUID.uuidString == item.uuid?.uuidString)
            && (Int16(beacon.major) == item.major)
            && (Int16(beacon.minor) == item.minor))
    }

}



// MARK: - CLLocationManagerDelegate

extension  BeaconsViewController : CLLocationManagerDelegate  {
    
    func locationManager(_ manager: CLLocationManager, monitoringDidFailFor region: CLRegion?, withError error: Error) {
        print("Failed monitoring region: \(error.localizedDescription)")
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location manager failed: \(error.localizedDescription)")
    }
    
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        
        // Find the same beacons in the table.
        var indexPaths = [IndexPath]()
        
        for beacon in beacons {
            for row in 0..<self.beacons.count {
                if self.beacons[row] == beacon {
                    self.beacons[row].beacon = beacon
                    indexPaths += [IndexPath(row: row, section: 0)]
                }
            }
        }
        
        // Update beacon locations of visible rows.
        if let visibleRows = tableView.indexPathsForVisibleRows {
            let rowsToUpdate = visibleRows.filter { indexPaths.contains($0) }
            for row in rowsToUpdate {
                let cell = tableView.cellForRow(at: row) as! BeaconTableViewCell
                cell.refreshLocation()
            }
        }
    }
    
}
