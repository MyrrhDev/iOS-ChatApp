//
//  UsersCore+CoreDataProperties.swift
//  ioszone
//
//  Created by Mayra on 17/04/2019.
//  Copyright © 2019 Mayra. All rights reserved.
//
//

import Foundation
import CoreData


extension UsersCore {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UsersCore> {
        return NSFetchRequest<UsersCore>(entityName: "UsersCore")
    }

 /*   @NSManaged public var dateTime: NSDate?
    @NSManaged public var date: String?
    @NSManaged public var time: String?*/
    @NSManaged public var idUser: Int16
    @NSManaged public var name: String?
    @NSManaged public var nameForImageView: String?
    @NSManaged public var surname: String?
    @NSManaged public var message: NSSet?

}

// MARK: Generated accessors for message
extension UsersCore {

    @objc(addMessageObject:)
    @NSManaged public func addToMessage(_ value: MessageCore)

    @objc(removeMessageObject:)
    @NSManaged public func removeFromMessage(_ value: MessageCore)

    @objc(addMessage:)
    @NSManaged public func addToMessage(_ values: NSSet)

    @objc(removeMessage:)
    @NSManaged public func removeFromMessage(_ values: NSSet)

}
