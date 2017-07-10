//
//  EchoBot.swift
//  EchoBot
//

import LoggerAPI
import BotsKit

public final class EchoBot: Bot {
    public let name = "Echo Bot"
   
    public let sendActivity: Signal<Activity>
    internal let sendInput: SignalInput<Activity>
    
    public init() {
        let (input, signal) = Signal<Activity>.create()
        self.sendActivity = signal
        self.sendInput = input
    }
    
    public func dispatch(activity: Activity) {
        Log.debug("\(self.name) dispatch activity \(activity.id) of type \(activity.type)")
        if activity.type == .message {
            sendInput.update(activity.replay(text: activity.text))
        }
    }
}
