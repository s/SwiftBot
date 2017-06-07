import PerfectLib
import PerfectHTTP
import PerfectHTTPServer
import Foundation
import Messenger

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
    let configuration = Configuration()
    let token = configuration.fbSubscribeToken
    let accessToken = configuration.fbPageAccessToken
    let facebook = Facebook(secretToken: token, accessToken: accessToken)
    
    // Store this in vm for now
    let messenger = Messenger(services: [facebook])
    messenger.updatesHandler.subscribe{ (message) in
        let replay = ReplayMessage(recipient: message.senderId, text: message.text ?? "Hello, world!")
        messenger.send(message: replay)
    }
    // Set routes
    server.addRoutes(routes([facebook]))
    
    // Set filters
    
    // Start
    try server.start()
} catch {
	fatalError("\(error)") // fatal error launching one of the servers
}



