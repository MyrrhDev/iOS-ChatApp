//
//  OneToOneCell.swift
//  ioszone
//
//  Created by Mayra Pastor Valdivia on 01/05/2019.
//  Copyright © 2019 Mayra Pastor Valdivia. All rights reserved.
//

import Foundation
import UIKit

class OneToOneCell: BaseCell {
    let messageTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 12)
        textView.text = "Sample message"
        textView.isEditable = false
        textView.backgroundColor = UIColor.clear
        return textView
    }()
    
    let timeTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 7)
        textView.text = "Sample time"
        textView.isEditable = false
        textView.textColor = UIColor.black
        textView.backgroundColor = UIColor.clear
        return textView
    }()
    
    
    let textBubbleView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 15
        view.layer.masksToBounds = true
        return view
    }()
    
    static let grayBubbleImage = UIImage(named: "bubble_gray")!.resizableImage(withCapInsets: UIEdgeInsets(top: 22, left: 26, bottom: 22, right: 26)).withRenderingMode(.alwaysTemplate)
    static let blueBubbleImage = UIImage(named: "bubble_blue")!.resizableImage(withCapInsets: UIEdgeInsets(top: 22, left: 26, bottom: 22, right: 26)).withRenderingMode(.alwaysTemplate)
    
    let bubbleImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = OneToOneCell.grayBubbleImage
        imageView.tintColor = UIColor(white: 0.90, alpha: 1)
        return imageView
    }()
    
    override func setupViews() {
        super.setupViews()
        //self.contentView.transform = CGAffineTransform(scaleX: 1, y: -1)
        addSubview(textBubbleView)
        addSubview(messageTextView)
        addSubview(timeTextView)
        
        textBubbleView.addSubview(bubbleImageView)
        textBubbleView.addConstraintsWithFormat(format: "H:|[v0]|", views: bubbleImageView)
        textBubbleView.addConstraintsWithFormat(format: "V:|[v0]|", views: bubbleImageView)
        
       
        
    }
    
}
