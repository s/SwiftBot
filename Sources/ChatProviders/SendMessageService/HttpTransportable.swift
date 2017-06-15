//
//  HttpTransportable.swift
//  SwiftBot
//
//  Created by Andrew Tokarev on 15/06/2017.
//
//

import Foundation

enum HttpTransportableMethod: Hashable, CustomStringConvertible {
    
    case get
    case post
    
    public var description: String {
        switch self {
        case .get:      return "GET"
        case .post:     return "POST"
        }
    }

}
protocol HttpTransportable {
    
    func request(method: HttpTransportableMethod, url: URL, data: Data, callback:(_ status:Int, _ body: String, _ error: Error?)->());
}
