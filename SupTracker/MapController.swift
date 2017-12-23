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
    @IBOutlet weak var mapView: MKMapView!
    
    let initialLocation = CLLocation(latitude: 21.282778, longitude: -157.829444)
    let regionRadius: CLLocationDistance = 1000

    override func viewDidLoad() {
        super.viewDidLoad()
        
        centerMapOnLocation(location: initialLocation)
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
        let loginStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        let loginController = loginStoryboard.instantiateViewController(withIdentifier: "login")
        self.present(loginController, animated: true, completion: nil)
        print("banane")
    }
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
                                                                  regionRadius, regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
    }
}
