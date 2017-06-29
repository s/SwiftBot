//
//  FacebookGraphResponse.swift
//  SwiftBot
//
//  Created by Andrew Tokarev on 29/06/2017.
//
//

import Foundation

struct FacebookGraphResponse {
    public let body : String?
    public let error: Error?
    
    init(body: String) {
        self.body  = body
        self.error = nil;
    }
    
    init(error: Error) {
        self.body  = nil;
        self.error = error
    }
}
