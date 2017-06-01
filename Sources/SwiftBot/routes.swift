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
import Storage
import PerfectCURL

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
        
        parseRequestAndReplyWithEcho(request);
        logRequest(request);
    
        response.completed(status: .ok)
    }
    
    webhook.add(method: .get,  uri: "", handler: webhookHandler)
    webhook.add(method: .post, uri: "", handler: webhookHandler)

    return webhook;
}

internal func createStorageRoutes() -> Routes {
    var routes = Routes(baseUri: "/storage")

    let storageFetchHandler: RequestHandler = { (request, response) in
        response.setHeader(.contentType, value: "text/plain")
        do {
            let storage = try Storage();
            let value = try storage.fetch( request.param(name: "key")! )
            response.appendBody(string: "Value: \(String(describing: value))")
            response.completed(status: .ok)
        } catch {
            response.completed(status: .internalServerError)
        }
        
    }

    let storageStoreHandler: RequestHandler  = { (request, response) in
        guard let key = request.param(name: "key") else { return }
        guard let value = request.param(name: "value") else { return }
        
        response.setHeader(.contentType, value: "text/plain")
        do {
            let storage = try Storage();
            try storage.store( key, value )
            response.appendBody(string: "Stored")
            response.completed(status: .ok)
        } catch {
            response.completed(status: .internalServerError)
        }
     
    }

    routes.add(method: .get,  uri: "/fetch", handler: storageFetchHandler)
    routes.add(method: .get,  uri: "/store", handler: storageStoreHandler)
    return routes;
}


private func parseRequestAndReplyWithEcho(_ request: HTTPRequest) {
    if let postBodyBytes = request.postBodyBytes {
        let postData = Data(bytes: postBodyBytes)
        if let json = try? JSONSerialization.jsonObject(with: postData, options: []) as? [String: Any] {
            
            
            if let entries = json?["entry"] as? [[String:Any]] {
                for entry in entries {
                    if let messaging = entry["messaging"] as? [[String:Any]] {
                        for message in messaging {
                            
                            if let sender = message["sender"] as? [String:String], let senderId = sender["id"] {
                                
                                echoBack(senderId: senderId)
                            }
                        }
                    }
                }
            }
        }
    }
}

private func echoBack(senderId: String) {
    if let accessToken = ProcessInfo.processInfo.environment["FACEBOOK_PAGE_ACCESS_TOKEN"] {
        let messageJson = "{\"recipient\": { \"id\": \"\(senderId)\" }, \"message\": { \"text\": \"hello, world!\"}}"
        do {
            let url = "https://graph.facebook.com/v2.6/me/messages?access_token=\(accessToken)"
            let res = try CURLRequest(url,
                                       .httpMethod(.post),
                                       .addHeader(.fromStandard(name: "Content-Type"), "application/json"),
                                       .postString(messageJson)
            ).perform().bodyString
            
            HerokuLogger.info(res);
        }
        catch let error {
            fatalError("\(error)")
        }
    }
    else {
        HerokuLogger.info("FACEBOOK_PAGE_ACCESS_TOKEN is not set");
    }
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
    routes.add(createStorageRoutes())
    
    return routes;
}
