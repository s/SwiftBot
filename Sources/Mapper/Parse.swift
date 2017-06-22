//
//  Parse.swift
//  Messanger
//

import Foundation

enum ParseError: Error {
    case missedKey(key: KeyPath, of: Any)
    case typeMismatch(expected: Any.Type, of: Any)
    
    public var debugDescription: String {
        switch self {
        case let .typeMismatch(expected, of):
            return "Type mismatch on parse. Expected type \(expected), but \(of) is of type \(type(of: of))"
        case let .missedKey(key, of):
            return "Missed key \(key) in \(of)"
        
        }
    }
}

// JSON types

public typealias JSON = Any

// JSON mapping

public protocol Mappable {
    static func mapped(json: JSON) throws -> Self
}

// MARK: Parse

internal func parse(_ json: JSON, key: KeyPath) throws -> Any {
    var result = json
    for k in key.path {
        guard let value = try (cast(result) as [String:Any])[k] else {
            throw ParseError.missedKey(key: key, of: json)
        }
        result = value
        
    }
    return result
}

internal func parseOptional(_ json: JSON, key: KeyPath) throws -> Any? {
    var result = json
    for k in key.path {
        guard let value = try (cast(result) as [String:Any])[k] else {
            if !key.optional {
                throw ParseError.missedKey(key: key, of: json)
            } else {
                return nil;
            }
        }
        result = value
        
    }
    return result
}


internal func cast<T>(_ object: Any) throws -> T {
    guard let result = object as? T else {
        throw ParseError.typeMismatch(expected: T.self, of: object)
    }
    return result
}

internal func parse<T>(_ json: JSON, key: KeyPath, parser: ((Any) throws -> T)) throws -> T {
    return try parser(parse(json, key: key))
}

internal func parseOptional<T>(_ json: JSON, key: KeyPath, parser: ((Any) throws -> T)) throws -> T? {
    guard let object = try parseOptional(json, key: key) else {
        return nil
    }
    return try parser(object)
}



// MARK: Operations

precedencegroup TraversPrecedence {
    associativity: right
    higherThan: CastingPrecedence
}

infix operator =>  : TraversPrecedence
infix operator =>? : TraversPrecedence

public func => (lhs: JSON, rhs: KeyPath) throws -> Any {
    return try parse(lhs, key: rhs, parser: {$0})
}

public func => <T:Mappable>(lhs: JSON, rhs: KeyPath) throws -> T {
    return try parse(lhs, key: rhs, parser: {try T.mapped(json: $0)})
}

public func =>? (lhs: JSON, rhs: KeyPath) throws -> Any? {
    return try parseOptional(lhs, key: rhs, parser: Optional.mapper({$0}))
}

public func => (lhs: JSON, rhs: KeyPath) throws -> [Any] {
    return try parse(lhs, key: rhs, parser: {
        $0 as! [Any]
    })
}

public func => <T:Mappable>(lhs: JSON, rhs: KeyPath) throws -> [T] {
    return try parse(lhs, key: rhs, parser: {
        try Array.mapped($0)
    })
}

// MARK: Mapper helpers

extension Optional {
    static func mapper(_ wrappedDecoder: @escaping (Any) throws -> Wrapped) -> (Any) throws -> Wrapped? {
        return { json in
            if json is NSNull {
                return nil
            } else {
                return try wrappedDecoder(json)
            }
        }
    }
}

extension Array where Element: Mappable {
    internal static func mapped(_ json: Any) throws -> [Element] {
        return try [Element].mapped(json, decoder: { (o: Any) -> Element? in
            guard let element = try? Element.mapped(json: o) else {
                return nil;
            }
            return element;
        })
    }
}

extension Array {
    public static func mapped(_ json: JSON, decoder: @escaping (Any) -> Element? ) throws -> [Element] {
        let object:[Any] = try cast(json)
        return object.flatMap { (o:Any) -> Element? in
            return decoder(o)
        }
    }
}

// MARK: foundation classes mappers

extension String: Mappable {
    public static func mapped(json: JSON) throws -> String {
        return try cast(json) as String
    }
}

extension Int: Mappable {
    public static func mapped(json: JSON) throws -> Int {
        return try cast(json) as Int
    }
}

extension Date: Mappable {
    public static func mapped(json: JSON) throws -> Date {
        let time: Int = try cast(json)
        return Date(timeIntervalSince1970: Double(time/1000))
    }
}

