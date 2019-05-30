//
//  EditProfileView.swift
//  ioszone
//
//  Created by Mayra on 24/05/2019.
//  Copyright © 2019 Mayra Pastor Valdivia. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import CoreData
import InitialsImageView

class EditProfileView: UIViewController {
    
    var defaults = UserDefaults()
    var userDict: NSDictionary?
    
    var dataProvider: DataProvider = {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        let managedContext = appDelegate?.persistentContainer
        var dataProv = DataProvider(persistentContainer: managedContext!, repository: DataRepository.shared)
        return dataProv
    }()
    
    let registerComponentView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        return view
    }()
    
    let instructionLabel: UILabel = {
        let textView = UILabel()
        textView.font = UIFont.systemFont(ofSize: 13)
        textView.text = "Estos son los datos actuales:"
        textView.textAlignment = .left
        textView.textColor = UIColor.gray
        textView.backgroundColor = UIColor.clear
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    let userName: LeftPaddedTextField = {
        let textField = LeftPaddedTextField()
        textField.placeholder = "Nombre"
        //textField.text = "Rodolfo"
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.layer.borderWidth = 1
        textField.keyboardType = UIKeyboardType.alphabet
        return textField
    }()
    
    let userLastName: LeftPaddedTextField = {
        let textField = LeftPaddedTextField()
        textField.placeholder = "Apellido"
        //textField.text = "Claustro"
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.layer.borderWidth = 1
        textField.keyboardType = UIKeyboardType.alphabet
        return textField
    }()
    
    let userEmail: LeftPaddedTextField = {
        let textField = LeftPaddedTextField()
        textField.placeholder = "Email"
        //textField.text = "rodolfo@gmail.com"
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.layer.borderWidth = 1
        textField.keyboardType = .emailAddress
        return textField
    }()
    
    let userDOB: LeftPaddedTextField = {
        let textField = LeftPaddedTextField()
        textField.placeholder = "Date of birth"
        //textField.text = "rodolfo@gmail.com"
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.layer.borderWidth = 1
        textField.keyboardType = UIKeyboardType.numberPad
        return textField
    }()
    
    let instructionLabel2: UILabel = {
        let textView = UILabel()
        textView.font = UIFont.systemFont(ofSize: 13)
        textView.text = "Cambiar Contraseña:"
        textView.textAlignment = .left
        textView.textColor = UIColor.gray
        textView.backgroundColor = UIColor.clear
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    let userPasswordPre: LeftPaddedTextField = {
        let textField = LeftPaddedTextField()
        textField.placeholder = "Enter password"
        //textField.text = ""
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.layer.borderWidth = 1
        textField.isSecureTextEntry = true
        return textField
    }()
    
    let userPasswordPost: LeftPaddedTextField = {
        let textField = LeftPaddedTextField()
        textField.placeholder = "Repeat password"
        //textField.text = "Rodolfo"
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.layer.borderWidth = 1
        textField.isSecureTextEntry = true
        return textField
    }()
    
    let saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Guardar", for: .normal)
        let titleColor = UIColor(red: 0, green: 137/255, blue: 249/255, alpha: 1)
        button.setTitleColor(titleColor, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.addTarget(self, action: #selector(saveAndBack), for: .touchUpInside)
        return button
    }()
    
    
    
    @objc func saveAndBack() {
        if (emailChecked()) {
            if(passwordChecked()) {
                self.defaults.set(self.userPasswordPre.text!.sha512(), forKey: "myNewPW")
                print(self.defaults.value(forKey: "myNewPW") as! String)
                dataProvider.changePassword(newPass: userPasswordPre.text!)
            }
            
            
            dataProvider.changeUserInfo(name: userName.text!, surname: userLastName.text!, email: userEmail.text!)
//            //Interests:
//
//            dataProvider.fetchInterests()
            
            //Alert
            let alert = UIAlertController(title: "Tus datos han sido guardados",
                                          message: nil,
                                          preferredStyle: .alert)
            //let continueAction = UIAlertAction(title: "Okay",
                                             //style: .default)
            alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: goBack))
            self.present(alert, animated: true)
            
            //segue back to Config
            
        }
    }
   
    func goBack(action: UIAlertAction) {
        self.show(ConfigurationView(),sender: nil)
    }
            
            
    func passwordChecked() -> Bool {
        if((!userPasswordPre.text!.isEmpty) && (!userPasswordPost.text!.isEmpty)) {
            if (userPasswordPre.text == userPasswordPost.text) {
                return true
            } else {
                let alert = UIAlertController(title: "Las contraseñas no son iguales",
                                              message: "Please try again",
                                              preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "Try Again",
                                                 style: .cancel)
                alert.addAction(cancelAction)
                self.present(alert, animated: true)
            }
        }
        return false
    }
    
    //TODO: se puede customize dependiendo de que restriccion de email se quiere hacer
    //termina en .com
    func emailChecked() -> Bool {
        //tiene @
        if((userEmail.text?.contains("@"))! && ((userEmail.text?.hasSuffix(".com"))!)) {
            return true
        } else {
            let alert = UIAlertController(title: "El email no tiene el formato correcto",
                                          message: "Please try again",
                                          preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Try Again",
                                             style: .cancel)
            alert.addAction(cancelAction)
            self.present(alert, animated: true)
        }
        return false
    }
    
    
    private func setupRegisterComponents() {
        registerComponentView.addSubview(instructionLabel)
        registerComponentView.addSubview(userName)
        registerComponentView.addSubview(userLastName)
        registerComponentView.addSubview(userEmail)
        registerComponentView.addSubview(instructionLabel2)
        registerComponentView.addSubview(userPasswordPre)
        registerComponentView.addSubview(userPasswordPost)
        registerComponentView.addSubview(saveButton)
        
        registerComponentView.addConstraintsWithFormat(format: "V:|-80-[v0(40)]-5-[v1(40)]-5-[v2(40)]-5-[v3(40)]-5-[v4(40)]-5-[v5(40)]-15-[v6(40)]", views: instructionLabel, userName, userLastName, userEmail, instructionLabel2, userPasswordPre, userPasswordPost)
        registerComponentView.addConstraintsWithFormat(format: "V:[v0(40)]-120-|", views: saveButton)
        
        registerComponentView.addConstraintsWithFormat(format: "H:|-10-[v0]", views: instructionLabel)
        registerComponentView.addConstraintsWithFormat(format: "H:|-60-[v0(200)]-60-|", views: userName)
        registerComponentView.addConstraintsWithFormat(format: "H:|-60-[v0(200)]-60-|", views: userLastName)
        registerComponentView.addConstraintsWithFormat(format: "H:|-60-[v0(200)]-60-|", views: userEmail)
        registerComponentView.addConstraintsWithFormat(format: "H:|-10-[v0]-10-|", views: instructionLabel2)
        registerComponentView.addConstraintsWithFormat(format: "H:|-60-[v0(200)]-60-|", views: userPasswordPre)
        registerComponentView.addConstraintsWithFormat(format: "H:|-60-[v0(200)]-60-|", views: userPasswordPost)
        registerComponentView.addConstraintsWithFormat(format: "H:|-60-[v0(200)]-60-|", views: saveButton)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBarController?.tabBar.isHidden = true
        view.addSubview(registerComponentView)
        view.addConstraintsWithFormat(format: "H:|[v0]|", views: registerComponentView)
        view.addConstraintsWithFormat(format: "V:|[v0]|", views: registerComponentView)
        setupRegisterComponents()
        observeKeyboardNotifications()
        loadUserInformation()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(keyboardHide))
        view.addGestureRecognizer(tap)
    }
    
    func loadUserInformation() {
        userDict = self.defaults.value(forKey: "thisUserDict") as! NSDictionary
        userName.text = userDict?.value(forKey: "name") as! String
        userLastName.text = userDict?.value(forKey: "surname") as! String
        userEmail.text = userDict?.value(forKey: "email") as! String
        //self.defaults.set(result?.value(forKey: "idUser"), forKey: "myID")
    }
    
    
    fileprivate func observeKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardHide() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        }, completion: nil)
        view.endEditing(true)
        
    }
    
    @objc func keyboardShow() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.view.frame = CGRect(x: 0, y: -50, width: self.view.frame.width, height: self.view.frame.height)
        }, completion: nil)
    }
    
    
    
    
}
