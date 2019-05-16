//
//  IdsChattingUsers+CoreDataClass.swift
//  ioszone
//
//  Created by Mayra on 25/04/2019.
//  Copyright © 2019 Mayra. All rights reserved.
//
//

import Foundation
import CoreData

@objc(IdsChattingUsers)
public class IdsChattingUsers: NSManagedObject {
    func update(with jsonDictionary: [String: Any]) throws {
        guard let userId = jsonDictionary["UserChating"] as? Int
            else {
                throw NSError(domain: "", code: 100, userInfo: nil)
        }
        self.userChating = Int16(userId)
    }
}
