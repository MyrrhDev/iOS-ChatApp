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
//        addConstraintsWithFormat(format: "V:|[v0]|", views: interestPicture)
       
        addConstraintsWithFormat(format: "H:|-20-[v0(60)]", views: interestName)
        //addConstraintsWithFormat(format: "V:|[v0]", views: interestName)
        
        //interestName.backgroundColor = .blue
        //interestPicture.backgroundColor = .red
    }
    
    
    
    /// same with UITableViewCell's selected backgroundColor
    private let highlightedColor = UIColor(red: 0, green: 137/255, blue: 249/255, alpha: 1)
    
   
        
        var shouldTintBackgroundWhenSelected = true // You can change default value
        var specialHighlightedArea: UIView?
        
        // make lightgray background show immediately
        override var isHighlighted: Bool {
            willSet {
                onSelected(newValue)
            }
        }
        // keep lightGray background until unselected
        override var isSelected: Bool {
            willSet {
                onSelected(newValue)
            }
        }
        func onSelected(_ newValue: Bool) {
            guard selectedBackgroundView == nil else { return }
            if shouldTintBackgroundWhenSelected {
                contentView.backgroundColor = newValue ? highlightedColor : UIColor.clear
            }
//            if let sa = specialHighlightedArea {
//                sa.backgroundColor = newValue ? UIColor.black.withAlphaComponent(0.4) : UIColor.clear
//            }
        }
}


extension UIColor {
    convenience init(rgb: Int, alpha: CGFloat = 1.0) {
        self.init(red: CGFloat((rgb & 0xFF0000) >> 16) / 255.0, green: CGFloat((rgb & 0xFF00) >> 8) / 255.0, blue: CGFloat(rgb & 0xFF) / 255.0, alpha: alpha)
    }
}
