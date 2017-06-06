//
//  Message.swift
//  SwiftBot
//

import Foundation

public protocol Message {
    var id: String { get }
    var senderId: String { get }
    var text: String? { get }
}

// Context will store original message and chanel
// context will be serialazible
public protocol Context {
    
}

// TODO rename this methods
public struct ReplayMessage {
    let recipient: String
    let text: String
    
    public init(recipient: String, text: String) {
        self.recipient = recipient
        self.text = text
    }
}
