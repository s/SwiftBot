//
//  KeyPath.swift
//  Messanger
//

import Foundation

public struct KeyPath: ExpressibleByStringLiteral, ExpressibleByArrayLiteral, CustomStringConvertible, Equatable {
    public private(set) var path: [String]
    public private(set) var optional: Bool = false
    
    public init(_ path: [String]) {
        self.path = path
    }
    
    public init(_ path: String) {
        self.path = [path]
    }
    
    public init(_ path: String, optional: Bool) {
        self.path = [path]
        self.optional = optional;
    }
    
// MARK: ExpressibleByStringLiteral
    public init(stringLiteral value: String) {
        self.path = [value]
    }
    
    public init(extendedGraphemeClusterLiteral value: String) {
        self.path = [value]
    }
    
    public init(unicodeScalarLiteral value: String) {
        self.path = [value]
    }
    
// MARK: ExpressibleByArrayLiteral
    public init(arrayLiteral elements: String...) {
        self.path = elements
    }
    
    // MARK: CustomStringConvertible
    public var description: String {
        get {
            return self.path.description
        }
    }
    
// MARK: Equatable
    public static func ==(lhs: KeyPath, rhs: KeyPath) -> Bool {
        return lhs.path == rhs.path
    }
}

public func => (lhs: KeyPath, rhs: KeyPath) -> KeyPath {
    return KeyPath(lhs.path + rhs.path)
}
