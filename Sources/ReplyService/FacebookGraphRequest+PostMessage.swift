//
//  FacebookGraphRequest+PostMessage.swift
//  SwiftBot
//
//  Created by Andrew Tokarev on 29/06/2017.
//
//

import Foundation

extension FacebookGraphRequest
{
    static func meMessagePostRequest(accessToken: String, json: [String:Any]) throws -> FacebookGraphRequest {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: json)
            
            return FacebookGraphRequest(path: "/me/messages",
                                        params: ["access_token": accessToken],
                                        body: jsonData,
                                        contentType: "application/json")
        }
    }
}
