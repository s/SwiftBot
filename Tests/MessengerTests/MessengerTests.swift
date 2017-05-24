
import XCTest
@testable import Messanger

class MessangerTests : XCTest {
    func testMmessage() {
        let msg = Message(sender: "123",
                          recipient: "122",
                          timestamp: Date(),
                          mid: "mid",
                          text: "text",
                          attachments: nil,
                          quick_reply: nil)
        XCTAssertNotNil(msg)
        XCTAssertEqual(msg.type, Type.message)
    }
}
