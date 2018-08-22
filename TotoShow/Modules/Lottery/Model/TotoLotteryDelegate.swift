//
//  TotoShowDelegate.swift
//  TotoShow
//
//  Created by Yuri Saboia Felix Frota on 20/08/18.
//  Copyright © 2018 Davi Cabral. All rights reserved.
//

import Foundation

protocol TotoLotteryDelegate: class {
    func updateNumbers(with itens: [Int])
    func winnerFound(winner: String)
}
