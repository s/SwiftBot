//
//  Facebook.swift
//  SwiftBot
//

import Foundation
import PerfectHTTP
import PerfectCURL
import Facebook
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
                let challenge = request.param(name: "hub.challenge") {
                switch (self.take(challenge: challenge, token: token)) {
                case .ok(let answer):
                    response.appendBody(string: answer)
                    response.completed(status: .ok)
                    Log.info("Subscribe mode challenge done")
                case .error(let error):
                    response.status = .forbidden;
                    Log.warning(error)
                }
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
            try self.parse(data: postData)
            response.completed(status: .ok)
        } catch {
            Log.error("Can't messenger webhook request with \(error)")
            response.completed(status: .noContent)
        }
    }
}
