//
//  KeyPathTests.swift
//  SwiftBot
//


import XCTest
@testable import Mapper

class KeyPathTests : XCTestCase {
    
    func testKeyPathInit() {
        let key: Mapper.KeyPath = "key1"
        XCTAssertEqual(key.path, ["key1"])
    }
    
    func testKeyPathChaine() {
        let key: Mapper.KeyPath = "key1" => "key2"
        XCTAssertEqual(key.path, ["key1", "key2"])
    }
}

