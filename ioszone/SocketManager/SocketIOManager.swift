////
////  SocketIOManager.swift
////  ioszone
////
////  Created by Mayra on 19/02/2019.
////  Copyright © 2019 Mayra. All rights reserved.
////
//
//import UIKit
//import SocketIO
//
//class SocketIOManager: NSObject {
//    static let sharedInstance = SocketIOManager()
//    //var manager: SocketManager = SocketManager(socketURL: URL(string: "https://zonetactsbackend-pre-env-1.eu-west-1.elasticbeanstalk.com:8082/100")!)
//    //var manager: SocketManager = SocketManager(socketURL: URL(string: "http://172.20.39.191:3000")!)
//
//    var socket: SocketIOClient!
//
//    override init() {
//        //socket = manager.defaultSocket
//        super.init()
//
//        socket.on("connect") {data, ack in
//            print("socket connected")
//        }
//
//
//    }
//
//
//    func establishConnection() {
//        socket.connect()
//    }
//
//
//    func closeConnection() {
//        socket.disconnect()
//    }
//
//    //Change nickname to pulled name from database
//    func connectToServerWithNickname(nickname: String, completionHandler: @escaping (_ userList: [[String: AnyObject]]?) -> Void) {
//        //mandar email
//        socket.emit("connectUser", nickname)
//
//        ///esto igual ya no es necesario porque we'll pull sus actives chats, no una userlist
//        socket.on("userList") { ( dataArray, ack) -> Void in
//            completionHandler(dataArray[0] as! [[String: AnyObject]])
//        }
//
//        listenForOtherMessages()
//    }
//
//    //Change nickname to pulled name from database
//    func exitChatWithNickname(nickname: String, completionHandler: () -> Void) {
//        socket.emit("exitUser", nickname)
//        completionHandler()
//    }
//
//
//    func sendMessage(message: String, withNickname nickname: String) {
//        socket.emit("chatMessage", nickname, message)
//    }
//
//
//    func getChatMessage(completionHandler: @escaping (_ messageInfo: [String: AnyObject]) -> Void) {
//        socket.on("newChatMessage") { (dataArray, socketAck) -> Void in
//            var messageDictionary = [String: AnyObject]()
//            messageDictionary["nickname"] = dataArray[0] as! String as AnyObject
//            messageDictionary["message"] = dataArray[1] as! String as AnyObject
//            messageDictionary["date"] = dataArray[2] as! String as AnyObject
//
//            completionHandler(messageDictionary)
//        }
//    }
//
//
//    private func listenForOtherMessages() {
//        socket.on("userConnectUpdate") { (dataArray, socketAck) -> Void in
//            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "userWasConnectedNotification"),object: dataArray[0] as! [String: AnyObject])
//        }
//
//        socket.on("userExitUpdate") { (dataArray, socketAck) -> Void in
//            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "userWasDisconnectedNotification"),object: dataArray[0] as! [String: AnyObject])
//        }
//
//        socket.on("userTypingUpdate") { (dataArray, socketAck) -> Void in
//            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "userTypingNotification"),object: dataArray[0] as! [String: AnyObject])
//        }
//    }
//
//
//    func sendStartTypingMessage(nickname: String) {
//        socket.emit("startType", nickname)
//    }
//
//
//    func sendStopTypingMessage(nickname: String) {
//        socket.emit("stopType", nickname)
//    }
//}
