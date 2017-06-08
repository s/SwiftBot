//
//  MessagesDispatcher.swift
//  Messanger
//

import Foundation

public class MessagesDispatcher {
    let services: [Provider]
    public let updatesHandler: Signal<Activity> = Signal()
    
    public init(services: [Provider]) {
        self.services = services
        self.register(services: self.services)
    }
    
    public func send(activity: Activity) {
        debugPrint("Send message with service")
        services.forEach{ $0.send(activity: activity) }
    }
}

public protocol Provider: class {
    weak var delegate: ProviderDelegate? { get set }
    func parse(data: Data) throws
    func parse(json: JSON) throws
    
    func send(activity: Activity)
}

public protocol ProviderDelegate: class {
    func receive(message: Activity)
}

extension MessagesDispatcher: ProviderDelegate {
    internal func register(services: [Provider]) {
        services.forEach{ $0.delegate = self }
    }
    
    public func receive(message: Activity) {
        self.updatesHandler.update(message)
    }
}

enum DispatcherError: Error {
    case cantParseJSON(Any)
    
    public var debugDescription: String {
        switch self {
        case let .cantParseJSON(json):
            return "Can't parse json \(json)"
            
        }
    }
}

