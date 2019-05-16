//
//  UserCell.swift
//  ioszone
//
//  Created by Mayra Pastor Valdivia on 02/05/2019.
//  Copyright © 2019 Mayra Pastor Valdivia. All rights reserved.
//

import UIKit

class UserCell: BaseCell {
    let userPhoto: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 15
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    let userName: UILabel = {
        let textView = UILabel()
        textView.font = UIFont.systemFont(ofSize: 13)
        textView.text = "Sample message"
        textView.textColor = UIColor.black
        textView.backgroundColor = UIColor.clear
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    let statusText: UILabel = {
        let textView = UILabel()
        textView.font = UIFont.systemFont(ofSize: 11)
        textView.text = "Sample message"
        textView.textColor = UIColor.black
        textView.backgroundColor = UIColor.clear
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    override func setupViews() {
        super.setupViews()
        addSubview(userPhoto)
        addConstraintsWithFormat(format: "H:|-12-[v0(40)]", views: userPhoto)
        addConstraintsWithFormat(format: "V:[v0(40)]", views: userPhoto)
        addConstraint(NSLayoutConstraint(item: userPhoto, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
        
        let containerView = UIView()
        addSubview(containerView)
        addConstraintsWithFormat(format: "H:|-60-[v0]|", views: containerView)
        addConstraintsWithFormat(format: "V:[v0(50)]", views: containerView)
        addConstraint(NSLayoutConstraint(item: containerView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
        
        containerView.addSubview(userName)
        containerView.addSubview(statusText)
        //containerView.addSubview(dateTime)
        containerView.addConstraintsWithFormat(format: "H:|[v0]|", views: userName)
        containerView.addConstraintsWithFormat(format: "V:|-5-[v0][v1]-5-|", views: userName, statusText)
        containerView.addConstraintsWithFormat(format: "H:|[v0]-40-|", views: statusText)
        //containerView.addConstraintsWithFormat("H:|[v0]-8-[v1(20)]-12-|", views: userLastMsg, hasReadImageView)
        //containerView.addConstraintsWithFormat(format: "V:|[v0(24)]", views: dateTime)
        //containerView.addConstraintsWithFormat("V:[v0(20)]|", views: hasReadImageView)
    }
    
    
}
