//
//  HeaderCollectionView.swift
//  ioszone
//
//  Created by Mayra on 17/05/2019.
//  Copyright © 2019 Mayra Pastor Valdivia. All rights reserved.
//

import UIKit

class HeaderCollectionView: UICollectionReusableView {
    
    let messageHeader: UILabel = {
        let textView = UILabel()
        textView.font = UIFont.systemFont(ofSize: 15)
//        textView.text = "Tienes que elegir al menos un interes:"
        textView.textAlignment = .left
        textView.textColor = .gray
        textView.backgroundColor = UIColor.clear
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
//        self.backgroundColor = .blue
        
        myCustomInit()
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func myCustomInit() {
        addSubview(messageHeader)
        addConstraintsWithFormat(format: "H:|-25-[v0(300)]", views: messageHeader)
        addConstraintsWithFormat(format: "V:|-20-[v0(20)]", views: messageHeader)
//        messageHeader.backgroundColor = .red
        print("hello there from SupView")
    }
    
    
}
