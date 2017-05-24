//
//  Messanger.swift
//  SwiftBot
//

import Foundation

// MARK Requests

public class Messenger {
    
}

internal struct Request {
    let object: String
    let entry: [Entry]
}

public protocol Entry {
    var type: Type { get }
    var sender: String { get }
    var recipient: String { get }
    var timestamp: Date { get }
}

public enum `Type` {
    case message
    case delivery
    case read
    
    case unknown
}

// MARK Message

public struct Message: Entry {
    public let type = Type.message
    public let sender: String
    public let recipient: String
    public let timestamp: Date

    public let mid: String
    public let text: String
    public let attachments: [Attachment]?
    public let quick_reply: QuickReply?
}

public struct Attachment {
    enum `Type` {
        case audio
        case fallback
        case file
        case image
        case location
        case video
    }
    public struct Payload {
        let url: String?
        
    }
    let type: Type
    let payload: Payload
}

public struct QuickReply {
    let payload: String
}

// MARK Delivery

public struct Delivery: Entry {
    public let type = Type.delivery
    public let sender: String
    public let recipient: String
    public let timestamp: Date
    
    public let mids: [String]
    public let watermark: Int
    public let seq: Int
}

// MARK Read

public struct Read: Entry {
    public let type = Type.read
    public let sender: String
    public let recipient: String
    public let timestamp: Date
    
    public let watermark: Int
    public let seq: Int
}
