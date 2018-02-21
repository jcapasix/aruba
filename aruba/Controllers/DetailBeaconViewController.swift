//
//  DetailBeaconViewController.swift
//  aruba
//
//  Created by Jordan Capa on 21/02/18.
//  Copyright © 2018 everis. All rights reserved.
//

import UIKit

class DetailBeaconViewController: UIViewController {

    var beacon:Beacon?
    
    @IBOutlet weak var beaconNameLabel: UILabel!
    @IBOutlet weak var beaconUUIDLabel: UILabel!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.beaconNameLabel.text = beacon?.name
        self.beaconUUIDLabel.text = "\(String(describing: beacon?.uuid?.uuidString ?? ""))"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func doneButtonPressed(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
