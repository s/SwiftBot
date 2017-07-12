//
//  HttpTransporter.swift
//  SwiftBot
//
//  Created by Andrew Tokarev on 11/07/2017.
//
//

import Foundation

public enum HttpTransporterMethod: Hashable, CustomStringConvertible {
    
    case get
    case post
    
    public var description: String {
        switch self {
        case .get:      return "GET"
        case .post:     return "POST"
        }
    }
}

public protocol HttpTransporter
{
    func sendRequest(url: URL, method: HttpTransporterMethod, headers:[String: String], data: Data?) throws -> String
}

