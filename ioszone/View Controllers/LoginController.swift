//
//  LoginController.swift
//  ioszone
//
//  Created by Mayra on 18/02/2019.
//  Copyright © 2019 Mayra. All rights reserved.
//

import UIKit
import Alamofire
import CommonCrypto
import Starscream
import CoreData

class LoginController: UIViewController {
    var dataProvider: DataProvider = {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        let managedContext = appDelegate?.persistentContainer
        var dataProv = DataProvider(persistentContainer: managedContext!, repository: DataRepository.shared)
        return dataProv
    }()
    
    let loginInputContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        return view
    }()
    
    /*
    let logoImageView: UIImageView = {
        let image = UIImage(named: "logo")
        let imageView = UIImageView(image: image)
        return imageView
    }()*/
    
    let txtClient: LeftPaddedTextField = {
        let textField = LeftPaddedTextField()
        textField.placeholder = "Mutua Gallega"
        textField.text = "Mutua Gallega"
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.layer.borderWidth = 1
        textField.keyboardType = .emailAddress
        return textField
    }()
    
    let txtEmail: LeftPaddedTextField = {
        let textField = LeftPaddedTextField()
        textField.placeholder = "Enter email"
        textField.text = "rodolfo@gmail.com"
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.layer.borderWidth = 1
        textField.keyboardType = .emailAddress
        return textField
    }()
    
    let txtPass: LeftPaddedTextField = {
        let textField = LeftPaddedTextField()
        textField.placeholder = "Enter password"
        textField.text = "Rodolfo"
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.layer.borderWidth = 1
        textField.isSecureTextEntry = true
        return textField
    }()
    
    let logbutton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .red
        button.setTitle("Log in", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        return button
    }()
    
    private func setupLoginComponents() {
        loginInputContainerView.addSubview(txtClient)
        loginInputContainerView.addSubview(txtEmail)
        loginInputContainerView.addSubview(txtPass)
        loginInputContainerView.addSubview(logbutton)
        
        loginInputContainerView.addConstraintsWithFormat(format: "V:|-150-[v0(40)]-5-[v1(40)]-5-[v2(40)]", views: txtClient, txtEmail, txtPass)
        loginInputContainerView.addConstraintsWithFormat(format: "V:[v0(40)]-220-|", views: logbutton)

        loginInputContainerView.addConstraintsWithFormat(format: "H:|-60-[v0(200)]-60-|", views: txtClient)
        loginInputContainerView.addConstraintsWithFormat(format: "H:|-60-[v0(200)]-60-|", views: txtEmail)
        loginInputContainerView.addConstraintsWithFormat(format: "H:|-60-[v0(200)]-60-|", views: txtPass)
        loginInputContainerView.addConstraintsWithFormat(format: "H:|-60-[v0(200)]-60-|", views: logbutton)
    }
    
    let networkHandler = NetworkManager.sharedNetworkManager
    var defaults = UserDefaults()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(loginInputContainerView)
        view.addConstraintsWithFormat(format: "H:|[v0]|", views: loginInputContainerView)
        view.addConstraintsWithFormat(format: "V:|[v0]|", views: loginInputContainerView)
        setupLoginComponents()
        observeKeyboardNotifications()

        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(keyboardHide))
        view.addGestureRecognizer(tap)

        defaults.set(false, forKey: "gotToken")
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    @objc func handleLogin() {
        let parameters: Parameters = [
            "nameClient": txtClient.text,
            "email": txtEmail.text,
            "password": txtPass.text!.sha512()
        ]
        
        Alamofire.request(networkHandler.baseString+"loginuser", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: networkHandler.headerJSON).responseJSON { response in
            //print("Request: \(String(describing: response.request))")   // original url request
            //print("Response: \(String(describing: response.response))") // http url response
            //print("Result: \(response.result)")                         // response serialization result
            if let json = response.result.value {
                if let dictionary = json as? [String: Any] {
                    if let token = dictionary["authToken"] as? String {
                        //print("Tokn!! \(token)")
                        self.networkHandler.saveToken(myToken: token)
                        self.defaults.set(true, forKey: "gotToken")
                        
//                        self.dataProvider.fetchRooms { (error) in
//                            print(error)
//                        }
//                        self.dataProvider.fetchUsers { (error) in
//                            print(error)
//                        }
//                        self.dataProvider.fetchUsersChatting { (error) in
//                            print(error)
//                        }
//                        self.dataProvider.fetchRoomMessages { (error) in
//                            print(error)
//                        }
//                        self.dataProvider.fetchHumanMessages { (error) in
//                            print(error)
//                        }
                        
                        
                        
                        self.authIsVerified()
                    } else {
                        do {
                            let data = response.data
                            let jsonObject = try JSONSerialization.jsonObject(with: data!, options: [])
                            let jsonDictionary = jsonObject as? [String: Any]
                            let result = jsonDictionary!["error"] as? [String: Any]
                            let errorType = result!["detail"] as? [String: Any]
                            
                            let alert = UIAlertController(title: errorType!["en"] as! String,
                                                          message: "Please try again",
                                                          preferredStyle: .alert)
                            let cancelAction = UIAlertAction(title: "Try Again",
                                                             style: .cancel)
                            alert.addAction(cancelAction)
                            self.present(alert, animated: true)
                        } catch {
                            
                        }
                    }
                } else {
                    print("Error getting authToken!")
                }
            }
        }
    }
   
    func authIsVerified() {
        self.show(CustomTabBarController(), sender: nil)
        print("success!!")
    }
}


class LeftPaddedTextField: UITextField {
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: bounds.origin.x + 10, y: bounds.origin.y, width: bounds.width + 10, height: bounds.height)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: bounds.origin.x + 10, y: bounds.origin.y, width: bounds.width + 10, height: bounds.height)
    }
    
}

