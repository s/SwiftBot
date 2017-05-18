import PerfectLib
import PerfectHTTP
import PerfectHTTPServer
import Foundation

#if os(Linux)
    import Glibc
#else
    import Darwin
#endif

enum Logger {
    static func info(_ string: String) {
        fputs(string, stdout)
        fflush(stdout)
    }
}

// An example request handler.
// This 'handler' function can be referenced directly in the configuration below.
func handler(data: [String:Any]) throws -> RequestHandler {
	return {
		request, response in
		// Respond with a simple message.
		response.setHeader(.contentType, value: "text/html")
		response.appendBody(string: "<html><title>Hello, world!</title><body>Hello, world!</body></html>")
		// Ensure that response.completed() is called when your processing is done.
		response.completed()
	}
}

let WebHookToken = "mega-secret-token-1"

// Test: curl  -X GET "http://localhost:8080//webhook?hub.mode=subscribe&hub.challenge=27493587&hub.verify_token=mega-secret-token-1"
func simplePrintWebhook(data: [String:Any]) throws -> RequestHandler {
    return {
        request, response in
        
        Logger.info("query: \(request.queryParams)\n")
        Logger.info("data: \(request.postParams)\n")
        
        let hubMode = request.param(name: "hub.mode")
        let hubToken = request.param(name: "hub.verify_token")
        let hubChallenge = request.param(name: "hub.challenge")
        
        if let mode = hubMode, mode == "subscribe" {
            
            if let token = hubToken, let challenge = hubChallenge, token == WebHookToken {
                Logger.info("Validating webhook\n");
            
                response.appendBody(string: challenge);
                response.completed(status: .ok)
            }
            else {
                response.completed(status: .forbidden);
            }
        }
        else {
            response.completed(status: .ok)
        }
    }
}

func providePort() -> Int {
    if let port = ProcessInfo.processInfo.environment["PORT"] {
        return Int(port)!;
    }
    
    return 8080;
}

// Configuration data for two example servers.
// This example configuration shows how to launch one or more servers 
// using a configuration dictionary.

let port = providePort()

let confData = [
	"servers": [
		// Configuration data for one server which:
		//	* Serves the hello world message at <host>:<port>/
		//	* Serves static files out of the "./webroot"
		//		directory (which must be located in the current working directory).
		//	* Performs content compression on outgoing data when appropriate.
		[
			"name":"localhost",
			"port":port,
			"routes":[
				["method":"get",  "uri":"/", "handler":handler],
				["methid":"get",  "uri":"/webhook", "handler": simplePrintWebhook],
                ["methid":"post", "uri":"/webhook", "handler": simplePrintWebhook],
			],
			"filters":[
				[
				"type":"response",
				"priority":"high",
				"name":PerfectHTTPServer.HTTPFilter.contentCompression,
				]
			]
		]
    ]
]

do {
	// Launch the servers based on the configuration data.
	try HTTPServer.launch(configurationData: confData)
} catch {
	fatalError("\(error)") // fatal error launching one of the servers
}

