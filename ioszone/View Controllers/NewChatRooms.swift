//
//  NewChatRooms.swift
//  ioszone
//
//  Created by Mayra on 25/04/2019.
//  Copyright © 2019 Mayra. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import CoreData
import InitialsImageView


class NewChatRooms: UITableViewController, UISearchBarDelegate {
    private let cellId = "cellId"
    private let cellId2 = "cellId2"
    private let cellId3 = "cellId3"


    var defaults = UserDefaults()
    var roomsFiltered = [RoomCore]()
    var usersFiltered = [UsersCore]()
    var messagesFiltered = [MessageCore]()

    var myID: Int!
    
    var blockOperations = [BlockOperation]()
    var allRooms = [RoomCore]()
    //var allMsgs = [MessageCore]()

    var dataProvider: DataProvider = {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        let managedContext = appDelegate?.persistentContainer
        var dataProv = DataProvider(persistentContainer: managedContext!, repository: DataRepository.shared)
        return dataProv
    }()
    
//    lazy var fetchedResultsController: NSFetchedResultsController<RoomCore> = {
//        let fetchRequest = NSFetchRequest<RoomCore>(entityName:"RoomCore")
//        //fetchRequest.sortDescriptors = [NSSortDescriptor(key: "idRoom", ascending:true)]
////        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "idRoom.message.dateTime", ascending:true)]
////        fetchRequest.fetchLimit = 1
//       let controller = NSFetchedResultsController(fetchRequest: fetchRequest,
//                                                    managedObjectContext: dataProvider.viewContext,
//                                                    sectionNameKeyPath: nil, cacheName: nil)
//        //controller.delegate = self
//
//        do {
//            try controller.performFetch()
//
//        } catch {
//            let nserror = error as NSError
//            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
//        }
//
//        return controller
//    }()
    
    
    fileprivate func infoForTable() -> [MessageCore] {
        var tempMsgs = [MessageCore]()
        let roomsFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "RoomCore")
        var fetchedRooms = [RoomCore]()
        do {
            fetchedRooms = try dataProvider.viewContext.fetch(roomsFetch) as! [RoomCore]
        } catch {
            fatalError("Failed to fetch Msgs rooms: \(error)")
        }
        for room in fetchedRooms {
            let fetchRequest = NSFetchRequest<MessageCore>(entityName:"MessageCore")
            fetchRequest.sortDescriptors = [NSSortDescriptor(key: "dateTime", ascending:false)]
            if (room.human) {
                fetchRequest.predicate = NSPredicate(format: "idUser == %i", room.idRoom)
            } else {
                fetchRequest.predicate = NSPredicate(format: "idRoom == %i", room.idRoom)
            }
            fetchRequest.fetchLimit = 1
            
            
            do {
                let fetchedMessages = try dataProvider.viewContext.fetch(fetchRequest)
                if(fetchedMessages.count != 0) {
                    tempMsgs.append(fetchedMessages[0])
                }
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
        tempMsgs.sort ( by: {$0.dateTime!.compare($1.dateTime! as Date) == .orderedDescending})
        
        return tempMsgs
    }
    
    lazy var allMsgs: [MessageCore] = {
        return infoForTable()
    }()
    
//    lazy var fetchedResultsController2: NSFetchedResultsController<MessageCore> = {
//        let fetchRequest = NSFetchRequest<MessageCore>(entityName:"MessageCore")
//
//        fetchRequest.predicate = NSPredicate(format: "idRoom == %i", <#T##args: CVarArg...##CVarArg#>)
//        //fetchRequest.sortDescriptors = [NSSortDescriptor(key: "idRoom.message.dateTime", ascending:true)]
//        fetchRequest.fetchLimit = 1
//
//
//        let controller = NSFetchedResultsController(fetchRequest: fetchRequest,
//                                                    managedObjectContext: dataProvider.viewContext,
//                                                    sectionNameKeyPath: nil, cacheName: nil)
//        //controller.delegate = self
//
//        do {
//            try controller.performFetch()
//            //self.tableView.reloadData()
//        } catch {
//            let nserror = error as NSError
//            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
//        }
//
//        return controller
//    }()

    var searchController: UISearchController?

    fileprivate func setupSearchBar() {
        searchController = UISearchController(searchResultsController: nil)
        searchController?.searchResultsUpdater = self
        searchController?.obscuresBackgroundDuringPresentation = false
        searchController?.searchBar.placeholder = "Search Rooms"
        navigationItem.hidesSearchBarWhenScrolling = true
        definesPresentationContext = true
        navigationItem.searchController = searchController
        searchController?.searchBar.delegate = self
    }
    
    fileprivate func setupTableView() {
        self.tableView.register(AllChatsCell.self, forCellReuseIdentifier: cellId)
        self.tableView.register(UserCell.self, forCellReuseIdentifier: cellId2)
        self.tableView.register(MessageCell.self, forCellReuseIdentifier: cellId3)

        self.tableView.backgroundColor = .white
        self.tableView.alwaysBounceVertical = true
        self.tableView.tableFooterView = UIView()
        self.tableView.scrollsToTop = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchBar()
        setupNavigationBarItems()
        setupTableView()
        myID = self.defaults.integer(forKey: "myID")
        
//        dataProvider.fetchRooms { (error) in
//            print(error)
//        }
//        dataProvider.fetchUsers { (error) in
//            print(error)
//        }
//        dataProvider.fetchUsersChatting { (error) in
//            print(error)
//        }
//        dataProvider.fetchRoomMessages { (error) in
//            print(error)
//        }
//        dataProvider.fetchHumanMessages { (error) in
//            print(error)
//        }
        
        print("viewdidload")
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("view will appear")
        
        allMsgs = infoForTable()
        
        self.tableView.reloadData()
        tabBarController?.tabBar.isHidden = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //sets navigationbar backgroundColor
        /*if let navigationbar = self.navigationController?.navigationBar {
            navigationbar.barTintColor = UIColor.magenta
        }*/
        
        let searchField = searchController?.searchBar.value(forKey: "searchField") as? UITextField
        //sets searchBar backgroundColor
        //searchController?.searchBar.backgroundColor = .blue
        
        if let field = searchField {
            field.layer.cornerRadius = 15.0
            //sets text Color
            field.textColor = .black
            //sets indicator and cancel button Color
            field.tintColor = .black
            field.font = UIFont.systemFont(ofSize: 13)
            field.layer.masksToBounds = true
            field.returnKeyType = .search
            //sets placeholder text Color
            let placeholderString = NSAttributedString(string: "Search", attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
            field.attributedPlaceholder = placeholderString
            //sets icon Color
            let iconView = field.leftView as! UIImageView
            iconView.image = iconView.image?.withRenderingMode(.alwaysTemplate)
            iconView.tintColor = .gray
            //sets textField backgroundColor
            if let backgroundview = field.subviews.first {
                backgroundview.backgroundColor = UIColor.white
            }
        }
    }
    
    @objc func keyboardHide() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        }, completion: nil)
        view.endEditing(true)
        
    }
    
    func setupNavigationBarItems() {
        setupRightNavItems()
        navigationController?.navigationBar.barTintColor = UIColor.red
        navigationController?.navigationBar.tintColor = UIColor.white
        navigationController?.navigationBar.isTranslucent = false
        
        self.navigationItem.leftBarButtonItem = nil
        self.navigationItem.hidesBackButton = true
    }
    
    private func setupRightNavItems() {
        let newMessageButton = UIButton(type: .system)
        newMessageButton.setImage(#imageLiteral(resourceName: "write_msg").withRenderingMode(.alwaysTemplate), for: .normal)
        newMessageButton.frame = CGRect(x: 0, y: 0, width: 10, height: 10)
        newMessageButton.addTarget(self, action: #selector(sendToUsersView), for: .touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: newMessageButton)
    }
    
    @objc func sendToUsersView() {
        let controller = NewUsersView()
        self.navigationController?.pushViewController(controller, animated: false)
    }
    
    func searchBarIsEmpty() -> Bool {
        return searchController?.searchBar.text?.isEmpty ?? true
    }
    
    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        //myID = self.defaults.integer(forKey: "myID")
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        let managedContext = appDelegate?.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<RoomCore>(entityName:"RoomCore")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending:true)]
        fetchRequest.predicate = NSPredicate(format: "name CONTAINS[c] %@", searchText.lowercased())
        
        let fetchRequest2 = NSFetchRequest<UsersCore>(entityName:"UsersCore")
        fetchRequest2.sortDescriptors = [NSSortDescriptor(key: "name", ascending:true)]
        fetchRequest2.predicate = NSPredicate(format: "(idUser != %i) AND (name CONTAINS[c] %@)", myID, searchText.lowercased())
        
        let fetchRequest3 = NSFetchRequest<MessageCore>(entityName:"MessageCore")
        fetchRequest3.sortDescriptors = [NSSortDescriptor(key: "idRoom", ascending:true)]
        fetchRequest3.predicate = NSPredicate(format: "messageSent CONTAINS[c] %@", searchText.lowercased())
        
        do {
            roomsFiltered = try managedContext!.fetch(fetchRequest)
            usersFiltered = try (managedContext?.fetch(fetchRequest2))!
            messagesFiltered = try managedContext!.fetch(fetchRequest3)
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
        
        tableView.reloadData()
    }
    
    func isFiltering() -> Bool {
        return (searchController?.isActive)! && !searchBarIsEmpty()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering() {
            if (section == 0) {
                if (roomsFiltered.count != 0) {
                    return roomsFiltered.count
                } else {
                    if (usersFiltered.count != 0) {
                        return usersFiltered.count
                    } else {
                        if (messagesFiltered.count != 0) {
                            return messagesFiltered.count
                        }
                    }
                }
            } else if (section == 1) {
                if (usersFiltered.count != 0) {
                    return usersFiltered.count
                } else {
                    if (messagesFiltered.count != 0) {
                        return messagesFiltered.count
                    }
                }
            } else {
                if (messagesFiltered.count != 0) {
                    return messagesFiltered.count
                }
            }
        }
        return allMsgs.count
    }
    
    /*
    override func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsController.sections?.count ?? 0
    }*/
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        if isFiltering() {
            if(roomsFiltered.count == 0 && usersFiltered.count == 0 && messagesFiltered.count == 0) {
                return 0
            }

            if(!roomsFiltered.isEmpty && !usersFiltered.isEmpty && !messagesFiltered.isEmpty) {
                print("number 3")
                    return 3
            } else if ((!roomsFiltered.isEmpty && !usersFiltered.isEmpty && messagesFiltered.isEmpty) || (roomsFiltered.isEmpty && !usersFiltered.isEmpty && !messagesFiltered.isEmpty) || (!roomsFiltered.isEmpty && usersFiltered.isEmpty && !messagesFiltered.isEmpty)) {
                print("number 2")
                return 2
            } else {
                print("1")
                return 1
            }
        }
        return 1
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var title: String
        if isFiltering() {
            if(roomsFiltered.count == 0 && usersFiltered.count == 0 && messagesFiltered.count == 0) {
                return "No hay resultados"
            }
            
            if (section == 0) {
                if (!roomsFiltered.isEmpty) {
                    return "Rooms"
                } else {
                    if (!usersFiltered.isEmpty) {
                        return "Users"
                    } else {
                        if (!messagesFiltered.isEmpty) {
                            return "Messages"
                        }
                    }
                }
            } else if (section == 1) {
                if (!roomsFiltered.isEmpty && !usersFiltered.isEmpty) {
                    return "Users"
                } else {
                    if (roomsFiltered.isEmpty && !usersFiltered.isEmpty && !messagesFiltered.isEmpty || !roomsFiltered.isEmpty && usersFiltered.isEmpty && !messagesFiltered.isEmpty) {
                        return "Messages"
                    }
                }
            } else if (section == 2) {
                if (!messagesFiltered.isEmpty) {
                    return "Messages"
                }
            }
        }
        title = ""
        return title
    }
    
    fileprivate func createRoomRoomCell(_ cell: AllChatsCell, _ message: MessageCore) {
        cell.userPhoto.frame = CGRect(x: 8, y: 0, width: 40, height: 40)
        if (message.room != nil) {
            cell.userPhoto.setImageForName(message.room?.name ?? "Loading", circular: true, textAttributes: nil)
            cell.userName.text = message.room?.name
        } else {
            cell.userPhoto.setImageForName(message.user?.name ?? "Loading", circular: true, textAttributes: nil)
            cell.userName.text = message.user?.name
        }
        
        cell.userLastMsg.text = message.messageSent
        if (Calendar.current.isDateInToday(message.dateTime! as Date) ) {
            cell.dateTime.text = message.time
        } else {
            cell.dateTime.text = message.date
        }
        
    }
    
    
    fileprivate func createRoomCell(_ cell: AllChatsCell, _ room: RoomCore) {
        cell.userPhoto.frame = CGRect(x: 8, y: 0, width: 40, height: 40)
        cell.userPhoto.setImageForName(room.name ?? "Loading", circular: true, textAttributes: nil)
        cell.userName.text = room.name
        
        //Function to fetch text from "most recent msg"
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "MessageCore")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "dateTime", ascending: false)]
        if (room.human) {
            fetchRequest.predicate = NSPredicate(format: "idUser == %i", room.idRoom)
        } else {
            fetchRequest.predicate = NSPredicate(format: "idRoom == %i", room.idRoom)
        }
        fetchRequest.fetchLimit = 1
        
        do {
            let fetchedMessage = try dataProvider.viewContext.fetch(fetchRequest) as? [MessageCore]
            if (fetchedMessage != nil && fetchedMessage?.count != 0) {
                cell.userLastMsg.text = fetchedMessage?[0].messageSent
                if (Calendar.current.isDateInToday(fetchedMessage?[0].dateTime! as! Date) ) {
                    cell.dateTime.text = fetchedMessage?[0].time
                } else {
                    cell.dateTime.text = fetchedMessage?[0].date
                }
            } else {
                //cell.userLastMsg?.text = "msg"
            }
        } catch let err {
            print(err)
        }
    }
    
    fileprivate func createUserCell(_ cell2: UserCell, _ user: UsersCore) {
        cell2.userPhoto.frame = CGRect(x: 8, y: 0, width: 30, height: 30)
        cell2.userPhoto.setImageForName(user.nameForImageView!, circular: true, textAttributes: nil)
        cell2.userName.text = user.name
        cell2.statusText.text = "Some status"
    }
    
    fileprivate func createMsgCell(_ message: MessageCore, _ cell3: MessageCell) {
        let fetchRequestU = NSFetchRequest<UsersCore>(entityName:"UsersCore")
        fetchRequestU.predicate = NSPredicate(format: "idUser == %i", message.idUser)
        fetchRequestU.fetchLimit = 1
        
        let fetchRequestR = NSFetchRequest<RoomCore>(entityName:"RoomCore")
        fetchRequestR.predicate = NSPredicate(format: "idRoom == %i", message.idRoom)
        fetchRequestR.fetchLimit = 1
        
        do {
            let fetchedUser = try dataProvider.viewContext.fetch(fetchRequestU) as? [UsersCore]
            let fetchedRoom = try dataProvider.viewContext.fetch(fetchRequestR) as? [RoomCore]
            if (fetchedUser != nil && fetchedUser?.count != 0) {
                cell3.userName.text = fetchedUser?[0].name
            } else if (fetchedRoom != nil && fetchedRoom?.count != 0) {
                cell3.userName.text = fetchedRoom?[0].name
            } else {
                cell3.userName.text = "Test Need Name"
            }
        } catch let err {
            print(err)
        }
        cell3.userLastMsg.text = message.messageSent
        cell3.dateTime.text = message.date
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! AllChatsCell
        var cell2 = tableView.dequeueReusableCell(withIdentifier: cellId2, for: indexPath) as! UserCell
        var cell3 = tableView.dequeueReusableCell(withIdentifier: cellId3, for: indexPath) as! MessageCell
        
        
        let user: UsersCore
        let room: RoomCore
        let message: MessageCore

        if isFiltering() {
            if(indexPath.section == 0) {
                if(roomsFiltered.count != 0) {
                    room = roomsFiltered[indexPath.row]
                    createRoomCell(cell, room)
                    return cell
                } else {
                    if(usersFiltered.count != 0) {
                        user = usersFiltered[indexPath.row]
                        createUserCell(cell2, user)
                        return cell2
                    } else {
                        if (messagesFiltered.count != 0) {
                            message = messagesFiltered[indexPath.row]
                            createMsgCell(message, cell3)
                            return cell3
                        }
                    }
                }
            } else if (indexPath.section == 1) {
                if(!roomsFiltered.isEmpty && !usersFiltered.isEmpty) {
                    user = usersFiltered[indexPath.row]
                    createUserCell(cell2, user)
                    return cell2
                } else {
                    if ((roomsFiltered.isEmpty && !usersFiltered.isEmpty && !messagesFiltered.isEmpty) || (!roomsFiltered.isEmpty && usersFiltered.isEmpty && !messagesFiltered.isEmpty)) {
                        message = messagesFiltered[indexPath.row]
                        createMsgCell(message, cell3)
                        return cell3
                    }
                }
            } else if (indexPath.section == 2) {
                if (!messagesFiltered.isEmpty) {
                    message = messagesFiltered[indexPath.row]
                    createMsgCell(message, cell3)
                    return cell3
                }
            }
        } else {
            message = allMsgs[indexPath.row]
            if (message.room == nil) {
                //createUserCell(cell2, message.user!)
                createRoomRoomCell(cell,message)
                return cell
            } else {
                createRoomCell(cell, message.room!)
            }
            
        }
        return cell
    }
        
    fileprivate func segueFromRoom(_ room: RoomCore) {
        if (room.human) {
            let controller = NewSingleChatController()
            controller.groupName = room.name
            controller.userID = Int(room.idRoom)//to fetch CoreData
            navigationController?.pushViewController(controller, animated: true)
        } else {  //room
            let controller = NewGroupChatController()
            controller.groupName = room.name
            controller.roomintID = Int(room.idRoom) //to fetch CoreData
            navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    fileprivate func segueFromMessage(_ message: MessageCore) {
        if (message.idUser != 0) {
            let controller = NewSingleChatController()
            controller.groupName = message.user?.name
            controller.userID = Int(message.idUser)//to fetch CoreData
            navigationController?.pushViewController(controller, animated: true)
        } else {  //room
            let controller = NewGroupChatController()
            controller.groupName = message.room?.name
            controller.roomintID = Int(message.idRoom) //to fetch CoreData
            navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       if isFiltering() {
        let user: UsersCore
        let room: RoomCore
        let message: MessageCore
        
        if(indexPath.section == 0) {
            if(roomsFiltered.count != 0) {
                room = roomsFiltered[indexPath.row]
                segueFromRoom(room)
            } else {
                if(usersFiltered.count != 0) {
                    user = usersFiltered[indexPath.row]
                    let controller = NewSingleChatController()
                    controller.groupName = user.name
                    controller.userID = Int(user.idUser)//to fetch CoreData
                    navigationController?.pushViewController(controller, animated: true)
                } else {
                    if (!messagesFiltered.isEmpty) {
                        message = messagesFiltered[indexPath.row]
                        segueFromMessage(message)
                    }
                }
            }
        } else if (indexPath.section == 1) {
            if(!roomsFiltered.isEmpty && !usersFiltered.isEmpty) {
                user = usersFiltered[indexPath.row]
                let controller = NewSingleChatController()
                controller.groupName = user.name
                controller.userID = Int(user.idUser)//to fetch CoreData
                navigationController?.pushViewController(controller, animated: true)
                
            } else {
                if ((roomsFiltered.isEmpty && !usersFiltered.isEmpty && !messagesFiltered.isEmpty) || !roomsFiltered.isEmpty && usersFiltered.isEmpty && !messagesFiltered.isEmpty) {
                    message = messagesFiltered[indexPath.row]
                    segueFromMessage(message)
                }
            }
        } else if (indexPath.section == 2) {
            if (!messagesFiltered.isEmpty) {
                message = messagesFiltered[indexPath.row]
                segueFromMessage(message)
                
            }
        }
       } else {
            let message = allMsgs[indexPath.row]
            if (message.room == nil && message.user != nil) {
                let controller = NewSingleChatController()
                controller.groupName = message.user?.name
                controller.userID = Int(message.user!.idUser)//to fetch CoreData
                navigationController?.pushViewController(controller, animated: true)
            } else {
                segueFromRoom(message.room!)
            }
        }
    }
 
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        
        
        return CGFloat.init(100)
    }
    
}

extension NewChatRooms: NSFetchedResultsControllerDelegate {
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        print("type:\(type) ")
        if type == .insert {
            tableView.reloadData()
        }
    }
}

extension NewChatRooms: UISearchResultsUpdating {
    // MARK: - UISearchResultsUpdating Delegate
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
}

/*
extension NewChatRooms: NSFetchedResultsControllerDelegate {
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        if type == .insert {
            blockOperations.append(BlockOperation(block: {
                self.tableView.insertRows(at: [newIndexPath! as IndexPath], with: .right)
            }))
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.performBatchUpdates({
            for operation in self.blockOperations {
            operation.start()
            }
        }, completion: { (completed) in
                
            let lastItem = self.fetchedResultsController.sections![0].numberOfObjects - 1
            let indexPath = NSIndexPath(item: lastItem, section: 0)
            self.tableView.scrollToRow(at: indexPath as IndexPath, at: .bottom, animated: true)
        })
    }
}*/
