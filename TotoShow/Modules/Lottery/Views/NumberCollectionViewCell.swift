//
//  NumberCollectionViewCell.swift
//  TotoShow
//
//  Created by Davi Cabral on 17/08/18.
//  Copyright © 2018 Davi Cabral. All rights reserved.
//

import UIKit

class NumberCollectionViewCell: UICollectionViewCell, ReusableView, NibLoadableView {

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = self.frame.width/2
    }

}
