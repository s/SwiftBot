//
//  SendMessageService.swift
//  SwiftBot
//
//  Created by Andrew Tokarev on 15/06/2017.
//
//

import Foundation

class SendMessageService {
    
    private let httpTransport: HttpTransportable;
    
    init(httpTransport: HttpTransportable) {
        self.httpTransport = httpTransport;
    }
    
    func send(request: SendMessageRequest, _ callback: (_ response: SendMessageResponse)->()) {
        
        
        if let url = URL(string: "https://graph.facebook.com/v2.6/me/messages?access_token=PAGE_ACCESS_TOKEN") {
        
            httpTransport.request(method: .post, url: url, data: Data(), callback: { (code, body, error) in
                
                callback(SendMessageResponse(body: body,
                                             error:error))
            })
        }
        
        
    }
}
