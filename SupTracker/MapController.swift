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
import CoreLocation


class MapController: UIViewController, CLLocationManagerDelegate {
    var sendLocationTimer : Timer!
    var lat : Double = 0
    var lon : Double = 0
    var locationManager : CLLocationManager!
    @IBOutlet weak var mapView : MKMapView!

    let initialLocation = CLLocation(latitude: 21.282778, longitude: -157.829444)
    let regionRadius: CLLocationDistance = 1000

    override func viewDidLoad() {
        super.viewDidLoad()
        sendLocationTimer = Timer.scheduledTimer(timeInterval: 60.0, target: self, selector: #selector(MapController.sendLocation), userInfo: nil, repeats: true)
        centerMapOnLocation(location: initialLocation)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        determineMyCurrentLocation()
        sendLocation()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func determineMyCurrentLocation() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation:CLLocation = locations[0] as CLLocation
        
        lat = userLocation.coordinate.latitude
        lon = userLocation.coordinate.longitude
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
    {
        print("Error \(error)")
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
    
    func sendLocation() {
        if Connectivity.isConnectedToInternet {
            print("anus")
            let login = UserDefaults.standard.string(forKey: "login")
            let password = UserDefaults.standard.string(forKey: "password")
            
            print(login!)
            print(password!)
            
            if login != nil && password != nil {
                Alamofire.request("http://supinfo.steve-colinet.fr/suptracking/", method: .post,
                                  parameters: ["action": "updatePosition", "login": "admin", "password": "admin", "latitude": String(lat), "longitude": String(lon)]).validate().responseJSON {
                                    response in
                                    switch response.result {
                                    case .success(let value):
                                        let json = JSON(value)
                                        if json[0]["success"] == "true"{
                                            // Position send
                                            print("send")
                                        } else {
                                            print(response)
                                        }
                                    case .failure(_):
                                        print("fail")
                                    }
                                    
                }
            } else {
                // Login error
            }
        }
        else {
            // No Internet
        }
    }
}
