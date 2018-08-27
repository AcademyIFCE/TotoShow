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
    
    @IBOutlet weak var firstPrizeImageView: UIImageView!
    @IBOutlet weak var firstPrizeLabel: UILabel!
    
    @IBOutlet weak var secondPrizeImageView: UIImageView!
    @IBOutlet weak var secondPrizeLabel: UILabel!
    
    private var model: TotoShowModel!
    private let numberSize: CGFloat = UIScreen.main.bounds.width/10
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        model = TotoShowModel(delegate: self)
        self.setupCollection()
        
        self.lotteryCollectionView.delegate = self
        self.lotteryCollectionView.dataSource = self
        self.lotteryCollectionView.allowsSelection = false
        self.cardCollectionView.delegate = self
        self.cardCollectionView.dataSource = self
        self.cardCollectionView.allowsMultipleSelection = true
    }
    
    private func setupCollection() {
        let cellNib = NumberCollectionViewCell.asNib()
        self.lotteryCollectionView.register(cellNib, forCellWithReuseIdentifier: NumberCollectionViewCell.reuseIdentifier)
        self.cardCollectionView.register(cellNib, forCellWithReuseIdentifier: NumberCollectionViewCell.reuseIdentifier)
    }
    
    private func changeLottery() {
        self.model.changePrize()
        self.changePrizeImageView(firstPrizeImageView)
        self.changePrizeImageView(secondPrizeImageView)
        self.changePrizeLabel(firstPrizeLabel)
        self.changePrizeLabel(secondPrizeLabel)
        firstPrizeImageView.isUserInteractionEnabled = !firstPrizeImageView.isUserInteractionEnabled
        secondPrizeImageView.isUserInteractionEnabled = !secondPrizeImageView.isUserInteractionEnabled
        self.lotteryCollectionView.reloadData()
        self.cardCollectionView.reloadData()
    }
    
    private func changePrizeImageView(_ imageView: UIImageView ) {
        imageView.image = imageView.image == #imageLiteral(resourceName: "letreiroQuadrado") ? #imageLiteral(resourceName: "letreiroQuadradoApagado") : #imageLiteral(resourceName: "letreiroQuadrado")
    }
    
    private func changePrizeLabel(_ label: UILabel ) {
        label.isEnabled = !label.isEnabled
    }
    
    @IBAction func didChangePrize(_ sender: Any) {
        self.changeLottery()
    }
    
}


extension TotoShowViewController : UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionView == lotteryCollectionView ? model.numberOfPickedBalls() : model.numberOfCards()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NumberCollectionViewCell.reuseIdentifier, for: indexPath) as? NumberCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let number: Int
        if collectionView == lotteryCollectionView {
            number = model.numberForPicked(row: indexPath.row)
            cell.isSelected = true
        } else {
            number = model.numberForCard(row: indexPath.row)
            cell.isSelected = model.shouldMarkBall(of: number)
        }
        
        cell.numberLabel.text = "\(number)"
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == cardCollectionView {
            model.addNumberToCard(index: indexPath.row)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return model.shouldSelectBall(of: indexPath.row)
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

extension TotoShowViewController: TotoLotteryDelegate {
    func updateNumbers(with itens: [Int]) {
        self.lotteryCollectionView.performBatchUpdates({
            self.lotteryCollectionView.insertItems(at: [IndexPath(item: 0, section: 0)])
        }, completion: nil)
    }
    
    func winnerFound(winner: String) {
        let alert = UIAlertController(title: "End of Game", message: winner, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default) { [unowned self] _ in
            self.changeLottery()
            self.lotteryCollectionView.reloadData()
        })
        present(alert, animated: true, completion: nil)
    }
}
