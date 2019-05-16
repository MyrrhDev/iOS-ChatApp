//
//  NetworkManager.swift
//  ioszone
//
//  Created by Mayra on 28/02/2019.
//  Copyright © 2019 Mayra. All rights reserved.
//

import Foundation
import Alamofire

class NetworkManager {
    static let sharedNetworkManager = NetworkManager()
    var defaults = UserDefaults()
    let baseString = "http://zonetactsbackend-pre-env-1.eu-west-1.elasticbeanstalk.com:8081/api/v1.0/users/"
    
    let roomURL = "http://zonetactsbackend-pre-env-1.eu-west-1.elasticbeanstalk.com:8081/api/v1.0/rooms/"
    
    let headerJSON = [
        "Accept": "application/json",
        "Content-Type" : "application/json; charset=utf-8"
    ]
    
    var headersHTTP: HTTPHeaders = [:]

    
    init() {
        
        headersHTTP = [
            "authorization": "",
            "Accept": "application/json"
        ]
        
    }
    
    func saveToken(myToken: String) {
        defaults.set(myToken, forKey: "myAuthToken")
    }
    
    func getToken() {
        if(defaults.bool(forKey: "gotToken")) {
            headersHTTP = [
                "authorization": defaults.string(forKey: "myAuthToken")!,
                "Accept": "application/json"
            ]
        }
    }
    
    
}

