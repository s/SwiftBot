//
//  Parser.swift
//  ChatProviders
//

import Foundation
import Mapper

public protocol Parser {
    func parse(data: Data) throws
    func parse(json: JSON) throws
}
