//
//  Application.swift
//  SwiftBot
//

import Foundation
import BotsKit
import ChatProviders
import EchoBot

/// Main object that connect components for chat bot application.
/// This class init and store chat providers, dispatcher and
/// bots handlers
internal final class Application {
    let dispatcher: ConnectorDispatcher
    internal let routes: [RoutesFactory]
    
    init(configuration: Configuration) {
        // Init providers
        let token = configuration.fbSubscribeToken
        let accessToken = configuration.fbPageAccessToken
        let facebook = FacebookProvider(secretToken: token, accessToken: accessToken)
        
        let echoBot = EchoBot()
        
        // Chat messages dispatcher connect messages from providers to bots
        dispatcher = ConnectorDispatcher()
        dispatcher.register(bot: echoBot, in: facebook)
        
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
    }
    
}
