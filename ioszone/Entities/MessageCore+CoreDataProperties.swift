//
//  MessageCore+CoreDataProperties.swift
//  ioszone
//
//  Created by Mayra on 17/04/2019.
//  Copyright © 2019 Mayra. All rights reserved.
//
//

import Foundation
import CoreData


extension MessageCore {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MessageCore> {
        return NSFetchRequest<MessageCore>(entityName: "MessageCore")
    }

    //Rooms
    @NSManaged public var idRoom: Int16      //Sent to this room
    @NSManaged public var userIDSender: Int16 //idUser
    
    //HumanRoom
    @NSManaged public var idUser: Int16 //Sent by NO, mas idRoom
    @NSManaged public var userIDReceiver: Int16 
    
    //Both
    @NSManaged public var dateTime: NSDate?
    @NSManaged public var messageSent: String?
    
    @NSManaged public var date: String?
    @NSManaged public var time: String?
    @NSManaged public var room: RoomCore?
    @NSManaged public var user: UsersCore?

}
