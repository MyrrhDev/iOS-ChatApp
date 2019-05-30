//
//  NewUsersView.swift
//  ioszone
//
//  Created by Mayra on 23/04/2019.
//  Copyright © 2019 Mayra. All rights reserved.
//

import UIKit
import CoreData
import InitialsImageView

class NewUsersView: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var defaults = UserDefaults()
    var myID: Int!
    var usersFiltered = [UsersCore]()
    
    var dataProvider: DataProvider = {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        let managedContext = appDelegate?.persistentContainer
        var dataProv = DataProvider(persistentContainer: managedContext!, repository: DataRepository.shared)
        return dataProv
    }()
    
    lazy var fetchedResultsController: NSFetchedResultsController<UsersCore> = {
        myID = self.defaults.integer(forKey: "myID")
        let fetchRequest = NSFetchRequest<UsersCore>(entityName:"UsersCore")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending:true)]
        fetchRequest.predicate = NSPredicate(format: "idUser != %i", myID)
        let controller = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                    managedObjectContext: dataProvider.viewContext,
                                                    sectionNameKeyPath: nil, cacheName: nil)
        controller.delegate = self
        
        do {
            try controller.performFetch()
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
        
        return controller
    }()
    
    private let cellId = "cellId"


    let usersTable: UITableView = {
        let tv = UITableView()
        tv.backgroundColor = UIColor.white
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    func setupTableView() {
        usersTable.register(UserCell.self, forCellReuseIdentifier: cellId)
        view.addSubview(usersTable)
        NSLayoutConstraint.activate([
            usersTable.topAnchor.constraint(equalTo: self.view.topAnchor),
            usersTable.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            usersTable.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            usersTable.leftAnchor.constraint(equalTo: self.view.leftAnchor)
            ])
        self.usersTable.alwaysBounceVertical = true
        self.usersTable.backgroundColor = UIColor.white
        self.usersTable.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 50, right: 0)
        self.usersTable.separatorStyle = .none
        self.usersTable.scrollsToTop = false
    }
    
    
    var searchController: UISearchController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        usersTable.delegate = self
        usersTable.dataSource = self
        setupTableView()
        tabBarController?.tabBar.isHidden = true

        // Setup the Search Controller
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Users"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        
        /* Esto arregla en general que se vacie fetchedResultsController
         las extensions no son el problema... parece que de fetch le mandan
         erroneamente algo de que los borre... type .delete decia
        dataProvider.fetchUsers { (error) in
            print(error)
            // Handle Error by displaying it in UI
        }*/
   
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
            let placeholderString = NSAttributedString(string: "Search Users", attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
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
        
        /*
         super.viewDidAppear(animated)
         print("viewDidAppearCR")
         if #available(iOS 11.0, *) {
         //navigationItem.hidesSearchBarWhenScrolling = true
         }*/
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
   /*
    func setupNavigationBarItems() {
        let searchButton = UIButton(type: .system)
        searchButton.setImage(#imageLiteral(resourceName: "search").withRenderingMode(.alwaysOriginal), for: .normal)
        searchButton.frame = CGRect(x: 0, y: 0, width: 34, height: 34)
        searchButton.addTarget(self, action: #selector(handleSearch), for: .touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: searchButton)
    }*/
    
    func searchBarIsEmpty() -> Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        //myID = self.defaults.integer(forKey: "myID")
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        let managedContext = appDelegate?.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<UsersCore>(entityName:"UsersCore")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending:true)]
        fetchRequest.predicate = NSPredicate(format: "(idUser != %i) AND (name CONTAINS[c] %@)", myID, searchText.lowercased())
        do {
            usersFiltered = try managedContext!.fetch(fetchRequest)
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
        
        usersTable.reloadData()
    }
    
    func isFiltering() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering() {
            return usersFiltered.count
        }
        //let tab = self.usersTable.frame

        //print("numberOfRowsInSection: \(fetchedResultsController.sections?[section].numberOfObjects)")
        return fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        //print("numberOfSections: \(fetchedResultsController.sections?.count)")
        return fetchedResultsController.sections?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! UserCell
        let user: UsersCore
        if isFiltering() {
            user = usersFiltered[indexPath.row]
        } else {
            user = fetchedResultsController.object(at: indexPath)
        }
        cell.userPhoto.frame = CGRect(x: 8, y: 0, width: 30, height: 30)
        cell.userPhoto.setImageForName(user.nameForImageView!, circular: true, textAttributes: nil)
        cell.userName.text = user.name
        cell.statusText.text = "Some status"
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var userRoom: UsersCore
        if(isFiltering()){
            userRoom = usersFiltered[indexPath.row]
            
        } else {
           userRoom = fetchedResultsController.object(at: indexPath)
        }
        
        let controller = NewSingleChatController()
        controller.groupName = userRoom.name
        controller.userID = Int(userRoom.idUser)//to fetch CoreData
        navigationController?.pushViewController(controller, animated: true)
        
    }
    
    
    
    
}

extension NewUsersView: NSFetchedResultsControllerDelegate {
     func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
         print("type:\(type) ")
         if type == .insert {
         usersTable.reloadData()
     }
    }
}


extension NewUsersView: UISearchResultsUpdating {
    // MARK: - UISearchResultsUpdating Delegate
     func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
     }
}

