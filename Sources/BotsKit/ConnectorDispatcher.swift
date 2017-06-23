//
//  ConnectorDispatcher.swift
//  BotsKit
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

internal final class BotConnector {
    
    let provider: Provider
    
    let bot: Bot
    
    init(bot: Bot, provider: Provider) {
        self.bot = bot
        self.provider = provider
        
        self.provider.update.subscribe{ bot.dispatch(activity: $0) }
        self.bot.sendActivity.subscribe{ provider.send(activity: $0) }
    }
    
}

public final class ConnectorDispatcher {
    var connectors: [BotConnector]
    
    public init() {
        connectors = []
    }
    
    public func register(bot: Bot, `in` provider: Provider) {
        let connector = BotConnector(bot: bot, provider: provider)
        connectors.append(connector)
    }
}
