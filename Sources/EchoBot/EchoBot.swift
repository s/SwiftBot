//
//  EchoBot.swift
//  EchoBot
//

import BotsKit
import Foundation

public final class EchoBot: Bot {
    public var delegate: BotDelegate?
    
    public init() { }
    
    public func dispatch(activity: Activity) -> DispatchResult {
        if activity.type == .message {
            let replay = Activity(type: .message,
                                  id: "",
                                  conversation: activity.conversation,
                                  from: activity.recipient,
                                  recipient: activity.from,
                                  timestamp: Date(),
                                  localTimestamp: Date(),
                                  text: activity.text)
            if let delegate = self.delegate {
                delegate.send(activity: replay)
            }
        }
        return .ok
    }
}
