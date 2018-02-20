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
    
    private var beacons:[Beacon] = []
    
    static var shareInstance:BeaconManager{
        return _shareInstance
    }
    
    func addBeacon(name:String, uuid: UUID, major: Int, minor: Int) -> Beacon{
        
        let beacon = Beacon(name: name, uuid: uuid, major: major, minor: minor)
        self.beacons.append(beacon)
        return beacon
    }
    
    func deleteBeacon(index:Int){
        self.beacons.remove(at: index)

    }
    
    func getBeacons()->[Beacon]{
        return self.beacons
    }
    
}


