//
//  CoffeeBot.swift
//  CoffeeBot
//

import LoggerAPI
import BotsKit

internal protocol CoffeeBotInputProtocol {
    func send(activity:Activity)
}

public final class CoffeeBot : Bot {
    
    //MARK: Bot Protocol Properties
    public let name = "CoffeeBot"
    public var sendActivity: Signal<Activity> = Signal()
    
    //MARK: Other Properties
    private let coffeeManager : CoffeeManager
    
    //MARK: Bot Protocol Methods
    public func dispatch(activity: Activity) -> DispatchResult {
        self.coffeeManager.process(activity: activity)
        return .ok
    }
    
    //MARK: Lifecycle
    public init() {
        let sessionService = SessionService()
        let appointingService = AppointingService()
        let spellCheckerService = SpellCheckingService()
        let entityRecognitionService = EntityRecognitionService()
        let textProcessingService = TextProcessingService(spellCheckerService: spellCheckerService,
                                                          entityRecognitionService: entityRecognitionService)
        
        self.coffeeManager = CoffeeManager(textProcessingService: textProcessingService,
                                           appointingService:appointingService,
                                           sessionService:sessionService)
        self.coffeeManager.botDelegate = self
    }
}

extension CoffeeBot : CoffeeBotInputProtocol {
    func send(activity: Activity) {
        self.sendActivity.update(activity)
    }
}
