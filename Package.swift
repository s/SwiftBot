import PackageDescription

let package = Package(
	name: "SwiftBot",
	targets: [
        Target(
            name:"Messanger",
            dependencies:[]),
        Target(
            name:"SwiftBot",
            dependencies:["Messanger"])
    ],
	dependencies: [
		.Package(url: "https://github.com/PerfectlySoft/Perfect-HTTPServer.git", majorVersion: 2)
    ]
)
