//
//  UsersCore+CoreDataClass.swift
//  ioszone
//
//  Created by Mayra on 17/04/2019.
//  Copyright © 2019 Mayra. All rights reserved.
//
//

import Foundation
import CoreData

@objc(UsersCore)
public class UsersCore: NSManagedObject {
    
    func update(with jsonDictionary: [String: Any]) throws {
        guard let idUser = jsonDictionary["idUser"] as? Int,
            let name = jsonDictionary["name"] as? String,
            let surname = jsonDictionary["surname"] as? String
            else {
                throw NSError(domain: "", code: 100, userInfo: nil)
        }
        
        self.name = name
        self.idUser = Int16(idUser)
        self.nameForImageView = name + " " + surname
        self.surname = surname
    }

}
