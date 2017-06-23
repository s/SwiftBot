//
//  Provider.swift
//  SwiftBot
//
//  Created by Andrew on 14/06/2017.
//
//

import Foundation

/// Chat provider receives and parses messages from chat.
/// And also can send messages back
public protocol Provider: class {
    weak var delegate: ProviderDelegate? { get set }
    func send(activity: Activity)
}

public protocol ProviderDelegate: class {
    func receive(message: Activity)
}

public enum ProviderError: Error {
    case cantParseJSON(Any)
    
    public var debugDescription: String {
        switch self {
        case let .cantParseJSON(json):
            return "Can't parse json \(json)"
            
        }
    }
}

