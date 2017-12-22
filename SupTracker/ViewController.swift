//
//  ViewController.swift
//  SupTracker
//
//  Created by Supinfo on 14/12/2017.
//  Copyright © 2017 Supinfo. All rights reserved.
//

import UIKit
import Alamofire


class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
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
                          parameters: ["action": "login", "login": login, "password": password]).responseJSON {
                            response in
                            debugPrint(response)
                            let defaults = UserDefaults.standard
                            defaults.set(login, forKey: "login")
                            defaults.set(password, forKey: "password")
        }
    }
}

