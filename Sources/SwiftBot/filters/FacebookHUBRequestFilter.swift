//
//  FBTokenVerificationFilter.swift
//  SwiftBot
//
//  Created by Andrew on 30/05/2017.
//
//

import Foundation
import PerfectHTTP

public class FacebookHUBRequestFilter : HTTPRequestFilter
{
    private let secretToken : String
    
    public init(token: String) {
        self.secretToken = token;
    }
    
    public func filter(request: HTTPRequest, response: HTTPResponse, callback: (HTTPRequestFilterResult) -> ())
    {
        if (request.path == "/webhook" && !request.queryParams.isEmpty) {
            
            if let mode = request.param(name: "hub.mode"), mode == "subscribe" {
                
                HerokuLogger.info("Subscribe Mode\n");
                
                if let token = request.param(name: "hub.verify_token"),
                   let challenge = request.param(name: "hub.challenge"), token == secretToken {
                    
                    response.appendBody(string: challenge);
                    response.status = .ok
                }
                else {
                    
                    HerokuLogger.info("Invalid Subscribe Token\n");
                    
                    response.status = .forbidden;
                }
                
                callback(.halt(request, response));
                
                // No More Handlers / Filters
                return;
            }
        }
        
        // Default we pass it through
        callback(.continue(request, response));
    }
}
