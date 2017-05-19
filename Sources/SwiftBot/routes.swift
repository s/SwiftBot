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
    return routes;
}
