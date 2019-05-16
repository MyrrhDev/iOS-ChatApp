//
//  IdsChattingUsers+CoreDataProperties.swift
//  ioszone
//
//  Created by Mayra on 25/04/2019.
//  Copyright © 2019 Mayra. All rights reserved.
//
//

import Foundation
import CoreData


extension IdsChattingUsers {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<IdsChattingUsers> {
        return NSFetchRequest<IdsChattingUsers>(entityName: "IdsChattingUsers")
    }

    @NSManaged public var userChating: Int16

}
