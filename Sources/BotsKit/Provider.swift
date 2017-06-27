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
    
    /// Fancy provider name
    var name: String { get }
    
    /// Provider recieve activity signal
    var recieveActivity: Signal<Activity> { get }
    
    /// Send activity to provider
    ///
    /// - Parameter activity: response from bot to send to the provider
    func send(activity: Activity)
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

