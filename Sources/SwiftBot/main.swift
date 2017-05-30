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

func provideRequestFilters() -> [(HTTPRequestFilter, HTTPFilterPriority)]
{
    let token = ProcessInfo.processInfo.environment["FACEBOOK_SUBSCRIBE_TOKEN"] ?? "test-token"
    
    return [
        (FacebookHUBRequestFilter(token: token), .high)
    ]
}

do {
	// Launch the servers based on the configuration data.
    let server = HTTPServer()
    server.serverName = "localhost";
    server.serverPort = UInt16(providePort())
    server.documentRoot = "./webroot"
    
    server.setRequestFilters(provideRequestFilters())
    server.addRoutes(routes())
    
    // Set filters
    
    
    // Start
    try server.start()
} catch {
	fatalError("\(error)") // fatal error launching one of the servers
}



