//
//  FacebookGraph.swift
//  SwiftBot
//
//  Created by Andrew Tokarev on 27/06/2017.
//
//

import Foundation
import PerfectCURL

enum FacebookGraphRequestHttpMethod: Hashable, CustomStringConvertible {
    
    case get
    case post
    
    public var description: String {
        switch self {
        case .get:      return "GET"
        case .post:     return "POST"
        }
    }
}

struct FacebookGraphRequest {
    
    let path: String                // /me/messages
    let params: [String: String]    // access_token:xxx
    let body: Data                  // might be json
    let contentType: String         // application/json
    
    let httpMethod: FacebookGraphRequestHttpMethod
    
    static func meMessagePostRequest(accessToken: String, jsonBody: Data) -> FacebookGraphRequest {
        return FacebookGraphRequest(path: "/me/messages",
                                    params: ["access_token": accessToken],
                                    body: jsonBody,
                                    contentType: "application/json",
                                    httpMethod: .post)
    }
}

struct FacebookGraphResponse {
    public let body : String?
    public let error: Error?
    
    init(body: String) {
        self.body  = body
        self.error = nil;
    }
    
    init(error: Error) {
        self.body  = nil;
        self.error = error
    }
}

final class FacebookGraph {
    
    let baseUrl = "https://graph.facebook.com/v2.6"
    
    private func buildUrl(request: FacebookGraphRequest) -> URL? {
        guard var urlComponents = URLComponents(string: baseUrl) else { return nil }
        
        urlComponents.path += request.path
        urlComponents.queryItems = request.params.map({ (key, value) in URLQueryItem(name: key, value: value) })
        
        return urlComponents.url
    }
    
    func post(request: FacebookGraphRequest) -> FacebookGraphResponse {
        guard let url = buildUrl(request: request) else { fatalError("Could not build url: \(self.baseUrl), [\(request.params)]") }
        
        do {
            let body = try performHTTPRequest(url.absoluteString,
                                              data: request.body,
                                              contentTypeValue: request.contentType,
                                              httpMethod: request.httpMethod.description);
            
            return FacebookGraphResponse(body: body)
        }
        catch let error {
            return FacebookGraphResponse(error: error)
        }
    }
    
    fileprivate func performHTTPRequest(_ url: String, data: Data, contentTypeValue: String, httpMethod: String) throws -> String
    {
        let request = CURLRequest(url,
                                  .httpMethod(.from(string: httpMethod)),
                                  .addHeader(.fromStandard(name: "Content-Type"), contentTypeValue),
                                  .postData([UInt8](data)))
        return try request.perform().bodyString
    }
}

