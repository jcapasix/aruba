//
//  AddBeaconViewController.swift
//  aruba
//
//  Created by Jordan Capa on 20/02/18.
//  Copyright © 2018 everis. All rights reserved.
//

import UIKit

protocol AddBeaconControllerDelegate {
    func addBeacon(beacon: Beacon)
}


class AddBeaconViewController: UIViewController {
    
    @IBOutlet weak var nameBeaconTextField: UITextField!
    @IBOutlet weak var uuidBeaconTextField: UITextField!
    @IBOutlet weak var majorBeaconTextField: UITextField!
    @IBOutlet weak var minorBeaconTextField: UITextField!
    
    var delegate:AddBeaconControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func addBeaconButtonPressed(_ sender: Any) {
        
        
        
        // Create new beacon item
        let uuidString = uuidBeaconTextField.text!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        guard let uuid = UUID(uuidString: uuidString) else { return }
        let major = Int(majorBeaconTextField.text!) ?? 0
        let minor = Int(minorBeaconTextField.text!) ?? 0
        let name = nameBeaconTextField.text!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        
        
        let newBeacon = BeaconManager.shareInstance.addBeacon(name: name, uuid: uuid, major: major, minor: minor)
        delegate?.addBeacon(beacon: newBeacon)
        
        self.navigationController?.popToRootViewController(animated: true)
        
    
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
