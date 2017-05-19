//
//  routes.swift
//  SwiftBot
//
//  Created by mainuser on 5/19/17.
//
//

import Foundation
import PerfectHTTP
import PerfectHTTPServer
#if os(Linux)
    import Glibc
#else
    import Darwin
#endif

enum Logger {
    static func info(_ string: String) {
        fputs(string, stdout)
        fflush(stdout)
    }
}

internal func routes() -> Routes {
    // Set routes
    var routes = Routes(baseUri: "/")
    routes.add(method: .get, uri: "/", handler: { request, response in
        // Respond with a simple message.
        response.setHeader(.contentType, value: "text/html")
        response.appendBody(string: "<html><title>Hello, world!</title><body>Hello, world!</body></html>")
        // Ensure that response.completed() is called when your processing is done.
        response.completed()
    })
    
    let WebHookToken = "mega-secret-token-1"
    var webhook = Routes(baseUri: "/webhook")
    let webhookHandler: RequestHandler = { (request, response) in
        Logger.info("query: \(request.queryParams)\n")
        Logger.info("data: \(request.postParams)\n")
        
        let hubMode = request.param(name: "hub.mode")
        let hubToken = request.param(name: "hub.verify_token")
        let hubChallenge = request.param(name: "hub.challenge")
        
        if let mode = hubMode, mode == "subscribe" {
            
            if let token = hubToken, let challenge = hubChallenge, token == WebHookToken {
                Logger.info("Validating webhook\n");
                
                response.appendBody(string: challenge);
                response.completed(status: .ok)
            }
            else {
                response.completed(status: .forbidden);
            }
        }
        else {
            response.completed(status: .ok)
        }
    }
    // Test: curl  -X GET "http://localhost:8080//webhook?hub.mode=subscribe&hub.challenge=27493587&hub.verify_token=mega-secret-token-1"
    webhook.add(method: .get, uri: "", handler: webhookHandler)
    webhook.add(method: .post, uri: "", handler: webhookHandler)
    routes.add(webhook)
    return routes;
}
