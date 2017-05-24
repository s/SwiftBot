import PackageDescription

let package = Package(
	name: "SwiftBot",
	targets: [
        Target(
            name:"Messenger",
            dependencies:[]),
        Target(
            name:"SwiftBot",
            dependencies:["Messenger"])
    ],
	dependencies: [
		.Package(url: "https://github.com/PerfectlySoft/Perfect-HTTPServer.git", majorVersion: 2)
    ]
)
