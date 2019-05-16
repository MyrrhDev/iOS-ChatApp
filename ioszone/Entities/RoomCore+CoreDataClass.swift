//
//  RoomCore+CoreDataClass.swift
//  ioszone
//
//  Created by Mayra on 17/04/2019.
//  Copyright © 2019 Mayra. All rights reserved.
//
//

import Foundation
import CoreData

@objc(RoomCore)
public class RoomCore: NSManagedObject {
    func updateRoom(with jsonDictionary: [String: Any]) throws {
        guard let idRoom = jsonDictionary["idRoom"] as? Int,
            let name = jsonDictionary["name"] as? String,
            let membersCount = jsonDictionary["membersCount"] as? Int
            else {
                throw NSError(domain: "", code: 100, userInfo: nil)
        }
        
        self.name = name
        self.idRoom = Int16(idRoom)
        self.membersCount = Int16(membersCount)
        self.human = false
        
        //Date, time and day come from the last message sent here
        
    }
    
    func updateHuman(with jsonDictionary: [UsersCore]) throws {
        let idUser = jsonDictionary[0].idUser
        let name = jsonDictionary[0].name
        
        
        self.name = name
        self.idRoom = idUser
        self.membersCount = Int16(1)
        self.human = true
    }
    /*
    func updateHuman(with jsonDictionary: [Any]) throws {
        let idUser = jsonDictionary[]
        let name = jsonDictionary.name
        
        
        self.name = name
        self.idRoom = idUser
        self.membersCount = Int16(1)
        self.human = true
    }*/
}
