//
//  Messenger.swift
//  SwiftBot
//

import Foundation


public class Messenger {
    public static func parse(json: JSON) throws -> [Entry] {
        do {
            let request = try Request.mapped(json: json)
            return request.entry
        } catch {
            throw error
        }
    }
}

// MARK Requests

internal struct Request {
    let object: String
    let entry: [Entry]
}

public final class Entry {
    public let id: String
    public let time: Date
    public let messaging: [AbstractMessage]
    
    init(id: String, time: Date, messaging: [AbstractMessage]) {
        self.id = id
        self.time = time
        self.messaging = messaging
    }
}

public class AbstractMessage {
    public enum `Type` {
        case message
        case delivery
        case read
        case unknown
    }

    public let type: Type
    public let sender: String
    public let recipient: String
    public let timestamp: Date
    
    internal init(type: Type, sender: String, recipient: String, timestamp: Date) {
        self.type = type
        self.sender = sender
        self.recipient = recipient
        self.timestamp = timestamp
    }
}

// MARK Message

public final class Message: AbstractMessage {
    public let mid: String
    public let text: String
    public let attachments: [Attachment]?
    public let quickReply: QuickReply?
    
    internal init(sender: String, recipient: String, timestamp: Date, mid: String, text: String, attachments: [Attachment]?, quickReply: QuickReply?) {
        self.mid = mid
        self.text = text
        self.attachments = attachments
        self.quickReply = quickReply
        super.init(type: .message, sender: sender, recipient: recipient, timestamp: timestamp)
    }
}

public struct Attachment {
    enum `Type`: String {
        case audio
        case fallback
        case file
        case image
        case location
        case video
    }
    public struct MultimediaPayload {
        let url: String?
    }
    public struct LocationPayload {
        let lat: String
        let long: String
    }
    let type: Type
    let multimediaPayload: MultimediaPayload?
    let locationPayload: LocationPayload?
}

public struct QuickReply {
    let payload: String
}

// MARK Delivery

public final class Delivery: AbstractMessage {
    public let mids: [String]
    public let watermark: Int
    public let seq: Int
    
    internal init(sender: String, recipient: String, timestamp: Date, mids: [String], watermark: Int, seq: Int) {
        self.mids = mids
        self.watermark = watermark
        self.seq = seq
        super.init(type: .delivery, sender: sender, recipient: recipient, timestamp: timestamp)
    }
}

// MARK Read

public final class Read: AbstractMessage {
    public let watermark: Int
    public let seq: Int
    
    internal init(sender: String, recipient: String, timestamp: Date, watermark: Int, seq: Int) {
        self.watermark = watermark
        self.seq = seq
        super.init(type: .read, sender: sender, recipient: recipient, timestamp: timestamp)
    }
}


// MARK Parsed

extension Request: Mappable {
    public static func mapped(json: JSON) throws -> Request {
        return try Request(object: json => "object",
                            entry: json => "entry"
        )
    }
}

extension Entry: Mappable {
    public static func mapped(json: JSON) throws -> Entry {
        return try Entry(id: json => "id",
                         time: Date(),
                         messaging: (json => "messaging").flatMap{ return AbstractMessage.message(json: $0) }
        )
    }
}

extension AbstractMessage {
    static func message(json: Any) -> AbstractMessage? {
        do {
            if let message: Any = try json =>? KeyPath("message", optional: true) {
                return try Message(sender: json => "sender" => "id",
                                   recipient: json => "recipient" => "id",
                                   timestamp: json => "timestamp",
                                   mid: message => "mid",
                                   text: message => "text",
                                   attachments: nil,
                                   quickReply: nil)
            } else if let delivery = try json =>? KeyPath("delivery", optional: true) {
                return try Delivery(sender: json => "sender" => "id",
                                    recipient: json => "recipient" => "id",
                                    timestamp: json => "timestamp",
                                    mids: delivery => "mids",
                                    watermark: delivery => "watermark",
                                    seq: delivery => "seq")
            } else if let read = try json =>? KeyPath("read", optional: true) {
                return try Read(sender: json => "sender" => "id",
                                recipient: json => "recipient" => "id",
                                timestamp: json => "timestamp",
                                watermark: read => "watermark",
                                seq: read => "seq")
            }
        } catch {
            return nil;
        }
        return nil;
    }
}

extension Attachment: Mappable {
    public static func mapped(json: JSON) throws -> Attachment {
        return try Attachment(type: Type(rawValue: json => "type")!,
                              multimediaPayload: nil,
                              locationPayload: nil)
    }
    
}

