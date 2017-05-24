//
//  Parse.swift
//  SwiftBot
//

public protocol Parser {
    static func parse(json: Any, handler: @escaping (Entry) -> Void)
}

extension Messenger: Parser {
    public static func parse(json: Any, handler: @escaping (Entry) -> Void ) {
        
    }
}
