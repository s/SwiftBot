//
//  HttpTransporter+CURLRequest.swift
//  SwiftBot
//
//  Created by Andrew Tokarev on 11/07/2017.
//
//

import Foundation
import PerfectCURL

class CURLHttpTransporter: HttpTransporter
{
    public func sendRequest(url: URL, method: HttpTransporterMethod, headers:[String: String], data: Data?) throws -> String
    {
        var options : [CURLRequest.Option] = []
        
        options.append(.httpMethod(.from(string: method.description)))
        for (key,value) in headers {
            options.append(.addHeader(.fromStandard(name: key), value))
        }
        if let data = data {
            options.append(.postData([UInt8](data)))
        }
        
        let request = CURLRequest(url.absoluteString, options:options)
        return try request.perform().bodyString;
    }
}
