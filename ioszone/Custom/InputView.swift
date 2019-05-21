//
//  InputView.swift
//  ioszone
//
//  Created by Mayra on 10/05/2019.
//  Copyright © 2019 Mayra Pastor Valdivia. All rights reserved.
//

import Foundation
import UIKit
import ISEmojiView

protocol InputViewDelegate {
    func messageWasSent(message: String)
    func loadOptions()
}


class InputView: UIView {
    static let inputView = InputView()
    var delegate: InputViewDelegate?
    
    let inputTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter message..."
        return textField
    }()
    
    let sendButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Send", for: .normal)
        let titleColor = UIColor(red: 0, green: 137/255, blue: 249/255, alpha: 1)
        button.setTitleColor(titleColor, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.addTarget(self, action: #selector(sendInfo), for: .touchUpInside)
        return button
    }()
    
    let emojiButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .gray
        button.setImage(#imageLiteral(resourceName: "new_chat_icon").withRenderingMode(.alwaysTemplate), for: .normal)
        button.addTarget(self, action: #selector(chooseOptions), for: .touchUpInside)
        return button
    }()
    
    @objc func chooseOptions() {
        delegate?.loadOptions()
    }
    
    @objc func sendInfo() {
        if(inputTextField.text != "") {
            delegate?.messageWasSent(message: inputTextField.text!)
            inputTextField.text = nil
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        setupInputView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupInputView() {
        let topBorderView = UIView()
        topBorderView.backgroundColor = UIColor(white: 0.5, alpha: 0.5)
        self.addSubview(emojiButton)
        self.addSubview(inputTextField)
        self.addSubview(sendButton)
        self.addSubview(topBorderView)
        self.addConstraintsWithFormat(format: "H:|-8-[v0(40)]-8-[v1][v2(60)]|", views: emojiButton, inputTextField, sendButton)
        self.addConstraintsWithFormat(format: "V:|[v0]|", views: emojiButton)
        self.addConstraintsWithFormat(format: "V:|[v0]|", views: inputTextField)
        self.addConstraintsWithFormat(format: "V:|[v0]|", views: sendButton)
        self.addConstraintsWithFormat(format: "H:|[v0]|", views: topBorderView)
        self.addConstraintsWithFormat(format: "V:|[v0(0.5)]", views: topBorderView)
    }
}
