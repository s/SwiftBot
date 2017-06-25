//
//  Facebook.swift
//  SwiftBot
//

import Foundation
import PerfectHTTP
import PerfectCURL
import ChatProviders
import LoggerAPI

extension FacebookProvider: RoutesFactory {
    internal func routes() -> Routes {
        var routes = Routes(baseUri: "/webhook")
        routes.add(method: .get,  uri: "", handler: webhookChallenge)
        routes.add(method: .post, uri: "", handler: webhookHandler)
        return routes;
    }
    
    private func webhookChallenge(request: HTTPRequest, response: HTTPResponse) {
        if let mode = request.param(name: "hub.mode"), mode == "subscribe" {
            Log.info("Starting subscribe mode challenge")
            
            if let token = request.param(name: "hub.verify_token"),
                let challenge = request.param(name: "hub.challenge"),
                token == self.secretToken {
                
                response.appendBody(string: challenge)
                response.completed(status: .ok)
                Log.info("Subscribe mode challenge done")
            } else {
                Log.warning("Invalid Subscribe Token in request \(request.params())");
                response.status = .forbidden;
            }
        } else {
            response.setBody(string: "")
            response.completed(status: .ok)
        }
    }
    
    private func webhookHandler(request: HTTPRequest, response: HTTPResponse) {
        Log.info("Messenger webhook request start")
        guard let postBodyBytes = request.postBodyBytes else {
            response.completed(status: .noContent)
            return
        }
        let postData = Data(bytes: postBodyBytes)
        do {
            let json = try JSONSerialization.jsonObject(with: postData, options: [])
            try self.parse(json: json)
            response.completed(status: .ok)
        } catch {
            Log.error("Can't messenger webhook request with \(error)")
            response.completed(status: .noContent)
        }
    }
}
