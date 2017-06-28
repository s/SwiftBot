//
//  Session.swift
//  Session
//

import Foundation
import BotsKit

internal struct Session {
    
    var coffeesRequested : [CoffeeRequest] = []
    var membersReplied : [Account] {
        get {
            return self.coffeesRequested.map({ (request) -> Account in
                return request.person
            })
        }
    }
    
    var description : String {
        get {
            let descriptions : [String] = self.coffeesRequested.map { (request) -> String in
                return request.coffee.description
            }
            return descriptions.joined(separator: "\n")
        }
    }
}
