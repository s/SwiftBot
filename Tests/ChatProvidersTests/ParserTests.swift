//
//  ParserTests.swift
//  SwiftBot
//

import XCTest
@testable import ChatProviders

struct TestObj: Mappable {
    let value: String
    
    static func mapped(json: JSON) throws -> TestObj {
        return try TestObj(value: json => "key")
    }
}

class ParserTests: XCTestCase {
    
    func testParse() {
        let text = "{\"key\":\"value\"}"
        do {
            let json = try JSONSerialization.jsonObject(with: text.data(using: .utf8)!, options: .mutableLeaves)
            let o = try TestObj.mapped(json: json)
            XCTAssertEqual(o.value, "value")
        } catch {
            XCTAssert(false, "Can't parse json \(error.localizedDescription)");
        }
    }
    
    func testNestedParse() {
        let text = "{\"key\":{\"key2\":{\"key3\":\"value\"}}}"
        do {
            let json = try JSONSerialization.jsonObject(with: text.data(using: .utf8)!, options: .mutableLeaves)
            let value: String = try json => "key" => "key2" => "key3"
            XCTAssertEqual(value, "value")
        } catch {
            XCTAssert(false, "Can't parse json \(error.localizedDescription)");
        }
    }
    
}
