//
//  Storage+Routes.swift
//  SwiftBot
//

import Foundation
import Storage
import PerfectHTTP

internal final class StorageRoutes: RoutesFactory {
    let dsn: String
    
    init(dsn: String) {
        self.dsn = dsn
    }
    
    func routes() -> Routes {
        var routes = Routes(baseUri: "/storage")
        routes.add(method: .get,  uri: "/fetch", handler: storageFetchHandler)
        routes.add(method: .get,  uri: "/store", handler: storageStoreHandler)
        return routes;
    }
    
    private func storageFetchHandler(request: HTTPRequest, response: HTTPResponse) {
        response.setHeader(.contentType, value: "text/plain")
        do {
            let storage = try Storage(dsn: dsn);
            let value = try storage.fetch( request.param(name: "key")! )
            response.appendBody(string: "Value: \(String(describing: value))")
            response.completed(status: .ok)
        } catch {
            response.completed(status: .internalServerError)
        }
    }
    
    private func storageStoreHandler(request: HTTPRequest, response: HTTPResponse) {
        guard let key = request.param(name: "key") else { return }
        guard let value = request.param(name: "value") else { return }
        
        response.setHeader(.contentType, value: "text/plain")
        do {
            let storage = try Storage(dsn: dsn);
            try storage.store( key, value )
            response.appendBody(string: "Stored")
            response.completed(status: .ok)
        } catch {
            response.completed(status: .internalServerError)
        }
    }
    
}
