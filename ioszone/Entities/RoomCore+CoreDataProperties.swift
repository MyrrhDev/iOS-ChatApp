//
//  RoomCore+CoreDataProperties.swift
//  ioszone
//
//  Created by Mayra on 17/04/2019.
//  Copyright © 2019 Mayra. All rights reserved.
//
//

import Foundation
import CoreData


extension RoomCore {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<RoomCore> {
        return NSFetchRequest<RoomCore>(entityName: "RoomCore")
    }

    @NSManaged public var dateTime: NSDate?
    @NSManaged public var date: String?
    @NSManaged public var time: String?
    @NSManaged public var lastMsgTxt: String?
    @NSManaged public var name: String?
    @NSManaged public var human: Bool
    @NSManaged public var idRoom: Int16
    @NSManaged public var membersCount: Int16
    @NSManaged public var message: NSSet?

}

// MARK: Generated accessors for message
extension RoomCore {

    @objc(addMessageObject:)
    @NSManaged public func addToMessage(_ value: MessageCore)

    @objc(removeMessageObject:)
    @NSManaged public func removeFromMessage(_ value: MessageCore)

    @objc(addMessage:)
    @NSManaged public func addToMessage(_ values: NSSet)

    @objc(removeMessage:)
    @NSManaged public func removeFromMessage(_ values: NSSet)

}
