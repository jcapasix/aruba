//
//  BeaconTableViewCell.swift
//  aruba
//
//  Created by Jordan Capa on 20/02/18.
//  Copyright © 2018 everis. All rights reserved.
//

import UIKit

class BeaconTableViewCell: UITableViewCell {

    //@IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var uuidLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    
    var beacon: Beacon? = nil {
        didSet {
            if let beacon = beacon {
                //iconImageView.image = Icons(rawValue: beacon.icon)?.image()
                nameLabel.text = beacon.name
                uuidLabel.text = "\(beacon.uuid!)"
                locationLabel.text = beacon.locationString()
                
            } else {
                //iconImageView.image = nil
                nameLabel.text = ""
                uuidLabel.text = ""
                locationLabel.text = ""
            }
        }
    }
    
    func refreshLocation() {
        locationLabel.text = beacon?.locationString() ?? ""
    }


}



