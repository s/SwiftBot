//
//  Signal.swift
//  Messanger
//

import Foundation

public class Signal<T> {
    fileprivate var value: T?
    fileprivate var callbacks: [(T)->Void] = []
    
    public init() {}
    
    public var lastValue: T? {
        return value
    }
    
    public func subscribe(_ callback: @escaping (T)->Void) {
        callbacks.append(callback)
        if let value = self.value {
            callback(value)
        }
    }
    
    public func update(_ newValue: T) {
        value = newValue
        callbacks.forEach {
            $0(newValue)
        }
    }
}

