import PackageDescription

let package = Package(
	name: "SwiftBot",
	targets: [
        Target(
            name:"ChatProviders",
            dependencies:[]),
        Target(
            name:"Storage",
            dependencies:[]),
        Target(
            name:"SwiftBot",
            dependencies:["ChatProviders","Storage"])
    ],
	dependencies: [
		.Package(url: "https://github.com/PerfectlySoft/Perfect-HTTPServer.git", majorVersion: 2),
		.Package(url: "https://github.com/PerfectlySoft/Perfect-CURL.git", majorVersion: 2),
		.Package(url: "https://github.com/PerfectlySoft/Perfect-MySQL.git", majorVersion: 2)
    ],
    exclude:["Scripts","__tests__"]
)
