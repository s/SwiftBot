//
//  SendMessageRequest.swift
//  SwiftBot
//
//  Created by Andrew Tokarev on 15/06/2017.
//
//

import Foundation

public protocol ReplyRequest
{
    var recepientId : String { get }
    var messageText : String { get }
}

extension ReplyRequest {
    
    func generateFacebookMessageSendJSON() -> [String:Any] {
        let json = [
            "recipient": ["id": self.recepientId ],
            "message": ["text": self.messageText]
        ];
        
        return json;
    }
}
