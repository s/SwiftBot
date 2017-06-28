//
//  CoffeeRequest.swift
//  CoffeeRequest
//

import Foundation
import BotsKit

internal struct CoffeeRequest {
    let person : Account
    let coffees : [Coffee]
    
    var description : String {
        let coffeeDescriptions = coffees.map { (coffee) -> String in
            return coffee.description
        }
        return "\(person.name) would like to have: \n \(coffeeDescriptions.joined(separator:" "))"
    }
}
