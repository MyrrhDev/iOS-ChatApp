//
//  ConfigurationView.swift
//  ioszone
//
//  Created by Mayra on 14/05/2019.
//  Copyright © 2019 Mayra Pastor Valdivia. All rights reserved.
//

import Foundation
import InitialsImageView
import UIKit

class ConfigurationView: UIViewController {
    
    let editProfileComponentView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        return view
    }()
    
    //Profile View
    let userPhoto: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 15
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    let userName: UILabel = {
        let textView = UILabel()
        textView.font = UIFont.systemFont(ofSize: 15)
        textView.text = "Rodolfo Claustro"
        textView.textColor = UIColor.black
        textView.backgroundColor = UIColor.clear
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    let userEmail: UILabel = {
        let textView = UILabel()
        textView.font = UIFont.systemFont(ofSize: 14)
        textView.text = "rodolfo@gmail.com"
        textView.textColor = UIColor.black
        textView.backgroundColor = UIColor.clear
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    let infoLabel: UILabel = {
        let textView = UILabel()
        textView.font = UIFont.systemFont(ofSize: 13)
        textView.text = "Aquí puedes actulizar la informacion de tu perfil:"
        textView.textColor = UIColor.black
        textView.backgroundColor = UIColor.clear
        textView.numberOfLines = 0
        textView.lineBreakMode = NSLineBreakMode.byWordWrapping
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    let editButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Edit Profile", for: .normal)
        let titleColor = UIColor(red: 0, green: 137/255, blue: 249/255, alpha: 1)
        button.setTitleColor(titleColor, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.addTarget(self, action: #selector(editProfile), for: .touchUpInside)
        return button
    }()
    
    let infoLabel2: UILabel = {
        let textView = UILabel()
        textView.font = UIFont.systemFont(ofSize: 13)
        textView.text = "No es tu cuenta? Puedes cerrar tu sesión:"
        textView.textColor = UIColor.black
        textView.backgroundColor = UIColor.clear
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    let logoutButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Logout", for: .normal)
        let titleColor = UIColor(red: 0, green: 137/255, blue: 249/255, alpha: 1)
        button.setTitleColor(titleColor, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.addTarget(self, action: #selector(logOut), for: .touchUpInside)
        return button
    }()
    
    let deleteButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Delete Account", for: .normal)
        let titleColor = UIColor.red
//        let titleColor = UIColor(red: 0, green: 137/255, blue: 249/255, alpha: 1)
        button.setTitleColor(titleColor, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.addTarget(self, action: #selector(deleteAccount), for: .touchUpInside)
        return button
    }()
    
    func addCustomView() {
        editProfileComponentView.addSubview(userPhoto)
        editProfileComponentView.addSubview(userName)
        editProfileComponentView.addSubview(userEmail)
        editProfileComponentView.addSubview(infoLabel)
        editProfileComponentView.addSubview(editButton)
        editProfileComponentView.addSubview(infoLabel2)
        editProfileComponentView.addSubview(logoutButton)
        editProfileComponentView.addSubview(deleteButton)
        
        editProfileComponentView.addConstraintsWithFormat(format: "V:|-80-[v0]-5-[v1]-5-[v2]-5-[v3(40)]-5-[v4(40)]-5-[v5(40)]-15-[v6(40)]-5-[v7]", views: userPhoto, userName, userEmail, infoLabel, editButton, infoLabel2, logoutButton, deleteButton)
        
        editProfileComponentView.addConstraintsWithFormat(format: "H:|-120-[v0]", views: userPhoto)
        editProfileComponentView.addConstraintsWithFormat(format: "V:[v0]", views: userPhoto)
        
        editProfileComponentView.addConstraintsWithFormat(format: "H:|-100-[v0]", views: userName)
        editProfileComponentView.addConstraintsWithFormat(format: "H:|-95-[v0]", views: userEmail)
        editProfileComponentView.addConstraintsWithFormat(format: "H:|-10-[v0]", views: infoLabel)
        editProfileComponentView.addConstraintsWithFormat(format: "H:|-60-[v0(200)]-60-|", views: editButton)
        editProfileComponentView.addConstraintsWithFormat(format: "H:|-30-[v0]", views: infoLabel2)
        editProfileComponentView.addConstraintsWithFormat(format: "H:|-60-[v0(200)]-60-|", views: logoutButton)
        editProfileComponentView.addConstraintsWithFormat(format: "H:|-10-[v0]-10-|", views: deleteButton)
        
        
    }
    
    
    @objc func editProfile() {
        self.show(EditProfileView(), sender: nil)
    }
    
    @objc func logOut() {
        let alert = UIAlertController(title: "¿Estás seguro que quieres cerrar tu sesión?",
                                      message: nil,
                                      preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Si", style: .default, handler: logOutThen))
        alert.addAction(UIAlertAction(title: "No", style: .default))
        
        self.present(alert, animated: true)
        
    }
    
    @objc func deleteAccount() {
        let alert = UIAlertController(title: "¿Estás seguro que quieres borrar tu cuenta?",
                                      message: "Se borraran todos tus datos y mensajes",
                                      preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Si", style: .destructive, handler: deleteEverything))
        alert.addAction(UIAlertAction(title: "No", style: .default))
        
        self.present(alert, animated: true)
    }
    
    func deleteEverything(action: UIAlertAction) {
        self.show(LoginController(), sender: nil)
    }
    func logOutThen(action: UIAlertAction) {
        self.show(LoginController(), sender: nil)
    }
    
    var dataProvider: DataProvider = {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        let managedContext = appDelegate?.persistentContainer
        var dataProv = DataProvider(persistentContainer: managedContext!, repository: DataRepository.shared)
        return dataProv
    }()
    func setupConfigView() {
        view.addSubview(editProfileComponentView)
        view.addConstraintsWithFormat(format: "H:|[v0]|", views: editProfileComponentView)
        view.addConstraintsWithFormat(format: "V:|[v0]|", views: editProfileComponentView)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupConfigView()
        addCustomView()
        loadUserInformation()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    func loadUserInformation() {
        userPhoto.frame = CGRect(x: 8, y: 0, width: 80, height: 80)
        userPhoto.setImageForName("Rodolfo Claustro", circular: true, textAttributes: nil)
    }
    
}
