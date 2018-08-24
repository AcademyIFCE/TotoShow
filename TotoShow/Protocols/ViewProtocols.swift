//
//  ViewProtocols.swift
//  FastCaico
//
//  Created by Davi Cabral on 10/07/18.
//  Copyright © 2018 academy. All rights reserved.
//

import UIKit

protocol ReusableView: class {
    static var reuseIdentifier: String { get }
}
protocol NibLoadableView: class {
    associatedtype View
    static var nibName: String { get }
    static func viewForNib() -> View?
    static func asNib() -> UINib
}

/*Implements obrigatory reuse identifiers from class name to views that
 conform to this protocol */
extension ReusableView where Self: UIView {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}

extension NibLoadableView where Self: UIView {
    static var nibName: String {
        return String(describing: self)
    }
    
    //Load view from nib using class reference
    static func viewForNib() -> Self? {
        guard let view =  Bundle.main.loadNibNamed(Self.nibName, owner: self, options: nil)?.first as? Self else {
            return nil
        }
        return view
    }
    
    static func asNib() -> UINib {
        return UINib(nibName: nibName, bundle: Bundle.main)
    }
}



