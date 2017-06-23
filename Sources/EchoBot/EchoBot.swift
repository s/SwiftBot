//
//  EchoBot.swift
//  EchoBot
//

import Foundation
import BotsKit

public final class EchoBot: Bot {
   
    public let sendActivity: Signal<Activity>
    
    public init() {
        sendActivity = Signal()
    }
    
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
            sendActivity.update(replay)
        }
        return .ok
    }
}
