//
//  RegisterView.swift
//  ioszone
//
//  Created by Mayra on 14/05/2019.
//  Copyright © 2019 Mayra Pastor Valdivia. All rights reserved.
//

import UIKit

class RegisterView: UIViewController {
    
    let registerComponentView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        return view
    }()
    
    let userName: LeftPaddedTextField = {
        let textField = LeftPaddedTextField()
        textField.placeholder = "Mutua Gallega"
        textField.text = "Mutua Gallega"
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.layer.borderWidth = 1
        textField.keyboardType = .emailAddress
        return textField
    }()
    
    let userLastName: LeftPaddedTextField = {
        let textField = LeftPaddedTextField()
        textField.placeholder = "Mutua Gallega"
        textField.text = "Mutua Gallega"
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.layer.borderWidth = 1
        textField.keyboardType = .emailAddress
        return textField
    }()
    
    let userEmail: LeftPaddedTextField = {
        let textField = LeftPaddedTextField()
        textField.placeholder = "Enter email"
        textField.text = "rodolfo@gmail.com"
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.layer.borderWidth = 1
        textField.keyboardType = .emailAddress
        return textField
    }()
    
    let userPasswordPre: LeftPaddedTextField = {
        let textField = LeftPaddedTextField()
        textField.placeholder = "Enter password"
        textField.text = "Rodolfo"
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.layer.borderWidth = 1
        textField.isSecureTextEntry = true
        return textField
    }()
    
    let userPasswordPost: LeftPaddedTextField = {
        let textField = LeftPaddedTextField()
        textField.placeholder = "Enter password"
        textField.text = "Rodolfo"
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.layer.borderWidth = 1
        textField.isSecureTextEntry = true
        return textField
    }()
    
    
    let continueButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Edit Profile", for: .normal)
        let titleColor = UIColor(red: 0, green: 137/255, blue: 249/255, alpha: 1)
        button.setTitleColor(titleColor, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        //button.addTarget(self, action: #selector(sendInfo), for: .touchUpInside)
        return button
    }()
    
    private func setupLoginComponents() {
        registerComponentView.addSubview(userName)
        registerComponentView.addSubview(userLastName)
        registerComponentView.addSubview(userEmail)
        registerComponentView.addSubview(userPasswordPre)
        registerComponentView.addSubview(userPasswordPost)
        registerComponentView.addSubview(continueButton)
        
        registerComponentView.addConstraintsWithFormat(format: "V:|-150-[v0(40)]-5-[v1(40)]-5-[v2(40)]", views: userName, userEmail, userPasswordPre, userPasswordPost)
        registerComponentView.addConstraintsWithFormat(format: "V:[v0(40)]-220-|", views: continueButton)
        
        registerComponentView.addConstraintsWithFormat(format: "H:|-60-[v0(200)]-60-|", views: userName)
        registerComponentView.addConstraintsWithFormat(format: "H:|-60-[v0(200)]-60-|", views: userEmail)
        registerComponentView.addConstraintsWithFormat(format: "H:|-60-[v0(200)]-60-|", views: userPasswordPre)
        registerComponentView.addConstraintsWithFormat(format: "H:|-60-[v0(200)]-60-|", views: userPasswordPost)
        registerComponentView.addConstraintsWithFormat(format: "H:|-60-[v0(200)]-60-|", views: continueButton)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(registerComponentView)
        view.addConstraintsWithFormat(format: "H:|[v0]|", views: registerComponentView)
        view.addConstraintsWithFormat(format: "V:|[v0]|", views: registerComponentView)
        
    }
    
    
    
}
