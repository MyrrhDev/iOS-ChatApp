//
//  ConfigurationView.swift
//  ioszone
//
//  Created by Mayra on 14/05/2019.
//  Copyright © 2019 Mayra Pastor Valdivia. All rights reserved.
//

import Foundation
import InitialsImageView
import UIKit

class ConfigurationView: UIViewController {
    
    var dataProvider: DataProvider = {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        let managedContext = appDelegate?.persistentContainer
        var dataProv = DataProvider(persistentContainer: managedContext!, repository: DataRepository.shared)
        return dataProv
    }()
    
    var theConfigView = Configuration()
    
    func setupConfigView() {
        //tableView.register(GroupChatCell.self, forCellReuseIdentifier: cellId)
        view.addSubview(theConfigView)
        NSLayoutConstraint.activate([
            theConfigView.topAnchor.constraint(equalTo: self.view.topAnchor),
            theConfigView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            theConfigView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            theConfigView.leftAnchor.constraint(equalTo: self.view.leftAnchor)
            ])
//        self.tableView.alwaysBounceVertical = true
//        self.theConfigView.backgroundColor = UIColor.white
//        self.tableView.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 50, right: 0)
//        self.tableView.separatorStyle = .none
//
    }
    
    override func viewDidLoad() {
        setupConfigView()
    }
    
}
