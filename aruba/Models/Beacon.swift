//
//  Beacon.swift
//  aruba
//
//  Created by Jordan Capa on 20/02/18.
//  Copyright © 2018 everis. All rights reserved.
//

import UIKit
import CoreLocation

class Beacon{
    
    var name:String?
    var uuid:UUID?
    var major:Int
    var minor:Int
    
    var beacon:CLBeacon?
    
    init(name:String?, uuid:UUID?, major:Int, minor:Int) {
        self.name = name
        self.uuid = uuid
        self.major = major
        self.minor = minor
    }
    
    func setBeacon(beacon:CLBeacon?){
        self.beacon = beacon
    }

    func asBeaconRegion() -> CLBeaconRegion {
        return CLBeaconRegion(proximityUUID: uuid!,
                              major: CLBeaconMajorValue(exactly: major)!,
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
        guard let beacon = self.beacon else { return "Location: Unknown" }
        let proximity = nameForProximity(beacon.proximity)
        let accuracy = String(format: "%.2f", beacon.accuracy)
        
        var location = "Location: \(proximity)"
        if beacon.proximity != .unknown {
            location += " (approx. \(accuracy)m)"
        }
        
        return location
    }

}
