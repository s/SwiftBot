//
//  BotInterface.swift
//  EchoBot
//

import Foundation

/// Bot is process that can process activity
/// and send answer to user
public protocol Bot: class {
    
    /// Bot name
    var name: String { get }
    
    /// Signal use for bot feedback
    var sendActivity: Signal<Activity> { get }
    
    /// Process income message
    ///
    /// - Parameter activity: income activity
    func dispatch(activity: Activity)
}
