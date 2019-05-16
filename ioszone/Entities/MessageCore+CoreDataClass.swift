//
//  MessageCore+CoreDataClass.swift
//  ioszone
//
//  Created by Mayra on 17/04/2019.
//  Copyright © 2019 Mayra. All rights reserved.
//
//

import Foundation
import CoreData
import UIKit

@objc(MessageCore)
public class MessageCore: NSManagedObject {
    
    func updateRoomMsg(with jsonDictionary: [String: Any]) throws {
        guard let idRoom = jsonDictionary["idRoom"] as? Int,
            let dateTime: NSDate = {
                var theDate = NSDate()
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
                if let date = dateFormatter.date(from: (jsonDictionary["date"] as? String)!) {
                    theDate = date as NSDate
                }
                return theDate
            }(),
            let date: String = {
                var thedate = String()
                return thedate.getDate(temp: ((jsonDictionary["date"] as? String)!))
            }(),
            let time: String = {
                var thetime = String()
                return thetime.getTime(temp: ((jsonDictionary["date"] as? String)!))
            }(),
            let messageTxt = jsonDictionary["message"] as? String,
            let userIDSender = jsonDictionary["idUser"] as? Int
            else {
                throw NSError(domain: "updateRoomMsg", code: 100, userInfo: nil)
        }
        
        self.idRoom = Int16(idRoom)
        self.userIDSender = Int16(userIDSender)
        self.messageSent = messageTxt
        self.dateTime = dateTime
        self.date = date
        self.time = time
        
        var roomFiltered = [RoomCore]()
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        let managedContext = appDelegate?.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<RoomCore>(entityName:"RoomCore")
        fetchRequest.predicate = NSPredicate(format: "idRoom == %i", self.idRoom)
        fetchRequest.fetchLimit = 1
        do {
            roomFiltered = try (managedObjectContext?.fetch(fetchRequest))!
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved RoomCore error \(nserror), \(nserror.userInfo)")
        }
        if (roomFiltered != nil && roomFiltered.count != 0) {
            roomFiltered[0].addToMessage(self)
            roomFiltered[0].addToMessage(roomFiltered[0].message!)
        }
        
    }
    
    func updateHumanMsg(with jsonDictionary: [String: Any]) throws {
        guard let idUser = jsonDictionary["idUser"] as? Int,
            let dateTime: NSDate = {
                var theDate = NSDate()
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
                if let date = dateFormatter.date(from: (jsonDictionary["date"] as? String)!) {
                    theDate = date as NSDate
                }
                return theDate
            }(),
            let date: String = {
                var thedate = String()
                return thedate.getDate(temp: ((jsonDictionary["date"] as? String)!))
            }(),
            let time: String = {
                var thetime = String()
                return thetime.getTime(temp: ((jsonDictionary["date"] as? String)!))
            }(),
            let messageTxt = jsonDictionary["message"] as? String,
            let userIDReceiver = jsonDictionary["toIdUser"] as? Int
        else {
            throw NSError(domain: "updateHumanMsg", code: 100, userInfo: nil)
        }
        
        self.idUser = Int16(idUser)
        self.userIDReceiver = Int16(userIDReceiver)
        self.messageSent = messageTxt
        self.dateTime = dateTime
        self.date = date
        self.time = time
        
        var userFiltered = [UsersCore]()
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        let managedContext = appDelegate?.persistentContainer.viewContext
        let fetchRequest2 = NSFetchRequest<UsersCore>(entityName:"UsersCore")
        fetchRequest2.predicate = NSPredicate(format: "idUser == %i", idUser)
        fetchRequest2.fetchLimit = 1
        do {
            userFiltered = try (managedObjectContext?.fetch(fetchRequest2))!
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved UsersCore error \(nserror), \(nserror.userInfo)")
        }
        if (userFiltered != nil && userFiltered.count != 0) {
            userFiltered[0].addToMessage(self)
            userFiltered[0].addToMessage(userFiltered[0].message!)
        }
    }
    

}
