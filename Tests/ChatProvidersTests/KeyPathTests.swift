//
//  KeyPathTests.swift
//  SwiftBot
//


import XCTest
@testable import ChatProviders

class KeyPathTests : XCTestCase {
    
    func testKeyPathInit() {
        let key: ChatProviders.KeyPath = "key1"
        XCTAssertEqual(key.path, ["key1"])
    }
    
    func testKeyPathChaine() {
        let key: ChatProviders.KeyPath = "key1" => "key2"
        XCTAssertEqual(key.path, ["key1", "key2"])
    }
}

