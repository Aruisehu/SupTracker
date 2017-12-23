//
//  Connectivity.swift
//  SupTracker
//
//  Created by Supinfo on 23/12/2017.
//  Copyright © 2017 Supinfo. All rights reserved.
//

import Foundation
import Alamofire

class Connectivity {
    class var isConnectedToInternet:Bool {
        return NetworkReachabilityManager()!.isReachable
    }
}
