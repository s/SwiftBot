//
//  EchoBotTests.swift
//  EchoBot
//


import XCTest
import BotsKit
@testable import EchoBot

final class TestBotDelegate: BotDelegate {
    var lastActivity: Activity?
    
    func send(activity: Activity) {
        lastActivity = activity
    }
}

class EchoBotTests : XCTestCase {
    
    func testEchoMessage() {
        let bot = EchoBot()
        let delegate = TestBotDelegate()
        bot.delegate = delegate
        
        let from = Account(id: "from_id", name: "from")
        let to = Account(id: "to_id", name: "to")
        let conversation = Conversation(members: [from, to],
                                        status: "",
                                        channelId: "",
                                        activityId: "test")
        let activity = Activity(type: .message,
                                id: "id",
                                conversation: conversation,
                                from: from,
                                recipient: to,
                                timestamp: Date(),
                                localTimestamp: Date(),
                                text: "text")
        let _ = bot.dispatch(activity: activity)
        
        XCTAssertNotNil(delegate.lastActivity)
        XCTAssertEqual(delegate.lastActivity?.text, "text")
        XCTAssertEqual(delegate.lastActivity?.from.id, "to_id")
        XCTAssertEqual(delegate.lastActivity?.recipient.id, "from_id")
    }
}
