//
//  SendMessageResponse.swift
//  SwiftBot
//
//  Created by Andrew Tokarev on 15/06/2017.
//
//

import Foundation

public struct ReplyResponse {
    
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
