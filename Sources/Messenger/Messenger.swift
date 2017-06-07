//
//  Messenger.swift
//  SwiftBot
//

public protocol Service: class {
    weak var delegate: ServiceDelegate? { get set }
    func send(message: ReplayMessage)
}

public protocol ServiceDelegate: class {
    func receive(message: Message)
}


public typealias UpdatesHandler = (Message) -> Void

public class Messenger {
    let services: [Service]
    public let updatesHandler: Signal<Message> = Signal()
    
    public init(services: [Service]) {
        self.services = services
        self.register(services: self.services)
    }
    
    public func send(message: ReplayMessage) {
        debugPrint("Send message with service")
        services.forEach{ $0.send(message: message) }
    }
}

extension Messenger: ServiceDelegate {
    internal func register(services: [Service]) {
        services.forEach{ $0.delegate = self }
    }
    
    public func receive(message: Message) {
        self.updatesHandler.update(message)
    }
}
