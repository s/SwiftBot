//
//  main.swift
//  SwiftBot
//

import PerfectLib
import PerfectHTTP
import PerfectHTTPServer
import Foundation
import HeliumLogger

// Init default logger
let log = HeliumLogger.applicationLogger()
// Set application default logger as output for perfect logger
Log.logger = log.perfectLogger()

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
    log.log(.error, msg: error.localizedDescription, functionName: #function, lineNum: #line, fileName: #file)
}



