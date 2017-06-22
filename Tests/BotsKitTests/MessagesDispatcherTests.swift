//
//  MessagesDispatcher.swift
//  BotsKit
//

import XCTest
import Mapper
@testable import BotsKit

final class TestProvider: Provider {
    weak var delegate: ProviderDelegate?
    
    func parse(data: Data) throws {
        
    }
    
    func parse(json: JSON) throws {
        let from = Account(id: "from_id", name: "from")
        let to = Account(id: "to_id", name: "to")
        let conversation = Conversation(members: [from, to],
                                        status: "",
                                        channelId: "",
                                        activityId: "test")
        let activity = try Activity(type: .message,
                                    id: "id",
                                    conversation: conversation,
                                    from: from,
                                    recipient: to,
                                    timestamp: Date(),
                                    localTimestamp: Date(),
                                    text: json => "text")
        self.delegate?.receive(message: activity)
    }
    
    func send(activity: Activity) {
        
    }
    
    
}

final class TestBot: Bot {
    weak var delegate: BotDelegate?
    var lastActivity: Activity?
    
    @discardableResult
    func dispatch(activity: Activity) -> DispatchResult {
        lastActivity = activity
        return .ok
    }
}

class MessagesDispatcherTests : XCTestCase {
    var dispatcher: MessagesDispatcher?
    
    func testActivityDispatch() {
        let provider = TestProvider()
        let bot = TestBot()
        dispatcher = MessagesDispatcher(providers: [provider], bots: [bot])
        
        XCTAssertNoThrow(try provider.parse(json: ["text":"Hello, World!"]))
        
        XCTAssertEqual(bot.lastActivity?.text, "Hello, World!")
    }
}

