//
//  FacebookGraph.swift
//  SwiftBot
//
//  Created by Andrew Tokarev on 27/06/2017.
//
//

import Foundation
import PerfectCURL

final class FacebookGraph {
    
    let baseUrl = "https://graph.facebook.com/v2.6"
    
    private func buildUrl(request: FacebookGraphRequest) -> URL? {
        guard var urlComponents = URLComponents(string: baseUrl) else { fatalError("Please check baseUrl, it should be valid url") }
        
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
            
            return .body(text: body)
        }
        catch let error {
            return .error(error: error)
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

