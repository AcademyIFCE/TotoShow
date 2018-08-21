//
//  TotoShowDelegate.swift
//  TotoShow
//
//  Created by Yuri Saboia Felix Frota on 20/08/18.
//  Copyright © 2018 Davi Cabral. All rights reserved.
//

import Foundation

protocol TotoCardDelegate: class {
    func addNumberToCard(index: Int)
    func changePrize()
    func numberOfPickedBalls() -> Int
    func numberForPicked(row: Int) -> Int
    func numberForCard(row: Int) -> Int
    func numberOfCards() -> Int
    func shouldSelectBall(of number: Int) -> Bool
}

protocol TotoLotteryDelegate: class {
    func updateNumbers(with itens: [Int])
    func winnerFound(winner: String)
}
