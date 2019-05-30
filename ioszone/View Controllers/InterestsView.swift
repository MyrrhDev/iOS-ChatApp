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
    func continueToChats() {
        print("delegate works")
        defaults.set(true, forKey: "gotToken15")
        dataProvider.changeInterests(interests: arrayToSend)
        dataProvider.dealWithTerms()
        
        dataProvider.getNewToken()
        
        self.show(CustomTabBarController(), sender: nil)
        print("success to Chats!!")
    }
    
    
    var dataProvider: DataProvider = {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        let managedContext = appDelegate?.persistentContainer
        var dataProv = DataProvider(persistentContainer: managedContext!, repository: DataRepository.shared)
        return dataProv
    }()
    
    private let cellId = "cellId"
    private let headerId = "headerId"
    private let footerId = "footerId"
    
    var defaults = UserDefaults()
    var selectedInterests = [String]()
    
    var interestsClient: [[String:Any]]?
    var interestsUsers: [[String:Any]]?
    var interestNames = ["Deportist", "Bowling","Montaña","Playa","Buceo"]
    var arrayToSend = [Int]()
    
    var allIndex = [IndexPath]()
    
    func loadInterests() {
        interestsClient = self.defaults.value(forKey: "interestsClientDict") as! [[String : Any]]
        interestsUsers = self.defaults.value(forKey: "userInterestsDict") as! [[String : Any]]
        interestNames = self.defaults.stringArray(forKey: "InterestArray")!
        print(interestNames)
        //collectionView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.backgroundColor = .white
        collectionView.bounces = false
        collectionView.dataSource = self
        collectionView.alwaysBounceVertical = false
        collectionView.alwaysBounceHorizontal = false
        collectionView.allowsMultipleSelection = true
        collectionView.register(HeaderCollectionView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerId)
        collectionView.register(FooterCollectionView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: footerId)
        collectionView.register(InterestCell.self, forCellWithReuseIdentifier: cellId)
        loadInterests()
        collectionView.reloadData()
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let index = arrayToSend.index(of: interestsClient![indexPath.item]["idInterest"] as! Int) {
            arrayToSend.remove(at: index)
        }

        if !(arrayToSend.contains(interestsClient![indexPath.item]["idInterest"] as! Int)) {
            arrayToSend.append(interestsClient![indexPath.item]["idInterest"] as! Int)
        }

        if !(allIndex.contains(indexPath)) {
            allIndex.append(indexPath)
            collectionView.reloadItems(at: [indexPath])
        }
        print(arrayToSend)
        print(allIndex)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {

        if let index = arrayToSend.index(of: interestsClient![indexPath.item]["idInterest"] as! Int) {
            arrayToSend.remove(at: index)
        }

        if (allIndex.contains(indexPath)) {
            let index = allIndex.index(of: indexPath)!
            allIndex.remove(at: index)
            collectionView.reloadItems(at: [indexPath])
        }

        print(arrayToSend)
        print(allIndex)

    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(self.interestsClient!.count)
        return self.interestsClient!.count
       //return 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! InterestCell


        if allIndex.contains(indexPath) {
            cell.interestPicture.frame = CGRect(x: 8, y: 0, width: 50, height: 50)
            cell.interestPicture.setImageForName(interestsClient![indexPath.item]["name"] as! String, backgroundColor: .red, circular: true, textAttributes: nil)
            cell.interestName.text = interestsClient![indexPath.item]["name"] as! String
        } else {
            cell.interestPicture.frame = CGRect(x: 8, y: 0, width: 50, height: 50)
            cell.interestPicture.setImageForName(interestsClient![indexPath.item]["name"] as! String, backgroundColor: .lightGray, circular: true, textAttributes: nil)
            cell.interestName.text = interestsClient![indexPath.item]["name"] as! String
        }
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
            
            footerView.delegate = self
            // Customize headerView here
            footerView.backgroundColor = UIColor.white
//            if indexPath.section == 0 {
//                footerView.messageHeader.text = "Tienes que elegir al menos un interes:"
//
//            }
            return footerView
        }
        fatalError("Something's wrong with the header or footer")
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
