import PackageDescription

let package = Package(  
	name: "SwiftBot",  
	targets: [
        Target(
            name:"Mapper",
            dependencies:[]),
        Target(
            name:"BotsKit",
            dependencies:[]),
        Target(
            name:"ChatProviders",
            dependencies:["Mapper", "BotsKit"]),
        Target(
            name:"Storage",
            dependencies:[]),
        Target(
            name: "EchoBot",
            dependencies:["BotsKit"]),
        Target(
            name:"SwiftBot",
            dependencies:["ChatProviders","Storage","EchoBot"]),
        Target(
            name:"CoffeeBot",
            dependencies:["BotsKit"])
    ],  
	dependencies: [
		.Package(url: "https://github.com/PerfectlySoft/Perfect-HTTPServer.git", majorVersion: 2),
		.Package(url: "https://github.com/PerfectlySoft/Perfect-CURL.git", majorVersion: 2),
		.Package(url: "https://github.com/PerfectlySoft/Perfect-MySQL.git", majorVersion: 2),
        .Package(url: "https://github.com/IBM-Swift/Health.git", majorVersion: 0),
        // Common
        .Package(url: "https://github.com/IBM-Swift/HeliumLogger", majorVersion: 1)
    ],
  exclude:["Scripts"]       
)
