//
//  Signal.swift
//  BotsKit
//


public class Signal<T> {
    fileprivate var value: T?
    fileprivate var callbacks: [(T)->Void] = []
    
    public class func create() -> (input: SignalInput<T>, signal: Signal<T>) {
        let signal = Signal()
        return (SignalInput(signal: signal), signal)
    }
    
    public var lastValue: T? {
        return value
    }
    
    public func subscribe(_ callback: @escaping (T)->Void) {
        callbacks.append(callback)
        if let value = self.value {
            callback(value)
        }
    }
    
    fileprivate func update(_ newValue: T) {
        value = newValue
        callbacks.forEach {
            $0(newValue)
        }
    }
}

public protocol Input {
    associatedtype InputValue
    
    @discardableResult
    func update(_ newValue: InputValue) -> Bool
}

public final class SignalInput<T>: Input {
    public typealias InputValue = T
    fileprivate weak var signal: Signal<T>?
    
    fileprivate init(signal: Signal<T>) {
        self.signal = signal
    }
    
    @discardableResult
    public func update(_ newValue: T) -> Bool {
        guard let s = signal else {
            return false
        }
        s.update(newValue)
        return true
    }
}

