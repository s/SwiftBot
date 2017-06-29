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
    static func meMessagePostRequest(accessToken: String, jsonBody: Data) -> FacebookGraphRequest {
        return FacebookGraphRequest(path: "/me/messages",
                                    params: ["access_token": accessToken],
                                    body: jsonBody,
                                    contentType: "application/json",
                                    httpMethod: .post)
    }
}
