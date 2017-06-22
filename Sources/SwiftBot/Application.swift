//
//  Application.swift
//  SwiftBot
//

import Foundation
import BotsKit
import ChatProviders

/// Main object that connect components for chat bot application.
/// This class init and store chat providers, dispatcher and
/// bots handlers
internal final class Application {
    let dispatcher: MessagesDispatcher
    internal let routes: [RoutesFactory]
    
    init(configuration: Configuration) {
        // Init providers
        let token = configuration.fbSubscribeToken
        let accessToken = configuration.fbPageAccessToken
        let facebook = FacebookProvider(secretToken: token, accessToken: accessToken)
        
        // Chat messages dispatcher connect messages from providers to bots
        dispatcher = MessagesDispatcher(services: [facebook])
        
        // Init other services
        let storage = StorageRoutes(dsn: configuration.dbURL)
        
        // Store services
        routes = [IndexRoutes(),
                  facebook,
                  storage]
        
        // Start application
        start()
    }
    
    private func start() -> Void {
        dispatcher.updatesHandler.subscribe{ (activity) in
            if activity.type == .message {
                let replay = Activity(type: .message,
                                      id: "",
                                      conversation: activity.conversation,
                                      from: activity.recipient,
                                      recipient: activity.from,
                                      timestamp: Date(),
                                      localTimestamp: Date(),
                                      text: activity.text)
                self.dispatcher.send(activity: replay)
            }
        }
    }
    
}
