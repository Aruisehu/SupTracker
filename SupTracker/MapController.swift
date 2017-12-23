//
//  MapController.swift
//  SupTracker
//
//  Created by Supinfo on 23/12/2017.
//  Copyright © 2017 Supinfo. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import MapKit


class MapController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func findCar(_ sender: Any) {
    }
    @IBAction func logout(_ sender: Any) {
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: "login")
        defaults.removeObject(forKey: "password")
        
    }
    
}
