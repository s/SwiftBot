//
//  MessagesDispatcher.swift
//  Messanger
//

import Foundation

/*
     ---------------------
     |      Provider     |
     ---------------------
        ||             ^
        || Activity    | Message to chat provider
        \/             |
     ---------------------
     |     Dispatcher    |
     ---------------------
        ||             /\
        || Activity    || Replay
        \/             ||
     ----------------  ||
     |   Bot Impl   |===/
     ----------------
     |   Storage    |
     ----------------
 */

/// Dispatcher connect bots and providers
public class MessagesDispatcher {
    
    /// Map of all chanels
    let serviceProviders: [Provider]
    
    /// Map of bots
    let bots: [Bot]
    
    public init(providers: [Provider], bots: [Bot]) {
        self.serviceProviders = providers
        self.bots = bots
        self.register(providers: self.serviceProviders, bots: self.bots)
    }
    
    internal func register(providers: [Provider], bots: [Bot]) {
        providers.forEach{ $0.delegate = self }
        bots.forEach{ $0.delegate = self }
    }
}

extension MessagesDispatcher: ProviderDelegate {
    public func receive(message: Activity) {
        self.bots.forEach{ $0.dispatch(activity: message) }
    }
}

extension MessagesDispatcher: BotDelegate {
    public func send(activity: Activity) {
        debugPrint("Send message with service")
        serviceProviders.forEach{ $0.send(activity: activity) }
    }
}

