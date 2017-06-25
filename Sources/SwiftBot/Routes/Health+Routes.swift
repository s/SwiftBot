//
//  Health+Routes.swift
//  SwiftBot
//

import Health
import PerfectHTTP

extension Health: RoutesFactory {
    func routes() -> Routes {
        var routes = Routes(baseUri: "/health")
        routes.add(method: .get,  uri: "", handler: healthCheck)
        return routes;
    }
    
    private func healthCheck(request: HTTPRequest, response: HTTPResponse) {
        let status = self.status.toSimpleDictionary()
        do {
            if self.status.state == .UP {
                try response.setBody(json: status).completed(status: .ok)
            } else {
                try response.setBody(json: status).completed(status: .serviceUnavailable)
            }
        } catch {
            response.completed(status: .internalServerError)
        }
    }
}
