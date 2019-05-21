//
//  DataProvider.swift
//  ioszone
//
//  Created by Mayra on 23/04/2019.
//  Copyright © 2019 Mayra. All rights reserved.
//

import Foundation
import CoreData

let dataErrorDomain = "dataErrorDomain"

enum DataErrorCode: NSInteger {
    case networkUnavailable = 101
    case wrongDataFormat = 102
}

class DataProvider { //Sync Coordinator
    private let persistentContainer: NSPersistentContainer
    private let repository: DataRepository
    
    var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    init(persistentContainer: NSPersistentContainer, repository: DataRepository) {
        self.persistentContainer = persistentContainer
        self.repository = repository
    }
    
    func fetchUsers(completion: @escaping(Error?) -> Void) {
        repository.getUsers() { jsonDictionary, error in
            if let error = error {
                completion(error)
                return
            }
            guard let jsonDictionary = jsonDictionary else {
                let error = NSError(domain: dataErrorDomain, code: DataErrorCode.wrongDataFormat.rawValue, userInfo: nil)
                completion(error)
                return
            }
            let taskContext = self.persistentContainer.newBackgroundContext()
            taskContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
            taskContext.undoManager = nil
            _ = self.syncUsers(jsonDictionary: jsonDictionary, taskContext: taskContext)
            completion(nil)
        }
        
        repository.whoAmI()
    }
    
    func fetchRooms(completion: @escaping(Error?) -> Void) {
        repository.getRooms() { jsonDictionary, error in
            if let error = error {
                completion(error)
                return
            }
            guard let jsonDictionary = jsonDictionary else {
                let error = NSError(domain: dataErrorDomain, code: DataErrorCode.wrongDataFormat.rawValue, userInfo: nil)
                completion(error)
                return
            }
            let taskContext = self.persistentContainer.newBackgroundContext()
            taskContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
            taskContext.undoManager = nil
            _ = self.syncRooms(jsonDictionary: jsonDictionary, taskContext: taskContext)
            completion(nil)
        }
    }
    
    func fetchUsersChatting(completion: @escaping(Error?) -> Void) {
        repository.getHumanRooms() { jsonDictionary, error in
            if let error = error {
                completion(error)
                return
            }
            guard let jsonDictionary = jsonDictionary else {
                let error = NSError(domain: dataErrorDomain, code: DataErrorCode.wrongDataFormat.rawValue, userInfo: nil)
                completion(error)
                return
            }
            let taskContext = self.persistentContainer.newBackgroundContext()
            taskContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
            taskContext.undoManager = nil
            
            _ = self.syncChattingIds(jsonDictionary: jsonDictionary, taskContext: taskContext)
            
            completion(nil)
        }
    }
    
    func fetchRoomMessages(completion: @escaping(Error?) -> Void) {
        repository.getMessagesRooms() { jsonDictionary, error in
            if let error = error {
                completion(error)
                return
            }
            guard let jsonDictionary = jsonDictionary else {
                let error = NSError(domain: dataErrorDomain, code: DataErrorCode.wrongDataFormat.rawValue, userInfo: nil)
                completion(error)
                return
            }
            let taskContext = self.persistentContainer.newBackgroundContext()
            taskContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
            taskContext.undoManager = nil
            
            _ = self.syncRoomMessages(jsonDictionary: jsonDictionary, taskContext: taskContext)
            
            completion(nil)
        }
    }
    
    
    func fetchHumanMessages(completion: @escaping(Error?) -> Void) {
        repository.getMessagesHumans() { jsonDictionary, error in
            if let error = error {
                completion(error)
                return
            }
            guard let jsonDictionary = jsonDictionary else {
                let error = NSError(domain: dataErrorDomain, code: DataErrorCode.wrongDataFormat.rawValue, userInfo: nil)
                completion(error)
                return
            }
            let taskContext = self.persistentContainer.newBackgroundContext()
            taskContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
            taskContext.undoManager = nil
            
            _ = self.syncHumanMessages(jsonDictionary: jsonDictionary, taskContext: taskContext)
            
            completion(nil)
        }
    }
    
    func fetchInterests() {
        repository.getInterests()
    }
    
    func fetchThisUser() {
        repository.whoAmI()
    }
    
    func dealWithTerms() {
        repository.acceptTerms()
    }
    
    
    //Sync:
    private func syncHumanMessages(jsonDictionary: [[String:Any]], taskContext: NSManagedObjectContext) -> Bool {
        var successfull = false
        taskContext.performAndWait {
            let matchingUserIDRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "MessageCore")
            let userID = jsonDictionary.map { $0["idUser"] as? Int }.compactMap { $0 }
            matchingUserIDRequest.predicate = NSPredicate(format: "idUser in %@", argumentArray: [userID])
            let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: matchingUserIDRequest)
            batchDeleteRequest.resultType = .resultTypeObjectIDs
            // Execute the request to de batch delete and merge the changes to viewContext, which triggers the UI update
            do {
                let batchDeleteResult = try taskContext.execute(batchDeleteRequest) as? NSBatchDeleteResult
                
                if let deletedObjectIDs = batchDeleteResult?.result as? [NSManagedObjectID] {
                    NSManagedObjectContext.mergeChanges(fromRemoteContextSave: [NSDeletedObjectsKey: deletedObjectIDs],
                                                        into: [self.persistentContainer.viewContext])
                }
            } catch {
                print("Error: \(error)\nCould not batch delete existing records.")
                return
            }
            
            // Create new records.
            for msgsDictionary in jsonDictionary {
                guard let msg = NSEntityDescription.insertNewObject(forEntityName: "MessageCore", into: taskContext) as? MessageCore else {
                    print("Error: Failed to create a new MessageCore object!")
                    return
                }
                do {
                    try msg.updateHumanMsg(with: msgsDictionary)
                } catch {
                    print("Error: \(error)\nThe MessageCore Human object will be deleted.")
                    taskContext.delete(msg)
                }
            }
            
            // Save all the changes just made and reset the taskContext to free the cache.
            if taskContext.hasChanges {
                do {
                    try taskContext.save()
                } catch {
                    print("Error: \(error)\nCould not save Core Data context.")
                }
                taskContext.reset() // Reset the context to clean up the cache and low the memory footprint.
            }
            successfull = true
        }
        return successfull
    }
    
    
    
    private func syncRoomMessages(jsonDictionary: [[String:Any]], taskContext: NSManagedObjectContext) -> Bool {
        var successful = false
        taskContext.performAndWait {
            let matchingUserIDRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "MessageCore")
            let userID = jsonDictionary.map { $0["idRoom"] as? Int }.compactMap { $0 }
            matchingUserIDRequest.predicate = NSPredicate(format: "idRoom in %@", argumentArray: [userID])
            let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: matchingUserIDRequest)
            batchDeleteRequest.resultType = .resultTypeObjectIDs
            // Execute the request to de batch delete and merge the changes to viewContext, which triggers the UI update
            do {
                let batchDeleteResult = try taskContext.execute(batchDeleteRequest) as? NSBatchDeleteResult
                
                if let deletedObjectIDs = batchDeleteResult?.result as? [NSManagedObjectID] {
                    NSManagedObjectContext.mergeChanges(fromRemoteContextSave: [NSDeletedObjectsKey: deletedObjectIDs],
                                                        into: [self.persistentContainer.viewContext])
                }
            } catch {
                print("Error: \(error)\nCould not batch delete existing records.")
                return
            }
            
            // Create new records.
            for msgsDictionary in jsonDictionary {
                guard let msg = NSEntityDescription.insertNewObject(forEntityName: "MessageCore", into: taskContext) as? MessageCore else {
                    print("Error: Failed to create a new MessageCore object!")
                    return
                }
                do {
                    try msg.updateRoomMsg(with: msgsDictionary)
                } catch {
                    print("Error: \(error)\nThe MessageCore Room object will be deleted.")
                    taskContext.delete(msg)
                }
            }
            
            // Save all the changes just made and reset the taskContext to free the cache.
            if taskContext.hasChanges {
                do {
                    try taskContext.save()
                } catch {
                    print("Error: \(error)\nCould not save Core Data context.")
                }
                taskContext.reset() // Reset the context to clean up the cache and low the memory footprint.
            }
            successful = true
        }
        return successful
    }
    
    
    private func syncUsers(jsonDictionary: [[String:Any]], taskContext: NSManagedObjectContext) -> Bool {
        var successfull = false
        taskContext.performAndWait {
            let matchingUserIDRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "UsersCore")
            let userID = jsonDictionary.map { $0["idUser"] as? Int }.compactMap { $0 }
            matchingUserIDRequest.predicate = NSPredicate(format: "idUser in %@", argumentArray: [userID])
            let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: matchingUserIDRequest)
            batchDeleteRequest.resultType = .resultTypeObjectIDs
            // Execute the request to de batch delete and merge the changes to viewContext, which triggers the UI update
            do {
                let batchDeleteResult = try taskContext.execute(batchDeleteRequest) as? NSBatchDeleteResult
                
                if let deletedObjectIDs = batchDeleteResult?.result as? [NSManagedObjectID] {
                    NSManagedObjectContext.mergeChanges(fromRemoteContextSave: [NSDeletedObjectsKey: deletedObjectIDs],
                                                        into: [self.persistentContainer.viewContext])
                }
            } catch {
                print("Error: \(error)\nCould not batch delete existing records.")
                return
            }
            
            // Create new records.
            for userDictionary in jsonDictionary {
                guard let user = NSEntityDescription.insertNewObject(forEntityName: "UsersCore", into: taskContext) as? UsersCore else {
                    print("Error: Failed to create a new User object!")
                    return
                }
                do {
                    try user.update(with: userDictionary)
                } catch {
                    print("Error: \(error)\nThe user object will be deleted.")
                    taskContext.delete(user)
                }
            }
            
            // Save all the changes just made and reset the taskContext to free the cache.
            if taskContext.hasChanges {
                do {
                    try taskContext.save()
                } catch {
                    print("Error: \(error)\nCould not save Core Data context.")
                }
                taskContext.reset() // Reset the context to clean up the cache and low the memory footprint.
            }
            successfull = true
        }
        return successfull
    }
    
    private func syncRooms(jsonDictionary: [[String:Any]], taskContext: NSManagedObjectContext) -> Bool {
        var successfull = false
        taskContext.performAndWait {
            let matchingUserIDRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "RoomCore")
            let userID = jsonDictionary.map { $0["idRoom"] as? Int }.compactMap { $0 }
            matchingUserIDRequest.predicate = NSPredicate(format: "idRoom in %@", argumentArray: [userID])
            
            let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: matchingUserIDRequest)
            batchDeleteRequest.resultType = .resultTypeObjectIDs
            
            // Execute the request to de batch delete and merge the changes to viewContext, which triggers the UI update
            do {
                let batchDeleteResult = try taskContext.execute(batchDeleteRequest) as? NSBatchDeleteResult
                
                if let deletedObjectIDs = batchDeleteResult?.result as? [NSManagedObjectID] {
                    NSManagedObjectContext.mergeChanges(fromRemoteContextSave: [NSDeletedObjectsKey: deletedObjectIDs],
                                                        into: [self.persistentContainer.viewContext])
                }
                
            } catch {
                print("Error: \(error)\nCould not batch delete existing records.")
                return
            }
            
            // Create new records.
            for roomsDictionary in jsonDictionary {
                guard let room = NSEntityDescription.insertNewObject(forEntityName: "RoomCore", into: taskContext) as? RoomCore else {
                    print("Error: Failed to create a new Room object!")
                    return
                }

                do {
                    try room.updateRoom(with: roomsDictionary)
                } catch {
                    print("Error: \(error)\nThe user object will be deleted.")
                    taskContext.delete(room)
                }
            }
            
            // Save all the changes just made and reset the taskContext to free the cache.
            if taskContext.hasChanges {
                do {
                    try taskContext.save()
                } catch {
                    print("Error: \(error)\nCould not save Core Data context.")
                }
                taskContext.reset() // Reset the context to clean up the cache and low the memory footprint.
            }
            successfull = true
        }
        return successfull
    }
    
    private func syncChattingIds(jsonDictionary: [[String:Any]], taskContext: NSManagedObjectContext) -> Bool {
        var successfull = false
        taskContext.performAndWait {
            let matchingUserIDRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "IdsChattingUsers")
            let userID = jsonDictionary.map { $0["UserChating"] as? Int }.compactMap { $0 }
            matchingUserIDRequest.predicate = NSPredicate(format: "userChating in %@", argumentArray: [userID])
            
            let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: matchingUserIDRequest)
            batchDeleteRequest.resultType = .resultTypeObjectIDs
            
            // Execute the request to de batch delete and merge the changes to viewContext, which triggers the UI update
            do {
                let batchDeleteResult = try taskContext.execute(batchDeleteRequest) as? NSBatchDeleteResult
                
                if let deletedObjectIDs = batchDeleteResult?.result as? [NSManagedObjectID] {
                    NSManagedObjectContext.mergeChanges(fromRemoteContextSave: [NSDeletedObjectsKey: deletedObjectIDs],
                                                        into: [self.persistentContainer.viewContext])
                }
                
            } catch {
                print("Error: \(error)\nCould not batch delete existing records.")
                return
            }
            
            // Create new records.
            for idsChatting in jsonDictionary {
                guard let idsChat = NSEntityDescription.insertNewObject(forEntityName: "IdsChattingUsers", into: taskContext) as? IdsChattingUsers else {
                    print("Error: Failed to create a new IDChattingUser object!")
                    return
                }
                
                guard let room = NSEntityDescription.insertNewObject(forEntityName: "RoomCore", into: taskContext) as? RoomCore else {
                    print("Error: Failed to create a new Room object!")
                    return
                }
                
                //print(idsChatting)
                //print(idsChatting["UserChating"] as? Int)
                //look for the idUser in Users
                let fetchRequest = NSFetchRequest<UsersCore>(entityName: "UsersCore")
                fetchRequest.sortDescriptors = [NSSortDescriptor(key: "idUser", ascending: false)]
                fetchRequest.predicate = NSPredicate(format: "idUser == %i", (idsChatting["UserChating"] as? Int)!)
                fetchRequest.fetchLimit = 1
            
               
                
                do {
                    try idsChat.update(with: idsChatting)
                    var humanroom = try taskContext.fetch(fetchRequest)
                    //print(humanroom)
                    try room.updateHuman(with: humanroom)
                    
                    //try room.updateHuman(with: idsChatting)
                } catch {
                    print("Error: \(error)\nThe user object will be deleted.")
                    taskContext.delete(idsChat)
                }
            }
            
            // Save all the changes just made and reset the taskContext to free the cache.
            if taskContext.hasChanges {
                do {
                    try taskContext.save()
                } catch {
                    print("Error: \(error)\nCould not save Core Data context.")
                }
                taskContext.reset() // Reset the context to clean up the cache and low the memory footprint.
            }
            successfull = true
        }
        return successfull
    }
}
