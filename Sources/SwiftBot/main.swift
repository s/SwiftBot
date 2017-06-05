import PerfectLib
import PerfectHTTP
import PerfectHTTPServer
import Foundation

func providePort() -> Int {
    return Configuration().port
}

func provideRequestFilters() -> [(HTTPRequestFilter, HTTPFilterPriority)]
{
    let token = Configuration().fbSubscribeToken
    
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



