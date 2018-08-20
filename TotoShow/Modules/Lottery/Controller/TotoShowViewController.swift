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
    @IBOutlet weak var cardCollectionView: UICollectionView!
    @IBOutlet weak var topStackView: UIStackView!
    
    private var numbers: [Int] = [10,2,60,12,51,1,1,1]
    private var userNumbers: [Int] = [10,2,60,12,51,47,11,1,52,33,32,8,9,21,44,57,47,19,24,39]
    private let numberSize: CGFloat = UIScreen.main.bounds.width/10
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.loadNumbers()
        self.setupCollection()
        
        self.lotteryCollectionView.delegate = self
        self.lotteryCollectionView.dataSource = self
        self.lotteryCollectionView.allowsSelection = false
        self.cardCollectionView.delegate = self
        self.cardCollectionView.dataSource = self
        self.cardCollectionView.allowsMultipleSelection = true
    }
    
    private func setupCollection() {

        //Register Cell
        let cellNib = NumberCollectionViewCell.asNib()
        self.lotteryCollectionView.register(cellNib, forCellWithReuseIdentifier: NumberCollectionViewCell.reuseIdentifier)
        self.cardCollectionView.register(cellNib, forCellWithReuseIdentifier: NumberCollectionViewCell.reuseIdentifier)
    }
    
//    private func loadNumbers() {
//        let path = Bundle.main.url(forResource: "numbers", withExtension: "json")
//        let data = try? Data(contentsOf: path!)
//        let decoder = JSONDecoder()
//        numbers = try! decoder.decode([Int].self, from: data!)
//    }

}


extension TotoShowViewController : UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionView == lotteryCollectionView ? numbers.count : userNumbers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NumberCollectionViewCell.reuseIdentifier, for: indexPath) as? NumberCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let number: Int
        if collectionView == lotteryCollectionView {
            number = numbers[indexPath.row]
            cell.isSelected = true
        } else {
            number = userNumbers[indexPath.row]
            cell.ballImagemView.image = #imageLiteral(resourceName: "whiteBall")
            //            cell.isSelected = true //TODO: Trocar quando tiver camada de modelo
        }
        
        cell.numberLabel.text = "\(number)"
        
        return cell
    }

    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let screenWidth = UIScreen.main.bounds.width
        if collectionView == lotteryCollectionView  {
            
            let screenWithoutGutters = screenWidth - 50 // minSpacing(10) * 4 + insetLeft (10)
            let itemRadius = screenWithoutGutters/5 //Number of columns
            return indexPath.row == 0 ? CGSize(width: (itemRadius) * 1.2, height: (itemRadius) * 1.2) : CGSize(width: (itemRadius), height: (itemRadius))
        } else {
            let screenWithoutGutters = screenWidth - 60 // minSpacing(10) * 4 + insetLeft(10) + insetRight(10
            let itemRadius = screenWithoutGutters/5 //Number of columns
            return CGSize(width: itemRadius, height: itemRadius)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        if collectionView == lotteryCollectionView  {
            return UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        } else {
            return UIEdgeInsets(top: 20, left: 10, bottom: 0, right: 10)
        }
    }
}
