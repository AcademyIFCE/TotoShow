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
    
    init() {
        guard let path = Bundle.main.path(forResource: "numbers", ofType: ".json"), let file = FileManager().contents(atPath: path) else {
            return
        }
        numbers = numbersFromJson(data: file).sorted()
    }
    
    //Parse numbers from a given JSON data
    func numbersFromJson(data: Data) -> [Int] {
        let decoder = JSONDecoder()
        let card = try? decoder.decode(Card.self, from: data)
        return card?.numbers ?? []
    }
    
    //Add a number to the marked numbers
    func addNumberToCard(number: Int, cardNumbers: [Int]? = nil) {
        let numbersArray = cardNumbers ?? numbers
        if !markedNumbers.contains(number) && numbersArray.contains(number) {
            self.markedNumbers.append(number)
        }
    }
}
