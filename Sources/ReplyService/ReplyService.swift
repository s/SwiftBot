//
//  SendMessageService.swift
//  SwiftBot
//
//  Created by Andrew Tokarev on 15/06/2017.
//
//

import Foundation

public final class ReplyService {
    
    private let accessToken: String;
    
    private let facebookGraph = FacebookGraph(httpTransporter: CURLHttpTransporter())
        
    public init(accessToken : String) {
        self.accessToken = accessToken
    }
    
    public func send(replyRequest: ReplyRequest, _ callback: (_ response: ReplyResponse)->())
    {
        let json = replyRequest.generateFacebookMessageSendJSON()
        
        do {
            let request = try FacebookGraphRequest.meMessagePostRequest(accessToken: accessToken, json: json)
            
            let response = facebookGraph.post(request: request)
            
            switch response {
            case .body (let text):  callback(ReplyResponse(body: text))
            case .error(let error): callback(ReplyResponse(error: error))
            }
        }
        catch let error {
            callback(ReplyResponse(error: error))
        }
    }
}
