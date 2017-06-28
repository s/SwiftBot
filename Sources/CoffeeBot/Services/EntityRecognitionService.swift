//
//  EntityRecognitionService.swift
//  PerfectLib
//
//  Created by Said Ozcan on 28/06/2017.
//

import Foundation

internal protocol EntityRecognitionServiceProtocol {
    func parse(_ text:String) -> [Coffee]
}

internal class EntityRecognitionService {}

extension EntityRecognitionService : EntityRecognitionServiceProtocol {
    
    func parse(_ text: String) -> [Coffee] {
        //TODO: Parse entities in the given text and return relevant models
        return []
    }
}
