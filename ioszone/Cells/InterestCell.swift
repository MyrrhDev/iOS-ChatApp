//
//  InterestCell.swift
//  ioszone
//
//  Created by Mayra on 16/05/2019.
//  Copyright © 2019 Mayra Pastor Valdivia. All rights reserved.
//

import UIKit

class InterestCell: UICollectionViewCell {
    
    let interestPicture: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 15
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    let interestName: UILabel = {
        let textView = UILabel()
        textView.font = UIFont.systemFont(ofSize: 13)
        textView.text = "Sample message"
        textView.textAlignment = .center
        textView.textColor = UIColor.black
        textView.backgroundColor = UIColor.clear
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        addSubview(interestPicture)
        addSubview(interestName)
        addConstraintsWithFormat(format: "V:|[v0]-10-[v1]", views: interestPicture, interestName)
        addConstraintsWithFormat(format: "H:|-25-[v0]", views: interestPicture)
        addConstraintsWithFormat(format: "H:|-20-[v0(60)]", views: interestName)
    }
}
