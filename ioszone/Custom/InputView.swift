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
    func reloadView()
}


class InputView: UIView, EmojiViewDelegate {
    func emojiViewDidSelectEmoji(_ emoji: String, emojiView: EmojiView) {
        inputTextField.insertText(emoji)
    }
    
    func emojiViewDidPressDeleteBackwardButton(_ emojiView: EmojiView) {
        inputTextField.deleteBackward()
    }
    
    var emojiView: EmojiView! {
        didSet {
            emojiView.delegate = self
        }
    }
    
    static let inputView = InputView()
    var delegate: InputViewDelegate?
    
    var bottomType: BottomType!
    //var emojis: [EmojiCategory]?
   
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
        button.addTarget(self, action: #selector(handleEmojis), for: .touchUpInside)
        return button
    }()
    
    @objc func handleEmojis() {
        let keyboardSettings = KeyboardSettings(bottomType: .categories)
        //keyboardSettings.customEmojis = emojis
        keyboardSettings.countOfRecentsEmojis = 20
        //keyboardSettings.afterScreenUpdates = true
        let emojiView = EmojiView(keyboardSettings: keyboardSettings)
        emojiView.translatesAutoresizingMaskIntoConstraints = false
        emojiView.delegate = self
        
        if (!inputTextField.isFirstResponder) {
            inputTextField.inputView = emojiView
            inputTextField.becomeFirstResponder()
            print("1")
        } else {
            inputTextField.resignFirstResponder()
            if(inputTextField.inputView != nil) {
                inputTextField.inputView = nil
                inputTextField.becomeFirstResponder()
                delegate?.reloadView()
                //inputTextField.reloadInputViews()
                print("2")
            } else {
                inputTextField.resignFirstResponder()
                inputTextField.inputView = emojiView
                inputTextField.becomeFirstResponder()
                //inputTextField.reloadInputViews()
                delegate?.reloadView()
                print("3")
            }
        }
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
