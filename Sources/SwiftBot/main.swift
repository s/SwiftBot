//
//  main.swift
//  SwiftBot
//

import PerfectLib
import PerfectHTTP
import PerfectHTTPServer
import Foundation

#if os(Linux)
    Log.logger = HerokuLogger()
#else
    Log.logger = ConsoleLogger()
#endif

do {
	// Launch the servers based on the configuration data.
    let server = HTTPServer()
    server.serverName = "localhost";
    server.serverPort = UInt16(Configuration().port)
    server.documentRoot = "./webroot"
    
    let application = Application(configuration: Configuration())
    
    // Set routes
    application.routes.forEach{ server.addRoutes($0.routes()) }
    
    // Set filters
    
    // Start
    try server.start()
} catch {
    Log.critical(message: error.localizedDescription) // fatal error launching one of the servers
}



