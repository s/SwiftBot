//
//  Activity+ReplyRequest.swift
//  SwiftBot
//
//  Created by Andrew Tokarev on 27/06/2017.
//
//

import Foundation
import BotsKit

extension Activity : ReplyRequest {
    
    public var recepientId : String {
        return self.recipient.id
    }
    
    public var messageText : String {
        return self.text
    }
}
