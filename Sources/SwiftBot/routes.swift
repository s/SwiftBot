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

internal protocol RoutesFactory {
    func routes() -> Routes
}

internal func createHtmlRoute() -> Route {
    return Route(method: .get, uri: "/", handler: { request, response in
        // Respond with a simple message.
        response.setHeader(.contentType, value: "text/html")
        response.appendBody(string: "<html><title>Hello, world!</title><body>Hello, world!</body></html>")
        // Ensure that response.completed() is called when your processing is done.
        response.completed()
    })
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

internal func routes(_ factories: [RoutesFactory]) -> Routes {
    // Set routes
    var routes = Routes(baseUri: "/")
    
    routes.add(createHtmlRoute())
    factories.forEach{ routes.add($0.routes()) }
    routes.add(createStorageRoutes())
    
    return routes;
}
