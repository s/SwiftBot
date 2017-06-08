//
//  KeyPathTests.swift
//  SwiftBot
//


import XCTest
@testable import Messenger
import struct Messenger.KeyPath

class KeyPathTests : XCTestCase {
    
    func testKeyPathInit() {
        let key: Messenger.KeyPath = "key1"
        XCTAssertEqual(key.path, ["key1"])
    }
    
    func testKeyPathChaine() {
        let key: Messenger.KeyPath = "key1" => "key2"
        XCTAssertEqual(key.path, ["key1", "key2"])
    }
}

