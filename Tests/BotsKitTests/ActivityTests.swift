//
//  ActivityTests.swift
//  BotsKitTests
//

import XCTest
@testable import BotsKit


class ActivityTests: XCTestCase {
    
    func message(text: String = "Text") -> Activity {
        let from = Account(id: "from",
                           name: "From")
        let to = Account(id: "to",
                         name: "To")
        let conversation = Conversation(members: [from, to],
                                        status: "go",
                                        channelId: "2",
                                        activityId: "test")
        return Activity(type: .message,
                        id: "123",
                        conversation: conversation,
                        from: from,
                        recipient: to,
                        timestamp: Date(),
                        localTimestamp: Date(),
                        text: text)
    }
    
    func testActivityReplayUseText() {
        let message = self.message()
        let replay = message.replay(text: "Replay to someone!")
        
        XCTAssertEqual(replay.text, "Replay to someone!")
    }
    
    func testActivityReplayChangeRecipientOnFrom() {
        let message = self.message()
        let replay = message.replay(text: "")
        
        XCTAssertEqual(message.from, replay.recipient)
    }
    
    func testActivityReplayChangeFromOnRecipient() {
        let message = self.message()
        let replay = message.replay(text: "")
        
        XCTAssertEqual(message.recipient, replay.from)
    }
    
    func testActivityReplayInSameConversation() {
        let message = self.message()
        let replay = message.replay(text: "")
        
        XCTAssertEqual(message.conversation, replay.conversation)
    }
}

