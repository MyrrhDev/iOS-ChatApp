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
        Alamofire.request(networkHandler.usersURL+"list", headers: networkHandler.headersHTTP).responseJSON { (response) in
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
        Alamofire.request(networkHandler.usersURL+"me/rooms", headers: networkHandler.headersHTTP).responseJSON { (response) in
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
        Alamofire.request(networkHandler.usersURL+"me/onetoone", headers: networkHandler.headersHTTP).responseJSON { response in
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
            Alamofire.request(networkHandler.usersURL + idUser + "/getmessages/range=2055-02-17T23:00:00.000Z,150", headers: networkHandler.headersHTTP).responseJSON { response in
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
        print(self.defaults.value(forKey: "myAuthToken"))
        
        Alamofire.request(networkHandler.postRegistro+"users/me", headers: networkHandler.headersHTTP).responseJSON { response in
            print("Request: \(String(describing: response.request))")   // original url request
            print("Response: \(String(describing: response.response))") // http url response
            print("Result: \(response.result)")                         // response serialization result
            
            do {
                let data = response.data
                let jsonObject = try JSONSerialization.jsonObject(with: data!, options: [])
                let jsonDictionary = jsonObject as? [String: Any]
                let result = jsonDictionary!["data"] as? NSDictionary
                print("Now I know myself!")
                self.defaults.set(result?.value(forKey: "idUser"), forKey: "myID")
                print(self.defaults.integer(forKey: "myID"))
                
                self.defaults.set(result, forKey: "thisUserDict")
                let testDict = self.defaults.value(forKey: "thisUserDict")
                print(testDict)
            } catch {
                //let error = NSError(domain: dataErrorDomain, code: DataErrorCode.networkUnavailable.rawValue, userInfo: nil)
                print("Who Am I?")
                return
            }
        }
    }
   
    
    
    func getClientInterests() {
        Alamofire.request(networkHandler.postRegistro + "interest/list", method: .get, headers: networkHandler.headersHTTP).responseJSON { response in
//            print("Request: \(String(describing: response.request))")   // original url request
//            print("Response: \(String(describing: response.response))") // http url response
//            print("Result: \(response.result)")                         // response serialization result
                do {
                    let data = response.data
                    let jsonObject = try JSONSerialization.jsonObject(with: data!, options: [])
                    let jsonDictionary = jsonObject as? [String: Any]
                    let result = jsonDictionary!["infor"] as? [[String: Any]]
                    print("Got 'em Interests")
//                    print(result)
                    var interestArray = [String]()
                    if(result != nil) {
                        self.defaults.set(result, forKey: "interestsClientDict")
                        
                        for interest in result! {
                            interestArray.append(interest["name"] as! String)
//                            print(interest["name"]!)
                        }
                    }
                    self.defaults.set(interestArray, forKey: "InterestArray")
                } catch {
                    //let error = NSError(domain: dataErrorDomain, code: DataErrorCode.networkUnavailable.rawValue, userInfo: nil)
                    return
                }
            }.resume()
    }
    
    
    func getUserInterests() {
        Alamofire.request(networkHandler.postRegistro + "users/me/interest", method: .get, headers: networkHandler.headersHTTP).responseJSON { response in
            do {
                let data = response.data
                let jsonObject = try JSONSerialization.jsonObject(with: data!, options: [])
                let jsonDictionary = jsonObject as? [String: Any]
                let result = jsonDictionary!["infor"] as? [[String: Any]]
                print("Got 'em Interests")
                //                    print(result)
                var interestArray = [String]()
                if(result != nil) {
                    self.defaults.set(result, forKey: "userInterestsDict")
                    
                    for interest in result! {
                        interestArray.append(interest["name"] as! String)
                        //                            print(interest["name"]!)
                    }
                }
                self.defaults.set(interestArray, forKey: "InterestArray")
            } catch {
                //let error = NSError(domain: dataErrorDomain, code: DataErrorCode.networkUnavailable.rawValue, userInfo: nil)
                
                return
            }
            }.resume()
    }
    
    
    func saveInterests (interests: [Int]) {
        let parameters: Parameters = [
            "interests": interests
        ]
        
         Alamofire.request(networkHandler.postRegistro + "users/me/interest", method: .put, parameters: parameters, headers: networkHandler.headersHTTP)
        
    }
    
    func acceptTerms() {
        Alamofire.request(networkHandler.postRegistro + "users/me/acceptlegaltext", method: .post, headers: networkHandler.headersHTTP)
    }
    
    //el password tiene que ser mandado como un string en sh512, no? tb: el nombre del parametro es password (asumo)
    func changePassword(newPass: String) {
        let parameters: Parameters = [
            "actualPassword": self.defaults.value(forKey: "myPW")!,
            "newPassword": newPass.sha512()
        ]
        Alamofire.request(networkHandler.postRegistro + "users/me/modifypassword", method: .put, parameters: parameters, headers: networkHandler.headersHTTP)
    }
    
    func updateUserData(name: String, surname: String, email: String) {
        let parameters: Parameters = [
            "name": name,
            "surname": surname,
            "email": email
        ]
        
        Alamofire.request(networkHandler.postRegistro + "users/me", method: .put, parameters: parameters, headers: networkHandler.headersHTTP)
    }

    func getNewToken() {
        let parameters: Parameters = [
            "clientCode": "FGDS2",
            "email": self.defaults.value(forKey: "myEmail")!,
            "password": (self.defaults.value(forKey: "myNewPW") as! String)
        ]
        
        Alamofire.request(networkHandler.usersURL+"loginuser", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: networkHandler.headerJSON).responseJSON { response in
            print("Request: \(String(describing: response.request))")   // original url request
            print("Response: \(String(describing: response.response))") // http url response
            print("Result: \(response.result)")                         // response serialization result
            if let json = response.result.value {
                if let dictionary = json as? [String: Any] {
                    if let token = dictionary["authToken"] as? String {
                        print("Tokn!! \(token)")
                        self.networkHandler.saveToken(myToken: token)
                        print(self.defaults.value(forKey: "myAuthToken"))
                        self.defaults.set(true, forKey: "gotSecondToken")
                    }
                } else {
                    print("Error getting authToken!")
                }
            }
        }
    }
    
}
