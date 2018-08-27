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

/// Model for the Lottery with Two Prizes
class TotoShowModel {
    private let firstPrize = Lottery(range: 1...50)
    private let secondPrize = Lottery(range: 1...50)
    private let firstCard = Card()
    private let secondCard = Card()
    private var prize: Prize = .second
    private weak var lotteryDelegate: TotoLotteryDelegate!
    
    
    /// Inits the model for the prizes
    ///
    /// - Parameter delegate: The object that will react to the drafts
    init(delegate: TotoLotteryDelegate) {
        lotteryDelegate = delegate
        startLottery(prize: .second)
    }
    
    
    /// Starts the draft for one of the two prizes on the model, it will only return a updated numbers for the prize being drafted at the moment.
    ///
    /// - Parameter prize: selected prize to start the draft
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

extension TotoShowModel {
    
    /// Returns a number from the card
    ///
    /// - Parameter row: the selected index to be returned
    /// - Returns: the Number for the index passed
    func numberForCard(row: Int) -> Int {
        switch prize {
        case .first:
            return firstCard.numbers[row]
        case .second:
            return secondCard.numbers[row]
        }

    }
    
    
    /// Returns the quantity of numbers in the card
    ///
    /// - Returns: quantity of numbers in the card
    func numberOfCards() -> Int {
        switch prize {
        case .first:
            return firstCard.numbers.count
        case .second:
            return secondCard.numbers.count
        }
    }
    
    
    /// Returns if the ball should be selectable, the ball can only be selected if has already been drafted
    ///
    /// - Parameter number: the index of the ball that wants to be selected
    /// - Returns: If it can be selected or not
    func shouldSelectBall(of number: Int) -> Bool {
        switch prize {
        case .first:
            return firstPrize.pickedNumbers.contains(firstCard.numbers[number])
        case .second:
            return secondPrize.pickedNumbers.contains(secondCard.numbers[number])
        }
    }
    
    
    /// Should automaticly select the balls, it will return true if the ball has already been marked by the player
    ///
    /// - Parameter number: the index of the ball to be marked
    /// - Returns: If it should be marked or not
    func shouldMarkBall(of number: Int) -> Bool {
        switch prize {
        case .first:
            return firstCard.markedNumbers.contains(number)
        case .second:
            return secondCard.markedNumbers.contains(number)
        }
    }
    
    
    /// Number of balls drafted till now
    ///
    /// - Returns: The number of drafted balls on the selected prize
    func numberOfPickedBalls() -> Int {
        switch prize {
        case .first:
            return firstPrize.pickedNumbers.count
        case .second:
            return secondPrize.pickedNumbers.count
        }
    }
    
    
    /// Number for the row in the drafted balls
    ///
    /// - Parameter row: index of the wanted number
    /// - Returns: number of the wanted index
    func numberForPicked(row: Int) -> Int {
        switch prize {
        case .first:
            return firstPrize.pickedNumbers[row]
        case .second:
            return secondPrize.pickedNumbers[row]
        }
    }
    
    
    /// Add number to the card of the selected prize
    ///
    /// - Parameter index: index of the selected ball to be added
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
    
    
    /// Toggle between prizes
    func changePrize() {
        switch prize {
        case .first:
            self.prize = .second
        case .second:
            self.prize = .first
        }
    }
}
