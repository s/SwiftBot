//
//  Health+Routes.swift
//  SwiftBot
//

import Health
import LoggerAPI
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
                Log.info("Health check is ok")
                try response.setBody(json: status).completed(status: .ok)
            } else {
                Log.warning("Health check is down")
                try response.setBody(json: status).completed(status: .serviceUnavailable)
            }
        } catch {
            Log.error("Health check failed")
            response.completed(status: .internalServerError)
        }
    }
}
