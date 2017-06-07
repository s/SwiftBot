import PerfectLib
import PerfectHTTP
import PerfectHTTPServer
import Foundation

func providePort() -> Int {
    return Configuration().port
}

do {
	// Launch the servers based on the configuration data.
    let server = HTTPServer()
    server.serverName = "localhost";
    server.serverPort = UInt16(providePort())
    server.documentRoot = "./webroot"
    
    // Init service
    let token = ProcessInfo.processInfo.environment["FACEBOOK_SUBSCRIBE_TOKEN"] ?? "test-token"
    let facebook = Facebook(token: token)
    
    // Set routes
    server.addRoutes(routes([facebook]))
    
    // Set filters
    
    // Start
    try server.start()
} catch {
	fatalError("\(error)") // fatal error launching one of the servers
}



