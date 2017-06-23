//
//  BotInterface.swift
//  EchoBot
//

import Foundation

/// Bot is process that can process activity
/// and send answer to user
public protocol Bot: class {
    var sendActivity: Signal<Activity> { get }
    
    @discardableResult
    func dispatch(activity: Activity) -> DispatchResult
}

public enum DispatchResult {
    case ok
    case error(Error)
}
