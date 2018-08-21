//
//  TotoShowModel.swift
//  TotoShow
//
//  Created by Yuri on 20/08/18.
//  Copyright © 2018 Davi Cabral. All rights reserved.
//

import Foundation

enum Prize {
    case first
    case second
}

class TotoShowModel {
    private let firstPrize = Lottery(range: 1...50)
    private let secondPrize = Lottery(range: 1...50)
    private let firstCard = Card()
    private let secondCard = Card()
    private var prize: Prize = .second
    private weak var lotteryDelegate: TotoLotteryDelegate!
    
    init(delegate: TotoLotteryDelegate) {
        lotteryDelegate = delegate
        startLottery(prize: .second)
    }
    
    private func startLottery(prize: Prize) {
        switch prize {
        case .first:
            firstPrize.beginDraft(winnerFrom: 20, interval: 2.5) { [unowned self] picks, winner in
                if self.prize == .first {
                    self.lotteryDelegate.updateNumbers(with: picks)
                }
                if winner {
                    self.lotteryDelegate.winnerFound(winner: "First Prize Winner not you")
                }
            }
        case .second:
            secondPrize.beginDraft(winnerFrom: 20, interval: 2.5) { [unowned self] picks, winner in
                if self.prize == .second {
                    self.lotteryDelegate.updateNumbers(with: picks)
                }
                if winner {
                    self.lotteryDelegate.winnerFound(winner: "Second Prize Winner not you")
                    self.startLottery(prize: .first)
                }
            }
        }
    }
}

extension TotoShowModel: TotoCardDelegate {
    func numberForCard(row: Int) -> Int {
        switch prize {
        case .first:
            return firstCard.numbers[row]
        case .second:
            return secondCard.numbers[row]
        }

    }
    
    func numberOfCards() -> Int {
        switch prize {
        case .first:
            return firstCard.numbers.count
        case .second:
            return secondCard.numbers.count
        }
    }
    
    func shouldSelectBall(of number: Int) -> Bool {
        switch prize {
        case .first:
            return firstPrize.pickedNumbers.contains(firstCard.numbers[number])
        case .second:
            return secondPrize.pickedNumbers.contains(secondCard.numbers[number])
        }
    }
    
    func numberOfPickedBalls() -> Int {
        switch prize {
        case .first:
            return firstPrize.pickedNumbers.count
        case .second:
            return secondPrize.pickedNumbers.count
        }
    }
    
    func numberForPicked(row: Int) -> Int {
        switch prize {
        case .first:
            return firstPrize.pickedNumbers[row]
        case .second:
            return secondPrize.pickedNumbers[row]
        }
    }
    
    func addNumberToCard(index: Int) {
        switch prize {
        case .first:
            firstCard.addNumberToCard(number: firstCard.numbers[index])
            if firstPrize.isHeAWinner(markedNumbers: firstCard.markedNumbers) {
                firstPrize.draft?.invalidate()
                lotteryDelegate.winnerFound(winner: "You won the first prize")
            }
        case .second:
            secondCard.addNumberToCard(number: secondCard.numbers[index])
            if secondPrize.isHeAWinner(markedNumbers: secondCard.markedNumbers) {
                lotteryDelegate.winnerFound(winner: "You won the second prize")
                secondPrize.draft?.invalidate()
                self.startLottery(prize: .first)
            }
        }
    }
    
    func changePrize() {
        switch prize {
        case .first:
            self.prize = .second
        case .second:
            self.prize = .first
        }
    }
}
