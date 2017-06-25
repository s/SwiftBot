//
//  MessengerWebhook.swift
//  Messanger
//

import Foundation
import LoggerAPI
import Mapper

public final class MessengerWebhook {
    internal struct Request {
        let object: String
        let entry: [Entry]
    }
    
    internal func parse(callback: JSON) throws -> Request {
        Log.verbose("Start parse \(callback)")
        return try Request.mapped(json: callback)
    }
}

// MARK Requests

public final class Entry {
    
    public enum Item {
        case message(Details, message: Message)
        case delivery(Details, delivery: Delivery)
        case read(Details, read: Read)
        case undefined
    }
    
    public final class Details {
        public let sender: String
        public let recipient: String
        public let timestamp: Date
        
        internal init(sender: String, recipient: String, timestamp: Date) {
            self.sender = sender
            self.recipient = recipient
            self.timestamp = timestamp
        }
    }
    
    public let id: String
    public let time: Date
    public let messaging: [Item]
    
    init(id: String, time: Date, messaging: [Item]) {
        self.id = id
        self.time = time
        self.messaging = messaging
    }
}

// MARK Message

public final class Message {
    public let mid: String
    public let text: String?
    public let attachments: [Attachment]?
    public let quickReply: QuickReply?
    
    internal init(mid: String, text: String?, attachments: [Attachment]?, quickReply: QuickReply?) {
        self.mid = mid
        self.text = text
        self.attachments = attachments
        self.quickReply = quickReply
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

public final class Delivery {
    public let mids: [String]
    public let watermark: Int
    public let seq: Int
    
    internal init(mids: [String], watermark: Int, seq: Int) {
        self.mids = mids
        self.watermark = watermark
        self.seq = seq
    }
}

// MARK Read

public final class Read {
    public let watermark: Int
    public let seq: Int
    
    internal init(watermark: Int, seq: Int) {
        self.watermark = watermark
        self.seq = seq
    }
}


// MARK Parsed

extension MessengerWebhook.Request: Mappable {
    public static func mapped(json: JSON) throws -> MessengerWebhook.Request {
        return try MessengerWebhook.Request(object: json => "object",
                                            entry: json => "entry"
        )
    }
}

extension Entry: Mappable {
    public static func mapped(json: JSON) throws -> Entry {
        return try Entry(id: json => "id",
                         time: json => "time",
                         messaging: json => "messaging"
        )
    }
}

extension Entry.Item: Mappable {
    public static func mapped(json: JSON) throws -> Entry.Item {
        do {
            let metadata = try Entry.Details(sender: json => "sender" => "id",
                                             recipient: json => "recipient" => "id",
                                             timestamp: json => "timestamp")
            if let message = try json =>? KeyPath("message", optional: true) {
                return .message(metadata,
                                message: try Message(mid: message => "mid",
                                                     text: message =>? KeyPath("text", optional: true),
                                                     attachments: message =>? KeyPath("attachments", optional: true),
                                                     quickReply: nil))
            } else if let delivery = try json =>? KeyPath("delivery", optional: true) {
                return .delivery(metadata,
                                 delivery: try Delivery(mids: delivery => "mids",
                                                        watermark: delivery => "watermark",
                                                        seq: delivery => "seq"))
            } else if let read = try json =>? KeyPath("read", optional: true) {
                return .read(metadata,
                             read: try Read(watermark: read => "watermark",
                                            seq: read => "seq"))
            }
        } catch {
            throw error
        }
        return .undefined
    }
}

extension Attachment: Mappable {
    public static func mapped(json: JSON) throws -> Attachment {
        return try Attachment(type: Type(rawValue: json => "type")!,
                              multimediaPayload: json =>? KeyPath("payload", optional: true),
                              locationPayload: nil)
    }
}

extension Attachment.MultimediaPayload: Mappable {
    public static func mapped(json: JSON) throws -> Attachment.MultimediaPayload {
        return try Attachment.MultimediaPayload(url: json =>? KeyPath("url", optional: true))
    }
}

extension Attachment.LocationPayload: Mappable {
    public static func mapped(json: JSON) throws -> Attachment.LocationPayload {
        let coordinatesKeyPath = KeyPath("coordinates", optional: true)
        guard let coordinates = try json =>? coordinatesKeyPath else {
            throw ParseError.missedKey(key: coordinatesKeyPath, of: json)
        }
        return try Attachment.LocationPayload(lat: coordinates => "lat", long: coordinates => "long")
    }
}
