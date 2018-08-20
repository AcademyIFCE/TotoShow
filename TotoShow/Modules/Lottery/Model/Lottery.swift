//
//  Lottery.swift
//  TotoShow
//
//  Created by Davi Cabral on 20/08/18.
//  Copyright © 2018 Davi Cabral. All rights reserved.
//

import Foundation
import UIKit

extension Array where Element: Equatable{
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
    
    init(range: CountableClosedRange<Int>) {
        self.lotteryRange = range
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
    
    func randomNumberInRange(range: CountableClosedRange<Int>? = nil) -> Int{
        let valueRange = range ?? lotteryRange
        return Int(arc4random_uniform(UInt32(valueRange.upperBound))) + (valueRange.lowerBound)
    }
    
    func uniqueNumber(from itens: [Int], range: CountableClosedRange<Int>? = nil) throws -> Int {
        let valueRange = range ?? lotteryRange
        let distinctItens = itens.distinct()
        if itens.count >= valueRange.upperBound { throw LotteryErrors.fullSet }
        else {
            var distinct = randomNumberInRange()
            while distinctItens.contains(distinct) { distinct = randomNumberInRange() }
            return distinct
        }
    }
    
    func drafts() {
        
    }
    
    // Picks a random unique number at time interval and notifies the subscriber. After the winner number has been reached, it begins to mock for a winner, it invalidates the timer after winner is found.
    func beginDraft(winnerFrom numbers: Int, interval: TimeInterval, completion: @escaping ([Int], Bool) -> Void) {
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
    
    //Not testable
    func mockSearchForWinner(for percentage: Int? = nil, winner: Int) -> Bool {
        let winningChance = percentage ?? (pickedNumbers.count - winner) * 5
        print(winningChance)
        return arc4random_uniform(100) <= winningChance
    }
}
