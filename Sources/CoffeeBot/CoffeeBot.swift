//
//  CoffeeBot.swift
//  CoffeeBot
//

import LoggerAPI
import BotsKit

public final class CoffeeBot : Bot {
    
    //MARK: Properties
    public let name = "CoffeeBot"
    public var sendActivity: Signal<Activity> = Signal()
    private let coffeeManager : CoffeeManager
    
    //MARK: Bot Protocol
    public func dispatch(activity: Activity) -> DispatchResult {
        self.coffeeManager.process(activity: activity)
        return .ok
    }
    
    //MARK: Lifecycle
    public init() {
        self.coffeeManager = CoffeeManager()
        self.coffeeManager.botDelegate = self
    }
}

extension CoffeeBot : CoffeeBotInputProtocol {
    func send(activity: Activity) {
        self.sendActivity.update(activity)
    }
}
