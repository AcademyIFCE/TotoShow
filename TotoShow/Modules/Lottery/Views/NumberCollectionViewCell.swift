//
//  NumberCollectionViewCell.swift
//  TotoShow
//
//  Created by Davi Cabral on 17/08/18.
//  Copyright © 2018 Davi Cabral. All rights reserved.
//

import UIKit

class NumberCollectionViewCell: UICollectionViewCell, ReusableView, NibLoadableView {

    @IBOutlet weak var ballImagemView: UIImageView!
    @IBOutlet weak var numberLabel: UILabel!
    
    
    override var isSelected: Bool {
        didSet {
            self.toggle(forState: isSelected)
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = self.frame.width/2
    }
    
    private func toggle(forState state:Bool) {
        self.ballImagemView.image = isSelected ? #imageLiteral(resourceName: "redBall") : #imageLiteral(resourceName: "whiteBall")
        self.numberLabel.textColor = isSelected ? .white : .black
    }

}
