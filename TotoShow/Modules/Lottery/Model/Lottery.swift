//
//  Lottery.swift
//  TotoShow
//
//  Created by Davi Cabral on 20/08/18.
//  Copyright © 2018 Davi Cabral. All rights reserved.
//

import Foundation

extension Array where Element: Equatable{
    /// Returns an array with only distinct elements
    ///
    /// - Parameter elements: Array of equatable elements
    /// - Returns: a an array with only distinct values from elements
    func distinct(elements: [Element] = []) -> [Element] {
        let itens = elements.count == 0 ? self : elements
        return itens.reduce([], {
            return $0.contains($1) ? $0 : $0 + [$1]
        })
    }
}

class Lottery {
    private let lotteryRange: CountableClosedRange<Int>
    var pickedNumbers = [Int]()
    var draft: Timer?
    var requiredBalls: Int = 0
    
    
    /// Inits a new lottery
    ///
    /// - Parameters:
    ///   - range: The range of balls numbers in the Lottery
    ///   - requiredToWin: Minimum number of balls required to win the game
    init(range: CountableClosedRange<Int>, requiredToWin: Int? = nil) {
        self.lotteryRange = range
        self.requiredBalls = requiredToWin ?? range.count/3
    }
    
    enum LotteryErrors: Error {
        case fullSet
        case finished
        
        var localizedDescription: String {
            switch self {
            case .fullSet:
                return "All unique values in range are already on Set"
            case .finished:
                return "Draft has ended"
            }
        }
    }
    
    /// Returns a random number on a given range, the default range is the one defined on the lottery creation
    ///
    /// - Parameter range: Range in which the random number is contained
    /// - Returns: a random number inside given range
    func randomNumberInRange(range: CountableClosedRange<Int>? = nil) -> Int{
        let valueRange = range ?? lotteryRange
        return Int(arc4random_uniform(UInt32(valueRange.upperBound))) + (valueRange.lowerBound)
    }
    
    /// Returns a unique number in a range given a array of ints, range default parameter is the one defined at the lottery instatiation
    ///
    /// - Parameters:
    ///   - itens: An array of Ints
    ///   - range: range in which the unique number will be choosen
    /// - Returns: a unique number from the given array in a choosed range
    /// - Throws: throws an error if the array already contains all unique numbers on that range
    func uniqueNumber(from itens: [Int], range: CountableClosedRange<Int>? = nil) throws -> Int {
        let valueRange = range ?? lotteryRange
        let distinctItens = itens.distinct()
        if distinctItens.count >= valueRange.count { throw LotteryErrors.fullSet }
        else {
            var distinct = randomNumberInRange(range: valueRange)
            while distinctItens.contains(distinct) { distinct = randomNumberInRange(range: valueRange) }
            return distinct
        }
    }
    
    /// Checks if the player has win the game
    ///
    /// - Parameters:
    ///   - markedNumbers: number of balls marked by the player
    ///   - required: number of balls required to win
    /// - Returns: if the player has win or not
    func isHeAWinner(markedNumbers: [Int], required: Int? = nil) -> Bool{
        let requiredBalls = required ?? self.requiredBalls
        return markedNumbers.count == requiredBalls
    }
    
    
    /// Picks a random unique number at time interval and notifies the subscriber. After the winner number has been reached, it begins to mock for a winner, it invalidates the timer after winner is found.
    ///
    /// - Parameters:
    ///   - numbers: minimum number of balls required to win the game
    ///   - interval: time between each ball draft
    ///   - completion: return an array of itens picked till that date and if the game has a winner or not
    func beginDraft(winnerFrom numbers: Int, interval: TimeInterval, completion: @escaping ([Int], Bool) -> Void) {
        requiredBalls = numbers
        draft = Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { [unowned self] timer in
            var hasWinner = false
            do {
                let number = try self.uniqueNumber(from: self.pickedNumbers)
                self.pickedNumbers.insert(number, at: 0)
                if self.pickedNumbers.count > numbers {
                    hasWinner = self.mockSearchForWinner(winner: numbers)
                    if hasWinner == true {
                        timer.invalidate()
                    }
                    completion(self.pickedNumbers, hasWinner)
                } else {
                    completion(self.pickedNumbers, false)
                }
            } catch {
                completion(self.pickedNumbers, true)
                timer.invalidate()
            }
        }
    }
    
    /// Not testable, fakes a winner
    ///
    /// - Parameters:
    ///   - percentage: Chance of drafting a winner
    ///   - winner: Number of balls already picked
    /// - Returns: if there has been a winner or not
    func mockSearchForWinner(for percentage: Int? = nil, winner: Int) -> Bool {
        let winningChance = percentage ?? (pickedNumbers.count - winner) * 5
        print(winningChance)
        return arc4random_uniform(100) <= winningChance
    }
}
