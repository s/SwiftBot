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
            sendActivity.update(activity.replay(text: activity.text))
        }
        return .ok
    }
}
