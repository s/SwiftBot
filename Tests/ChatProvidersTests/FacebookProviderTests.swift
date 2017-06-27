//
//  FacebookProviderTests.swift
//  ChatProviders
//

import XCTest
import Foundation
import BotsKit
@testable import ChatProviders

#if os(Linux)
extension FacebookProviderTests {
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

class FacebookProviderTests : XCTestCase {
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
            try facebook.parse(json: input)
            XCTAssertNotNil(facebook.recieveActivity.lastValue)
            let activity = facebook.recieveActivity.lastValue!
            XCTAssertEqual(activity.text, "does this work?")
            XCTAssertEqual(activity.conversation.channelId, "260317677677806")
            XCTAssertEqual(activity.conversation.activityId, "facebook")
        } catch {
            XCTFail("Failed to parse JSON \(error)")
        }
    }
    
    func testAttachments() {
        let input = ["object":"page",
                     "entry": [
                        [
                            "id": "223368791496726",
                            "time": 1497537501665,
                            "messaging": [
                                [
                                    "sender": [
                                        "id": "1212086162234423"
                                    ],
                                    "recipient":[
                                        "id": "223368791496726"
                                    ],
                                    "timestamp": 1497537501264,
                                    "message": [
                                        "mid": "mid.$cAADLJzyxrohi3XYgUFcrDDV6Ze4Y",
                                        "seq": 15180,
                                        "attachments": [
                                            [
                                                "type": "image",
                                                "payload": [
                                                    "url": "https://scontent.xx.fbcdn.net/v/t34.0-12/17690680_1741708379474843_664560316_n.gif?fallback"
                                                ]
                                            ]
                                        ]
                                    ]
                                ]
                            ]
                        ]
            ]] as [String: Any]
        do {
            let request = try webhook.parse(callback: input)
            let m = request.entry.last!.messaging.last
            XCTAssertNotNil(m)
            
            if case let Entry.Item.message(_, message: msg) = m! {
                XCTAssertNil(msg.text)
                XCTAssertNotNil(msg.attachments)
                
                guard let attachment = msg.attachments?.last else {
                    XCTFail("Did not prased attachment right")
                    return
                }
                XCTAssertEqual(attachment.type, .image)
                XCTAssertEqual(attachment.multimediaPayload?.url, "https://scontent.xx.fbcdn.net/v/t34.0-12/17690680_1741708379474843_664560316_n.gif?fallback")
            } else {
                XCTFail("Parsed item is not a message")
            }
        } catch {
            XCTFail("Failed to parse JSON \(error)")
        }
        //            {\"object\":\"page\",\"entry\":[{\"id\":\"223368791496726\",\"time\":1497537501665,\"messaging\":[{\"sender\":{\"id\":\"1212086162234423\"},\"recipient\":{\"id\":\"223368791496726\"},\"timestamp\":1497537501264,\"message\":{\"mid\":\"mid.$cAADLJzyxrohi3XYgUFcrDDV6Ze4Y\",\"seq\":15180,\"attachments\":[{\"type\":\"image\",\"payload\":{\"url\":\"https:\\/\\/scontent.xx.fbcdn.net\\/v\\/t34.0-12\\/17690680_1741708379474843_664560316_n.gif?fallback", "1"), ("_nc_ad", "z-m"), ("oh", "cd8368e49dbad1eb9f6b4d661b736bf9"), ("oe", "5944B972\"}}]}}]}]}
    }
    
    
}
