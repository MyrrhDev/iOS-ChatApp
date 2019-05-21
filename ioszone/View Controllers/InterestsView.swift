//
//  InterestsView.swift
//  ioszone
//
//  Created by Mayra on 16/05/2019.
//  Copyright © 2019 Mayra Pastor Valdivia. All rights reserved.
//

import UIKit
import InitialsImageView

class IntestsView: UICollectionViewController, UICollectionViewDelegateFlowLayout, FooterCollectionViewDelegate {
    private let cellId = "cellId"
    private let headerId = "headerId"
    private let footerId = "footerId"
    
    var defaults = UserDefaults()
    //var interestNames = [String]()
    var selectedInterests = [String]()
    var interestNames = ["Deportist", "Bowling","Montaña","Playa","Buceo"]
    
    
    func loadInterests() {
        interestNames = defaults.stringArray(forKey: "InterestArray")!
        print(interestNames[0])
        //collectionView.reloadData()
    }
    
    func continueToHelpView() {
        print("delegate works")
        
        
        //dataProvider.dealWithTerms()
        
//        let layout = UICollectionViewFlowLayout()
//        let controller = IntestsView(collectionViewLayout: layout)
//        self.navigationController?.isNavigationBarHidden = true
//        self.show(controller, sender: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = .white
        collectionView.bounces = false
        collectionView.dataSource = self
        collectionView.alwaysBounceVertical = false
        collectionView.alwaysBounceHorizontal = false
        collectionView.register(HeaderCollectionView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerId)
        collectionView.register(FooterCollectionView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: footerId)
        collectionView.register(InterestCell.self, forCellWithReuseIdentifier: cellId)
        
        //loadInterests()
        collectionView.reloadData()
    }
//
//    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        <#code#>
//    }
//
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(self.interestNames.count)
       return self.interestNames.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! InterestCell
//        cell.frame = CGRect(x: 0, y: 0, width: 90, height: 90)
        cell.interestPicture.frame = CGRect(x: 8, y: 0, width: 50, height: 50)
        cell.interestPicture.setImageForName(interestNames[indexPath.item], circular: true, textAttributes: nil)
//        cell.interestName.frame = CGRect(x: 0, y: 0, width: 30, height: 15)
        cell.interestName.text = interestNames[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: 40)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: 40)
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        if (kind == UICollectionView.elementKindSectionHeader) {
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerId, for: indexPath) as! HeaderCollectionView
                // Customize headerView here
                headerView.backgroundColor = UIColor.white
                if indexPath.section == 0 {
                    headerView.messageHeader.text = "Tienes que elegir al menos un interes:"

                }
             return headerView
        } else if (kind == UICollectionView.elementKindSectionFooter) {
            let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: footerId, for: indexPath) as! FooterCollectionView
            // Customize headerView here
            footerView.backgroundColor = UIColor.white
//            if indexPath.section == 0 {
//                footerView.messageHeader.text = "Tienes que elegir al menos un interes:"
//
//            }
            return footerView
        }
        fatalError("init(coder:) has not been implemented")
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if(interestNames.count <= 3) {
            let yourWidth = UIScreen.main.bounds.width/3.0
            //let yourWidth = collectionView.bounds.width/3.0
            let yourHeight = UIScreen.main.bounds.height-360
            return CGSize(width: yourWidth, height: yourHeight)
        } else {
            let yourWidth = collectionView.bounds.width/3.0
            let yourHeight = yourWidth-10
            return CGSize(width: yourWidth, height: yourHeight)
        }
        fatalError("init(coder:) has not been implemented")
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        print(UIScreen.main.bounds.height)
        //UIScreen.main.bounds.height-340
        return UIEdgeInsets(top: 30, left: 0, bottom: UIScreen.main.bounds.height-340, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
}
