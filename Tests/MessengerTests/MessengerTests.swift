
import XCTest
@testable import Messenger

class MessengerTests : XCTestCase {
    
    func testMessage() {
        let input = ["object":"page",
                     "entry": [
                        ["messaging": [
                            ["message":
                                [
                                    "text": "does this work?",
                                    "mid":"mid.1466015596912:7348aba4de4cfddf91",
                                    "attachments": [
                                        [
                                            "type": "image",
                                            "payload": [
                                                "url": "https://s-media-cache-ak0.pinimg.com/736x/da/af/73/daaf73960eb5a21d6bca748195f12052.jpg"
                                            ]
                                        ]
                                    ]
                                ],
                            "timestamp":1466015596919,
                            "sender": ["id": "885721401551027"],
                            "recipient": ["id": "260317677677806"]
                            ]
                        ],
                        "time":1466015596947,
                        "id":"260317677677806"]
            ]
            ] as [String : Any]
        
        do {
            let entries = try Messenger.parse(json: input)
            XCTAssertEqual(entries.count, 1)
        } catch {
            XCTFail("Failed to parse JSON \(error)")
        }
    }
    
    func testDelivery() {
        let input = ["object":"page",
                     "entry": [
                        ["messaging": [
                            ["delivery" :
                                [
                                    "mids": [],
                                    "watermark": 123123123123,
                                    "seq": 123
                                
                                ],
                             "timestamp":1466015596919,
                             "sender": ["id": "885721401551027"],
                             "recipient": ["id": "260317677677806"]
                            ]
                            ],
                         "time":1466015596947,
                         "id":"260317677677806"]
            ]
            ] as [String : Any]
        
        do {
            let entries = try Messenger.parse(json: input)
            XCTAssertEqual(entries.count, 1)
        } catch {
            XCTFail("Failed to parse JSON \(error)")
        }
    }
    
    func testRead() {
        let input = ["object":"page",
                     "entry": [
                        ["messaging": [
                            ["read" :
                                [
                                    "watermark": 123123123123,
                                    "seq": 123
                                ],
                             "timestamp":1466015596919,
                             "sender": ["id": "885721401551027"],
                             "recipient": ["id": "260317677677806"]
                            ]
                            ],
                         "time":1466015596947,
                         "id":"260317677677806"]
            ]
            ] as [String : Any]
        
        do {
            let entries = try Messenger.parse(json: input)
            XCTAssertEqual(entries.count, 1)
        } catch {
            XCTFail("Failed to parse JSON \(error)")
        }
    }
    
}
