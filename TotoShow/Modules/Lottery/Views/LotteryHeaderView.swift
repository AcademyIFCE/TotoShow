//
//  LotteryHeaderView.swift
//  TotoShow
//
//  Created by Davi Cabral on 17/08/18.
//  Copyright © 2018 Davi Cabral. All rights reserved.
//

import UIKit

class LotteryHeaderView: UICollectionReusableView, ReusableView, NibLoadableView {

    @IBOutlet weak var titleLabel: UILabel!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed(LotteryHeaderView.reuseIdentifier, owner: self, options: nil)
    }
}
