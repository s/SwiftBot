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
