//
//  KeyPathTests.swift
//  SwiftBot
//


import XCTest
@testable import ChatProviders

class KeyPathTests : XCTestCase {
    
    func testKeyPathInit() {
        let key: KeyPath = "key1"
        XCTAssertEqual(key.path, ["key1"])
    }
    
    func testKeyPathChaine() {
        let key: KeyPath = "key1" => "key2"
        XCTAssertEqual(key.path, ["key1", "key2"])
    }
}

