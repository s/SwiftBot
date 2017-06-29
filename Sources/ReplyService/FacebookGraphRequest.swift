//
//  FacebookGraphRequest.swift
//  SwiftBot
//
//  Created by Andrew Tokarev on 29/06/2017.
//
//

import Foundation

struct FacebookGraphRequest {
    
    enum HttpMethod: Hashable, CustomStringConvertible {
        
        case get
        case post
        
        public var description: String {
            switch self {
            case .get:      return "GET"
            case .post:     return "POST"
            }
        }
    }
    
    let path: String                // /me/messages
    let params: [String: String]    // access_token:xxx
    let body: Data                  // might be json
    let contentType: String         // application/json
    
    let httpMethod: HttpMethod      // .post, .get
}
