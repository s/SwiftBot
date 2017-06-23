//
//  EchoBotTests.swift
//  EchoBot
//


import XCTest
import BotsKit
@testable import EchoBot

class EchoBotTests : XCTestCase {
    
    func testEchoMessage() {
        let bot = EchoBot()
        
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
        
        XCTAssertNotNil(bot.sendActivity.lastValue)
        XCTAssertEqual(bot.sendActivity.lastValue?.text, "text")
        XCTAssertEqual(bot.sendActivity.lastValue?.from.id, "to_id")
        XCTAssertEqual(bot.sendActivity.lastValue?.recipient.id, "from_id")
    }
}
