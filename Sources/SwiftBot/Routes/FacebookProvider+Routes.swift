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
            Log.info("Subscribe Mode")
            
            if let token = request.param(name: "hub.verify_token"),
                let challenge = request.param(name: "hub.challenge"),
                token == self.secretToken {
                
                response.appendBody(string: challenge)
                response.completed(status: .ok)
            } else {
                Log.info("Invalid Subscribe Token");
                response.status = .forbidden;
            }
        } else {
            response.setBody(string: "")
            response.completed(status: .ok)
        }
    }
    
    private func webhookHandler(request: HTTPRequest, response: HTTPResponse) {
        Log.info("Facebook request")
        Log.info(request.queryParams.description)
        Log.info(request.postParams.description)
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
            Log.error("Can't parse requests \(error)")
            response.completed(status: .noContent)
        }
    }
}
