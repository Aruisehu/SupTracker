//
//  ViewController.swift
//  SupTracker
//
//  Created by Supinfo on 14/12/2017.
//  Copyright © 2017 Supinfo. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import MapKit


class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var loginField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        let login = loginField.text!
        let password = passwordField.text!
        Alamofire.request("http://supinfo.steve-colinet.fr/suptracking/", method: .post,
                          parameters: ["action": "login", "login": login, "password": password]).validate().responseJSON {
                            response in
                            switch response.result {
                                case .success(let value):
                                    let json = JSON(value)
                                    if json["success"] == true{
                                        let defaults = UserDefaults.standard
                                        defaults.set(login, forKey: "login")
                                        defaults.set(password, forKey: "password")
                                        let mapStoryboard = UIStoryboard(name: "Map", bundle: nil)
                                        
                                        let mapController = mapStoryboard.instantiateViewController(withIdentifier: "map")
                                        self.present(mapController, animated: true, completion: nil)
                                        
                                    } else {
                                        //TODO
                                    }
                                case .failure(_):
                                    print("fail")
                                
                            }
                            
        }
    }
}

