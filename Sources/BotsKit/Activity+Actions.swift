//
//  Activity+Actions.swift
//  BotsKit
//

import Foundation

extension Activity {
    public func replay(text: String) -> Activity {
        return Activity(type: self.type,
                        id: "",
                        conversation: self.conversation,
                        from: self.recipient,
                        recipient: self.from,
                        timestamp: Date(),
                        localTimestamp: Date(),
                        text: text)
    }
}
