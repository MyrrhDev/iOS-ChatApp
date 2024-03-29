//
//  FooterCollectionView.swift
//  ioszone
//
//  Created by Mayra on 17/05/2019.
//  Copyright © 2019 Mayra Pastor Valdivia. All rights reserved.
//


import UIKit

protocol FooterCollectionViewDelegate {
    func continueToChats()
}


class FooterCollectionView: UICollectionReusableView {
    
    var delegate: FooterCollectionViewDelegate?

    let continueButton: UIButton = {
        let button = UIButton(type: .system)
        //button.backgroundColor = .red
        button.setTitle("Continuar", for: .normal)
        let titleColor = UIColor(red: 0, green: 137/255, blue: 249/255, alpha: 1)
        button.setTitleColor(titleColor, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.addTarget(self, action: #selector(continueToChatView), for: .touchUpInside)
        return button
    }()
    
    @objc func continueToChatView() {
        delegate?.continueToChats()
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        myCustomInit()
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func myCustomInit() {
        addSubview(continueButton)
        addConstraintsWithFormat(format: "H:|-60-[v0(200)]", views: continueButton)
        addConstraintsWithFormat(format: "V:|[v0]", views: continueButton)
        print("hello there from FooterCollectionView")
    }
    
}
