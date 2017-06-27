//
//  SendMessageService.swift
//  SwiftBot
//
//  Created by Andrew Tokarev on 15/06/2017.
//
//

import Foundation
import PerfectCURL

public final class ReplyService {
    
    private let accessToken: String;
    
    private var urlString: String { return "https://graph.facebook.com/v2.6/me/messages?access_token=\(self.accessToken)" }
        
    public init(accessToken : String) {
        self.accessToken = accessToken
    }
    
    public func send(replyRequest: ReplyRequest, _ callback: (_ response: ReplyResponse)->()) {

        let json = [
            "recipient": ["id": replyRequest.recepientId ],
            "message": ["text": replyRequest.messageText]
        ];
        
        sendJson(json, callback)
    }
    
    fileprivate func sendJson(_ json: [String:Any], _ callback: (_ response: ReplyResponse)->()) {
        do {
            // Serialize
            let data = try JSONSerialization.data(withJSONObject: json)
            
            // Send
            let res = try performPOSTUrlRequest(self.urlString, data: data);
            
            // Callback
            callback(ReplyResponse(body: res))
        }
        catch let error {
            callback(ReplyResponse(error: error))
        }
    }
    
    fileprivate func performPOSTUrlRequest(_ url: String, data: Data) throws -> String {
        let request = CURLRequest(url,
                                  .httpMethod(.post),
                                  .addHeader(.fromStandard(name: "Content-Type"), "application/json"),
                                  .postData([UInt8](data)))
        return try request.perform().bodyString
    }

}
