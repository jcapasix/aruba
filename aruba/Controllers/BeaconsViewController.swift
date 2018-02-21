//
//  BeaconsViewController.swift
//  aruba
//
//  Created by Jordan Capa on 20/02/18.
//  Copyright © 2018 everis. All rights reserved.
//

import UIKit
import CoreLocation
import MBProgressHUD

class BeaconsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, AddBeaconControllerDelegate, CLLocationManagerDelegate {
    
    var beacons:[Beacon] = []
    var currentBeacon:Beacon?
    var beacon: CLBeacon?
    
    var max:Double = 999.0
    
    @IBOutlet weak var tableView: UITableView!
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.requestAlwaysAuthorization()
        locationManager.delegate = self
        self.initView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.getBeacons()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 84
    }
    
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
            BeaconManager.shareInstance.deleteBeacon(index: indexPath.row)
        }
        self.getBeacons()
    }
    
    
    // MARK: - CLLocationManagerDelegate
    
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
                //if self.beacons[row] == beacon {
                if self.compare(self.beacons[row], beacon){
                    self.beacons[row].beacon = beacon
                    indexPaths += [IndexPath(row: row, section: 0)]
                }
            }
        }
        
        self.max = 999.0
        
        for beacon in beacons{
            if beacon.accuracy <= self.max{
                self.max = beacon.accuracy
                for row in 0..<self.beacons.count {
                    if self.compare(self.beacons[row], beacon) && self.max != nil{
                        self.currentBeacon = self.beacons[row]
                        print("currentBeacon \(self.currentBeacon?.name)")
                    }
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
    
    
    // MARK: - AddBeaconControllerDelegate
    
    func addBeacon(beacon: Beacon){
        self.beacons.append(beacon)
        self.startMonitoringItem(beacon)
        self.tableView.reloadData()
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
        if segue.identifier == "addBeaconSegue"{
            let addBeaconView = segue.destination as! AddBeaconViewController
            addBeaconView.delegate = self
        }
        else{
            
            let navigation = segue.destination as! UINavigationController
            
            let detailBeaconView = navigation.topViewController as! DetailBeaconViewController
            detailBeaconView.beacon = self.currentBeacon
        }
        
    }
    
    
    // MARK: - Actions
    
    @IBAction func currentBeaconButton(_ sender: Any) {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            MBProgressHUD.hide(for: self.view, animated: true)
            self.performSegue(withIdentifier: "detailBeaconSegue", sender: nil)
        }
    }
    
    // MARK: - Own Methods

    func initView(){
        BeaconManager.shareInstance.addBeacon(name: "amp", uuid: UUID(uuidString: "A596EBF0-163B-4F0C-B55F-B9DEDFB7CF78")!, major: 1000, minor: 1007)
        BeaconManager.shareInstance.addBeacon(name: "dark", uuid: UUID(uuidString: "A596EBF0-163B-4F0C-B55F-B9DEDFB7CF78")!, major: 1000, minor: 1009)
        self.getBeacons()
    }
    
    func getBeacons(){
        self.beacons = BeaconManager.shareInstance.getBeacons()
        
        for beacon in beacons{
            self.startMonitoringItem(beacon)
        }
        
        self.tableView.reloadData()
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
            && (Int(truncating: beacon.major) == item.major)
            && (Int(truncating: beacon.minor) == item.minor))
    }

}




