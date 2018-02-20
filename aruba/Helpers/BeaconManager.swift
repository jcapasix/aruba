//
//  BeaconManager.swift
//  aruba
//
//  Created by Jordan Capa on 20/02/18.
//  Copyright © 2018 everis. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

class BeaconManager {
    
    private static let _shareInstance = BeaconManager()
    
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    static var shareInstance:BeaconManager{
        return _shareInstance
    }
    
    func addBeacon(name:String, uuid: UUID, major: UInt16, minor: UInt16) -> Beacon{
        
        let beacon = Beacon(context: context) // Link Beacon & Context
        beacon.name = name
        beacon.uuid = uuid
        beacon.major = Int16(bitPattern: major)
        beacon.minor = Int16(bitPattern: minor)
        
        // Save the data to coredata
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
        
        return beacon
    }
    
    func deleteBeacon(beacon:Beacon){
        
        context.delete(beacon)
        
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
        
//        do {
//            tasks = try context.fetch(Task.fetchRequest())
//        } catch {
//            print("Fetching Failed")
//        }
    }
    
    func getBeacons()->[Beacon]{
        var beacons:[Beacon] = []
        
        do {
            beacons = try context.fetch(Beacon.fetchRequest())
        } catch {
            print("Fetching Failed")
        }
        
        return beacons
    }
    
}

extension Beacon{
    
    func asBeaconRegion() -> CLBeaconRegion {
        return CLBeaconRegion(proximityUUID: uuid!,
                              major: CLBeaconMajorValue(exactly: major)!,
                              minor: CLBeaconMinorValue(exactly: minor)!,
                              identifier: name!)
    }
    
    
    func nameForProximity(_ proximity: CLProximity) -> String {
        switch proximity {
        case .unknown:
            return "Unknown"
        case .immediate:
            return "Immediate"
        case .near:
            return "Near"
        case .far:
            return "Far"
        }
    }
    
    func locationString() -> String {
        guard let beacon = beacon else { return "Location: Unknown" }
        let proximity = nameForProximity(beacon.proximity)
        let accuracy = String(format: "%.2f", beacon.accuracy)
        
        var location = "Location: \(proximity)"
        if beacon.proximity != .unknown {
            location += " (approx. \(accuracy)m)"
        }
        
        return location
    }
    

}

