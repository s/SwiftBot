//
//  CoffeeManager.swift
//  SwiftBot
//

import Foundation

class CoffeeManager : NSObject {
    open let persons : [Person]
    
    init(with persons: [Person]) {
        self.persons = persons
    }
}

extension CoffeeManager : CoffeeManagerInputProtocol {
    func process(text: String) {
        
    }
}
