
import XCTest
import Foundation
@testable import ChatProviders

class mockDelegate: ProviderDelegate {
    var lastActivity: Activity?
    
    func receive(message: Activity) {
        self.lastActivity = message
    }
}

#if os(Linux)
extension FacebookServiceTests {
    static var allTests : [(String, FacebookServiceTests -> () throws -> Void)] {
        return [
            ("testMessage", testMessage),
            ("testDelivery", testDelivery),
            ("testRead", testRead),
            ("testActivityParsing", testActivityParsing)
        ]
    }
}
#endif

class FacebookServiceTests : XCTestCase {
    var facebook: FacebookProvider!
    var webhook: MessengerWebhook!
    
    override func setUp() {
        facebook = FacebookProvider(secretToken: "secret", accessToken: "access")
        webhook = MessengerWebhook()
    }
    
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
            let request = try webhook.parse(callback: input)
            XCTAssertEqual(request.entry.count, 1)
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
            let request = try webhook.parse(callback: input)
            XCTAssertEqual(request.entry.count, 1)
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
            let request = try webhook.parse(callback: input)
            XCTAssertEqual(request.entry.count, 1)
        } catch {
            XCTFail("Failed to parse JSON \(error)")
        }
    }
    
    func testActivityParsing() {
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
            let delegate = mockDelegate()
            facebook.delegate = delegate
            try facebook.parse(json: input)
            XCTAssertNotNil(delegate.lastActivity)
            let activity = delegate.lastActivity!
            XCTAssertEqual(activity.text, "does this work?")
            XCTAssertEqual(activity.conversation.channelId, "260317677677806")
            XCTAssertEqual(activity.conversation.activityId, "facebook")
        } catch {
            XCTFail("Failed to parse JSON \(error)")
        }
    }
    
}
