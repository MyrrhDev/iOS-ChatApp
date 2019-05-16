//
//  DataRepository.swift
//  ioszone
//
//  Created by Mayra on 23/04/2019.
//  Copyright © 2019 Mayra. All rights reserved.
//

import Foundation
import Alamofire
import CoreData

class DataRepository {
    
    private init() {
        networkHandler.getToken()
    }
    static let shared = DataRepository()
    
    let networkHandler = NetworkManager.sharedNetworkManager
    var defaults = UserDefaults()
    
    func getUsers(completion: @escaping(_ usersArray: [[String:Any]]?, _ error: Error?) -> ()) {
        Alamofire.request(networkHandler.baseString+"list", headers: networkHandler.headersHTTP).responseJSON { (response) in
            do {
                let json = response.result.value
                print("Alamo Users!")
                let result = json as? [[String:Any]]
                completion(result, nil)
            } catch {
                //error = NSError(domain: dataErrorDomain, code: DataErrorCode.networkUnavailable.rawValue, userInfo: nil)
                 print("Alamo Users NOT!")
                completion(nil, error)
                return
            }
        }.resume()
    }
    
    func getRooms(completion: @escaping(_ chatRooms: [[String:Any]]?, _ error: Error?) -> ()) {
        Alamofire.request(networkHandler.baseString+"me/rooms", headers: networkHandler.headersHTTP).responseJSON { (response) in
            do {
                let data = response.data
                let jsonObject = try JSONSerialization.jsonObject(with: data!, options: [])
                let jsonDictionary = jsonObject as? [String: Any]
                let result = jsonDictionary!["rooms"] as? [[String: Any]]
                print("Alamo Rooms!")
                completion(result, nil)
            } catch {
                //error = NSError(domain: dataErrorDomain, code: DataErrorCode.networkUnavailable.rawValue, userInfo: nil)
                print("Alamo Rooms NOT!")
                completion(nil, error)
                return
            }
        }.resume()
    }
    
    func getHumanRooms(completion: @escaping(_ chatRooms: [[String:Any]]?, _ error: Error?) -> ()) {
        Alamofire.request(networkHandler.baseString+"me/onetoone", headers: networkHandler.headersHTTP).responseJSON { response in
            do {
                let data = response.data
                let jsonObject = try JSONSerialization.jsonObject(with: data!, options: [])
                let jsonDictionary = jsonObject as? [String: Any]
                let result = jsonDictionary!["rooms"] as? [[String: Any]]
                print("Alamo Human Rooms!")
                completion(result, nil)
            } catch {
                //let error = NSError(domain: dataErrorDomain, code: DataErrorCode.networkUnavailable.rawValue, userInfo: nil)
                print("Alamo Human Rooms NOT!")
                var dict = NSDictionary()
                completion(nil, error)
                return
            }
        }.resume()
    }
    
    
    func getMessagesRooms(completion: @escaping(_ chatRooms: [[String:Any]]?, _ error: Error?) -> ()) {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        let managedContext = appDelegate?.persistentContainer.viewContext
        let roomsFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "RoomCore")
        var fetchedRooms = [RoomCore]()
       roomsFetch.predicate = NSPredicate(format: "human == false")
        do {
            fetchedRooms = try managedContext!.fetch(roomsFetch) as! [RoomCore]
        } catch {
            fatalError("Failed to fetch Msgs rooms: \(error)")
        }
        
        for room in fetchedRooms {
            var idRoom = String(room.idRoom)
            Alamofire.request(networkHandler.roomURL + idRoom + "/getmessages/range=2055-02-17T23:00:00.000Z,150", headers: networkHandler.headersHTTP).responseJSON { response in
                do {
                    let data = response.data
                    let jsonObject = try JSONSerialization.jsonObject(with: data!, options: [])
                    let jsonDictionary = jsonObject as? [String: Any]
                    let result = jsonDictionary!["messages"] as? [[String: Any]]
                    print("Alamo Msgs Rooms!")
                    completion(result, nil)
                } catch {
                    //let error = NSError(domain: dataErrorDomain, code: DataErrorCode.networkUnavailable.rawValue, userInfo: nil)
                    print("Alamo Msgs NOT!")
                    completion(nil, error)
                    return
                }
            }.resume()
        }
    }
    
    
    func getMessagesHumans(completion: @escaping(_ chatRooms: [[String:Any]]?, _ error: Error?) -> ()) {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        let managedContext = appDelegate?.persistentContainer.viewContext
        let roomsFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "RoomCore")
        var fetchedRooms = [RoomCore]()
        roomsFetch.predicate = NSPredicate(format: "human == true")
        do {
            fetchedRooms = try managedContext!.fetch(roomsFetch) as! [RoomCore]
        } catch {
            fatalError("Failed to fetch HumanRooms: \(error)")
        }
        
        for human in fetchedRooms {
            let idUser = String(human.idRoom)
            Alamofire.request(networkHandler.baseString + idUser + "/getmessages/range=2055-02-17T23:00:00.000Z,150", headers: networkHandler.headersHTTP).responseJSON { response in
                do {
                    let data = response.data
                    let jsonObject = try JSONSerialization.jsonObject(with: data!, options: [])
                    let jsonDictionary = jsonObject as? [String: Any]
                    let result = jsonDictionary!["messages"] as? [[String: Any]]
                    print("Alamo Human Msgs Rooms!")
                    completion(result, nil)
                } catch {
                    //let error = NSError(domain: dataErrorDomain, code: DataErrorCode.networkUnavailable.rawValue, userInfo: nil)
                     print("Alamo Human Msgs NOT!")
                    completion(nil, error)
                    return
                }
            }.resume()
        }
    }
    
    func whoAmI() {
        Alamofire.request(networkHandler.baseString+"me/", headers: networkHandler.headersHTTP).responseJSON { response in
            do {
                let data = response.data
                let jsonObject = try JSONSerialization.jsonObject(with: data!, options: [])
                let jsonDictionary = jsonObject as? [String: Any]
                let result = jsonDictionary!["data"] as? NSDictionary
                print("Now I know myself!")
                self.defaults.set(result?.value(forKey: "idUser"), forKey: "myID")
                print(self.defaults.integer(forKey: "myID"))
            } catch {
                //let error = NSError(domain: dataErrorDomain, code: DataErrorCode.networkUnavailable.rawValue, userInfo: nil)
                print("Who Am I?")
                return
            }
        }.resume()
    }
}
