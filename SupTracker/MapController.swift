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
        let login = UserDefaults.standard.string(forKey: "login")!
        let password = UserDefaults.standard.string(forKey: "password")!
        print("lol")
        Alamofire.request("http://supinfo.steve-colinet.fr/suptracking/", method: .post,
                          parameters: ["action": "getCarPosition", "login": login, "password": password ]).validate().responseJSON {
                            response in
                            switch response.result {
                            case .success(let value):
                                let json = JSON(value)
                                debugPrint(json)
                                debugPrint(json["position"]["latitude"])
                                if json["success"] == true{
                                    let annotation = MKPointAnnotation()
                                    let lat = json["position"]["latitude"].double!
                                    let long = json["position"]["longitude"].double!
                                    annotation.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
                                    self.mapView.addAnnotation(annotation)
                                    self.centerMapOnLocation(location: CLLocation(latitude: lat, longitude: long))
                                } else {
                                    let loginStoryboard = UIStoryboard(name: "Main", bundle: nil)

                                    let loginController = loginStoryboard.instantiateViewController(withIdentifier: "login")
                                    self.present(loginController, animated: true, completion: nil)
                                }
                            case .failure(_):
                                let alertController = UIAlertController(title: "How to explain...", message: "Well, as far as we know, your car is lost thorough the immensity of space and time... Well, good luck with that!", preferredStyle: .actionSheet)
                                
                                let shrugAction = UIAlertAction(title: "\u{1F937}", style: .default) { (action:UIAlertAction!) in
                                    // close the popup
                                }
                                alertController.addAction(shrugAction)
                                
                                self.present(alertController, animated: true, completion:nil)
                            }
                            
        }
        
    }

    @IBAction func showAboutUs(_ sender: Any) {
        let alertController = UIAlertController(title: "About us", message: "We are 2 students from Supinfo who have been tortured and locked up to make this app. Here in France, we call that 'un examen'. What a terrifying word.", preferredStyle: .alert)
        
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
            // close the popup
        }
        alertController.addAction(OKAction)
        
        self.present(alertController, animated: true, completion:nil)
    }
    
    @IBAction func logout(_ sender: Any) {
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: "login")
        defaults.removeObject(forKey: "password")
        let loginStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        let loginController = loginStoryboard.instantiateViewController(withIdentifier: "login")
        self.present(loginController, animated: true, completion: nil)
    }
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
                                                                  regionRadius, regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    func sendLocation() {
        if Connectivity.isConnectedToInternet {

            let login = UserDefaults.standard.string(forKey: "login")
            let password = UserDefaults.standard.string(forKey: "password")

            if login != nil && password != nil {
                Alamofire.request("http://supinfo.steve-colinet.fr/suptracking/", method: .post,
                                  parameters: ["action": "updatePosition", "login": login!, "password": password!, "latitude": String(lat), "longitude": String(lon)]).validate().responseJSON {
                                    response in
                                    switch response.result {
                                    case .success(let value):
                                        let json = JSON(value)
                                        if json["success"] == true{
                                            // Position send
                                            print("send")
                                        } else {
                                            let loginStoryboard = UIStoryboard(name: "Main", bundle: nil)
                                            
                                            let loginController = loginStoryboard.instantiateViewController(withIdentifier: "login")
                                            self.present(loginController, animated: true, completion: nil)
                                        }
                                    case .failure(_):
                                        let alertController = UIAlertController(title: "Eeeermmm.....", message: "An error occured and we can't really fix it right now", preferredStyle: .actionSheet)
                                        
                                        let fuckAction = UIAlertAction(title: "Fuck", style: .default) { (action:UIAlertAction!) in
                                            // close the popup
                                        }
                                        alertController.addAction(fuckAction)
                                        
                                        self.present(alertController, animated: true, completion:nil)
                                    }
                                    
                }
            } else {
                let loginStoryboard = UIStoryboard(name: "Main", bundle: nil)
                
                let loginController = loginStoryboard.instantiateViewController(withIdentifier: "login")
                self.present(loginController, animated: true, completion: nil)
            }
        }
        else {
            let alertController = UIAlertController(title: "Ajit Pai is shit", message: "RIP Net Neutrality (or maybe you didn't activate internet)", preferredStyle: .actionSheet)
            
            let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
                // close the popup
            }
            alertController.addAction(OKAction)
            
            self.present(alertController, animated: true, completion:nil)
        }
    }
}
