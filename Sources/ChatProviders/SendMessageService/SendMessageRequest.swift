//
//  SendMessageRequest.swift
//  SwiftBot
//
//  Created by Andrew Tokarev on 15/06/2017.
//
//

import Foundation

struct SendMessageRequest {
    
    let recepientId : String
    let messageText : String
    
    let accessToken : String
    let httpMethod  : String
}
