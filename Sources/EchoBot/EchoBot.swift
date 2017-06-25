//
//  EchoBot.swift
//  EchoBot
//

import LoggerAPI
import BotsKit

public final class EchoBot: Bot {
    public let name = "Echo Bot"
   
    public let sendActivity: Signal<Activity> = Signal()
    
    public init() {}
    
    public func dispatch(activity: Activity) -> DispatchResult {
        Log.debug("\(self.name) dispatch activity \(activity.id) of type \(activity.type)")
        if activity.type == .message {
            sendActivity.update(activity.replay(text: activity.text))
        }
        return .ok
    }
}
