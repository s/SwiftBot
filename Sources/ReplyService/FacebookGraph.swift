//
//  FacebookGraph.swift
//  SwiftBot
//
//  Created by Andrew Tokarev on 27/06/2017.
//
//

import Foundation

final class FacebookGraph {
    
    let baseUrl = "https://graph.facebook.com/v2.6"
    
    let httpTransporter : HttpTransporter
    
    init(httpTransporter: HttpTransporter) {
        self.httpTransporter = httpTransporter;
    }
    
    private func buildUrl(request: FacebookGraphRequest) -> URL? {
        guard var urlComponents = URLComponents(string: baseUrl) else { fatalError("Please check baseUrl, it should be valid url") }
        
        urlComponents.path += request.path
        urlComponents.queryItems = request.params.map({ (key, value) in URLQueryItem(name: key, value: value) })
        
        return urlComponents.url
    }
    
    func post(request: FacebookGraphRequest) -> FacebookGraphResponse {
        guard let url = buildUrl(request: request) else { fatalError("Could not build url: \(self.baseUrl), [\(request.params)]") }
        
        do {
            let body = try httpTransporter.sendRequest(url: url,
                                                       method: .post,
                                                       headers: ["Content-Type": request.contentType],
                                                       data: request.body)
            return .body(text: body)
        }
        catch let error {
            return .error(error: error)
        }
    }
}

