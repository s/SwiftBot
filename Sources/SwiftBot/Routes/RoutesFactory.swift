//
//  RoutesFactory.swift
//  SwiftBot
//

import PerfectHTTP

internal protocol RoutesFactory {
    func routes() -> Routes
}

