//
//  MessagesDispatcher.swift
//  Messanger
//

import Foundation

public class MessagesDispatcher {
    let serviceProviders: [Provider]
    public let updatesHandler: Signal<Activity> = Signal()
    
    public init(services: [Provider]) {
        self.serviceProviders = services
        self.register(services: self.serviceProviders)
    }
    
    public func send(activity: Activity) {
        debugPrint("Send message with service")
        serviceProviders.forEach{ $0.send(activity: activity) }
    }
}

extension MessagesDispatcher: ProviderDelegate {
    internal func register(services: [Provider]) {
        services.forEach{ $0.delegate = self }
    }
    
    public func receive(message: Activity) {
        self.updatesHandler.update(message)
    }
}

public enum DispatcherError: Error {
    case cantParseJSON(Any)
    
    public var debugDescription: String {
        switch self {
        case let .cantParseJSON(json):
            return "Can't parse json \(json)"
            
        }
    }
}

