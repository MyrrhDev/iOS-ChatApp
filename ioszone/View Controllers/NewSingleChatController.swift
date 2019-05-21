//
//  NewSingleChatController.swift
//  ioszone
//
//  Created by Mayra on 29/04/2019.
//  Copyright © 2019 Mayra. All rights reserved.
//


import Foundation
import UIKit
import CoreData

class NewSingleChatController: UIViewController, UITableViewDelegate,  UITableViewDataSource, InputViewDelegate {
    func loadOptions() {
        let options = UIAlertController(title: nil,
                                        message: nil,
                                        preferredStyle: .actionSheet)
        
        options.addAction(UIAlertAction(title: "Take Photo or Video", style: .default, handler: { (_) in
            print("User click Take Photo or Video")
        }))
        options.addAction(UIAlertAction(title: "Photo/Video Library", style: .default, handler: { (_) in
            print("User click Photo/Video Library")
        }))
        options.addAction(UIAlertAction(title: "Share Location", style: .default, handler: { (_) in
            print("User click Share Location")
        }))
        options.addAction(UIAlertAction(title: "Share Contact", style: .default, handler: { (_) in
            print("User click Share Contact")
        }))
        options.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: { (_) in
            print("User click Dismiss button")
        }))
        self.present(options, animated: true)
    }
    
    
    func reloadView() {
        emoticonKeyboard = true
        var contentInset = self.tableView.contentInset
        contentInset.bottom = 346 + 50
        self.tableView.contentInset = contentInset
        self.tableView.scrollToBottomRow()
    }
    
    private let cellId = "cellId"
    var messages = [MessageCore]()
    var chatMessages = [[MessageCore]]()
    var thisUser = UsersCore()
    var keyboardInput = InputView()
    var theirUser = UsersCore()
    
    var groupName: String!
    var userID: Int!
    var myID: Int!
    var defaults = UserDefaults()
    var bottomConstraint: NSLayoutConstraint?
    var emoticonKeyboard: Bool?
   
    let tableView: UITableView = {
        let tv = UITableView()
        tv.backgroundColor = UIColor.white
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    func setupTableView() {
        tableView.register(OneToOneCell.self, forCellReuseIdentifier: cellId)
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: self.view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            tableView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            tableView.leftAnchor.constraint(equalTo: self.view.leftAnchor)
            ])
        self.tableView.alwaysBounceVertical = true
        self.tableView.backgroundColor = UIColor.white
        self.tableView.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 50, right: 0)
        self.tableView.separatorStyle = .none
    }
  
    func messageWasSent(message: String) {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        let managedContext = appDelegate?.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "MessageCore", in: managedContext!)!
        let theMessage = NSManagedObject(entity: entity, insertInto: managedContext)
        
        theMessage.setValue(Date(), forKeyPath: "dateTime")
        theMessage.setValue(message, forKeyPath: "messageSent")
        theMessage.setValue(userID, forKeyPath: "userIDReceiver")
        theMessage.setValue(userID, forKeyPath: "idUser")
        theMessage.setValue(Date().toString(dateFormat: "HH:MM"), forKeyPath: "time")
        theMessage.setValue(Date().toString(dateFormat: "dd-MMM-yyyy"), forKeyPath: "date")
        theMessage.setValue(theirUser, forKey: "user")
        
        do {
            try managedContext!.save()
            self.messages.append(theMessage as! MessageCore)
            attemptToAssembleGroupedMessages()
            self.tableView.reloadData()
            self.tableView.scrollToBottomRow()
            createNewRoom()
        } catch let err {
            print(err)
        }
    }
    
    //if room with User doesnt exist, create new RoomCore
    func createNewRoom() {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        let managedContext = appDelegate?.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<RoomCore>(entityName:"RoomCore")
        fetchRequest.predicate = NSPredicate(format: "idRoom == %i", userID)
        
        var fetchedRoom = [RoomCore]()
        do {
            fetchedRoom = try (managedContext?.fetch(fetchRequest))!
        } catch let err {
            print(err)
        }
        
        if(fetchedRoom.count == 0) {
            let entity = NSEntityDescription.entity(forEntityName: "RoomCore", in: managedContext!)!
            let newRoom = NSManagedObject(entity: entity, insertInto: managedContext)
            
            var tempUser = [UsersCore]()
            let appDelegate = UIApplication.shared.delegate as? AppDelegate
            let managedContext = appDelegate?.persistentContainer.viewContext
            let fetchRequest: NSFetchRequest<UsersCore> = UsersCore.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "idUser == %i", userID)
            do {
                tempUser = try managedContext!.fetch(fetchRequest)
            } catch let error as NSError {
                print("Could not fetch Messages. \(error), \(error.userInfo)")
            }
            
            if(tempUser.count != 0) {
                thisUser = tempUser[0]
            }
            
            newRoom.setValue(thisUser.name, forKey: "name")
            newRoom.setValue(thisUser.idUser, forKey: "idRoom")
            newRoom.setValue(1, forKey: "membersCount")
            newRoom.setValue(true, forKey: "human")
            
            do {
                try managedContext!.save()
            } catch let error as NSError {
                print(error)
            }
            
        }
    }
    
  
    fileprivate func attemptToAssembleGroupedMessages() {
        //print("Attempt to group our messages together based on Date property")
        let groupedMessages = Dictionary(grouping: messages) { (element) -> Date in
            return ((element.dateTime) as! Date).reduceToMonthDayYear()
        }
        // provide a sorting for your keys somehow
        let sortedKeys = groupedMessages.keys.sorted()
        sortedKeys.forEach { (key) in
            let values = groupedMessages[key]
            chatMessages.append(values ?? [])
        }
    }
    
    func getMyUserCore() {
        var tempUser = [UsersCore]()
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        let managedContext = appDelegate?.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<UsersCore> = UsersCore.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "idUser == %i", myID)
        do {
            tempUser = try managedContext!.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch Messages. \(error), \(error.userInfo)")
        }
        
        if(tempUser.count != 0) {
            thisUser = tempUser[0]
        }
    }
    
    func getTheirUserCore() {
        var tempUser = [UsersCore]()
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        let managedContext = appDelegate?.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<UsersCore> = UsersCore.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "idUser == %i", userID)
        do {
            tempUser = try managedContext!.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch Messages. \(error), \(error.userInfo)")
        }
        
        if(tempUser.count != 0) {
            theirUser = tempUser[0]
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = groupName
        tabBarController?.tabBar.isHidden = true
        self.tableView.delegate = self
        self.tableView.dataSource = self
        setupTableView()
        myID = defaults.integer(forKey: "myID")
        getMyUserCore()
        getTheirUserCore()
        
        keyboardInput.delegate = self
        emoticonKeyboard = false
        
        setupRightNavItems()
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.barTintColor = UIColor.red
        navigationController?.navigationBar.tintColor = UIColor.white
        navigationController?.navigationBar.isTranslucent = false
        
        
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        let managedContext = appDelegate?.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<MessageCore> = MessageCore.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "(idUser == %i) OR (userIDReceiver == %i)", userID, userID)
        do {
            messages = try managedContext!.fetch(fetchRequest)
            attemptToAssembleGroupedMessages()
            if(messages.count != 0) {
                let indexPath = IndexPath(item: self.chatMessages[self.chatMessages.count-1].count - 1, section: self.chatMessages.count-1)
                self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: false)
            }
            
        } catch let error as NSError {
            print("Could not fetch Messages. \(error), \(error.userInfo)")
        }
        //Input&Keyboard
        view.addSubview(keyboardInput)
        view.addConstraintsWithFormat(format: "H:|[v0]|", views: keyboardInput)
        view.addConstraintsWithFormat(format: "V:[v0(48)]", views: keyboardInput)
        bottomConstraint = NSLayoutConstraint(item: keyboardInput, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0)
        view.addConstraint(bottomConstraint!)
        //setupInputComponents()
        keyboardInput = InputView(frame: CGRect(x: view.frame.height - 48, y: 0, width: view.frame.width, height: 48))
        self.tableView.scrollToBottomRow()
    }
    
    @objc func handleKeyboardNotification(_ notification: Notification) {
        if let userInfo = notification.userInfo {
            let keyboardFrame: NSValue = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)!
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            let isKeyboardShowing = notification.name == UIResponder.keyboardWillShowNotification
            bottomConstraint?.constant = isKeyboardShowing ? -keyboardRectangle.height : 0
            UIView.animate(withDuration: 0, delay: 0, options: UIView.AnimationOptions.curveEaseOut, animations: {
                self.view.layoutIfNeeded()
            }, completion: { (completed) in
                if isKeyboardShowing {
                    var contentInset = self.tableView.contentInset
                    contentInset.bottom = keyboardRectangle.height + 50
                    self.tableView.contentInset = contentInset
                    self.tableView.scrollToBottomRow()
                } else if (!self.emoticonKeyboard!) {
                    var contentInset = self.tableView.contentInset
                    contentInset.bottom = 50
                    self.tableView.contentInset = contentInset
                    self.tableView.scrollToBottomRow()
                }
            })
        }
    }
    
    func setupRightNavItems() {
        let salirButton = UIButton(type: .system)
        salirButton.setTitle("Salir", for: .normal)
        salirButton.setTitleColor(.white, for: .normal)
        salirButton.frame = CGRect(x: 0, y: 0, width: 50, height: 30)
        salirButton.addTarget(self, action: #selector(salirRoom), for: .touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: salirButton)
    }
    
    @objc func salirRoom() {
        let alert = UIAlertController(title: "¿Estas seguro que quieres salir?",
                                      message: "Se borraran todos los mensajes",
                                      preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title:  "Si", style: .destructive, handler: leaveSingleChat))
        alert.addAction(UIAlertAction(title: "No", style: .default))
        
        self.present(alert, animated: true)
    }
    
    func leaveSingleChat(action: UIAlertAction) {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        let managedContext = appDelegate?.persistentContainer.viewContext
        
        let msgsFetchRequest = NSFetchRequest<MessageCore>(entityName: "MessageCore")
        msgsFetchRequest.predicate = NSPredicate(format: "idUser == %i OR userIDReceiver == %i", userID, userID)
        
        do {
            let testMsgs = try managedContext?.fetch(msgsFetchRequest)
             if(testMsgs!.count != 0) {
                for msgs in testMsgs! {
                    managedContext?.delete(msgs)
                    do {
                        try managedContext?.save()
                    } catch {
                        print(error)
                    }
                }
            }
        } catch {
            print(error)
        }
        
        
        let fetchRequest = NSFetchRequest<RoomCore>(entityName:"RoomCore")
        fetchRequest.predicate = NSPredicate(format: "idRoom == %i", userID)
        
        do {
            let test = try managedContext?.fetch(fetchRequest)
            if(test!.count != 0) {
                let thisRoom = test![0] as! RoomCore
                managedContext?.delete(thisRoom)
            }
            
            do {
                try managedContext?.save()
            } catch {
                print(error)
            }
        } catch {
            print(error)
        }
        
        self.navigationController?.isNavigationBarHidden = true
        self.show(CustomTabBarController(), sender: nil)
        }
        
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if let firstMessageInSection = chatMessages[section].first {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy"
            let dateString = dateFormatter.string(from: firstMessageInSection.dateTime as! Date)
            let label = DateHeaderLabel()
            label.text = dateString
            let containerView = UIView()
            containerView.addSubview(label)
            label.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
            label.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
            
            return containerView
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        emoticonKeyboard = false
        view.endEditing(true)
        //self.keyboardInput.hide()
        //self.keyboardInput.inputTextField.endEditing(true)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return chatMessages.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return self.messages.count
        return chatMessages[section].count
    }
    
    
    fileprivate func makeReceiveCell(_ cell: OneToOneCell, _ estimatedFrame: CGRect, _ testFrame: CGRect) {
        cell.messageTextView.frame = CGRect(x: 23, y: 0, width: estimatedFrame.width + 16, height: estimatedFrame.height + 20)
        cell.timeTextView.frame = CGRect(x: estimatedFrame.width, y: estimatedFrame.height + 7, width: testFrame.width + 10, height: testFrame.height + 10)
        cell.textBubbleView.frame = CGRect(x: 5, y: -4, width: estimatedFrame.width + testFrame.width + 15, height: estimatedFrame.height + 20 + 6 + 10)
        cell.timeTextView.textColor = UIColor.black
        cell.bubbleImageView.image = OneToOneCell.grayBubbleImage
        cell.bubbleImageView.tintColor = UIColor(white: 0.90, alpha: 1)
        cell.messageTextView.textColor = UIColor.black
    }
    
    fileprivate func makeSendingCell(_ cell: OneToOneCell, _ estimatedFrame: CGRect, _ testFrame: CGRect) {
        //outgoing sending message
        cell.timeTextView.textColor = UIColor.white
        cell.messageTextView.frame = CGRect(x: view.frame.width - estimatedFrame.width - testFrame.width - 10 - 5, y: 0, width: estimatedFrame.width + 16, height: estimatedFrame.height + 20)
        cell.timeTextView.frame = CGRect(x: view.frame.width - estimatedFrame.width - testFrame.width - 15, y: estimatedFrame.height + 7, width: testFrame.width + 10, height: testFrame.height + 10)
        cell.textBubbleView.frame = CGRect(x: view.frame.width - estimatedFrame.width - testFrame.width - 30, y: -4, width: estimatedFrame.width + testFrame.width + 5 + 22, height: estimatedFrame.height + 20 + 6 + 10)
        cell.bubbleImageView.image = OneToOneCell.blueBubbleImage
        cell.bubbleImageView.tintColor = UIColor(red: 255/255, green: 0, blue: 0, alpha: 1)
        cell.messageTextView.textColor = UIColor.white
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! OneToOneCell
        cell.messageTextView.text = chatMessages[indexPath.section][indexPath.row].messageSent
        let size = CGSize.init(width: 180, height: 1000)//edit how far bubble can go
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        let estimatedFrame = NSString(string: chatMessages[indexPath.section][indexPath.row].messageSent!).boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12)], context: nil)
        
        let thisDateTime = chatMessages[indexPath.section][indexPath.row].time!
        cell.timeTextView.text = thisDateTime
        
        let testFrame = NSString(string: thisDateTime).boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 7)], context: nil)
        
        if(self.chatMessages[indexPath.section][indexPath.row].userIDReceiver == myID) {
            makeReceiveCell(cell, estimatedFrame, testFrame)
            
        } else {
            makeSendingCell(cell, estimatedFrame, testFrame)
        }
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if let messageText = chatMessages[indexPath.section][indexPath.row].messageSent {
            let size = CGSize.init(width: 180, height: 1000) //CGSizeMake(250, 1000)
            let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
            let estimatedFrame = NSString(string: messageText).boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12)], context: nil)
            
            return CGFloat.init(estimatedFrame.height + 40)
        }
        return CGFloat.init(100)
    }
}
