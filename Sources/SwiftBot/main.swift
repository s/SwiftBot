import PerfectLib
import PerfectHTTP
import PerfectHTTPServer
import Foundation
import ChatProviders

func providePort() -> Int {
    return Configuration().port
}

#if os(Linux)
    Log.logger = HerokuLogger()
#else
    Log.logger = ConsoleLogger()
#endif

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
    let facebook = FacebookProvider(secretToken: token, accessToken: accessToken)
    
    // Store this in vm for now
    let dispatcher = MessagesDispatcher(services: [facebook])
    dispatcher.updatesHandler.subscribe{ (activity) in
        if activity.type == .message {
            let replay = Activity(type: .message,
                                  id: "",
                                  conversation: activity.conversation,
                                  from: activity.recipient,
                                  recipient: activity.from,
                                  timestamp: Date(),
                                  localTimestamp: Date(),
                                  text: activity.text)
            dispatcher.send(activity: replay)
        }
    }
    // Set routes
    server.addRoutes(routes([facebook]))
    
    // Set filters
    
    // Start
    try server.start()
} catch {
	fatalError("\(error)") // fatal error launching one of the servers
}



