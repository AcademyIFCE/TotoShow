//
//  HeaderView.swift
//  TotoShow
//
//  Created by Davi Cabral on 17/08/18.
//  Copyright © 2018 Davi Cabral. All rights reserved.
//

import UIKit

class HeaderView: UIView {

    
    @IBInspectable var title: String = "" {
        didSet {
            self.titleLabel.text = title
        }
    }
    
    private var imageView: UIImageView = {
       let imageView = UIImageView(image: #imageLiteral(resourceName: "letreiro"))
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        var label = UILabel()
        label.textColor = .white
        label.sizeToFit()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame.size = self.frame.size
    }
    
    private func commonInit() {
        self.addSubview(imageView)
        self.addSubview(titleLabel)
        
        
        NSLayoutConstraint.activate([
                NSLayoutConstraint(item: titleLabel, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: titleLabel, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0)
            ])
        
    }
    
    func setText(_ text: String) {
        self.titleLabel.text = text
    }
}
