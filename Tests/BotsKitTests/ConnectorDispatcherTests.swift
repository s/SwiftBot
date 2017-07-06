//
//  ConnectorDispatcherTests.swift
//  BotsKitTests
//

import XCTest
@testable import BotsKit

final class TestProvider: Provider {
    var name: String = "TestProvider"

    let recieveActivity: Signal<Activity>
    internal let updateInput: SignalInput<Activity>
    
    init() {
        let (input, signal) = Signal<Activity>.create()
        recieveActivity = signal
        updateInput = input
    }
    
    func receive(activity: Activity) {
        updateInput.update(activity)
    }
    
    func send(activity: Activity) {
        
    }
    
    func parse(data: Data) throws {
        
    }
}

final class TestBot: Bot {
    var name: String = "TestBot"

    public let sendActivity: Signal<Activity>
    var lastActivity: Activity?
    
    init() {
        sendActivity = Signal()
    }
    
    @discardableResult
    func dispatch(activity: Activity) -> DispatchResult {
        lastActivity = activity
        return .ok
    }
}

class ConnectorDispatcherTests: XCTestCase {
    
    var dispatcher: ConnectorDispatcher?
    
    func testActivityDispatch() {
        let provider = TestProvider()
        let bot = TestBot()
        
        dispatcher = ConnectorDispatcher()
        dispatcher?.register(bot: bot, in: provider)
        
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
                                text: "Hello, World!")
        provider.receive(activity: activity)
        
        XCTAssertEqual(bot.lastActivity?.text, "Hello, World!")
    }
    
}
