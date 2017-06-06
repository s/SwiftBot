//
//  FBRoute.swift
//  SwiftBot
//

import Foundation
import PerfectHTTP
import PerfectCURL

internal final class Facebook {
    fileprivate let secretToken : String
    
    public init(token: String) {
        self.secretToken = token;
    }
}

extension Facebook: RoutesFactory {
    internal func routes() -> Routes {
        var routes = Routes(baseUri: "/webhook")
        
        let webhookChalange: RequestHandler = { [unowned self] (request, response) in
            if let mode = request.param(name: "hub.mode"), mode == "subscribe" {
                HerokuLogger.info("Subscribe Mode\n");
                
                if let token = request.param(name: "hub.verify_token"),
                    let challenge = request.param(name: "hub.challenge"), token == self.secretToken {
                    
                    response.appendBody(string: challenge)
                    response.status = .ok
                } else {
                    HerokuLogger.info("Invalid Subscribe Token\n");
                    response.status = .forbidden;
                }
            } else {
                response.setBody(string: "")
                response.completed(status: .ok)
            }
        }
        
        let webhookHandler: RequestHandler = { (request, response) in
            
            parseRequestAndReplyWithEcho(request);
            logRequest(request)
            
            response.completed(status: .ok)
        }
        
        routes.add(method: .get,  uri: "", handler: webhookChalange)
        routes.add(method: .post, uri: "", handler: webhookHandler)
        
        return routes
    }
}

private func logRequest(_ request: HTTPRequest) {
    HerokuLogger.info("query: \(request.queryParams)\n")
    HerokuLogger.info("data: \(request.postParams)\n")
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

