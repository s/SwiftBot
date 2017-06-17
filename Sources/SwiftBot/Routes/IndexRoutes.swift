//
//  IndexRoute.swift
//  SwiftBot
//

import PerfectHTTP

internal final class IndexRoutes: RoutesFactory {
    func routes() -> Routes {
        var index = Routes(baseUri: "/")
        
        index.add(method: .get, uri: "/", handler: { request, response in
            // Respond with a simple message.
            response.setHeader(.contentType, value: "text/html")
            response.appendBody(string: "<html><title>SwiftBot</title><body>Hello, devs! <br/> Time to run some swift bots!</body></html>")
            // Ensure that response.completed() is called when your processing is done.
            response.completed()
        })
        
        return index
    }
}
