//
//  Activity.swift
//  Messanger
//

import Foundation

/// Type describe any kind of activities, that user can send throw the chat
public struct Activity {
    public enum `Type` {
        case message
        case ping
    }
    
    public let type: Type
    public let id: String
    public let conversation: Conversation
    public let from: Account
    public let recipient: Account
    public let timestamp: Date
    public let localTimestamp: Date
    
    public let text: String
//    public let attachments: []
    
    public init(type: Type,
                id: String,
                conversation: Conversation,
                from: Account,
                recipient: Account,
                timestamp: Date,
                localTimestamp: Date,
                text: String) {
        self.type = type
        self.id = id
        self.conversation = conversation
        self.from = from
        self.recipient = recipient
        self.timestamp = timestamp
        self.localTimestamp = localTimestamp
        self.text = text
    }
}

/// User account type
public struct Account {
    public let id: String
    public let name: String
}

public typealias ConversationService = String

/// Conversation type describe any chat between bot and user or multi user chat
public struct Conversation {
    public let members: [Account]
    public let status: String
    public let channelId: String
    
    public let activityId: ConversationService
//    public let serviceUrl: URL
}
