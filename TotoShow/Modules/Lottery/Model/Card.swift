//
//  Card.swift
//  TotoShow
//
//  Created by Yuri on 20/08/18.
//  Copyright © 2018 Davi Cabral. All rights reserved.
//

import Foundation

class Card: Decodable {
    var numbers = [Int]()
    var markedNumbers = [Int]()
    
    private enum CodingKeys: String, CodingKey {
        case numbers
    }
    
    
    /// Init a Card from the numbers.json on the main Bundle
    init() {
        guard let path = Bundle.main.path(forResource: "numbers", ofType: ".json"), let file = FileManager().contents(atPath: path) else {
            return
        }
        numbers = numbersFromJson(data: file).sorted()
    }
    
    
    /// Parse numbers from a given JSON data
    ///
    /// - Parameter data: JSON Data
    /// - Returns: A list of numbers in the given JSON
    func numbersFromJson(data: Data) -> [Int] {
        let decoder = JSONDecoder()
        let card = try? decoder.decode(Card.self, from: data)
        return card?.numbers ?? []
    }
    
    
    /// Marks number in the Card adding it to the markedNumbers variable
    ///
    /// - Parameters:
    ///   - number: number to be marked
    ///   - cardNumbers: an array o numbers that have already been marked, it will use the cards array if nil
    func addNumberToCard(number: Int, cardNumbers: [Int]? = nil) {
        let numbersArray = cardNumbers ?? numbers
        if !markedNumbers.contains(number) && numbersArray.contains(number) {
            self.markedNumbers.append(number)
        }
    }
}
