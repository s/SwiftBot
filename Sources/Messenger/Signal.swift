//
//  Signal.swift
//  PerfectLib
//

import Foundation

public class Signal<T> {
    private var _value: T?
    private var _callbacks: [(T)->Void] = []
    public var lastValue: T? {
        return _value
    }
    
    public func subscribe(_ callback: @escaping (T)->Void) {
        _callbacks.append(callback)
        if let value = _value {
            callback(value)
        }
    }
    
    internal func update(_ newValue: T) {
        _value = newValue
        _callbacks.forEach {
            $0(newValue)
        }
    }
}

