//
//  MessageCells.swift
//  ioszone
//
//  Created by Mayra Pastor Valdivia on 05/05/2019.
//  Copyright © 2019 Mayra Pastor Valdivia. All rights reserved.
//

import Foundation

import UIKit

class MessageCell: BaseCell {
    let userName: UILabel = {
        let textView = UILabel()
        textView.font = UIFont.systemFont(ofSize: 15)
        textView.text = "Sample message"
        textView.textColor = UIColor.black
        textView.backgroundColor = UIColor.clear
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    let userLastMsg: UILabel = {
        let textView = UILabel()
        textView.font = UIFont.systemFont(ofSize: 11)
        textView.text = "Sample time"
        textView.textColor = UIColor.black
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.backgroundColor = UIColor.clear
        return textView
    }()
    
    let dateTime: UILabel = {
        let textView = UILabel()
        textView.font = UIFont.systemFont(ofSize: 11)
        textView.text = "Sample time"
        textView.textColor = UIColor.black
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.backgroundColor = UIColor.clear
        return textView
    }()
    
   
    override func setupViews() {
        super.setupViews()
         
        let containerView = UIView()
        addSubview(containerView)
        addConstraintsWithFormat(format: "H:|-60-[v0]|", views: containerView)
        addConstraintsWithFormat(format: "V:[v0(50)]", views: containerView)
        addConstraint(NSLayoutConstraint(item: containerView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
        
        containerView.addSubview(userName)
        containerView.addSubview(userLastMsg)
        containerView.addSubview(dateTime)
        containerView.addConstraintsWithFormat(format: "H:|[v0][v1(80)]-12-|", views: userName, dateTime)
        containerView.addConstraintsWithFormat(format: "V:|[v0][v1(24)]-3-|", views: userName, userLastMsg)
        containerView.addConstraintsWithFormat(format: "H:|[v0]-40-|", views: userLastMsg)
        //containerView.addConstraintsWithFormat("H:|[v0]-8-[v1(20)]-12-|", views: userLastMsg, hasReadImageView)
        containerView.addConstraintsWithFormat(format: "V:|[v0(24)]", views: dateTime)
        //containerView.addConstraintsWithFormat("V:[v0(20)]|", views: hasReadImageView)
    }
}
