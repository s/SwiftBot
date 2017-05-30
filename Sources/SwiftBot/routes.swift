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

internal func createHtmlRoute() -> Route {
    return Route(method: .get, uri: "/", handler: { request, response in
        // Respond with a simple message.
        response.setHeader(.contentType, value: "text/html")
        response.appendBody(string: "<html><title>Hello, world!</title><body>Hello, world!</body></html>")
        // Ensure that response.completed() is called when your processing is done.
        response.completed()
    })
}

internal func createWebhookRoutes() -> Routes {
    var webhook = Routes(baseUri: "/webhook")
    let webhookHandler: RequestHandler = { (request, response) in
        
        logRequest(request);

        response.completed(status: .ok)
    }
    // Test: curl  -X GET "http://localhost:8080//webhook?hub.mode=subscribe&hub.challenge=27493587&hub.verify_token=mega-secret-token-1"
    webhook.add(method: .get, uri: "", handler: webhookHandler)
    webhook.add(method: .post, uri: "", handler: webhookHandler)
    
    return webhook;
}

private func logRequest(_ request: HTTPRequest) {
    HerokuLogger.info("query: \(request.queryParams)\n")
    HerokuLogger.info("data: \(request.postParams)\n")
}

internal func routes() -> Routes {
    // Set routes
    var routes = Routes(baseUri: "/")
    
    routes.add(createHtmlRoute())
    routes.add(createWebhookRoutes())
    
    return routes;
}
