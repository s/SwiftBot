//
//  BotInterface.swift
//  EchoBot
//

import Foundation

public enum DispatchResult {
    case ok
    case error(Error)
}

public protocol Bot: class {
    weak var delegate: BotDelegate? { get set }
    
    @discardableResult
    func dispatch(activity: Activity) -> DispatchResult
}

public protocol BotDelegate: class {
    func send(activity: Activity)
}
