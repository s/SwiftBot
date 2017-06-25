//
//  Parser.swift
//  ChatProviders
//

import Foundation
import Mapper

/// TODO Good candidate to rename
/// This protocol describe object that can parse Data or JSON object
public protocol Parser {
    func parse(data: Data) throws
    func parse(json: JSON) throws
}
