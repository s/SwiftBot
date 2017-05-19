import PerfectLib
import PerfectHTTP
import PerfectHTTPServer
import Foundation

func providePort() -> Int {
    if let port = ProcessInfo.processInfo.environment["PORT"] {
        return Int(port)!;
    }
    
    return 8080;
}

do {
	// Launch the servers based on the configuration data.
    let server = HTTPServer()
    server.serverName = "localhost";
    server.serverPort = UInt16(providePort())
    server.documentRoot = "./webroot"
    
    server.addRoutes(routes())
    
    // Set filters
    server.setResponseFilters([(try HTTPFilter.contentCompression(data: [:]), .high)])
    
    // Start
    try server.start()
} catch {
	fatalError("\(error)") // fatal error launching one of the servers
}

