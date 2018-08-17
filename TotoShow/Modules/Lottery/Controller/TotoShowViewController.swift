//
//  TotoShowViewController.swift
//  TotoShow
//
//  Created by Davi Cabral on 17/08/18.
//  Copyright © 2018 Davi Cabral. All rights reserved.
//

import UIKit
import CoreData

class TotoShowViewController: UIViewController {

    @IBOutlet var lotteryCollectionView: UICollectionView!
    
    private var numbers: [Int] = [10,2,60,12,51]
    private var userNumbers: [Int] = [10,2,60,12,51,47,11,1,52,33,32,8,9,21,44,57,47,19,24,39]
    private let numberSize: CGFloat = UIScreen.main.bounds.width/10
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.loadNumbers()
        self.setupCollection()
        self.lotteryCollectionView.delegate = self
        self.lotteryCollectionView.dataSource = self
    }
    
    private func setupCollection() {

        let cellNib = NumberCollectionViewCell.asNib()
        self.lotteryCollectionView.register(cellNib, forCellWithReuseIdentifier: NumberCollectionViewCell.reuseIdentifier)
    }
    
//    private func loadNumbers() {
//        let path = Bundle.main.url(forResource: "numbers", withExtension: "json")
//        let data = try? Data(contentsOf: path!)
//        let decoder = JSONDecoder()
//        numbers = try! decoder.decode([Int].self, from: data!)
//    }

}


extension TotoShowViewController : UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return section == 0 ? numbers.count : userNumbers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NumberCollectionViewCell.reuseIdentifier, for: indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let screenWidth = UIScreen.main.bounds.width
        let screenWithoutGutters = screenWidth - 60
        let itemRadius = screenWithoutGutters/5
        
        if indexPath.section == 0  {
            return indexPath.row == 0 ? CGSize(width: itemRadius * 2, height: itemRadius * 2) : CGSize(width: itemRadius, height: itemRadius)
        } else {

            return CGSize(width: itemRadius, height: itemRadius)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        if section == 0  {
            return UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        } else {
            return UIEdgeInsets(top: 40, left: 10, bottom: 0, right: 10)
        }
    }
}