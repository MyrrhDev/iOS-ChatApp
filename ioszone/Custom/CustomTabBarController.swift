//
//  CustomTabBarController.swift
//  ioszone
//
//  Created by Mayra Pastor Valdivia on 30/04/2019.
//  Copyright © 2019 Mayra Pastor Valdivia. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class CustomTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let navigationController = UINavigationController(rootViewController: NewChatRooms())
        navigationController.title = "Chats"
        navigationController.tabBarItem.image = UIImage(named: "Chats")
        
        let configurationController = ConfigurationView()
        let secondNavigationController = UINavigationController(rootViewController: configurationController)
        secondNavigationController.title = "Configuration"
        secondNavigationController.tabBarItem.image = UIImage(named: "config")
        
        let discoverController = UIViewController()
        let thirdNavigationController = UINavigationController(rootViewController: discoverController)
        thirdNavigationController.title = "Discover"
        thirdNavigationController.tabBarItem.image = UIImage(named: "discover")
        
        let alertsController = UIViewController()
        alertsController.navigationItem.title = "Alert Title"
        
        let fourthNavigationController = UINavigationController(rootViewController: alertsController)
        fourthNavigationController.title = "Alerts"
        fourthNavigationController.tabBarItem.image = UIImage(named: "bell")
        
        viewControllers = [navigationController, fourthNavigationController, thirdNavigationController, secondNavigationController]
    }
}
