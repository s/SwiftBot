//
//  Facebook.swift
//  SwiftBot
//

import Foundation
import PerfectHTTP
import PerfectCURL
import Messenger

extension Facebook: RoutesFactory {
    internal func routes() -> Routes {
        var routes = Routes(baseUri: "/webhook")
        
        let webhookChallenge: RequestHandler = { [unowned self] (request, response) in
            if let mode = request.param(name: "hub.mode"), mode == "subscribe" {
                HerokuLogger.info("Subscribe Mode\n");
                
                if let token = request.param(name: "hub.verify_token"),
                    let challenge = request.param(name: "hub.challenge"),
                    token == self.secretToken {
                    
                    response.appendBody(string: challenge)
                    response.completed(status: .ok)
                } else {
                    HerokuLogger.info("Invalid Subscribe Token\n");
                    response.status = .forbidden;
                }
            } else {
                response.setBody(string: "")
                response.completed(status: .ok)
            }
        }
        
        let webhookHandler: RequestHandler = { [unowned self] (request, response) in
            
            if let postBodyBytes = request.postBodyBytes {
                let postData = Data(bytes: postBodyBytes)
                do {
                    if let json = try? JSONSerialization.jsonObject(with: postData, options: []) {
                        try self.parse(json: json)
                    }
                } catch {
                    HerokuLogger.info("Error on message parsing \(error)")
                }
                
            }
            logRequest(request)
            
            response.completed(status: .ok)
        }
        
        routes.add(method: .get,  uri: "", handler: webhookChallenge)
        routes.add(method: .post, uri: "", handler: webhookHandler)
        
        return routes;
    }
}

private func logRequest(_ request: HTTPRequest) {
    HerokuLogger.info("query: \(request.queryParams)\n")
    HerokuLogger.info("data: \(request.postParams)\n")
}
