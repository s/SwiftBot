//
//  ParserTests.swift
//  SwiftBot
//

import XCTest
@testable import Messanger

class ParserTests: XCTestCase {
    
    func testParse() {
        let json = ["key":"value"]
        Messanger.parse(json: json) { (entry: Entry) in
            
        }
    }
    
}
