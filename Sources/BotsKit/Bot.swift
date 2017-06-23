//
//  BotInterface.swift
//  EchoBot
//

import Foundation

/// Bot is process that can process activity
/// and send answer to user
public protocol Bot: class {
    weak var delegate: BotDelegate? { get set }
    
    @discardableResult
    func dispatch(activity: Activity) -> DispatchResult
}

public protocol BotDelegate: class {
    func send(activity: Activity)
}

public enum DispatchResult {
    case ok
    case error(Error)
}
