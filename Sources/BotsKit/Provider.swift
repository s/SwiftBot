//
//  Provider.swift
//  SwiftBot
//
//  Created by Andrew on 14/06/2017.
//
//

import Foundation
import Mapper

public protocol Provider: class {
    weak var delegate: ProviderDelegate? { get set }
    func parse(data: Data) throws
    func parse(json: JSON) throws
    
    func send(activity: Activity)
}

public protocol ProviderDelegate: class {
    func receive(message: Activity)
}
